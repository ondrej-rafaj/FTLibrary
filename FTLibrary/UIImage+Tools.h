//
//  UIImage+Tools.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 26/09/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tools)

+ (UIImage *)alphaPatternImageWithSguareSide:(CGFloat)side withColor1:(UIColor *)color1 andColor2:(UIColor *)color2;

+ (UIImage *)alphaPatternImageWithSguareSide:(CGFloat)side;

+ (UIImage *)alphaPatternImage;


@end
