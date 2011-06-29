//
//  FTProjectInitialization.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 28/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
	
	FTProjectInitializationFunctionTypeTrackingFlurry,
	FTProjectInitializationFunctionTypeTrackingGoogle
	
} FTProjectInitializationFunctionType;


@interface FTProjectInitialization : NSObject {
	
}

+ (void)initialize;

+ (void)resume;

+ (void)enableFlurryWithApiKey:(NSString *)apiKey;

+ (BOOL)isUsing:(FTProjectInitializationFunctionType)functionality;


@end
