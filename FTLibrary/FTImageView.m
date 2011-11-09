//
//  FTImageView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 27/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTImageView.h"
#import "UIColor+Tools.h"
#import "FTFilesystem.h"
#import "FTText.h"
#import "UIView+Layout.h"


@implementation FTImageView

@synthesize overlayImage;
@synthesize delegate;
@synthesize activityIndicator;
@synthesize progressLoadingView;
@synthesize useAsiHTTPRequest;
@synthesize debugMode;
@synthesize imageUrl;


#pragma mark Debug mode methods

- (void)updateDebugInfo:(NSString *)message {
	if (debugMode) {
		NSString *t = @"";
		t = [t stringByAppendingFormat:@"Message: %@\n", message];
		t = [t stringByAppendingFormat:@"Url: %@\n", imageUrl];
		[debugLabel setText:t];
	}
}

#pragma mark Initilization

//set the image resizable and centered
- (void)doSetup {
	// Basic self setup
	[self setContentMode:UIViewContentModeScaleAspectFill];
	[self setClipsToBounds:YES];
	debugMode = NO;
	
	// Adding overlay image
    overlayImage = [[UIImageView alloc] initWithFrame:self.bounds];
    [overlayImage setBackgroundColor:[UIColor clearColor]];
    [overlayImage setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [overlayImage setContentMode:UIViewContentModeCenter];
    [self addSubview:overlayImage];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self doSetup];
    }
    return self;
}

- (id)initWithFrameWithRandomColor:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self doSetup];
        
    }
    return self;
}

- (id)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        [self doSetup];
    }
    return self;
}

#pragma mark Settings

- (void)setRandomColorBackground {
    [self setBackgroundColor:[UIColor randomColor]];
}

- (void)doFlashWithColor:(UIColor *)color {
	flashOverlay = [[UIView alloc] initWithFrame:self.bounds];
	[flashOverlay setBackgroundColor:color];
	[flashOverlay setAlpha:0];
	[self addSubview:flashOverlay];
	[UIView animateWithDuration:0.3
					 animations:^{
						 [flashOverlay setAlpha:1];
					 } 
					 completion:^(BOOL finished) {
						 [UIView animateWithDuration:0.2 
										  animations:^{
											  [flashOverlay setAlpha:0];
										  }
										  completion:^(BOOL finished) {
											  [flashOverlay removeFromSuperview];
											  [flashOverlay release];
										  }];
					 }];
}

#pragma mark Loading elements handling

- (void)enableLoadingElements:(BOOL)enable {
	[UIView beginAnimations:nil context:nil];
	if (activityIndicator) {
		[activityIndicator setAlpha:(enable) ? 1 : 0];
	}
	if (progressLoadingView) {
		[progressLoadingView setAlpha:(enable) ? 1 : 0];
	}
	[UIView commitAnimations];
}

- (void)enableActivityIndicator:(BOOL)enable {
	if (enable) {
		if (!activityIndicator) {
			activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
			[activityIndicator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
			[activityIndicator setAlpha:0];
			[activityIndicator startAnimating];
			[self addSubview:activityIndicator];
			[activityIndicator aestheticCenterInSuperView];
			[self enableLoadingElements:YES];
		}
	}
	else {
		if (activityIndicator) {
			[UIView animateWithDuration:0.3
							 animations:^{
								 [activityIndicator setAlpha:0];
							 }
							 completion:^(BOOL finished) {
								 [activityIndicator removeFromSuperview];
								 [activityIndicator release];
								 activityIndicator = nil;
							 }
			 ];
		}
	}
}

#pragma mark Background image loading

- (void)loadImage:(NSString *)url {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSData *data;
	NSString *path = [[FTFilesystemPaths getCacheDirectoryPath] stringByAppendingPathComponent:[FTText getSafeText:url]];
	BOOL isLoadingFromUrl = NO;
	@synchronized(self) {
		if (![FTFilesystemIO isFile:path]) {
			data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
			[data writeToFile:path atomically:YES];
			isLoadingFromUrl = YES;
		}
		else {
			data = [NSData dataWithContentsOfFile:path];
		}
	}
	UIImage *img = [UIImage imageWithData:data];
	[self performSelectorOnMainThread:@selector(setImage:) withObject:img waitUntilDone:NO];
	
	if (isLoadingFromUrl) {
		if ([delegate respondsToSelector:@selector(imageView:didFinishLoadingImageFromInternet:)]) {
			[delegate imageView:self didFinishLoadingImageFromInternet:img];
		}
	}
	if ([delegate respondsToSelector:@selector(imageView:didFinishLoadingImage:)]) {
		[delegate imageView:self didFinishLoadingImage:img];
	}
	
	[pool release];
}

- (void)loadImageFromUrlOnBackground:(NSString *)url {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self performSelectorInBackground:@selector(loadImage:) withObject:url];
	[pool release];
}

