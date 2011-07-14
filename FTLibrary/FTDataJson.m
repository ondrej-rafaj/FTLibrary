//
//  FTDataJson.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 29/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTDataJson.h"
#import "SBJson.h"
#import "FTError.h"


@implementation FTDataJson

+ (id)jsonDataFromString:(NSString *)string {
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	NSError *error = nil;
	id d = [parser objectWithString:string error:&error];
	if (error) [FTError handleError:error];
	return d;
}

+ (id)jsonDataFromUrl:(NSString *)url {
	NSString *string = [super stringWithContentsOfUrl:url];
	return [self jsonDataFromString:string];
}


@end
