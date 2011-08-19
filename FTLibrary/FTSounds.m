//
//  FTSounds.m
//  AudiEvent
//
//  Created by Ondrej Rafaj on 26/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTSounds.h"


@implementation FTSounds

@synthesize delegate;
@synthesize isPlaying;

#pragma mark Initialization

- (id)init {
	self = [super init];
	if (self) {
		playerArray = [[NSMutableArray alloc] init];
        self.isPlaying = NO;
	}
	return self;
}

#pragma mark Settings

- (void)stopAllSounds {
    NSArray *arr = [[NSArray alloc] initWithArray:playerArray];
    for (AVAudioPlayer *ap in arr) {
        if ([ap isPlaying]) [ap stop];
        [playerArray removeObject:ap];
        [ap release];
    }
    [arr release];
    self.isPlaying = NO;
}

- (void)doPlaySound:(NSString *)soundName {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:soundName ofType:@"mp3"]];
	NSError *error;
	AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	[audioPlayer setDelegate:self];
	if (audioPlayer == nil) NSLog(@"Audio player error: %@", [error description]);
	else {
		[playerArray addObject:audioPlayer];
		[audioPlayer play];
        self.isPlaying = YES;
	}
	[pool drain];
}

- (void)playSoundOnBackground:(NSString *)soundName {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self performSelectorInBackground:@selector(doPlaySound:) withObject:soundName];
	[pool drain];
}

- (void)playSound:(NSString *)soundName {
	[NSThread detachNewThreadSelector:@selector(playSoundOnBackground:) toTarget:self withObject:soundName];
}

#pragma mark Memory management

- (void)dealloc {
	[self stopAllSounds];
	[playerArray release];
    delegate = nil;
    [super dealloc];
}

#pragma mark Audio player delegate methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	[playerArray removeObject:player];
	[player release];
    if (self.delegate && [self.delegate respondsToSelector:@selector(soundDidFinishPlay)]) {
        [self.delegate soundDidFinishPlay];
    }
    self.isPlaying = NO;
}



@end
