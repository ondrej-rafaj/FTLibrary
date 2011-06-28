//
//  UIColor+HEXConverter.h
//  AsiaETrading
//
//  Created by cescofry on 26/01/2011.
//  Copyright 2011 ziofritz.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define DEFAULT_VOID_COLOR					[UIColor blackColor]


@interface UIColor (HEXConverter) 

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;


@end
