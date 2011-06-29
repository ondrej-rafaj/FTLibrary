//
//  FTError.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 29/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FTError : NSObject {
    
}

+ (void)handleErrorWithString:(NSString *)errorMessage;

+ (void)handleError:(NSError *)error;


@end
