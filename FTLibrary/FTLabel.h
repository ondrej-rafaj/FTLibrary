//
//  FTLabel.h
//  FTLibrary
//
//  Created by Francesco on 22/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTCoreTextView.h"


@interface FTLabel : UILabel {
    CGFloat _leading;
    CGFloat _letterSpacing;
}

@property (nonatomic, assign) CGFloat leading;
@property (nonatomic, assign) CGFloat letterSpacing;

- (void)rightAnchorToX:(CGFloat)x;
- (id)initWithFrame:(CGRect)frame font:(UIFont *)font andText:(NSString *)text;

@end
