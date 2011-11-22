//
//  FTProgressCircle.h
//  FTLibrary
//
//  Created by Francesco on 21/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTProgressCircle : UIView {
    UIImage *_foregroundImage;
    float _percentage;
@private
    BOOL _shouldAnimate;
    float _fromValue;
}

@property (nonatomic, retain) IBOutlet UIImage *foregroundImage;
@property (nonatomic, assign) float percentage;
@property (nonatomic, assign, getter=isShouldAnimate) BOOL shouldAnimate;
@property (nonatomic, assign) float fromValue;

- (id)initWithBackgroundImage:(UIImage *)bkgImg andForegroundImage:(UIImage *)frgImg;
- (void)setPercentage:(CGFloat)percentage animated:(BOOL)animated;
- (void)setDegrees:(CGFloat)degrees animated:(BOOL)animated;
@end
