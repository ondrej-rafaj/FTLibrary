//
//  FTImageService.m
//
//  Created by Simon Lee on 11/09/2009.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FTImageService.h"
#import "UIImage+Tint.h"
#import "UIView+Layout.h"

@implementation FTImageService

#define kCacheKeyImage							@"Image"
#define kCacheKeyImageDate						@"ImageDate"

+ (FTImageService *)instance  {
	static FTImageService *instance;
	
	@synchronized(self) {
		if(!instance) {
			instance = [[FTImageService alloc] init];
		}
	}
	
	return instance;
}

- (id) init {
	self = [super init];
	
	if(self != nil) {
		imageCache = [[NSMutableDictionary alloc] initWithCapacity:0];
		urlImageCache = [[NSMutableDictionary alloc] initWithCapacity:0];
	}
	
	return self;	
}

- (void) dealloc {
	[imageCache release];
	[urlImageCache release];
	[super dealloc];
}

- (void) freeMemory {
	[imageCache removeAllObjects];
	[urlImageCache removeAllObjects];
}

- (UIImage *) loadImage:(NSString *)imageName {
	UIImage *cachedImage = [imageCache objectForKey:imageName];
	
	if (cachedImage == nil)	{
		NSString *imageFile = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
		cachedImage = [UIImage imageWithContentsOfFile:imageFile];
		
		if(cachedImage != nil) {
			[imageCache setObject:cachedImage forKey:imageName];
		}
	}
	
	return cachedImage;
}

- (UIImage *) loadImageFromUrl:(NSString *)url withImageDate:(NSDate *)imageDate {	
	[imageDate retain];
	
	NSMutableDictionary *cachedImageData = [urlImageCache objectForKey:url];
	UIImage *cachedImage = nil;
	
	if(cachedImageData != nil) {
		if([imageDate compare:[cachedImageData objectForKey:kCacheKeyImageDate]] == NSOrderedSame) {
			cachedImage = [cachedImageData objectForKey:kCacheKeyImage];
		} else {
			[urlImageCache removeObjectForKey:url];
		}
	}
	
	if (cachedImage == nil)	{
		NSURL *urlObject = [[NSURL alloc] initWithString:url];
		
		NSError *error = nil;
		NSData *data = [[NSData alloc] initWithContentsOfURL:urlObject options:NSMappedRead error:&error];
		
		cachedImage = [UIImage imageWithData:data];
		
		[data release];
		[urlObject release];
		
		if(cachedImage != nil) {
			cachedImageData = [[NSMutableDictionary alloc] initWithCapacity:0];
			[cachedImageData setObject:cachedImage forKey:kCacheKeyImage];
			[cachedImageData setObject:imageDate forKey:kCacheKeyImageDate];
			
			[urlImageCache setObject:cachedImageData forKey:url];
			[cachedImageData release];
		}
	}
	
	[imageDate release];
	return cachedImage;
}

- (UIImage *) getColouredImage:(NSString *)baseName withColour:(UIColor *)colour {
	NSString *imageName = [[NSString alloc] initWithFormat:@"%@.png", baseName];
	NSString *maskName = [[NSString alloc] initWithFormat:@"%@_Mask.png", baseName];		
	
	UIImage *baseImage = [self loadImage:imageName];		
	[baseImage retain];
	
	UIImage *maskImage = [self loadImage:maskName];
	[maskImage retain];
	
	[imageName release];
	[maskName release];
	
	UIImage *image = [baseImage tintWithColor:colour andMask:maskImage];			
	
	[baseImage release];
	[maskImage release];
	
	return image;
}

- (UIImageView *) layerImageView:(UIImageView *)imageView withImage:(NSString *)imageName {
	UIImage *layerImage = [self loadImage:imageName];
	UIImageView *layerView = [[UIImageView alloc] initWithImage:layerImage];
	[layerView positionAtX:imageView.width - layerView.width];
	[imageView addSubview:layerView];
	[layerView release];
	
	return imageView;
}

@end
