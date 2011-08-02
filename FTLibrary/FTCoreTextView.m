//
//  CPCoreTextView.m
//  FTLibrary
//
//  Created by Francesco on 20/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTCoreTextView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import <regex.h>

@implementation FTCoreTextView

@synthesize text = _text;
@synthesize styles = _styles;
@synthesize markers = _markers;
@synthesize defaultStyle = _defaultStyle;
@synthesize processedString = _processedString;
@synthesize path = _path;


- (void)processText {
    
    if (!_text || [_text length] == 0) return;
    _processedString = (NSMutableString *)_text;
    FTCoreTextStyle style;
    [[self.styles objectForKey:@"_default"] getValue:&style];
    self.defaultStyle = style;
    
    NSString *regEx = @"<[a-zA-Z0-9]*( /){0,1}>";
       
    while (YES) {
        int length;
        NSRange rangeStart;
        NSRange rangeActive;
        NSValue *styleV;
        
        
        rangeStart = [_processedString rangeOfString:regEx options:NSRegularExpressionSearch];
        if (rangeStart.location == NSNotFound) return;
        NSString *key = [_processedString substringWithRange:NSMakeRange(rangeStart.location + 1, rangeStart.length - 2)];
       
        NSString *autoCloseKey = [key stringByReplacingOccurrencesOfString:@" /" withString:@""];
        BOOL isAutoClose = (![key isEqualToString:autoCloseKey]);
        
        styleV = [self.styles objectForKey:(isAutoClose)? autoCloseKey : key];
        if (styleV == nil) {
            NSLog(@"Definition of style [%@] not found!", key);
            continue;
        }
        [styleV getValue:&style];
        
        if (isAutoClose) {
            [_processedString replaceCharactersInRange:rangeStart withString:style.appendedCharacter];
            
            rangeActive = NSMakeRange(rangeStart.location, [style.appendedCharacter length]);
        }
        else {
            [_processedString replaceCharactersInRange:rangeStart withString:@""];
            NSRange rangeEnd = [_processedString rangeOfString:[NSString stringWithFormat:@"</%@>", key]];
            [_processedString replaceCharactersInRange:rangeEnd withString:@""];
            
            length = rangeEnd.location - rangeStart.location;
            rangeActive = NSMakeRange(rangeStart.location, length);
            
        }
        
        NSValue *rangeValue = [NSValue valueWithRange:rangeActive];
        NSDictionary *dict = [NSDictionary 
                              dictionaryWithObjects:[NSArray arrayWithObjects:rangeValue, styleV, nil]                                                     
                              forKeys:[NSArray arrayWithObjects:@"range", @"style", nil]];
        rangeValue = nil;
        [_markers addObject:dict]; 
    }
    
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _text = [[NSString alloc] init];
        _markers = [[NSMutableArray alloc] init];
        _processedString = [[NSMutableString alloc] init];
        _styles = [[NSMutableDictionary alloc] init];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    [self processText];
    
    if (!_processedString || [_processedString length] == 0) return;
    
    
    if (!_defaultStyle.name || [_defaultStyle.name length] == 0) {
        _defaultStyle.name = @"_default";
        _defaultStyle.font = [UIFont systemFontOfSize:14];
        _defaultStyle.color= [UIColor blackColor];
        NSLog(@"FTCoreTextView: _default style not found!");
    }
    
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_processedString];
    
    //set default attributeds
    
	[string addAttribute:(id)kCTForegroundColorAttributeName
                   value:(id)_defaultStyle.color.CGColor
                   range:NSMakeRange(0, [_text length])];
    
    CTFontRef ctFont = CTFontCreateWithName((CFStringRef)_defaultStyle.font.fontName, 
                                            _defaultStyle.font.pointSize, 
                                            NULL);
    
    [string addAttribute:(id)kCTFontAttributeName
                   value:(id)ctFont
                   range:NSMakeRange(0, [_text length])];
    
    
    
    //set markers attributes
    
    for (NSDictionary *dict in _markers) {
        NSRange aRange = [(NSValue *)[dict objectForKey:@"range"] rangeValue];
        FTCoreTextStyle style;
        [[dict objectForKey:@"style"] getValue:&style];
        if ((aRange.location + aRange.length) > [_text length] ) continue;
        
        
        
        [string addAttribute:(id)kCTForegroundColorAttributeName
                       value:(id)style.color.CGColor
                       range:aRange];
        ctFont = nil;
        ctFont = CTFontCreateWithName((CFStringRef)style.font.fontName, 
                                                style.font.pointSize, 
                                                NULL);
        
        [string addAttribute:(id)kCTFontAttributeName
                       value:(id)ctFont
                       range:aRange];
        
        
        NSLog(@"just applied attribute %@ from %d to %d", style.name, aRange.location, aRange.length);
        
    }
    
    CFRelease(ctFont);
    
    
	// layout master
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
    
    
	// left column form
	CGMutablePathRef mainPath = CGPathCreateMutable();
   	
    if (!_path) {
        CGPathAddRect(mainPath, NULL, 
                      CGRectMake(0, 0, 
                                 self.bounds.size.width,
                                 self.bounds.size.height));  
    }
    else {
        CGPathAddPath(mainPath, NULL, _path);
    }
    

    
	// left column frame
	CTFrameRef drawFrame = CTFramesetterCreateFrame(framesetter, 
                                                    CFRangeMake(0, 0),
                                                    mainPath, NULL);
    
    // flip the coordinate system
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetTextMatrix(context, CGAffineTransformIdentity);
	CGContextTranslateCTM(context, 0, self.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
    
	// draw
	CTFrameDraw(drawFrame, context);
    
    
    
	// cleanup
	CFRelease(drawFrame);
	CGPathRelease(mainPath);
	CFRelease(framesetter);
	[string release];
}

#pragma mark --
#pragma mark custom setters

- (void)setText:(NSString *)text {
    [_text release];
    _text = [[text mutableCopy] retain];
    [self setNeedsDisplay];
}

- (void)addStyle:(FTCoreTextStyle)style {
    [style.color retain];
    [style.font retain];
    NSValue *value = [NSValue valueWithBytes:&style objCType:@encode(FTCoreTextStyle)];
    [self.styles setValue:value forKey:style.name];
    [self setNeedsDisplay];
}

- (void)setStyles:(NSDictionary *)styles {
    NSArray *allKeys = [styles allKeys];
    for (NSString *key in allKeys) {
        NSValue *value = [styles objectForKey:key];
        FTCoreTextStyle style;
        [value getValue:&style];
        [style.color retain];
        [style.font retain];
    }
    
    [_styles release];
    _styles = [[NSMutableDictionary dictionaryWithDictionary:styles] retain];
    [self setNeedsDisplay];
}

- (void)setPath:(CGPathRef)path {
    _path = path;
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [_text release];
    [_styles release];
    [_markers release];
    [_processedString release];
    [super dealloc];
}

@end
