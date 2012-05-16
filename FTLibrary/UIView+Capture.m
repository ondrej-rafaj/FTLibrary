//
//  UIView+Capture.m
//
//  Created by Simon Lee on 29/11/2010.
//  Copyright 2010 Fuerte International. All rights reserved.
//

#import "UIView+Capture.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Capture)

- (UIImage *) captureImage {
	UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return viewImage;
}

@end
