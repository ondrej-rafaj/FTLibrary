//
//  NSMutableArray+Tools.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 14/02/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "NSMutableArray+Tools.h"


@implementation NSMutableArray (Tools)

- (void)reverse {
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:j];
        i++;
        j--;
    }
}


@end
