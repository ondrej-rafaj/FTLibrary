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
    float _leading;
}

@property (nonatomic, assign) float leading;

- (void)rightAnchorToX:(CGFloat)x;
- (id)initWithFrame:(CGRect)frame font:(UIFont *)font andText:(NSString *)text;

+ (CTTextAlignment)CTTextAlignmentFromUITextAlignment:(UITextAlignment)alignment;


@end
