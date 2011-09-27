//
//  FTImageService.h
//
//  Created by Simon Lee on 11/09/2009.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface FTImageService : NSObject {
	
	NSMutableDictionary *imageCache;
	NSMutableDictionary *urlImageCache;
	
}

+ (FTImageService *)instance;

- (void)freeMemory;

- (UIImage *)loadImage:(NSString *)imageName;
- (UIImage *)loadImageFromUrl:(NSString *)url withImageDate:(NSDate *)imageDate;

- (UIImage *)getColouredImage:(NSString *)baseName withColour:(UIColor *)colour;

- (UIImageView *)layerImageView:(UIImageView *)imageView withImage:(NSString *)imageName;

@end
