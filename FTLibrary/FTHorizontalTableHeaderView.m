//
//  FTHorizontalTableHeaderView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 16/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTHorizontalTableHeaderView.h"
#import <QuartzCore/QuartzCore.h>


@implementation FTHorizontalTableHeaderView

@synthesize startPosition;
@synthesize tableView;
@synthesize section;


#pragma mark Positioning & layout

- (void)setFrame:(CGRect)frame {
	CGRect r = CGRectMake(frame.origin.x, frame.origin.y, [tableView heightForHeader], frame.size.width);
	[super setFrame:r];
}

#pragma mark Initializations

- (void)doSetup {
	startPosition = FTHorizontalTableViewInitialRotationLeft;
}

- (void)applyRotation {
	float degrees = 0;
	if (startPosition == FTHorizontalTableViewInitialRotationLeft) degrees = -90;
	else if (startPosition == FTHorizontalTableViewInitialRotationRight) degrees = 90;
	float angle = (degrees * M_PI / 180);
	self.layer.transform = CATransform3DMakeRotation(angle, 0, 0.0, 1.0);
}

- (id)init {
	self = [super init];
    if (self) {
        [self doSetup];
		[self applyRotation];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
    if (self) {
        [self doSetup];
		[self applyRotation];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self doSetup];
		[self applyRotation];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andStartPosition:(FTHorizontalTableViewInitialRotation)position {
    self = [super initWithFrame:frame];
    if (self) {
		[self doSetup];
		startPosition = position;
		[self applyRotation];
    }
    return self;
}

#pragma mark Memory management

- (void)dealloc {
	[super dealloc];
}


@end
