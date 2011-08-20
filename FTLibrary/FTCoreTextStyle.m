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

- (id)copyWithZone:(NSZone *)zone
{
	FTCoreTextStyle *style = [[FTCoreTextStyle alloc] init];
	style.name = [[self.name copy] autorelease];
	style.appendedCharacter = [[self.appendedCharacter copy] autorelease];
	style.font = [UIFont fontWithName:self.font.fontName size:self.font.pointSize];
	const CGFloat *components = CGColorGetComponents(color.CGColor);
	style.color = [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:components[3]];
	style.isUnderLined = self.isUnderLined;
	return style;
}

- (void)dealloc {
    
    [name release], name = nil;
    [appendedCharacter release], appendedCharacter = nil;
    [font release], font = nil;
    [color release], color = nil;
    [super dealloc];
}

@end
