//
//  FTCoreTextStyle.m
//  Deloitte
//
//  Created by Francesco Freezone <cescofry@gmail.com> on 10/08/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTCoreTextStyle.h"

@implementation FTCoreTextStyle

@synthesize name = _name;
@synthesize appendedCharacter = _appendedCharacter;
@synthesize font = _font;
@synthesize color = _color;
@synthesize underlined = _underlined;
@synthesize textAlignment = _textAlignment;
@synthesize maxLineHeight = _maxLineHeight;
@synthesize paragraphInset = _paragraphInset;
@synthesize applyParagraphStyling = _applyParagraphStyling;

- (id)init
{
	self = [super init];
	if (self) {
		self.name = @"_default";
		self.appendedCharacter = @"";
		self.font = [UIFont systemFontOfSize:12];
		self.color = [UIColor blackColor];
		self.underlined = NO;
		self.textAlignment = FTCoreTextAlignementLeft;
		self.maxLineHeight = 0;
		self.paragraphInset = UIEdgeInsetsZero;
		self.applyParagraphStyling = YES;
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	FTCoreTextStyle *style = [[FTCoreTextStyle alloc] init];
	style.name = [[self.name copy] autorelease];
	style.appendedCharacter = [[self.appendedCharacter copy] autorelease];
	style.font = [UIFont fontWithName:self.font.fontName size:self.font.pointSize];
	style.color = self.color;
	style.underlined = self.isUnderLined;
    style.textAlignment = self.textAlignment;
	style.maxLineHeight = self.maxLineHeight;
	style.paragraphInset = self.paragraphInset;
	style.applyParagraphStyling = self.applyParagraphStyling;
	
	return style;
}

- (void)setParagraphInset:(UIEdgeInsets)paragraphInset
{
	if (paragraphInset.bottom < 0) paragraphInset.bottom = 0;
	if (paragraphInset.left < 0) paragraphInset.left = 0;
	if (paragraphInset.right < 0) paragraphInset.right = 0;
	if (paragraphInset.top < 0) paragraphInset.top = 0;
	
	_paragraphInset = paragraphInset;
}

- (void)dealloc
{    
    [_name release];
    [_appendedCharacter release];
    [_font release];
    [_color release];
    [super dealloc];
}

@end
