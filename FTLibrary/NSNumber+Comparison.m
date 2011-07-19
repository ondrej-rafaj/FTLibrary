//
//  NSNumber+Comparison.m
//  Locassa
//
//  Created by Simon Lee on 30/11/2009.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import "NSNumber+Comparison.h"


@implementation NSNumber (Comparison)

+ (BOOL) doubleValue:(double)sourceValue equalsDoubleValue:(double)destinationValue {
	NSNumber *source = [[NSNumber alloc] initWithDouble:sourceValue];
	NSNumber *destination = [[NSNumber alloc] initWithDouble:destinationValue];
	
	BOOL equal = [source isEqualToNumber:destination];
	
	[source release];
	[destination release];
	
	return equal;
}

@end
