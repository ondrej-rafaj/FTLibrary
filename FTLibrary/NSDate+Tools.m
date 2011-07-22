//
//  NSDate+Tools.m
//  FTLibrary
//
//  Created by Simon Lee on 09/11/2009.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import "NSDate+Tools.h"


#define SECOND     1
#define MINUTE (  60 * SECOND )
#define HOUR   (  60 * MINUTE )
#define DAY    (  24 * HOUR   )
#define WEEK   (   7 * DAY    )
#define MONTH  (  30 * DAY    )
#define YEAR   ( 365 * DAY    )


static NSCalendar *calendar;
static NSDateFormatter *displayFormatter;


@implementation NSDate (Tools)


- (NSString *)humanIntervalSinceNow {
    int delta = [self timeIntervalSinceNow];
    delta *= -1;
    if (delta < 0) {
        return [self description];
    } else if (delta <= 30 * SECOND) {
        return NSLocalizedString(@"just now", nil);
    } else if (delta < 1 * MINUTE) {
        return [NSString stringWithFormat:@"%u secs", delta];
    } else if (delta < 2 * MINUTE) {
        return @"1 min";
    } else if (delta <= 45 * MINUTE) {
        return [NSString stringWithFormat:@"%u mins", delta / MINUTE];
    } else if (delta <= 90 * MINUTE) {
        return @"1 hour";
    } else if (delta < 3 * HOUR) {
        return @"2 hours";
    } else if (delta < 23 * HOUR) {
        return [NSString stringWithFormat:@"%u hours", delta / HOUR];
    } else if (delta < 36 * HOUR) {
        return @"1 day";
    } else if (delta < 72 * HOUR) {
        return @"2 days";
    } else if (delta < 7 * DAY) {
        return [NSString stringWithFormat:@"%u days", delta / DAY];
    } else if (delta < 11 * DAY) {
        return @"1 week";
    } else if (delta < 14 * DAY) {
        return @"2 weeks";
    } else if (delta < 9 * WEEK) {
        return [NSString stringWithFormat:@"%u weeks", delta / WEEK];
    } else if (delta < 19 * MONTH) {
        return [NSString stringWithFormat:@"%u months", delta / MONTH];        
    } else if (delta < 2 * YEAR) {
        return @"1 year";
    } else {
        return [NSString stringWithFormat:@"%u years", delta / YEAR];        
    }
}

- (NSString *)summarise {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterNoStyle];
	
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekdayCalendarUnit;
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
	[comps setHour:0];
	[comps setMinute:0];
	[comps setSecond:0];
	
	NSDate *suppliedDate = [calendar dateFromComponents:comps];
	
	for (int i = -1; i < 7; i++)
	{
		comps = [calendar components:unitFlags fromDate:[NSDate date]];
		[comps setHour:0];
		[comps setMinute:0];
		[comps setSecond:0];
		[comps setDay:[comps day] - i];
		
		NSDate *referenceDate = [calendar dateFromComponents:comps];
		
		int weekday = [[calendar components:unitFlags fromDate:referenceDate] weekday] - 1;

		if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == -1) {		
			[formatter setDateFormat:@"HH:mm"];
			NSString *summary = [NSString stringWithFormat:@"Tomorrow, %@.", [formatter stringFromDate:self]];
			[formatter release];
			return summary;			
		} else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 0)	{		
			[formatter setDateFormat:@"HH:mm"];
			NSString *summary = [NSString stringWithFormat:@"Today, %@.", [formatter stringFromDate:self]];
			[formatter release];
			return summary;
		} else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 1) {		
			[formatter setDateFormat:@"HH:mm"];
			NSString *summary = [NSString stringWithFormat:@"Yesterday, %@.", [formatter stringFromDate:self]];
			[formatter release];
			return summary;
		} else if ([suppliedDate compare:referenceDate] == NSOrderedSame) {	
			[formatter setDateFormat:@"HH:mm"];
			NSString *day = [[formatter weekdaySymbols] objectAtIndex:weekday];
			NSString *summary = [NSString stringWithFormat:@"%@, %@.", day, [formatter stringFromDate:self]];
			[formatter release];
			return summary;
		}
	}
	
	[formatter setDateFormat:@"d MMM yyyy, HH:mm"];	
	NSString *summary = [NSString stringWithFormat:@"%@.", [formatter stringFromDate:self]];
	[formatter release];
	
	return summary;
}

+ (void)load {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    calendar = [[NSCalendar currentCalendar] retain];
    displayFormatter = [[NSDateFormatter alloc] init];
    
	[pool drain];
}

/*
 * This guy can be a little unreliable and produce unexpected results,
 * you're better off using daysAgoAgainstMidnight
 */
- (NSUInteger)daysAgo {
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit) 
											   fromDate:self
												 toDate:[NSDate date]
												options:0];
	return [components day];
}

- (NSUInteger)daysAgoAgainstMidnight {
	// get a midnight version of ourself:
	NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
	[mdf setDateFormat:@"yyyy-MM-dd"];
	NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];
	[mdf release];
	
	return (int)[midnight timeIntervalSinceNow] / (60*60*24) *-1;
}

- (NSString *)stringDaysAgo {
	return [self stringDaysAgoAgainstMidnight:YES];
}

- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag {
	NSUInteger daysAgo = (flag) ? [self daysAgoAgainstMidnight] : [self daysAgo];
	NSString *text = nil;
	switch (daysAgo) {
		case 0:
			text = @"Today";
			break;
		case 1:
			text = @"Yesterday";
			break;
		default:
			text = [NSString stringWithFormat:@"%d days ago", daysAgo];
	}
	return text;
}

