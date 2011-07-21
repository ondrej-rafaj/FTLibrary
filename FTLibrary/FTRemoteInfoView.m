//
//  FTRemoteInfoView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 24/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTRemoteInfoView.h"


@implementation FTRemoteInfoView

@synthesize dataUrl;
@synthesize data;
@synthesize title;
@synthesize content;


#pragma mark Data loading

#pragma mark Initialization

- (id)initWithDataUrl:(NSURL *)url {
	CGRect r = CGRectZero;
    self = [super initWithFrame:r];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark Draw rect

- (void)drawRect:(CGRect)rect {
    
}

#pragma mark Memory management

- (void)dealloc {
	[dataUrl release];
	[data release];
	[title release];
	[content release];
    [super dealloc];
}

@end
