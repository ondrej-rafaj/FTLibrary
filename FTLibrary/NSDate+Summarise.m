//
//  NSDate+Summarise.m
//  FTLibrary
//
//  Created by Simon Lee on 09/11/2009.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import "NSDate+Summarise.h"

@implementation NSDate (Summarise)


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

@end
