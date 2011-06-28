//
//  UIView+IGTools.m
//  CanvasApp
//
//  Created by Ondrej Rafaj on 20/02/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "UIView+IGTools.h"
#import <QuartzCore/QuartzCore.h>


@implementation UIView (UIView_IGTools)

- (void)addShadowWithOffset:(CGFloat)offset withColor:(UIColor *)color andOpacity:(CGFloat)opacity {
    self.layer.shadowColor = [color CGColor];
    self.layer.shadowOffset = CGSizeMake(offset, offset);
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = offset;
    self.layer.shouldRasterize = YES;
    //self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

- (void)addShadow {
    [self addShadowWithOffset:2.0f withColor:[UIColor blackColor] andOpacity:0.4f];
}


@end
