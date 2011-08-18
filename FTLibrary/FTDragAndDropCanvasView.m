//
//  FTDragAndDropCanvasView.m
//  DDrop
//
//  Created by Ondrej Rafaj on 03/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTDragAndDropCanvasView.h"
#import <QuartzCore/QuartzCore.h>

#define degreesToRadians(__ANGLE__) (M_PI * (__ANGLE__) / 180.0)
#define radiansToDegrees(__ANGLE__) (180.0 * (__ANGLE__) / M_PI)

#define kFTDragAndDropCanvasViewMinScale            0.55f
#define kFTDragAndDropCanvasViewMaxScale            1.0f
#define kFTDragAndDropCanvasViewSpeed               0.75f


@interface FTDragAndDropCanvasView (Private)

- (void)activateElement:(FTDragAndDropView *)element;
- (void)deleteElement:(FTDragAndDropView *)element;

@end


@implementation FTDragAndDropCanvasView

@synthesize backgroundImageView;
@synthesize delegate;


#pragma mark Initialization

- (void)doInit {
    elements = [[NSMutableArray alloc] init];
    backgroundImageView = [[UIImageView alloc] init];	
    [self addSubview:backgroundImageView];
	
	UIImage *deleteImage = [UIImage imageNamed:@"DD_canvas-delete.png"];
	UIImage *highlightedDeleteImage = [UIImage imageNamed:@"DD_canvas-delet-highlighted.png"];
	deleteImageView = [[UIImageView alloc] initWithImage:deleteImage highlightedImage:highlightedDeleteImage];
	deleteImageView.hidden = YES;
	[self addSubview:deleteImageView];
	
	stickersContainerView = [[UIView alloc] init];
	stickersContainerView.clipsToBounds = YES;
	[self addSubview:stickersContainerView];
	
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
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
	
	if (self.bounds.size.height / self.bounds.size.width < 1) {
		//landscape
		interfaceRotationFactor = 1;
	}
	else {
		//portrait
		interfaceRotationFactor = 3/4;
	}
	
	if (!CGRectIsEmpty(backgroundImageView.frame)) {
		CGRect previousFrame = backgroundImageView.frame;
		CGFloat scalingDueToRotation = r.size.width / previousFrame.size.width;
		
		for (FTDragAndDropView *element in elements) {
						
			element.transform = CGAffineTransformScale(element.transform, scalingDueToRotation, scalingDueToRotation);
			element.interfaceRotationScaling = interfaceRotationFactor;
			
			CGPoint newCenter = CGPointMake(element.center.x * scalingDueToRotation, element.center.y * scalingDueToRotation);
			element.center = newCenter;
		}
	}
    [backgroundImageView setFrame:CGRectIntegral(r)];
	[stickersContainerView setFrame:CGRectIntegral(r)];
	
	CGRect deleteImageViewRect = deleteImageView.frame;
	deleteImageViewRect.origin = CGPointMake(backgroundImageView.frame.origin.x + 35, ceilf((CGRectGetHeight(self.bounds) - deleteImageViewRect.size.height) / 2));
	deleteImageView.frame = deleteImageViewRect;
	
	[deleteImagePath release];
	deleteImagePath = [[UIBezierPath bezierPathWithOvalInRect:deleteImageViewRect] retain];
}

