//
//  FTDragDropCropView.m
//  xProgress.com
//
//  Created by Ondrej Rafaj on 11/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTDragDropCropView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Layout.h"
#import "UIImage+Resize.h"
#import "UIImage+Tools.h"


#define kFTDragDropCropViewInitialSpace                     70
#define kFTDragDropCropViewAddToCenter                      8


@implementation FTDragDropCropView

@synthesize delegate;


#pragma positioning

- (CGPoint)posTopLeftPoint {
    return ddTopLeft.center;
}

- (CGPoint)posTopRightPoint {
    return ddTopRight.center;
}

- (CGPoint)posBottomLeftPoint {
    return ddBottomLeft.center;
}

- (CGPoint)posBottomRightPoint {
    return ddBottomRight.center;
}

- (CGPoint)retTopLeftPoint {
    CGPoint p = ddTopLeft.center;
    p.x += kFTDragDropCropViewAddToCenter;
    p.y += kFTDragDropCropViewAddToCenter;
    return p;
}

- (CGPoint)retTopRightPoint {
    CGPoint p = ddTopRight.center;
    p.x += kFTDragDropCropViewAddToCenter;
    p.y += kFTDragDropCropViewAddToCenter;
    return p;
}

- (CGPoint)retBottomLeftPoint {
    CGPoint p = ddBottomLeft.center;
    p.x += kFTDragDropCropViewAddToCenter;
    p.y += kFTDragDropCropViewAddToCenter;
    return p;
}

- (CGPoint)retBottomRightPoint {
    CGPoint p = ddBottomRight.center;
    p.x += kFTDragDropCropViewAddToCenter;
    p.y += kFTDragDropCropViewAddToCenter;
    return p;
}

#pragma mark Creating elements

- (UIPanGestureRecognizer *)getNewRecognizer {
    UIPanGestureRecognizer *gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didMovePoint:)];
    return [gr autorelease];
}

- (void)createAllElements {
    ddTopLeft = [[FTDragDropCropElementView alloc] initWithImage:[UIImage imageNamed:@"DD_photo_adjust_01.png"]];
    [ddTopLeft setCenter:CGPointMake(kFTDragDropCropViewInitialSpace, kFTDragDropCropViewInitialSpace)];
    [ddTopLeft addGestureRecognizer:[self getNewRecognizer]];
	[ddTopLeft setHidden:!_isCropEnabled];
    [self addSubview:ddTopLeft];
    
    ddTopRight = [[FTDragDropCropElementView alloc] initWithImage:[UIImage imageNamed:@"DD_photo_adjust_02.png"]];
    [ddTopRight setCenter:CGPointMake((self.frame.size.width - kFTDragDropCropViewInitialSpace), kFTDragDropCropViewInitialSpace)];
    [ddTopRight addGestureRecognizer:[self getNewRecognizer]];
	[ddTopRight setHidden:!_isCropEnabled];
    [self addSubview:ddTopRight];
    
    ddBottomLeft = [[FTDragDropCropElementView alloc] initWithImage:[UIImage imageNamed:@"DD_photo_adjust_02.png"]];
    [ddBottomLeft setCenter:CGPointMake(kFTDragDropCropViewInitialSpace, (self.frame.size.height - kFTDragDropCropViewInitialSpace))];
    [ddBottomLeft addGestureRecognizer:[self getNewRecognizer]];
	[ddBottomLeft setHidden:!_isCropEnabled];
    [self addSubview:ddBottomLeft];
    
    ddBottomRight = [[FTDragDropCropElementView alloc] initWithImage:[UIImage imageNamed:@"DD_photo_adjust_01.png"]];
    [ddBottomRight setCenter:CGPointMake((self.frame.size.width - kFTDragDropCropViewInitialSpace), (self.frame.size.height - kFTDragDropCropViewInitialSpace))];
    [ddBottomRight addGestureRecognizer:[self getNewRecognizer]];
	[ddBottomRight setHidden:!_isCropEnabled];
    [self addSubview:ddBottomRight];
}

#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createAllElements];
        
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

#pragma mark Calculations