- (NSUInteger)weekday {
    NSDateComponents *weekdayComponents = [calendar components:(NSWeekdayCalendarUnit) fromDate:self];
	return [weekdayComponents weekday];
}

+ (NSDate *)dateFromString:(NSString *)string {
	return [NSDate dateFromString:string withFormat:[NSDate dbFormatString]];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:format];
	NSDate *date = [inputFormatter dateFromString:string];
	[inputFormatter release];
	return date;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
	return [date stringWithFormat:format];
}

+ (NSString *)stringFromDate:(NSDate *)date {
	return [date string];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed alwaysDisplayTime:(BOOL)displayTime
{
    /* 
	 * if the date is in today, display 12-hour time with meridian,
	 * if it is within the last 7 days, display weekday name (Friday)
	 * if within the calendar year, display as Jan 23
	 * else display as Nov 11, 2008
	 */
	
	NSDate *today = [NSDate date];
    NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
													 fromDate:today];
	
	NSDate *midnight = [calendar dateFromComponents:offsetComponents];
	
	NSString *displayString = nil;
	
	// comparing against midnight
	if ([date compare:midnight] == NSOrderedDescending) {
		if (prefixed) {
			[displayFormatter setDateFormat:@"'at' h:mm a"]; // at 11:30 am
		} else {
			[displayFormatter setDateFormat:@"h:mm a"]; // 11:30 am
		}
	} else {
		// check if date is within last 7 days
		NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
		[componentsToSubtract setDay:-7];
		NSDate *lastweek = [calendar dateByAddingComponents:componentsToSubtract toDate:today options:0];
		[componentsToSubtract release];
		if ([date compare:lastweek] == NSOrderedDescending) {
            if (displayTime)
                [displayFormatter setDateFormat:@"EEEE h:mm a"]; // Tuesday
            else
                [displayFormatter setDateFormat:@"EEEE"]; // Tuesday
		} else {
			// check if same calendar year
			NSInteger thisYear = [offsetComponents year];
			
			NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
														   fromDate:date];
			NSInteger thatYear = [dateComponents year];			
			if (thatYear >= thisYear) {
                if (displayTime)
                    [displayFormatter setDateFormat:@"MMM d h:mm a"];
                else
                    [displayFormatter setDateFormat:@"MMM d"];
			} else {
                if (displayTime)
                    [displayFormatter setDateFormat:@"MMM d, yyyy h:mm a"];
                else
                    [displayFormatter setDateFormat:@"MMM d, yyyy"];
			}
		}
		if (prefixed) {
			NSString *dateFormat = [displayFormatter dateFormat];
			NSString *prefix = @"'on' ";
			[displayFormatter setDateFormat:[prefix stringByAppendingString:dateFormat]];
		}
	}
	
	// use display formatter to return formatted date string
	displayString = [displayFormatter stringFromDate:date];
	return displayString;
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed {
    // preserve prior behavior
	return [self stringForDisplayFromDate:date prefixed:prefixed alwaysDisplayTime:NO];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date {
	return [self stringForDisplayFromDate:date prefixed:NO];
}

- (NSString *)stringWithFormat:(NSString *)format {
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:format];
	NSString *timestamp_str = [outputFormatter stringFromDate:self];
	[outputFormatter release];
	return timestamp_str;
}

- (NSString *)string {
	return [self stringWithFormat:[NSDate dbFormatString]];
}

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateStyle:dateStyle];
	[outputFormatter setTimeStyle:timeStyle];
	NSString *outputString = [outputFormatter stringFromDate:self];
	[outputFormatter release];
	return outputString;
}

- (NSDate *)beginningOfWeek {
	// largely borrowed from "Date and Time Programming Guide for Cocoa"
	// we'll use the default calendar and hope for the best
	
    NSDate *beginningOfWeek = nil;
	BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginningOfWeek
						   interval:NULL forDate:self];
	if (ok) {
		return beginningOfWeek;
	} 
	
	// couldn't calc via range, so try to grab Sunday, assuming gregorian style
	// Get the weekday component of the current date
	NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
	
	/*
	 Create a date components to represent the number of days to subtract from the current date.
	 The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today's Sunday, subtract 0 days.)
	 */
	NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
	[componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
	beginningOfWeek = nil;
	beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:self options:0];
	[componentsToSubtract release];
	
	//normalize to midnight, extract the year, month, and day components and create a new date from those components.
	NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
											   fromDate:beginningOfWeek];
	return [calendar dateFromComponents:components];
}

- (NSDate *)beginningOfDay {
    // Get the weekday component of the current date
	NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
											   fromDate:self];
	return [calendar dateFromComponents:components];
}

- (NSDate *)endOfWeek {
    // Get the weekday component of the current date
	NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
	NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
	// to get the end of week for a particular date, add (7 - weekday) days
	[componentsToAdd setDay:(7 - [weekdayComponents weekday])];
	NSDate *endOfWeek = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
	[componentsToAdd release];
	
	return endOfWeek;
}

+ (NSString *)dateFormatString {
	return @"yyyy-MM-dd";
}

+ (NSString *)timeFormatString {
	return @"HH:mm:ss";
}

+ (NSString *)timestampFormatString {
	return @"yyyy-MM-dd HH:mm:ss";
}

// preserving for compatibility
+ (NSString *)dbFormatString {	
	return [NSDate timestampFormatString];
}


@end
