//
//  FTProgressCircle.h
//  FTLibrary
//
//  Created by Francesco on 21/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTProgressCircle : UIView {
    UIImageView *_backgroundImage;
    UIImageView *_foregroundImage;
    float _value;
@private
    BOOL _shouldAnimate;
    float _fromValue;
}

@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, retain) IBOutlet UIImageView *foregroundImage;
@property (nonatomic, assign) float value;
@property (nonatomic, assign, getter=isShouldAnimate) BOOL shouldAnimate;
@property (nonatomic, assign) float fromValue;

- (id)initWithBackgroundImage:(UIImage *)bkgImg andForegroundImage:(UIImage *)frgImg;
- (void)setValue:(CGFloat)value animated:(BOOL)animated;

@end
