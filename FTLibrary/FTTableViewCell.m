//
//  FTTableViewCell.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 09/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTTableViewCell.h"
#import "UILabel+DynamicHeight.h"
#import "UIView+Layout.h"


@implementation FTTableViewCell

@synthesize cellTitleLabel;
@synthesize cellDetailLabel;
@synthesize cellImageView;
@synthesize cellStatsLabel;
@synthesize dataObject;
@synthesize background;


#pragma mark Initialization

- (void)doInit {	
	cellImageView = [[FTImageView alloc] init];
	[cellImageView setBackgroundColor:[UIColor whiteColor]];
	[self addSubview:cellImageView];
	[self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
}

- (id)init {
    self = [super init];
    if (self) {
        [self doInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		[self doInit];
    }
    return self;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
		[self doInit];
    }
    return self;
}

#pragma mark Settings

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setDynamicDetailText:(NSString *)text {
	CGFloat origHeight = cellDetailLabel.frame.size.height;
	[cellDetailLabel setText:text withWidth:cellDetailLabel.frame.size.width];
	[cellDetailLabel setHeight:([cellDetailLabel height] + 4)];
	if (cellDetailLabel.frame.size.height > origHeight) {
		[cellDetailLabel setHeight:origHeight];
	}
}

- (void)enableBackgroundWithImage:(UIImage *)image {
	background = [[UIImageView alloc] initWithFrame:self.bounds];
	[background setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[self addSubview:background];
	[self sendSubviewToBack:background];
	[background setImage:image];
}

#pragma mark Memory management

- (void)dealloc {
	[cellTitleLabel release];
	[cellDetailLabel release];
	[cellImageView release];
	[cellStatsLabel release];
	[dataObject release];
	[background release];
    [super dealloc];
}


@end
