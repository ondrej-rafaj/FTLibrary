//
//  FTGoogleQRCodeURLComposer.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 09/02/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum {
	
	FTGoogleQRCodeURLComposerDataTypeTextMessage
	
} FTGoogleQRCodeURLComposerDataType;


@interface FTGoogleQRCodeURLComposer : NSObject


@property (nonatomic) CGFloat size;
@property (nonatomic) FTGoogleQRCodeURLComposerDataType type;
@property (nonatomic, retain) UIImage *image;

- (NSString *)getUrlString;
- (NSURL *)getUrl;


@end
