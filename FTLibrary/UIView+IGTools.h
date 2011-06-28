//
//  UIView+IGTools.h
//  CanvasApp
//
//  Created by Ondrej Rafaj on 20/02/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIView (UIView_IGTools)

- (void)addShadowWithOffset:(CGFloat)offset withColor:(UIColor *)color andOpacity:(CGFloat)opacity;

- (void)addShadow;

@end
