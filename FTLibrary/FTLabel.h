//
//  FTLabel.h
//  FTLibrary
//
//  Created by Francesco on 22/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTLabel : UILabel {
    CGFloat _leading;
}

@property (nonatomic, assign) CGFloat leading;

- (void)rightAnchorToX:(CGFloat)x;
- (id)initWithFrame:(CGRect)frame font:(UIFont *)font andText:(NSString *)text;


@end