- (BOOL)isCacheFileForUrl:(NSString *)url {
	NSString *path = [[FTFilesystemPaths getCacheDirectoryPath] stringByAppendingPathComponent:[FTText getSafeText:url]];
	return ([FTFilesystemIO isFile:path]);
}

- (void)loadImageFromUrl:(NSString *)url {
	[imageUrl release];
	imageUrl = url;
	[imageUrl retain];
	
	NSString *path = [[FTFilesystemPaths getCacheDirectoryPath] stringByAppendingPathComponent:[FTText getSafeText:url]];
	if ([FTFilesystemIO isFile:path]) {
		[NSThread detachNewThreadSelector:@selector(loadImageFromUrlOnBackground:) toTarget:self withObject:url];
		[self updateDebugInfo:@"Loading from cache"];
		return;
	}
	else {
		if (!useAsiHTTPRequest) {
			[self updateDebugInfo:@"Loading url from web"];
			[NSThread detachNewThreadSelector:@selector(loadImageFromUrlOnBackground:) toTarget:self withObject:url];
		}
		else {
			imageRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
			[imageRequest setDelegate:self];
			[imageRequest startAsynchronous];
		}
	}
}

#pragma mark ASIHTTPRequest delegate methods

- (void)requestFinished:(ASIHTTPRequest *)request {
	[self updateDebugInfo:@"Request successful"];
	[self enableLoadingElements:NO];
	UIImage *img = [UIImage imageWithData:[request responseData]];
	NSString *path = [[FTFilesystemPaths getCacheDirectoryPath] stringByAppendingPathComponent:[FTText getSafeText:request.url.absoluteString]];
	[[request responseData] writeToFile:path atomically:YES];
	[self performSelectorOnMainThread:@selector(setImage:) withObject:img waitUntilDone:NO];
	
	if ([delegate respondsToSelector:@selector(imageView:didFinishLoadingImageFromInternet:)]) {
		[delegate imageView:self didFinishLoadingImageFromInternet:img];
	}
	if ([delegate respondsToSelector:@selector(imageView:didFinishLoadingImage:)]) {
		[delegate imageView:self didFinishLoadingImage:img];
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	[self updateDebugInfo:@"Request failed"];
	[self enableLoadingElements:NO];
	if ([delegate respondsToSelector:@selector(imageViewDidFailLoadingImage:withError:)]) {
		[delegate imageViewDidFailLoadingImage:self withError:[request error]];
	}
}

- (void)requestStarted:(ASIHTTPRequest *)request {
	[self updateDebugInfo:@"Request started"];
	[self enableLoadingElements:YES];
	if ([delegate respondsToSelector:@selector(imageViewDidStartLoadingImage:)]) {
		[delegate imageViewDidStartLoadingImage:self];
	}
}

#pragma mark Memory management

- (void)dealloc {
	[self setDelegate:nil];
    [overlayImage release];
	[activityIndicator release];
	[progressLoadingView release];
	[imageRequest cancel];
	[imageRequest setDelegate:nil];
	[imageRequest release];
	[debugLabel release];
	[imageUrl release];
    [super dealloc];
}

#pragma mark Debug mode

- (void)enableDebugMode:(BOOL)enable {
	debugMode = enable;
	if (enable) {
		debugLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 180, 180)];
		[debugLabel setBackgroundColor:[UIColor orangeColor]];
		[debugLabel setTextColor:[UIColor whiteColor]];
		[debugLabel setFont:[UIFont systemFontOfSize:11]];
		[debugLabel setAlpha:0.8];
		[debugLabel setTextAlignment:UITextAlignmentCenter];
		[debugLabel setText:@"Debug label"];
		[debugLabel setNumberOfLines:0];
		[self addSubview:debugLabel];
	}
	else {
		if (debugLabel) {
			[debugLabel removeFromSuperview];
			[debugLabel release];
			debugLabel = nil;
		}
	}
}


@end
