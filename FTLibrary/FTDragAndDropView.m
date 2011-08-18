//
//  FTDragAndDropView.m
//  DDrop
//
//  Created by Ondrej Rafaj on 03/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTDragAndDropView.h"
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
@synthesize dragged = _dragged;

#pragma mark - private methods

- (NSDictionary *)defaultImageDataDictionnaryWithImagePath:(NSString *)imagePath
{
	return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0], @"rotationValue",
			[NSNumber numberWithFloat:1], @"scaleValue",
			[NSNumber numberWithFloat:0], @"positionX",
			[NSNumber numberWithFloat:0], @"positionY",
			imagePath, @"imagePath",
			nil];
}

#pragma mark Initialization

- (id)initWithImagePath:(NSString *)path {
	
	NSDictionary *imageData = [self defaultImageDataDictionnaryWithImagePath:path];
	
	self = [self initWithImageData:imageData];
	if (self) {
		
	}
	return self;
}

- (id)initWithImageData:(NSDictionary *)data {
	
    UIImage *image = [UIImage imageWithContentsOfFile:[data objectForKey:@"imagePath"]];
    if (image == nil) return nil;
    CGRect r = CGRectMake(0, 0, image.size.width, (image.size.height + (kFTDragAndDropViewButtonSize + kFTDragAndDropViewButtonSpace)));
    self = [super initWithFrame:r];
    if (self) {
        
		self.elementData = data;
		self.backgroundColor = [UIColor clearColor];
		//self.elementData = data;
        self.imagePath = [data objectForKey:@"imagePath"];
        
		_rotationValue = [[data objectForKey:@"rotationValue"] floatValue];
		_scaleValue = [[data objectForKey:@"scaleValue"] floatValue];
		_positionX = [[data objectForKey:@"positionX"] floatValue];
		_positionY = [[data objectForKey:@"positionY"] floatValue];

		_dragged = NO;
       		
        _imageView = [[UIImageView alloc] initWithImage:image];
        r.origin.y += (kFTDragAndDropViewButtonSize + kFTDragAndDropViewButtonSpace);
        r.size.height -= (kFTDragAndDropViewButtonSize + kFTDragAndDropViewButtonSpace);
        [_imageView setFrame:r];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_imageView];
    }
    return self;
}

#pragma mark Data

- (NSDictionary *)getInfo {

	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:_elementData];
	[dict setValue:[NSNumber numberWithFloat:_scaleValue] forKey:@"scaleValue"];
	[dict setValue:[NSNumber numberWithFloat:_rotationValue] forKey:@"rotationValue"];
	[dict setValue:[NSNumber numberWithFloat:_positionX] forKey:@"positionX"];
	[dict setValue:[NSNumber numberWithFloat:_positionY] forKey:@"positionY"];
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
