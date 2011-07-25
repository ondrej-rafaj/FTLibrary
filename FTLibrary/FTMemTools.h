//
//  FTMemTools.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 23.1.11.
//  Copyright Fuerte Int Ltd. (http://www.fuerteint.com) 2011. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FTMemTools : NSObject {
	
}

+ (void)logMemory:(NSString *)ident;

+ (void)logMemoryInFunction:(NSString *)function;

+ (natural_t)getAvailableMemory;

+ (natural_t)getAvailableMemoryInKb;


@end
