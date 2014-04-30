//
//  FTSounds.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 26/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol FTSoundsDelegate;
@interface FTSounds : NSObject <AVAudioPlayerDelegate> {
	NSMutableArray *playerArray;
    id<FTSoundsDelegate> delegate;
    BOOL isPlaying;
	
}

@property(nonatomic, assign) id<FTSoundsDelegate> delegate;
@property(nonatomic, assign) BOOL isPlaying;

/**
 *  If set to YES, the audio player will be configured to support audio background playback
 *  This values must be configured before the playback is started.
 *  Dont forget to configure Info plist with "UIBackgroundModes: audio"
 *  Default: NO
 */
@property(nonatomic, assign, getter = isBackgroundPlaybackEnabled) BOOL backgroundPlaybackEnabled;

- (void)playSound:(NSString *)soundName;
- (void)playLoopSound:(NSString *)soundName;

- (void)stopAllSounds;


@end

@protocol FTSoundsDelegate <NSObject>
@optional
- (void)soundDidFinishPlay;

@end
