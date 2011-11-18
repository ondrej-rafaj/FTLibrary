//
//  FTScrollableClockView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 02/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTScrollableClockView.h"
#import "FTLabel.h"


#pragma mark Time object implementation

@implementation FTScrollableClockViewTime
@synthesize hours;
@synthesize minutes;
@synthesize time;


- (void)setHours:(NSInteger)ahours {
    if (ahours < 0 || ahours > 23) return;
    hours = ahours;
}

- (void)setMinutes:(NSInteger)aminutes {
    if (minutes < 0 || minutes > 59) return;
    minutes = aminutes;
}

- (NSDate *)time {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:self.hours];
    [components setMinute:self.minutes];
    NSDate *date = [calendar dateFromComponents:components]; 
    return date;

}

- (void)setTime:(NSDate *)atime {
    [time release];
    time = [atime retain];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:time];
    self.hours = components.hour;
    self.minutes = components.minute;
}

@end


#pragma mark Scrolling clock implementation

@implementation FTScrollableClockView

@synthesize hours;
@synthesize minutes;
@synthesize timeFormat;
@synthesize delegate;

- (void)snapScrollViewToClosestPosition:(UIScrollView *)scrollView {
    int h = (int)scrollView.bounds.size.height;
    int discard = ((int)scrollView.contentOffset.y % h);
    int pageY = (discard > ([scrollView height] / 2))? scrollView.contentOffset.y + (h - discard) : scrollView.contentOffset.y - discard; 
    [scrollView setContentOffset:CGPointMake(0, pageY) animated:YES];
    
}

// move the scroll feed to the center to infinite scroll effect
- (void)centerScrollFeed:(UIScrollView *)scrollView {
    
    // try center approach!
    
    [self snapScrollViewToClosestPosition:scrollView];
    int h = self.bounds.size.height;
    int moveY = (scrollView == self.hours)? (24 * h) : (60 * h);
    int third = ceilf(scrollView.contentOffset.y/moveY);
    if (third != 2) {
        if (third == 3) moveY *= -1;
        moveY = scrollView.contentOffset.y + moveY;
        if (moveY != 0) [scrollView setContentOffset:CGPointMake(0, moveY) animated:NO];
    }
    
}




//check if should add or sub an hour
-(void)checkPageUp:(int)page {
    //check change
    static int previousMinute = 0;
    if (page == previousMinute) return;
    
    //check if Analog is dragging
    BOOL shouldPageUP = YES;
    if ([delegate respondsToSelector:@selector(scrollableClockViewshoudPageUp:)]) {
        shouldPageUP = [delegate scrollableClockViewshoudPageUp:self];
    }
    
    //check UP or DOWN
    int multiplier = 0;
    //page up
    if ((page == 0) && (previousMinute <= 59 && previousMinute > 55)) {
        multiplier = 1;
    }
    //page down
    if ((page == 59) && (previousMinute >= 0 && previousMinute < 5)) {
        multiplier = -1;
    }
    
    if (multiplier != 0 && shouldPageUP){
        (multiplier == 1)? self.currentTime.hours++ : self.currentTime.hours--;
        int moveY = self.hours.contentOffset.y + (multiplier * self.bounds.size.height);
        [self.hours setContentOffset:CGPointMake(0, moveY) animated:YES];
        //[hours scrollRectToVisible:CGRectMake(0, moveY, 1, self.bounds.size.height) animated:YES];
        [self snapScrollViewToClosestPosition:self.hours];
        
    }
    
    previousMinute = (page);
    
}

#pragma mark Creating elements

- (UILabel *)timeLabelWithValue:(NSInteger)value round:(NSInteger)round forScrollView:(UIScrollView *)scrollView {
    int multiplier = (scrollView == self.hours)? (round * 24) : (round * 60);
	int y = (multiplier * [self height]) + (value * [self height]);
	FTLabel *label = [[[FTLabel alloc] initWithFrame:CGRectMake(0, y, ([self width] / 2), [self height])] autorelease];
	NSString *textValue;
	if (scrollView == hours && timeFormat == FTScrollableClockViewTimeFormat12H) {
		if (value > 12) value -= 12;
	}
    [label setLetterSpacing:14];
	textValue = [NSString stringWithFormat:@"%@%d", ((value < 10) ? @"0" : @""), value];
	[label setText:textValue];
	[label setFont:[UIFont boldSystemFontOfSize:14]];
	[label setTextAlignment:UITextAlignmentCenter];
	[label setTextColor:[UIColor darkTextColor]];
	return label;
}

- (void)createHoursScrollView {
	hourLabels = [[NSMutableArray alloc] init];
	hours = [[UIScrollView alloc] initWithFrame:CGRectMake(12, 0, ([self width] / 2), [self height])];
	[hours setShowsVerticalScrollIndicator:NO];
	[hours setShowsHorizontalScrollIndicator:NO];
    [hours setPagingEnabled:NO];
    [hours setBounces:YES];
    [hours setDecelerationRate:UIScrollViewDecelerationRateNormal];
	[hours setDelegate:self];
	[hours setBackgroundColor:[UIColor clearColor]];
    for (int j = 0; j < 3; j++) {
        for (int i = 0; i < 24; i++) {
            UILabel *label = [self timeLabelWithValue:i round:j forScrollView:hours];
            [hourLabels addObject:label];
            [hours addSubview:label];
        }
    }
	[hours setContentSize:CGSizeMake([hours width], ([hourLabels count] * [hours height]))];
	[self addSubview:hours];
    
}

