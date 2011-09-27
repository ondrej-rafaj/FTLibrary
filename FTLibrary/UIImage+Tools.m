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


@end
