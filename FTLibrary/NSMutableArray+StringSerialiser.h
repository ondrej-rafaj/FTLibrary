//
//  NSMutableArray+StringSerialiser.h
//  Locassa
//
//  Created by Simon Lee on 15/08/2009.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableArray (StringSerialiser)

- (NSString *)stringValue;
+ (NSMutableArray *)fromStringValue:(NSString *)string;

@end
