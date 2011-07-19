//
//  FTTableViewCell.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 19/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTTableViewCell.h"

@implementation FTTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
