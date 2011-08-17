//
//  FTDragAndDropCanvasView.m
//  DDrop
//
//  Created by Ondrej Rafaj on 03/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTDragAndDropCanvasView.h"


#define degreesToRadians(__ANGLE__) (M_PI * (__ANGLE__) / 180.0)
#define radiansToDegrees(__ANGLE__) (180.0 * (__ANGLE__) / M_PI)

#define kFTDragAndDropCanvasViewMinScale            0.7f
#define kFTDragAndDropCanvasViewMaxScale            1.0f
#define kFTDragAndDropCanvasViewSpeed               0.75f


@interface FTDragAndDropCanvasView (Private)

- (void)activateElement:(FTDragAndDropView *)element;

@end


@implementation FTDragAndDropCanvasView

@synthesize backgroundImageView;
@synthesize delegate;


#pragma mark Initialization

- (void)doInit {
    elements = [[NSMutableArray alloc] init];
    backgroundImageView = [[UIImageView alloc] init];	
    [self addSubview:backgroundImageView];
	
	stickersContainerView = [[UIView alloc] init];
	[self addSubview:stickersContainerView];

}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        [self doInit];
    }
    return self;
}

- (void)layoutSubviews
{
	CGSize imageSize = backgroundImageView.image.size;
	CGFloat horizontalRatio = self.bounds.size.width / imageSize.width;
    CGFloat verticalRatio = self.bounds.size.height / imageSize.height;
    CGFloat ratio = MIN(horizontalRatio, verticalRatio);
	
    CGSize newImageSize = CGSizeMake(imageSize.width * ratio, imageSize.height * ratio);
    CGRect r = CGRectMake((self.bounds.size.width - newImageSize.width)/2, (self.bounds.size.height - newImageSize.height)/2, newImageSize.width, newImageSize.height);
	if (!CGRectIsEmpty(backgroundImageView.frame)) {
		CGRect previousFrame = backgroundImageView.frame;
		CGFloat scalingDueToRotation = r.size.width / previousFrame.size.width;
		for (FTDragAndDropView *element in elements) {
						
			element.transform = CGAffineTransformScale(element.transform, scalingDueToRotation, scalingDueToRotation);
			
			element.interfaceRotationScaling = scalingDueToRotation;
			
			CGPoint newCenter = CGPointMake(element.center.x * scalingDueToRotation, element.center.y * scalingDueToRotation);
			element.center = newCenter;
		}
	}
    [backgroundImageView setFrame:CGRectIntegral(r)];
	[stickersContainerView setFrame:CGRectIntegral(r)];
}

#pragma mark Using elements

- (void)didEditElement:(FTDragAndDropView *)element {
    if ([delegate respondsToSelector:@selector(finishedEditingElement:withData:)]) {
        [delegate finishedEditingElement:element withData:[element getInfo]];
    }
}

- (void)disableActiveElement {
    if (activeElement) {
        [activeElement setAlpha:1];
        [activeElement release];
        activeElement = nil;
    }
}

- (void)highlightActiveElement {
    [UIView beginAnimations:nil context:nil];
    for (FTDragAndDropView *e in elements) {
        if (e != activeElement) {
            [e setAlpha:1.0f];
        }
    }
    [activeElement setAlpha:0.85f];
    [UIView commitAnimations];
}

#pragma mark Gesture delegate methods

- (void)handleTap:(UITapGestureRecognizer *)tap {
    if (tap.view != activeElement) [self activateElement:(FTDragAndDropView *)tap.view];
    else [self disableActiveElement];
}

- (void)didTapElement:(UITapGestureRecognizer *)recognizer {
    [self handleTap:recognizer];
}

- (void)didDoubleTapElement:(UITapGestureRecognizer *)recognizer {
    FTDragAndDropView *v = (FTDragAndDropView *)recognizer.view;
    [self handleTap:recognizer];
    [self bringSubviewToFront:v];
    [self didEditElement:v];
}

- (void)rotateView:(UIRotationGestureRecognizer *)recognizer {
    FTDragAndDropView *v = (FTDragAndDropView *)recognizer.view;
    //[self activateElement:v];
    if([(UIRotationGestureRecognizer*)recognizer state] == UIGestureRecognizerStateEnded) {
        [v setLastRotation:0.0f];
        v.realRotationValue += radiansToDegrees([recognizer rotation]);
        [self didEditElement:v];
        return;
    }
    CGFloat rotation = 0.0 - (v.lastRotation - [recognizer rotation]);
    CGAffineTransform newTransform = CGAffineTransformRotate(v.transform, rotation);
    [v setTransform:newTransform];
    [v setLastRotation:[recognizer rotation]];
}

- (void)moveView:(UIPanGestureRecognizer *)recognizer {
    FTDragAndDropView *v = (FTDragAndDropView *)recognizer.view;
    //[self activateElement:v];
	//[self bringSubviewToFront:v];
	CGPoint translatedPoint = [recognizer translationInView:self];
	if([recognizer state] == UIGestureRecognizerStateBegan) {
		v.positionX = [v center].x;
		v.positionY = [v center].y;
	}
	translatedPoint = CGPointMake(v.positionX + translatedPoint.x, v.positionY + translatedPoint.y);
	
	CGRect newElementFrame;
	newElementFrame.size = v.bounds.size;
	newElementFrame.origin = CGPointMake(translatedPoint.x - newElementFrame.size.width / 2, translatedPoint.y - newElementFrame.size.height / 2);
	CGRect minimumInsideRectangle = CGRectInset(newElementFrame, 0.2 * newElementFrame.size.width, 0.2 * newElementFrame.size.height);

	if (!CGRectIsNull(CGRectIntersection(minimumInsideRectangle, stickersContainerView.bounds))) {
		[v setCenter:translatedPoint];
		if([recognizer state] == UIGestureRecognizerStateEnded) {
			v.positionX = [v center].x;
			v.positionY = [v center].y;
			[self didEditElement:v];
		}
	}
}

