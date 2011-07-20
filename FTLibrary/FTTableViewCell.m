//
//  FTTableViewCell.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 19/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTTableViewCell.h"

@implementation FTTableViewCell

@synthesize backgroundImageView;


#pragma mark Initialization

- (void)createAllElements {
//	backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
//	[backgroundImageView setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
//	[backgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
//	[self.backgroundView addSubview:backgroundImageView];
	[self setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
}

- (void)doInit {
	[self createAllElements];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		[self doInit];
    }
    return self;
}

#pragma mark Actions

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
