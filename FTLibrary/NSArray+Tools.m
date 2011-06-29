//
//  NSArray+Tools.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 14/02/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "NSArray+Tools.h"


@implementation NSArray (Tools)

- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

@end
