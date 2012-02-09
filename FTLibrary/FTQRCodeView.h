//
//  FTQRCodeView.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 09/02/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FTView.h"
#import "FTImageView.h"
#import "FTGoogleQRCodeURLComposer.h"


@class FTQRCodeView;

@protocol FTQRCodeViewDelegate <NSObject>

@optional

- (void)qrCodeView:(FTQRCodeView *)view didFinishLoadingDataWithComposer:(FTGoogleQRCodeURLComposer *)composer;

@end


@interface FTQRCodeView : FTView <FTImageViewDelegate>


@property (nonatomic, retain) FTImageView *imageView;
@property (nonatomic, retain) FTGoogleQRCodeURLComposer *qrCodeUrlComposer;
@property (nonatomic, assign) id <FTQRCodeViewDelegate> delegate;


- (void)loadQRCode:(FTGoogleQRCodeURLComposer *)qrCodeComposer;


@end
