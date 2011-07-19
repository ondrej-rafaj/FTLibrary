//
//  NSMutableArray+StringSerialiser.m
//  Locassa
//
//  Created by Simon Lee on 15/08/2009.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import "NSMutableArray+StringSerialiser.h"


@implementation NSMutableArray (StringSerialiser)

- (NSString *)stringValue {
	NSMutableString *valueString = [[NSMutableString alloc] init];
	
	for(NSString *value in self) {
		[valueString appendFormat:@"%@|", value];
	}
	
	return [valueString autorelease];
}

+ (NSMutableArray *)fromStringValue:(NSString *)string {
	NSMutableArray *items = [[NSMutableArray alloc] init];	
	NSMutableArray *elements = [[NSMutableArray alloc] initWithArray:[string componentsSeparatedByString:@"|"]];
	[elements removeLastObject];
	
	for(NSString *element in elements) {
		[items addObject:element];
	}
	
	[elements release];
	
	return [items autorelease];
}

@end
