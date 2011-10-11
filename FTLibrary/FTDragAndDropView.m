//
//  FTDragAndDropView.m
//  DDrop
//
//  Created by Ondrej Rafaj on 03/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTDragAndDropView.h"
#import "FTFilesystem.h"
#import "UIColor+Tools.h"


#define kFTDragAndDropViewButtonSize                0
#define kFTDragAndDropViewButtonSpace               0

@interface FTDragAndDropView ()

- (NSDictionary *)defaultImageDataDictionnaryWithImagePath:(NSString *)imagePath;

@end

@implementation FTDragAndDropView

@synthesize rotationValue = _rotationValue;
@synthesize scaleValue = _scaleValue;
@synthesize imageView = _imageView;
@synthesize imagePath = _imagePath;
@synthesize elementData = _elementData;
@synthesize positionX = _positionX;
@synthesize positionY = _positionY;
@synthesize imageOrientation = _imageOrientation;
@synthesize dragged = _dragged;


#pragma mark Custom elements persistent data

- (NSString *)newFilename {
	static NSString *key = @"FTDragAndDropViewCustomFilenameKey";
	int i = [[NSUserDefaults standardUserDefaults] integerForKey:key];
	i++;
	[[NSUserDefaults standardUserDefaults] setInteger:i forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
	NSString *file = [NSString stringWithFormat:@"custom-image-%d.png", i];
	return file;
}

#pragma mark Private methods

- (NSDictionary *)defaultImageDataDictionnaryWithImagePath:(NSString *)imagePath
{
	return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0], @"rotationValue",
			[NSNumber numberWithFloat:1], @"scaleValue",
			[NSNumber numberWithFloat:0], @"positionX",
			[NSNumber numberWithFloat:0], @"positionY",
			[NSNumber numberWithInt:UIImageOrientationUp], @"imageOrientation",
			imagePath, @"imagePath",
			nil];
}

#pragma mark Initialization

- (void)prepareViewWithData:(NSDictionary *)data andImage:(UIImage *)image {
	self.elementData = data;
	self.backgroundColor = [UIColor clearColor];
	//self.elementData = data;
	self.imagePath = [data objectForKey:@"imagePath"];
	
	_rotationValue = [[data objectForKey:@"rotationValue"] floatValue];
	_scaleValue = [[data objectForKey:@"scaleValue"] floatValue];
	_positionX = [[data objectForKey:@"positionX"] floatValue];
	_positionY = [[data objectForKey:@"positionY"] floatValue];
	//imageOrientation = (UIImageOrientation)[[data objectForKey:@"imageOrientation"] intValue];
	
	_dragged = NO;
	
	_imageView = [[UIImageView alloc] initWithImage:image];
	CGRect r = self.bounds;
	r.origin.y += (kFTDragAndDropViewButtonSize + kFTDragAndDropViewButtonSpace);
	r.size.height -= (kFTDragAndDropViewButtonSize + kFTDragAndDropViewButtonSpace);
	[_imageView setFrame:r];
	[_imageView setContentMode:UIViewContentModeScaleAspectFit];
	[self addSubview:_imageView];
}

- (id)initWithImagePath:(NSString *)path reversed:(BOOL)reversed {
	NSDictionary *imageData = [self defaultImageDataDictionnaryWithImagePath:path];
	self = [self initWithImageData:imageData reversed:reversed];
	if (self) {
		
	}
	return self;
}

- (id)initWithImage:(UIImage *)image {
	NSString *path = [[FTFilesystemPaths getFilesDirectoryPath] stringByAppendingPathComponent:@"custom-images"];
	if (![FTFilesystemIO isFolder:path]) [FTFilesystemIO makeFolderPath:path];
	NSString *filePath = [path stringByAppendingPathComponent:[self newFilename]];
	NSData *imageData = UIImagePNGRepresentation(image);
	[imageData writeToFile:filePath atomically:YES];
	NSDictionary *data = [self defaultImageDataDictionnaryWithImagePath:filePath];
    CGRect r = CGRectMake(0, 0, image.size.width, (image.size.height + (kFTDragAndDropViewButtonSize + kFTDragAndDropViewButtonSpace)));
    self = [super initWithFrame:r];
    if (self) {
        [self prepareViewWithData:data andImage:image];
    }
    return self;
}

- (id)initWithImagePath:(NSString *)path {
	return [self initWithImagePath:path reversed:NO];
}

- (id)initWithImageData:(NSDictionary *)data reversed:(BOOL)reversed {
    UIImage *image = [UIImage imageWithContentsOfFile:[data objectForKey:@"imagePath"]];
    if (image == nil) return nil;
	if (reversed || (UIImageOrientation)[[data objectForKey:@"imageOrientation"] intValue] == UIImageOrientationUpMirrored) {
		imageOrientation = UIImageOrientationUpMirrored;
		image = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationUpMirrored]; 
	}
	else imageOrientation = image.imageOrientation;
    CGRect r = CGRectMake(0, 0, image.size.width, (image.size.height + (kFTDragAndDropViewButtonSize + kFTDragAndDropViewButtonSpace)));
    self = [super initWithFrame:r];
    if (self) {
        [self prepareViewWithData:data andImage:image];
    }
    return self;
}

- (id)initWithImageData:(NSDictionary *)data {
    return [self initWithImageData:data reversed:NO];
}

#pragma mark Data

- (NSDictionary *)getInfo {
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:_elementData];
	[dict setValue:[NSNumber numberWithFloat:_scaleValue] forKey:@"scaleValue"];
	[dict setValue:[NSNumber numberWithFloat:_rotationValue] forKey:@"rotationValue"];
	[dict setValue:[NSNumber numberWithFloat:_positionX] forKey:@"positionX"];
	[dict setValue:[NSNumber numberWithFloat:_positionY] forKey:@"positionY"];
	[dict setValue:[NSNumber numberWithInt:imageOrientation] forKey:@"imageOrientation"];
	[dict setValue:_imagePath forKey:@"imagePath"];
	self.elementData = dict;
	return _elementData;
}

#pragma mark Memory management

- (void)dealloc {
    [_imageView release];
    [_imagePath release];
    [super dealloc];
}


@end
