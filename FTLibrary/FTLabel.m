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
    [self setLeading:0];
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

- (CGFloat)leading {
    if (_leading > 0) return _leading;
    else return self.font.leading;
}

- (void)setLeading:(CGFloat)leading {
    _leading = leading;
    if (_leading > 0) {
        [self setNeedsDisplay];
    }
    
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self setNeedsDisplay];
}

#pragma mark drawrect
///*
- (void)drawRect:(CGRect)rect {
    
    if (_leading > 0) {
        NSLog(@"leading : %.1f for color [%@]", self.leading, self.text);
        
        
        FTCoreTextView *ctview = [[FTCoreTextView alloc] initWithFrame:self.bounds];
        [ctview setText:self.text];
        
        FTCoreTextStyle *defaultS = [[FTCoreTextStyle alloc] init];
        [defaultS setName:@"_default"];
        [defaultS setFont:self.font];
        [defaultS setColor:self.textColor];
        [defaultS setAlignment:[FTLabel CTTextAlignmentFromUITextAlignment:self.textAlignment]];
#warning FTCoretext does not implement bigger leading of the font leading yet
        [defaultS setMaxLineHeight:self.leading];
        [ctview addStyle:defaultS];
        [self addSubview:ctview];
    }
    else {
       [super drawRect:rect]; 
    }
    

    
}
//*/

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
