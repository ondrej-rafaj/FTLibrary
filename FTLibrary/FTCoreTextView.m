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
    
    for (NSValue *styleV in _styles) {
        FTCoreTextStyle style;
        [styleV getValue:&style];
        
        while (YES) {
            int length;
            NSRange rangeStart;
            NSRange rangeActive;
            
            if ([style.name isEqualToString:@"bullet"]) {

                 rangeStart = [_processedString rangeOfString:[NSString stringWithFormat:@"<bullet />", style.name]];
                if ((rangeStart.length == 0) || (rangeStart.location >= [_processedString length])) {
                    break;
                }
                [_processedString replaceCharactersInRange:rangeStart withString:@"•"];
                rangeActive = rangeActive = NSMakeRange(rangeStart.location, 1);
                
            }
            else {
                NSRange rangeStart = [_processedString rangeOfString:[NSString stringWithFormat:@"<%@>", style.name]];
                if ((rangeStart.length == 0) || (rangeStart.location >= [_processedString length])) {
                    break;
                }
                [_processedString replaceCharactersInRange:rangeStart withString:@""];
                NSRange rangeEnd = [_processedString rangeOfString:[NSString stringWithFormat:@"</%@>", style.name]];
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
    
    //search for undefined markers!
    
    
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _text = [[NSString alloc] init];
        _markers = [[NSMutableArray alloc] init];
        _processedString = [[NSMutableString alloc] init];
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
    
    NSLog(@"def style : %@", _defaultStyle.name);
    
    if (!_defaultStyle.name) {
        _defaultStyle.name = @"default";
        _defaultStyle.font = [UIFont systemFontOfSize:14];
        _defaultStyle.color= [UIColor blackColor];
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
        if ((aRange.location + aRange.length) > [_text length] || [style.name isEqualToString:@"default"]) continue;
        
        
        
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
    
    if ([style.name isEqualToString:@"default"]) {
        _defaultStyle = style;
        [self setNeedsDisplay];
        return;
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:_styles];
    [array addObject:[NSValue value:&style withObjCType:@encode(FTCoreTextStyle)]];
    [self setStyles:array];
}

- (void)setStyles:(NSArray *)styles {
    [_styles release];
    _styles = [styles retain];
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