- (UIImage *)imageWithSize:(CGSize)desiredSize
{
	CGSize imageSize = backgroundImageView.image.size;

	CGFloat horizontalRatio = desiredSize.width / imageSize.width;
    CGFloat verticalRatio = desiredSize.height /imageSize.height;
    CGFloat ratio = MIN(horizontalRatio, verticalRatio);
	
    CGSize newImageSize = CGSizeMake(imageSize.width * ratio, imageSize.height * ratio);
	
	UIGraphicsBeginImageContextWithOptions(newImageSize, YES, 0.0);
	CGContextRef context = UIGraphicsGetCurrentContext();	
	
	[backgroundImageView.image drawInRect:CGRectMake(0, 0, newImageSize.width, newImageSize.height)];
	
	//the reference size is in landscape
	CGFloat horizontalRatio2 = newImageSize.width / 1024;
    CGFloat verticalRatio2 = newImageSize.height / 768;
    CGFloat newScaling = MIN(horizontalRatio2, verticalRatio2);

	for (FTDragAndDropView *element in elements) {

		CGPoint newCenter = CGPointMake(ceilf(element.center.x * newScaling), ceilf(element.center.y * newScaling));

		CGContextSaveGState(context);
		CGContextTranslateCTM(context, newCenter.x, newCenter.y);
		CGFloat scaleValue = element.realScaleValue;
		CGContextScaleCTM(context, scaleValue, scaleValue);
		CGFloat rotationValue = element.realRotationValue;
		CGContextRotateCTM(context, degreesToRadians(rotationValue));

		UIImage *imageToDraw = element.imageView.image;
		[imageToDraw drawAtPoint:CGPointMake(-ceilf(imageToDraw.size.width / 2), -ceilf(imageToDraw.size.height / 2))];
		
		CGContextRestoreGState(context);
	}
	
	UIImage *returnedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return returnedImage;
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

- (void)handleLongTouch:(UILongPressGestureRecognizer *)tap {

	FTDragAndDropView *v = (FTDragAndDropView *)tap.view;
	if (tap.state == UIGestureRecognizerStateBegan) {
		deleteImageView.hidden = NO;
	}
	else if (tap.state == UIGestureRecognizerStateEnded) {
		if (!v.isDragged)
			deleteImageView.hidden = YES;
		deleteImageView.highlighted = NO;
	}
}

- (void)didTapElement:(UITapGestureRecognizer *)recognizer {
    [self handleTap:recognizer];
}

- (void)didDoubleTapElement:(UITapGestureRecognizer *)recognizer {
    FTDragAndDropView *v = (FTDragAndDropView *)recognizer.view;
    [self handleTap:recognizer];
    [stickersContainerView bringSubviewToFront:v];
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
    [self activateElement:v];
	//[self bringSubviewToFront:v];
	
	
	CGPoint translatedPoint = [recognizer translationInView:stickersContainerView];
	if([recognizer state] == UIGestureRecognizerStateBegan) {
		v.dragged = YES;
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
	}
	
	CGPoint locationInSelf = [recognizer locationInView:self];
	BOOL shouldDelete = NO;
	
	if (!deleteImageView.hidden && [deleteImagePath containsPoint:locationInSelf]) {
		deleteImageView.highlighted = YES;
		shouldDelete = YES;
	}
	else {
		deleteImageView.highlighted = NO;		
	}
	
	if([recognizer state] == UIGestureRecognizerStateEnded) {
		v.positionX = [v center].x;
		v.positionY = [v center].y;
		[self didEditElement:v];
		deleteImageView.hidden = YES;
		deleteImageView.highlighted = NO;

		v.dragged = NO;
		if (shouldDelete) {
			[self deleteElement:v];
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
		CGAffineTransform savedTransform = v.transform;
		CGFloat actualScale = [[v.layer valueForKeyPath:@"transform.scale.x"] floatValue];

        v.transform = CGAffineTransformScale([v transform], newScale, newScale);
		if ([[v.layer valueForKeyPath:@"transform.scale.x"] floatValue] < kFTDragAndDropCanvasViewMinScale)
		{
			CGFloat scaleToMinimum = kFTDragAndDropCanvasViewMinScale / actualScale;
			v.transform = CGAffineTransformScale(savedTransform, scaleToMinimum, scaleToMinimum);
		}

        v.lastScale = [recognizer scale];
    }
    if([recognizer state] == UIGestureRecognizerStateEnded) {
        currentScale = [[v.layer valueForKeyPath:@"transform.scale.x"] floatValue];
        v.realScaleValue = currentScale;
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
	
	UILongPressGestureRecognizer *longTouch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongTouch:)];
	[longTouch setDelegate:self];
	longTouch.minimumPressDuration = 1;
	[element addGestureRecognizer:longTouch];
	[longTouch release];
	
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
		CGAffineTransform scaleTransformation = CGAffineTransformMakeScale(newScale, newScale);

        // Rotation
        CGFloat rv = [[d objectForKey:@"rotation"] floatValue];
        CGAffineTransform rotationTransformation = CGAffineTransformMakeRotation(degreesToRadians(rv));
        [v setTransform:CGAffineTransformConcat(scaleTransformation, rotationTransformation)];
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
	if ([delegate respondsToSelector:@selector(deletedElement:withIndex:)]) {
        [delegate deletedElement:element withIndex:0];
    }
}

#pragma mark Memory management

- (void)dealloc {
    [elements release];
    [backgroundImageView release];
	[stickersContainerView release];
	[deleteImagePath release];
	[deleteImageView release];
    [super dealloc];
}

@end