- (void)recalculateAllPositionsFrom:(FTDragDropCropElementView *)v {
    CGPoint tl = [self posTopLeftPoint];
    CGPoint tr = [self posTopRightPoint];
    CGPoint bl = [self posBottomLeftPoint];
    CGPoint br = [self posBottomRightPoint];
    if (v == ddTopLeft) {
        tl = v.center;
        tr.y = tl.y;
        bl.x = tl.x;
    }
    else if (v == ddTopRight) {
        tr = v.center;
        tl.y = tr.y;
        br.x = tr.x;
    }
    else if (v == ddBottomLeft) {
        bl = v.center;
        br.y = bl.y;
        tl.x = bl.x;
    }
    else if (v == ddBottomRight) {
        br = v.center;
        bl.y = br.y;
        tr.x = br.x;
    }
	
	CGFloat w = [self width];
	CGFloat h = [self height];
//	
	CGFloat mtl = ([ddTopLeft width] / 2);
	CGFloat mw = (w - mtl);
	CGFloat mh = (h - mtl);
	
	if (tl.x < mtl || bl.x < mtl) {
		tl.x = mtl;
		bl.x = mtl;
	}
	if (tl.y < mtl || tr.y < mtl) {
		tl.y = mtl;
		tr.y = mtl;
	}
	if (tr.x > mw || br.x > mw) {
		tr.x = mw;
		br.x = mw;
	}
	if (bl.y > mh || br.y > mh) {
		bl.y = mh;
		br.y = mh;
	}
	
//	CGFloat side = ([ddTopLeft width] + 2);
//	CGFloat top = (tl.x + side);
//	CGFloat left = (tl.x + side);
//	CGFloat right = (tr.x - side);
//	CGFloat bottom = (bl.y - side);
//	
//	// Checking top
//	if (bl.y < top || br.y < top) {
//		bl.y = top;
//		br.y = top;
//	}
//	// Checking left
//	if (tr.x < left || br.x < left) {
//		tr.x = left;
//		br.x = left;
//	}
//	// Checking right
//	if (tl.x > right || bl.x > right) {
//		tl.x = right;
//		bl.x = right;
//	}
//	// Checking  bottom
//	if (tl.y > bottom || tr.y > bottom) {
//		tl.y = bottom;
//		tr.y = bottom;
//	}
	
    [ddTopLeft setCenter:tl];
    [ddTopRight setCenter:tr];
    [ddBottomLeft setCenter:bl];
    [ddBottomRight setCenter:br];
}

#pragma mark Pan recognizer delegate method
                                  
- (void)didMovePoint:(UIPanGestureRecognizer *)recognizer {
    FTDragDropCropElementView *v = (FTDragDropCropElementView *)recognizer.view;
    CGPoint translatedPoint = [recognizer translationInView:self];
	if([recognizer state] == UIGestureRecognizerStateBegan) {
		v.positionX = [v center].x;
		v.positionY = [v center].y;
	}
	translatedPoint = CGPointMake(v.positionX + translatedPoint.x, v.positionY + translatedPoint.y);
	[v setCenter:translatedPoint];
    [self recalculateAllPositionsFrom:v];
    if ([delegate respondsToSelector:@selector(cropView:didMoveDDCTopLeft:topRight:bottomLeft:bottomRight:)]) {
        [delegate cropView:self didMoveDDCTopLeft:[self retTopLeftPoint] topRight:[self retTopRightPoint] bottomLeft:[self retBottomLeftPoint] bottomRight:[self retBottomRightPoint]];
    }
    if([recognizer state] == UIGestureRecognizerStateEnded) {
		v.positionX = [v center].x;
		v.positionY = [v center].y;
	}
	[self setNeedsDisplay];
}

#pragma mark Settings

- (void)manualUpdate {
    if ([delegate respondsToSelector:@selector(cropView:didMoveDDCTopLeft:topRight:bottomLeft:bottomRight:)]) {
        [delegate cropView:self didMoveDDCTopLeft:[self retTopLeftPoint] topRight:[self retTopRightPoint] bottomLeft:[self retBottomLeftPoint] bottomRight:[self retBottomRightPoint]];
    }
}

- (void)setImage:(UIImage *)image {
	_originalImageSize = image.size;
	
	// Saving the original image
	_originalImage = image;
	[_originalImage retain];
	
	// Resized image that fits the iew
	image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:self.bounds.size interpolationQuality:kCGInterpolationMedium];
	
	// Image effects for thumbs
	if (_isBlackAndWhite) image = [UIImage convertTo8bppGrayscaleFromImage:image];
	
	_resizedImage = image;
	[_resizedImage retain];
	
	// Setting up the view
	[self setSize:image.size];
	[self centerInSuperView];
	[self resetCropZone];
	[self setNeedsDisplay];
}

- (CGFloat)convertPixelValue:(CGFloat)value {
	CGFloat origWidth = _originalImage.size.width;
	CGFloat reszWidth = _resizedImage.size.width;
	CGFloat v = (origWidth / reszWidth);
	return (value * v);
}

/*
 
 0 - UIImageOrientationUp,
 1 - UIImageOrientationDown,   // 180 deg rotation
 2 - UIImageOrientationLeft,   // 90 deg CCW
 3 - UIImageOrientationRight,   // 90 deg CW
 
 4 - UIImageOrientationUpMirrored,    // as above but image mirrored along other axis. horizontal flip
 5 - UIImageOrientationDownMirrored,  // horizontal flip
 6 - UIImageOrientationLeftMirrored,  // vertical flip
 7 - UIImageOrientationRightMirrored, // vertical flip
 
//*/

