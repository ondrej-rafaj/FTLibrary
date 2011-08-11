//
//  UIView+Tools.m
//  CanvasApp
//
//  Created by Ondrej Rafaj on 20/02/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "UIView+Effects.h"
#import <QuartzCore/QuartzCore.h>


@implementation UIView (Effects)

- (void)addShadowWithOffset:(CGFloat)offset withColor:(UIColor *)color andOpacity:(CGFloat)opacity {
    self.layer.shadowColor = [color CGColor];
    self.layer.shadowOffset = CGSizeMake(offset, offset);
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = offset;
    self.layer.shouldRasterize = YES;
}

- (void)addShadow {
    [self addShadowWithOffset:2.0f withColor:[UIColor blackColor] andOpacity:0.4f];
}

- (void)addRedShadow {
    [self addShadowWithOffset:2.0f withColor:[UIColor redColor] andOpacity:0.8f];
}

- (UIImage *)captureImage {
	UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return viewImage;
}


@end
