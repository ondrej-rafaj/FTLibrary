//
//  FTAutoColumnView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 19/08/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTAutoColumnView.h"


@implementation FTAutoColumnView

@synthesize enableSideSpace;


#pragma mark Initialization

- (void)doSetup {
	enableSideSpace = YES;
}

- (id)init {
    self = [super init];
    if (self) {
        [self doSetup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self doSetup];
    }
    return self;
}

#pragma mark Settings

- (void)layoutElements {
	CGFloat elementsHeight = 0;
	for (UIView *v in self.subviews) {
		elementsHeight += [v height];
	}
	int add = (enableSideSpace) ? 1 : -1;
	CGFloat step = (([self height] - elementsHeight) / ([self.subviews count] + add));
	CGFloat yPos = (enableSideSpace) ? step : 0;
	for (UIView *v in self.subviews) {
		[v positionAtY:yPos];
		yPos += (step + [v height]);
	}
}

#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}


@end