- (void)createMinutesScrollView {
	minuteLabels = [[NSMutableArray alloc] init];
	minutes = [[UIScrollView alloc] initWithFrame:CGRectMake(([self width] / 2), 0, ([self width] / 2), [self height])];
	[minutes setShowsVerticalScrollIndicator:NO];
	[minutes setShowsHorizontalScrollIndicator:NO];
    [minutes setPagingEnabled:NO];
    [minutes setBounces:YES];
    [minutes setDecelerationRate:UIScrollViewDecelerationRateNormal];
    [minutes setDelegate:self];
	[minutes setBackgroundColor:[UIColor clearColor]];
    for (int j = 0; j < 3; j++) {
        for (int i = 0; i < 60; i++) {
            UILabel *label = [self timeLabelWithValue:i round:j forScrollView:minutes];
            [minuteLabels addObject:label];
            [minutes addSubview:label];
        }
    }
	[minutes setContentSize:CGSizeMake([minutes width], ([minuteLabels count] * [minutes height]))];
	[self addSubview:minutes];
}

- (void)createAllElements {
	[self createHoursScrollView];
	[self createMinutesScrollView];
}

#pragma mark Initialization

- (void)initializeView {
	[self createAllElements];
	
	[self setBackgroundColor:[UIColor clearColor]];
	
	if (!_currentTime) {
		FTScrollableClockViewTime *time = [[FTScrollableClockViewTime alloc] init];
		time.hours = 6;
		time.minutes = 25;
		[self setCurrentTime:time];
		[time release];
	}
}

- (id)initWithFrame:(CGRect)frame currentTime:(FTScrollableClockViewTime *)time andTimeFormat:(FTScrollableClockViewTimeFormat)format {
	timeFormat = format;
    self = [super initWithFrame:frame];
    if (self) {
        [self setCurrentTime:time];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andTimeFormat:(FTScrollableClockViewTimeFormat)format {
	timeFormat = format;
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


#pragma mark Scroll view delegate methods



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	int page = (scrollView.contentOffset.y / [scrollView height]);
	BOOL valueChanged = NO;
	
    if (scrollView == hours) {
		if (_currentTime.hours != page) valueChanged = YES;
        int limit = 24;
        page = (page%limit);
		[_currentTime setHours:page];
	}
	else if (scrollView == minutes) {
		if (_currentTime.minutes != page) valueChanged = YES;
        int limit = 60;
        page = (page%limit);
		[_currentTime setMinutes:page];
        if (valueChanged) [self checkPageUp:page];
	}
    
    if ([delegate respondsToSelector:@selector(scrollableClockView:didChangeTime:)]) {
        [delegate scrollableClockView:self didChangeTime:_currentTime];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self snapScrollViewToClosestPosition:scrollView];
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self centerScrollFeed:scrollView];
    //delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollableClockViewIsScrolling:)]) {
        [self.delegate scrollableClockViewIsScrolling:self];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self centerScrollFeed:scrollView];
    

    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollableClockView:didEndScrollingWithTime:)]) {
        [self.delegate scrollableClockView:self didEndScrollingWithTime:self.currentTime];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (!decelerate) [self snapScrollViewToClosestPosition:scrollView];
    
}

#pragma mark Setters & getters

- (void)setCurrentTime:(FTScrollableClockViewTime *)currentTime animated:(BOOL)animated {
	[_currentTime release];
	_currentTime = currentTime;
	[_currentTime retain];
	
	[hours setContentOffset:CGPointMake(0, (_currentTime.hours * [self height])) animated:animated];
	[self centerScrollFeed:self.hours];
    [minutes setContentOffset:CGPointMake(0, (_currentTime.minutes * [self height])) animated:animated];
    [self centerScrollFeed:self.minutes];
}

- (void)setCurrentTime:(FTScrollableClockViewTime *)currentTime {
	[self setCurrentTime:currentTime animated:NO];
}

- (FTScrollableClockViewTime *)currentTime {
	return _currentTime;
}

- (void)setFont:(UIFont *)font {
	for (UILabel *l in hourLabels) {
		[l setFont:font];
	}
	for (UILabel *l in minuteLabels) {
		[l setFont:font];
	}
}

- (void)setTextColor:(UIColor *)color {
	for (UILabel *l in hourLabels) {
		[l setTextColor:color];
	}
	for (UILabel *l in minuteLabels) {
		[l setTextColor:color];
	}
}

- (void)setTextAlignment:(UITextAlignment)alignment {
	for (UILabel *l in hourLabels) {
		[l setTextAlignment:alignment];
	}
	for (UILabel *l in minuteLabels) {
		[l setTextAlignment:alignment];
	}
}


#pragma mark Memory management

- (void)dealloc {
	[hours release];
	[minutes release];
	[_currentTime release];
	[hourLabels release];
	[minuteLabels release];
	[super dealloc];
}


@end
