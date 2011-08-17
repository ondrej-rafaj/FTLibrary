//
//  FTAppDelegate.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 06/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTAppDelegate.h"
#import "FTLang.h"


@implementation FTAppDelegate

@synthesize languageURL = _languageURL;
@synthesize languages = _languages;


+ (id)delegate {
	return [[UIApplication sharedApplication] delegate];
}

+ (UIWindow *)windowFromSelector:(SEL)selector {
	if ([[UIApplication sharedApplication] respondsToSelector:selector]) {
		return [[UIApplication sharedApplication] performSelector:selector];
	}
	else return nil;
}

+ (UIWindow *)window {
	return [self windowFromSelector:@selector(window)];
}

#pragma mark set languages

- (NSString *)languageURL {
    return @"";
}

- (NSDictionary *)languages {
    if (!_languages) {
        _languages = [FTLang importLanguagesFromURL:(NSString *)[self languageURL]];
        [_languages retain];
    }
    return _languages;
}

@end