- (UIImage *)image {
	// Generating the image + cropping
	CGRect cropRect = CGRectZero;
	cropRect.size = CGSizeMake([self convertPixelValue:_originalImage.size.width], [self convertPixelValue:_originalImage.size.height]);
	
	if (_isCropEnabled) {
		CGFloat x = [self convertPixelValue:[self posTopLeftPoint].x];
		CGFloat y = [self convertPixelValue:[self posTopLeftPoint].y];
		CGFloat w = [self convertPixelValue:([self posTopRightPoint].x - [self posTopLeftPoint].x)];
		CGFloat h = [self convertPixelValue:([self posBottomLeftPoint].y - [self posTopLeftPoint].y)];
		NSLog(@"Current resized orientation: %d", _originalImage.imageOrientation);
		NSLog(@"Original image Size %@",NSStringFromCGSize(_originalImage.size));
		UIImageOrientation o = _originalImage.imageOrientation;
		if (o == UIImageOrientationLeft) {
			cropRect = CGRectMake(x, (_originalImage.size.height - h - y), h, w);
		}
		else if (o == UIImageOrientationRight) {
			cropRect = CGRectMake(y, x, h, w);
		}
		else if (o == UIImageOrientationDown) {
			cropRect = CGRectMake((_originalImage.size.width - w - x), (_originalImage.size.height - h - y), w, h);
		}
//		else if (o == UIImageOrientationDownMirrored) {
//			cropRect = CGRectMake((_originalImage.size.width - w - x), y, w, h);
//		}
//		else if (o == UIImageOrientationUpMirrored) {
//			cropRect = CGRectMake((_originalImage.size.width - w - x), y, w, h);
//		}
//		else if (o == UIImageOrientationLeftMirrored) {
//			cropRect = CGRectMake((_originalImage.size.width - w - x), y, w, h);
//		}
//		else if (o == UIImageOrientationRightMirrored) {
//			cropRect = CGRectMake((_originalImage.size.width - w - x), y, w, h);
//		}
		else {
			cropRect = CGRectMake(x, y, w, h);
		}
	}
	CGImageRef imageRef = CGImageCreateWithImageInRect([_originalImage CGImage], cropRect);
	UIImage *ret = [UIImage imageWithCGImage:imageRef scale:1 orientation:_originalImage.imageOrientation];
	CGImageRelease(imageRef);
	
	// Image effects
	if (_isBlackAndWhite) ret = [UIImage convertTo8bppGrayscaleFromImage:ret];
	
	return ret;
}

- (void)resetCropZone {
	[ddTopLeft setOrigin:CGPointMake(10, 10)];
	[ddTopRight setOrigin:CGPointMake(([self width] - [ddTopRight width] - 10), 10)];
	[ddBottomLeft setOrigin:CGPointMake(10, ([self height] - [ddBottomLeft height] - 10))];
	[ddBottomRight setOrigin:CGPointMake([ddTopRight xPosition], [ddBottomLeft yPosition])];
	[self setNeedsDisplay];
}

- (void)toggleBlackAndWhite {
	_isBlackAndWhite = !_isBlackAndWhite;
	[self setImage:_originalImage];
}

- (BOOL)isBlackAndWhite {
	return _isBlackAndWhite;
}

- (void)toggleCropImage {
	_isCropEnabled = !_isCropEnabled;
	[ddTopLeft setHidden:!_isCropEnabled];
	[ddTopRight setHidden:!_isCropEnabled];
	[ddBottomLeft setHidden:!_isCropEnabled];
	[ddBottomRight setHidden:!_isCropEnabled];
	[self setNeedsDisplay];
}

- (BOOL)isCroppingEnabled {
	return _isCropEnabled;
}

#pragma mark Draw rectangle

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextClearRect(context, self.bounds);
	
	if (_resizedImage) {
		[_resizedImage drawInRect:rect];
	}
	
	if (_isCropEnabled) {
		CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
		// Draw them with a 2.0 stroke width so they are a bit more visible.
		CGContextSetLineWidth(context, 2.0);
		
		CGFloat dashArray[] = {6, 4};
		CGContextSetLineDash(context, 3, dashArray, 4);
		
		CGContextMoveToPoint(context, ddTopLeft.center.x, ddTopLeft.center.y); //start at this point
		CGContextAddLineToPoint(context, ddBottomLeft.center.x, ddBottomLeft.center.y); //draw to this point
		
		CGContextMoveToPoint(context, ddTopLeft.center.x, ddTopLeft.center.y); //start at this point
		CGContextAddLineToPoint(context, ddTopRight.center.x, ddTopRight.center.y); //draw to this point
		
		CGContextMoveToPoint(context, ddTopRight.center.x, ddTopRight.center.y); //start at this point
		CGContextAddLineToPoint(context, ddBottomRight.center.x, ddBottomRight.center.y); //draw to this point
		
		CGContextMoveToPoint(context, ddBottomRight.center.x, ddBottomRight.center.y); //start at this point
		CGContextAddLineToPoint(context, ddBottomLeft.center.x, ddBottomLeft.center.y); //draw to this point
    }
    CGContextStrokePath(context);
}

#pragma mark Memory management

- (void)dealloc {
    [ddTopLeft release];
    [ddTopRight release];
    [ddBottomLeft release];
    [ddBottomRight release];
	[_originalImage release];
	[_resizedImage release];
    [super dealloc];
}

@end
