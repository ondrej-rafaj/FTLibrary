//
//  UIImage+Tools.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 26/09/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "UIImage+Tools.h"
#import "FTSystem.h"
#import "UIColor+Tools.h"


static inline CGSize swapWidthAndHeight(CGSize size) {
    CGFloat swap = size.width;
    size.width  = size.height;
    size.height = swap;
    return size;
}

static inline CGFloat degreesToRadians(CGFloat degrees) {
    return M_PI * (degrees / 180.0);
}


@implementation UIImage (Tools)

+ (UIImage *)alphaPatternImageWithSguareSide:(CGFloat)side withColor1:(UIColor *)color1 andColor2:(UIColor *)color2 {
	if ([FTSystem isRetina]) side = (side * 2);
	CGFloat screenScale = [UIScreen mainScreen].scale;
	CGFloat ds = (side * 2);
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(ds, ds), 1, screenScale);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[color2 setFill];
	CGContextFillRect(context, CGRectMake(0, 0, ds, ds));
	
	[color1 setFill];
	CGContextFillRect(context, CGRectMake(0, 0, side, side));
	CGContextFillRect(context, CGRectMake(side, side, side, side));
	
	UIImage *patternImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	return patternImage;
}

+ (UIImage *)alphaPatternImageWithSguareSide:(CGFloat)side {
	CGFloat c = 245;
	return [self alphaPatternImageWithSguareSide:side withColor1:[UIColor colorWithRealRed:c green:c blue:c alpha:1] andColor2:[UIColor whiteColor]];
}

+ (UIImage *)alphaPatternImage {
	return [self alphaPatternImageWithSguareSide:12];
}

- (UIImage *)rotate:(UIImageOrientation)orient {
    CGRect bnds = CGRectZero;
    UIImage *copy = nil;
    CGContextRef ctxt = nil;
    CGRect rect = CGRectZero;
    CGAffineTransform tran = CGAffineTransformIdentity;
	
    bnds.size = self.size;
    rect.size = self.size;
	
    switch (orient) {
        case UIImageOrientationUp:
			return self;
			
        case UIImageOrientationUpMirrored:
			tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
			tran = CGAffineTransformScale(tran, -1.0, 1.0);
			break;
			
        case UIImageOrientationDown:
			tran = CGAffineTransformMakeTranslation(rect.size.width,
													rect.size.height);
			tran = CGAffineTransformRotate(tran, degreesToRadians(180.0));
			break;
			
        case UIImageOrientationDownMirrored:
			tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
			tran = CGAffineTransformScale(tran, 1.0, -1.0);
			break;
			
        case UIImageOrientationLeft:
			bnds.size = swapWidthAndHeight(bnds.size);
			tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
			tran = CGAffineTransformRotate(tran, degreesToRadians(-90.0));
			break;
			
        case UIImageOrientationLeftMirrored:
			bnds.size = swapWidthAndHeight(bnds.size);
			tran = CGAffineTransformMakeTranslation(rect.size.height, rect.size.width);
			tran = CGAffineTransformScale(tran, -1.0, 1.0);
			tran = CGAffineTransformRotate(tran, degreesToRadians(-90.0));
			break;
			
        case UIImageOrientationRight:
			bnds.size = swapWidthAndHeight(bnds.size);
			tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
			tran = CGAffineTransformRotate(tran, degreesToRadians(90.0));
			break;
			
        case UIImageOrientationRightMirrored:
			bnds.size = swapWidthAndHeight(bnds.size);
			tran = CGAffineTransformMakeScale(-1.0, 1.0);
			tran = CGAffineTransformRotate(tran, degreesToRadians(90.0));
			break;
			
        default:
			// orientation value supplied is invalid
			assert(false);
			return nil;
    }
	
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
	
    switch (orient) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
			CGContextScaleCTM(ctxt, -1.0, 1.0);
			CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
			break;
			
        default:
			CGContextScaleCTM(ctxt, 1.0, -1.0);
			CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
			break;
    }
	
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(ctxt, rect, self.CGImage);
	
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return copy;
}

- (UIImage *)rotateAndScaleFromCameraWithMaxSize:(CGFloat)maxSize {
    UIImage *imag = self;
    imag = [imag rotate:imag.imageOrientation];
    imag = [imag scaleWithMaxSize:maxSize];	
    return imag;
}

- (UIImage *)scaleWithMaxSize:(CGFloat)maxSize {
    return [self scaleWithMaxSize:maxSize quality:kCGInterpolationHigh];
}

-(UIImage*)scaleWithMaxSize:(CGFloat)maxSize
					quality:(CGInterpolationQuality)quality
{
    CGRect        bnds = CGRectZero;
    UIImage*      copy = nil;
    CGContextRef  ctxt = nil;
    CGRect        orig = CGRectZero;
    CGFloat       rtio = 0.0;
    CGFloat       scal = 1.0;
	
    bnds.size = self.size;
    orig.size = self.size;
    rtio = orig.size.width / orig.size.height;
	
    if ((orig.size.width <= maxSize) && (orig.size.height <= maxSize))
    {
        return self;
    }
	
    if (rtio > 1.0)
    {
        bnds.size.width  = maxSize;
        bnds.size.height = maxSize / rtio;
    }
    else
    {
        bnds.size.width  = maxSize * rtio;
        bnds.size.height = maxSize;
    }
	
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
	
    scal = bnds.size.width / orig.size.width;
    CGContextSetInterpolationQuality(ctxt, quality);
    CGContextScaleCTM(ctxt, scal, -scal);
    CGContextTranslateCTM(ctxt, 0.0, -orig.size.height);
    CGContextDrawImage(ctxt, orig, self.CGImage);
	
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return copy;
}


@end
