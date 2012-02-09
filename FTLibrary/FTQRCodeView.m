//
//  FTQRCodeView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 09/02/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FTQRCodeView.h"


@implementation FTQRCodeView

@synthesize imageView = _imageView;
@synthesize qrCodeUrlComposer = _qrCodeUrlComposer;
@synthesize delegate = _delegate;


#pragma mark Layout

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	[_imageView setFrame:self.bounds];
}

#pragma mark Initialization

- (void)initializeView {
	self.imageView = [[FTImageView alloc] initWithFrame:self.bounds];
	[self addSubview:_imageView];
}

#pragma mark Loading data

- (void)loadQRCode:(FTGoogleQRCodeURLComposer *)qrCodeComposer {
	[_imageView loadImageFromUrl:[qrCodeComposer getUrlString]];
	[_qrCodeUrlComposer release];
	self.qrCodeUrlComposer = qrCodeComposer;
}

#pragma mark Image view delegate methods

- (void)imageView:(FTImageView *)imgView didFinishLoadingImage:(UIImage *)image {
	[_qrCodeUrlComposer.image release];
	self.qrCodeUrlComposer.image = image;
	if ([_delegate respondsToSelector:@selector(qrCodeView:didFinishLoadingDataWithComposer:)]) {
		[_delegate qrCodeView:self didFinishLoadingDataWithComposer:_qrCodeUrlComposer];
	}
}

#pragma mark Memory handling

- (void)dealloc {
	[_imageView release];
	[_qrCodeUrlComposer release];
	[super dealloc];
}


@end
