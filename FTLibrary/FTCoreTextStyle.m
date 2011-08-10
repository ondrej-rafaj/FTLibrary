//
//  FTCoreTextStyle.m
//  Deloitte
//
//  Created by Fuerte International on 10/08/2011.
//  Copyright 2011 Baldoph Pourprix. All rights reserved.
//

#import "FTCoreTextStyle.h"

@implementation FTCoreTextStyle

@synthesize name;
@synthesize appendedCharacter;
@synthesize font;
@synthesize color;
@synthesize isUnderLined;

- (void)dealloc {
    
    [name release], name = nil;
    [appendedCharacter release], appendedCharacter = nil;
    [font release], font = nil;
    [color release], color = nil;
    [super dealloc];
}

@end
