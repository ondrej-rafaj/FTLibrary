//
//  FTDebugMemoryLabelView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 25/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTDebugMemoryLabelView.h"
#import "FTAppDelegate.h"
#import "FTMemTools.h"
#import "FTProject.h"


@implementation FTDebugMemoryLabelView


#pragma merk Initialization

- (id)init {
	CGRect r = CGRectMake(5, 5, 85, 17);
    self = [super initWithFrame:r];
    if (self) {
		r.origin.x = 2;
		r.origin.y = 2;
		r.size.width -= 4;
		r.size.height -= 4;
		
		[self setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.7]];
		
		label = [[UILabel alloc] initWithFrame:r];
		[label setFont:[UIFont systemFontOfSize:10]];
		[label setBackgroundColor:[UIColor clearColor]];
		[label setTextColor:[UIColor blackColor]];
		[self addSubview:label];
		
		//UIWindow *window = [FTAppDelegate window];
		//[window addSubview:self];
    }
    return self;
}

#pragma mark Getting values

- (void)update {
	float mem = (float)[FTMemTools getAvailableMemoryInKb];
	[label setText:[NSString stringWithFormat:@"FM: %.2f Mb", (mem / 1024.0f)]];
}

#pragma settings

- (void)startUpdatingWithInterval:(NSTimeInterval)time {
	timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(update) userInfo:nil repeats:YES];
}

- (void)startUpdating {
	[self startUpdatingWithInterval:0.2];
}

- (void)stopUpdating {
	[timer invalidate];
}

+ (FTDebugMemoryLabelView *)start {
	FTDebugMemoryLabelView *v = [[FTDebugMemoryLabelView alloc] init];
	[v startUpdating];
	return [v autorelease];
}

+ (FTDebugMemoryLabelView *)startIfDebug {
	if ([FTProject debugging]) return [self start];
	else return nil;
}

+ (FTDebugMemoryLabelView *)startWithView:(UIView *)view {
	FTDebugMemoryLabelView *debug = [self start];
	[view addSubview:debug];
	return debug;
}

+ (void)startWithWindow:(UIWindow *)window {
	[window addSubview:[self start]];
}

#pragma mark Memory management

- (void)dealloc {
	[label release];
	[timer invalidate];
	[timer release];
	[super dealloc];
}


@end
