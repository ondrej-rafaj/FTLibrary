//
//  CPCoreTextView.h
//  FTLibrary
//
//  Created by Francesco on 20/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    NSString *name;
    UIFont *font;
    UIColor *color;
    BOOL isUnderLined;
} FTCoreTextStyle;

@interface FTCoreTextView : UIView {
    NSString *_text;
    NSArray *_styles;
    @private
    NSMutableArray *_markers;
    FTCoreTextStyle _defaultStyle;
    NSMutableString *_processedString;
}

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSArray *styles;
@property (nonatomic, retain) NSMutableArray *markers;
@property (nonatomic, assign) FTCoreTextStyle defaultStyle;
@property (nonatomic, assign) NSMutableString *processedString;

- (id)initWithFrame:(CGRect)frame;
- (void)addStyle:(FTCoreTextStyle)style;

@end
