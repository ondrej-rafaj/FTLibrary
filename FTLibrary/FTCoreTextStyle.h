//
//  FTCoreTextStyle.h
//  Deloitte
//
//  Created by Fuerte International on 10/08/2011.
//  Copyright 2011 Baldoph Pourprix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FTCoreTextStyle : NSObject <NSCopying> {
    NSString *name;
    NSString *appendedCharacter;
    UIFont *font;
    UIColor *color;
    BOOL isUnderLined;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *appendedCharacter;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) UIColor *color;
@property (nonatomic, assign, getter=isUnderLined) BOOL isUnderLined;

@end