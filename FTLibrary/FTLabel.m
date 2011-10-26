//
//  FTLabel.m
//  FTLibrary
//
//  Created by Francesco on 22/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTLabel.h"
#import "UILabel+DynamicHeight.h"
#import "FTCoreTextView.h"


@implementation FTLabel

@synthesize leading = _leading;


- (void)rightAnchorToX:(CGFloat)x {
    if (!self.superview) return;
    
    CGRect frame = self.frame;
    frame.origin.x = x - frame.size.width;
    [self setFrame:frame];
}

#pragma Initialization

- (void)doInit {
	[self setBackgroundColor:[UIColor clearColor]];
	[self setLineBreakMode:UILineBreakModeWordWrap];
    self.leading = -1;
}

- (id)init {
    self = [super init];
    if (self) {
        [self doInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self doInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame font:(UIFont *)font andText:(NSString *)text {
    CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(frame.size.width, CGFLOAT_MAX)];
	frame.size.height = textSize.height;
    self = [self initWithFrame:frame];
    if (self) {
        [self doInit];
		[self setNumberOfLines:0];
		[self setFont:font];
		[self setText:text];
    }
    return self;
}

#pragma mark leading setters

- (float)leading {
    if (_leading > 0) return _leading;
    else return self.font.leading;
}

- (void)drawRect:(CGRect)rect {
    if (self.leading > 0) {
        FTCoreTextView *ctview = [[FTCoreTextView alloc] initWithFrame:CGRectMake(30, 161, 180, 50)];
        [ctview setText:self.text];
        
        FTCoreTextStyle *defaultS = [[FTCoreTextStyle alloc] init];
        [defaultS setName:@"_default"];
        [defaultS setFont:self.font];
        [defaultS setColor:self.textColor];
        [defaultS setAlignment:[FTLabel CTTextAlignmentFromUITextAlignment:self.textAlignment]];
        [defaultS setMaxLineHeight:self.leading];
        [ctview addStyle:defaultS];
    }
    else {
        [super drawRect:rect];
    }
}


#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}


#pragma mark Alignment converter
+ (CTTextAlignment)CTTextAlignmentFromUITextAlignment:(UITextAlignment)alignment {
    switch (alignment) {
        case UITextAlignmentLeft:
            return kCTLeftTextAlignment;
        case UITextAlignmentCenter: 
            return kCTCenterTextAlignment;
        case UITextAlignmentRight: 
            return kCTRightTextAlignment;
        default: 
            return kCTNaturalTextAlignment;
    }
}


@end
