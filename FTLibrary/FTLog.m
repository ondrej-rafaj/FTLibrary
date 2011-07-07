//
//  FTLog.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 02/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#include "FTLog.h"

#if defined(DEBUG)

void _FTLog(Class <LOGGING> klass, const char *file, int lineNumber, const char *funcName, NSString *format, ...) {
    
    if (![klass LOGGING_shouldLog]) {
        return;
    }
    
	va_list ap;
	
	va_start (ap, format);
    
	NSString *fileName=[[NSString stringWithUTF8String:file] lastPathComponent];
	const char *threadName = [[[NSThread currentThread] name] UTF8String];
    
    NSString *extendedFormat = nil;
    
	if (threadName) {
		extendedFormat = [[NSString alloc] initWithFormat:@"%s/%s (%s:%d)\n%@\n", threadName, funcName, [fileName UTF8String], lineNumber, format];
	}
	else {
		extendedFormat = [[NSString alloc] initWithFormat:@"%p/%s (%s:%d) \r\n %@", [NSThread currentThread], funcName, [fileName UTF8String], lineNumber, format];
	}
    
    NSLogv(extendedFormat, ap);
    [extendedFormat release];
    
	va_end (ap);
}

#endif

#if defined(DEBUG)
@implementation NSObject (LOGGING)

+ (BOOL)LOGGING_shouldLog {
	return YES;
	
    NSString *key = nil;
    BOOL result = NO;
	
	key = [[NSString alloc] initWithFormat:@"LOGGING_EnabledFor%@", NSStringFromClass([self class])];
	result = [[NSUserDefaults standardUserDefaults] boolForKey:key] || [[NSUserDefaults standardUserDefaults] boolForKey:@"LOGGING_EnabledForALL"];
    
	[key release];
	return result;
}
#endif

@end
