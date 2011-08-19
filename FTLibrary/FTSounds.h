//
//  FTSounds.h
//  AudiEvent
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

- (void)playSound:(NSString *)soundName;

- (void)stopAllSounds;


@end

@protocol FTSoundsDelegate <NSObject>
@optional
- (void)soundDidFinishPlay;

@end
