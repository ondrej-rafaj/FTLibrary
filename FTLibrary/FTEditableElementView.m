//
//  FTEditableElementView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 13/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTEditableElementView.h"


@implementation FTEditableElementReturnObject

@synthesize returnString;
@synthesize returnImage;
@synthesize returnData;
@synthesize returnObject;

+ (id)instance {
	return [[[FTEditableElementReturnObject alloc] init] autorelease];
}

- (void)dealloc {
	[returnString release];
	[returnImage release];
	[returnData release];
	[returnObject release];
	[super dealloc];
}

@end


#define kFTEditableElementViewEditIconSize						16


@implementation FTEditableElementView

@synthesize toggleEditModeButton;
@synthesize isEditMode;
@synthesize editIcon;


#pragma mark Initialization

- (void)doMainSetup {
	[self setClipsToBounds:YES];
	[self setToggleEditModeAutomatically:YES];
	[self setEdittingBorderColorForElement:[UIColor yellowColor]];
	[self setEdittingBorderLineWidth:2.0];
	
	// Creating edit icon
	editIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - kFTEditableElementViewEditIconSize), 0, kFTEditableElementViewEditIconSize, kFTEditableElementViewEditIconSize)];
	[editIcon setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin];
	[editIcon setBackgroundColor:[UIColor redColor]];
	[editIcon setUserInteractionEnabled:NO];
	[self addSubview:editIcon];
}

- (void)setupElement {
	
}

- (id)init {
    self = [super init];
    if (self) {
        [self doMainSetup];
		[self setupElement];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self doMainSetup];
		[self setupElement];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self doMainSetup];
		[self setupElement];
    }
    return self;
}

#pragma mark Layout



#pragma mark Drawrect

- (void)refresh {
	[self setNeedsDisplay];
	[self bringSubviewToFront:editIcon];
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	if (_edittingBorderColorForElement && isEditMode) {
		CGContextRef contextRef = UIGraphicsGetCurrentContext();
		CGContextSetLineWidth(contextRef, _edittingBorderLineWidth);
		CGContextSetStrokeColorWithColor(contextRef, _edittingBorderColorForElement.CGColor);
		CGContextStrokeRect(contextRef, rect);
	}
}

#pragma mark Edit mode handling

- (void)configureForEditMode:(BOOL)isEditting {
	
}

- (void)toggleEditMode {
	isEditMode = !isEditMode;
	if (isEditMode) {
		[[NSNotificationCenter defaultCenter] postNotificationName:kFTEditableElementViewStopEdittingNotification object:self];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopEditingNotificationReceived:) name:kFTEditableElementViewStopEdittingNotification object:nil];
		
		[editIcon setBackgroundColor:[UIColor greenColor]];
	}
	else {
		[[NSNotificationCenter defaultCenter] removeObserver:self];
		
		[editIcon setBackgroundColor:[UIColor redColor]];
	}
	[self configureForEditMode:isEditMode];
	[self refresh];
}

- (void)toggleEditModeClicked:(UIButton *)sender {
	[self toggleEditMode];
}

- (void)startEditing {
	if (!isEditMode) {
		[self toggleEditMode];
	}
}

- (void)stopEditing {
	if (isEditMode) {
		[self toggleEditMode];
	}
}

- (void)stopEditingNotificationReceived:(NSNotification *)notification {
	[self stopEditing];
}

#pragma mark Settings

- (void)setEdittingBorderColorForElement:(UIColor *)color {
	[_edittingBorderColorForElement release];
	_edittingBorderColorForElement = [color retain];
	[self refresh];
}

- (UIColor *)edittingBorderColorForElement {
	return _edittingBorderColorForElement;
}

- (void)setEdittingBorderLineWidth:(CGFloat)width {
	if (_edittingBorderLineWidth != width) {
		_edittingBorderLineWidth = width;
		[self refresh];
	}
}

- (CGFloat)edittingBorderLineWidth {
	return _edittingBorderLineWidth;
}

- (void)setBorderType:(FTEditableElementViewBorderType)type {
	if (_borderType != type) {
		_borderType = type;
		[self refresh];
	}
}

- (FTEditableElementViewBorderType)borderType {
	return _borderType;
}

- (void)setBorderStyle:(FTEditableElementViewBorderStyle)style {
	if (_borderStyle != style) {
		_borderStyle = style;
		[self refresh];
	}
}

- (FTEditableElementViewBorderStyle)borderStyle {
	return _borderStyle;
}

- (void)setToggleEditModeAutomatically:(BOOL)automatically {
	_toggleEditModeAutomatically = automatically;
}

- (BOOL)toggleEditModeAutomatically {
	return _toggleEditModeAutomatically;
}

- (void)finishEditIconAnimation {
	if (editIcon.alpha == 0) {
		[editIcon setHidden:YES];
	}
	else {
		[editIcon setHidden:NO];
	}
}

- (void)enableEditIcon:(BOOL)enable animated:(BOOL)animated {
	if (enable) [editIcon setHidden:NO];
	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.2];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(finishEditIconAnimation)];
	}
	if (enable) {
		[editIcon setAlpha:1];
	}
	else {
		[editIcon setAlpha:0];
	}
	if (animated) [UIView commitAnimations];
	else [self finishEditIconAnimation];
}

- (void)enableEditIcon:(BOOL)enable {
	[self enableEditIcon:enable animated:NO];
}

#pragma mark Touches handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (_toggleEditModeAutomatically) {
		
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (_toggleEditModeAutomatically) {
		[self startEditing];
	}
}

#pragma mark Memory management

- (void)dealloc {
	if (isEditMode) {
		[[NSNotificationCenter defaultCenter] removeObserver:self];
	}
	[toggleEditModeButton release];
	[_edittingBorderColorForElement release];
	[editIcon release];
    [super dealloc];
}


@end
