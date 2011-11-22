//
//  FTError.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 29/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTError.h"


@implementation FTError

+ (void)handleErrorWithString:(NSString *)errorMessage {
	//[NSException raise:errorMessage format:@""];
    NSLog(@"Error: %@", errorMessage);
	//abort();
}

+ (void)handleError:(NSError *)error {
	[self handleErrorWithString:error.localizedDescription];
}


@end
