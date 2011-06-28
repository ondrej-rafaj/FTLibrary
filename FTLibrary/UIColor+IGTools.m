//
//  UIColor+IGTools.m
//  IGFrameworkProject
//
//  Created by Ondrej Rafaj on 7.6.10.
//  Copyright 2010 Home. All rights reserved.
//

#import "UIColor+IGTools.h"


@implementation UIColor (IGTools)

+ (CGFloat)getFrom:(CGFloat)value {
	//NSLog(@"From value:%f to: %f", value, (value / 255));
	return (value / 255);
}

+ (UIColor *)colorWithRealRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	return [UIColor colorWithRed:[self getFrom:red] green:[self getFrom:green] blue:[self getFrom:blue] alpha:alpha];
}

- (UIColor *)colorWithRealRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	return [UIColor colorWithRed:[UIColor getFrom:red] green:[UIColor getFrom:green] blue:[UIColor getFrom:blue] alpha:alpha];
}

+ (UIColor *)randomColor {
	CGFloat red =  (CGFloat)random() / (CGFloat)RAND_MAX;
	CGFloat blue = (CGFloat)random() / (CGFloat)RAND_MAX;
	CGFloat green = (CGFloat)random() / (CGFloat)RAND_MAX;
	return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}


@end
