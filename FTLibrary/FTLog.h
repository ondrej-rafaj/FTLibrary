//
//  FTLog.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 02/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG

#define FTLog(args...) _FTLog([self class], __FILE__,__LINE__,__PRETTY_FUNCTION__,args);

#else

#define FTLog(x...)

#endif

void _FTLog(Class klass, const char *file, int lineNumber, const char *funcName, NSString *format,...);


#if defined(DEBUG)
@protocol LOGGING

+ (BOOL)LOGGING_shouldLog;

@end

@interface NSObject (LOGGING) <LOGGING>

+ (BOOL)LOGGING_shouldLog;

@end
#endif