- (void)resizeView:(UIPinchGestureRecognizer *)recognizer    {
    FTDragAndDropView *v = (FTDragAndDropView *)recognizer.view;
    //[self activateElement:v];
    if([recognizer state] == UIGestureRecognizerStateBegan) {
        v.lastScale = [recognizer scale];
    }
    CGFloat currentScale = [[v.layer valueForKeyPath:@"transform.scale"] floatValue];
    if ([recognizer state] == UIGestureRecognizerStateBegan || [recognizer state] == UIGestureRecognizerStateChanged) {
        CGFloat newScale = 1 -  (v.lastScale - [recognizer scale]) * (kFTDragAndDropCanvasViewSpeed);
        newScale = MIN(newScale, kFTDragAndDropCanvasViewMaxScale / currentScale);   
        newScale = MAX(newScale, kFTDragAndDropCanvasViewMinScale / currentScale);
        v.transform = CGAffineTransformScale([v transform], newScale, newScale);
        v.lastScale = [recognizer scale];
        NSLog(@"Scale value: %f - %f", currentScale, newScale);
    }
    if([recognizer state] == UIGestureRecognizerStateEnded) {
        currentScale = [[v.layer valueForKeyPath:@"transform.scale"] floatValue];
        v.realScaleValue = currentScale;
        NSLog(@"Real scale value: %f", v.realScaleValue);
 		[self didEditElement:v];
	}
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark Elements

- (void)activateElement:(FTDragAndDropView *)element {
    if (element != activeElement) {
        [activeElement release];
        activeElement = element;
        [activeElement retain];
        [self highlightActiveElement];
    }
}

- (void)configureElement:(FTDragAndDropView *)element {

    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTapElement:)];
    [tap2 setNumberOfTapsRequired:2];
    [tap2 setNumberOfTouchesRequired:1];
    [element addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapElement:)];
    [tap1 requireGestureRecognizerToFail:tap2];
    [tap2 release];
    [tap1 setNumberOfTapsRequired:1];
    [tap1 setNumberOfTouchesRequired:1];
    [element addGestureRecognizer:tap1];
    [tap1 release];
    
    UIRotationGestureRecognizer *rot = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    [rot setDelegate:self];
    [element addGestureRecognizer:rot];
    [rot release];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveView:)];
    [rot setDelegate:self];
    [pan setMinimumNumberOfTouches:1];
    [pan setMaximumNumberOfTouches:1];
    [element addGestureRecognizer:pan];
    [pan release];
    
    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(resizeView:)];
    [rot setDelegate:self];
    [element addGestureRecognizer:pin];
    [pin release];
    
    [elements addObject:element];
    [element setCenter:CGPointMake(stickersContainerView.frame.size.width / 2, stickersContainerView.frame.size.height / 2)];
    [stickersContainerView addSubview:element];
    [self activateElement:element];
}

- (void)addElementFromData:(NSDictionary *)data {
    FTDragAndDropView *element = [[FTDragAndDropView alloc] initWithImageData:data];
    [self configureElement:element];
    [element release];
}

- (void)addElementFromPath:(NSString *)imagePath {
    FTDragAndDropView *element = [[FTDragAndDropView alloc] initWithImagePath:imagePath];
    [self configureElement:element];
    if ([delegate respondsToSelector:@selector(createdElement:withData:)]) {
        [delegate createdElement:element withData:[element getInfo]];
    }
    [element release];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
	[backgroundImageView setImage:backgroundImage];
	[self layoutSubviews];
}

- (void)removeActiveElement {
    if (activeElement) {
        [activeElement removeFromSuperview];
        [elements removeObject:activeElement];
        [activeElement release];
        activeElement = nil;
    }
}

- (void)layoutElements:(BOOL)animated {
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.6];
    }
    
    for (FTDragAndDropView *v in elements) {
        NSDictionary *d = v.elementData;
        
        // Position
        CGPoint p = CGPointFromString([d objectForKey:@"center"]);
        [v setCenter:p];
        
        // Scale
        CGFloat newScale = [[d objectForKey:@"scale"] floatValue];
        if (newScale < kFTDragAndDropCanvasViewMinScale) newScale = kFTDragAndDropCanvasViewMinScale;
        v.transform = CGAffineTransformScale(v.transform, newScale, newScale);

        // Rotation
        CGFloat rv = [[d objectForKey:@"rotation"] floatValue];
        CGAffineTransform newTransform = CGAffineTransformRotate(v.transform, degreesToRadians(rv));
        [v setTransform:newTransform];
        [v setRealRotationValue:rv];

    }
    
    if (animated) [UIView commitAnimations];
}

#pragma mark Controls delegate methods

- (void)deleteElementClicked:(UIButton *)sender {
    if ([delegate respondsToSelector:@selector(deletedElement:withIndex:)]) {
        [delegate deletedElement:nil withIndex:0];
    }
}

#pragma mark Element delegate methods

- (void)deleteElement:(FTDragAndDropView *)element {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeActiveElement)];
    [element setAlpha:0];
    [UIView commitAnimations];
}

#pragma mark Memory management

- (void)dealloc {
    [elements release];
    [backgroundImageView release];
	[stickersContainerView release];
    [super dealloc];
}

@end
