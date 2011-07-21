//
//  FTSounds.h
//  AudiEvent
//
//  Created by Ondrej Rafaj on 26/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface FTSounds : NSObject <AVAudioPlayerDelegate> {
    
	NSMutableArray *playerArray;
	
}

- (void)playSound:(NSString *)soundName;

- (void)stopAllSounds;


@end
