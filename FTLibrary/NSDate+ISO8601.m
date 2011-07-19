//
//  NSDate+ISO8601.m
//

#import "NSDate+ISO8601.h"


@implementation NSDate(ISO8601)

static NSDateFormatter *formatter = nil;

+ (NSDate *)dateFromISO8601String:(NSString *)dateString {
    NSDate *aDate = nil;
    NSArray *dateFormats = [NSArray arrayWithObjects:@"yyyy-MM-dd",
							@"yyyy-MM-dd'T'HH:mmZZZ", 
                            @"yyyy-MM-dd'T'HH:mm:ssZZZ", 
                            @"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ", nil];
    
    if ([dateString hasSuffix:@"Z"]) {
        dateString = [dateString stringByReplacingOccurrencesOfString:@"Z" withString:@"+0000"];
    }
    
    // Strict unicode standard has timezones as +0100 or -0500 not +01:00 or -05:00, so fix them if required
    dateString = [dateString stringByReplacingOccurrencesOfString:@":" 
                                                       withString:@"" 
                                                          options:0 
                                                            range:NSMakeRange([dateString length] - 5,5)];
    
    if (formatter == nil)
        formatter = [[NSDateFormatter alloc] init];
    
    for (NSString *dateFormat in dateFormats) {
        [formatter setDateFormat:dateFormat];
        aDate = [formatter dateFromString:dateString];
        if (aDate != nil)
            break;
    }
    
    return aDate;
}

@end
