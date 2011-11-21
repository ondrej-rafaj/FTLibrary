//
//  FTProgressCircle.m
//  FTLibrary
//
//  Created by Francesco on 21/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTProgressCircle.h"

@implementation FTProgressCircle

@synthesize backgroundImage = _backgroundImage;
@synthesize foregroundImage = _foregroundImage;
@synthesize value = _value;
@synthesize shouldAnimate = _shouldAnimate;
@synthesize fromValue = _fromValue;


- (void)animate {
    
}

#pragma mark setters

- (void)setValue:(CGFloat)value animated:(BOOL)animated {
    self.fromValue = _value;
    _value = value;
    self.shouldAnimate = YES;
}

- (void)setValue:(CGFloat)value {
    [self setValue:value animated:NO];
}


- (id)initWithBackgroundImage:(UIImage *)bkgImg andForegroundImage:(UIImage *)frgImg {
    self = [super initWithFrame:CGRectMake(0, 0, bkgImg.size.width, bkgImg.size.height)];
    if (self) {
        // Initialization code
        self.backgroundImage = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.backgroundImage setImage:bkgImg];
        [self addSubview:self.backgroundImage];
        
        
        self.foregroundImage = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.foregroundImage setImage:frgImg];
        [self addSubview:self.foregroundImage];
        [self setValue:0];
    }
    return self;    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

}
*/
- (void)dealloc {
    
    [_backgroundImage release], _backgroundImage = nil;
    [_foregroundImage release], _foregroundImage = nil;
    [super dealloc];
}


@end
