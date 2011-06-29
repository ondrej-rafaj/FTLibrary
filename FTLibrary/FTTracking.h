//
//  FTTracking.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 28/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlurryAPI.h"


@interface FTTracking : NSObject


- (void)logEvent:(NSString *)event;


@end
