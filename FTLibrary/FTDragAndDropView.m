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


@implementation FTDragAndDropView

@synthesize imageView;
@synthesize lastRotation;
@synthesize lastScale;
@synthesize imagePath;
@synthesize elementData;
@synthesize interfaceRotationScaling;
@synthesize positionX;
@synthesize positionY;


@synthesize realRotationValue;
@synthesize realScaleValue;

#pragma mark Initialization

- (id)initWithImagePath:(NSString *)path {
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if (image == nil) return nil;
    CGRect r = CGRectMake(0, 0, image.size.width, (image.size.height + (kFTDragAndDropViewButtonSize + kFTDragAndDropViewButtonSpace)));
    self = [super initWithFrame:r];
    if (self) {		
        [self setElementData:[NSDictionary dictionary]];
        
        // Setting basic parameters
        [self setImagePath:path];
        [self setLastScale:1.0f];
        [self setLastRotation:0.0f];
        [self setRealScaleValue:1.0f];
        [self setRealRotationValue:0.0f];
		[self setInterfaceRotationScaling:1];
		
        // Creating image view
        imageView = [[UIImageView alloc] initWithImage:image];
        r.origin.y += (kFTDragAndDropViewButtonSize + kFTDragAndDropViewButtonSpace);
        r.size.height -= (kFTDragAndDropViewButtonSize + kFTDragAndDropViewButtonSpace);
        [imageView setFrame:r];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:imageView];
        
    }
    return self;
}

- (id)initWithImageData:(NSDictionary *)data {
    UIImage *image = [UIImage imageWithContentsOfFile:[data objectForKey:@"imagePath"]];
    if (image == nil) return nil;
    CGRect r = CGRectMake(0, 0, image.size.width, (image.size.height + (kFTDragAndDropViewButtonSize + kFTDragAndDropViewButtonSpace)));
    self = [super initWithFrame:r];
    if (self) {
        
        //[self setBackgroundColor:[UIColor randomColor]];
        [self setElementData:data];
        [self setImagePath:[data objectForKey:@"imagePath"]];
        [self setLastScale:1.0f];
        [self setLastRotation:0.0f];
		[self setRealScaleValue:[[data objectForKey:@"scale"] floatValue]];
		[self setRealRotationValue:[[data objectForKey:@"rotation"] floatValue]];
		[self setInterfaceRotationScaling:1];

        imageView = [[UIImageView alloc] initWithImage:image];
        r.origin.y += (kFTDragAndDropViewButtonSize + kFTDragAndDropViewButtonSpace);
        r.size.height -= (kFTDragAndDropViewButtonSize + kFTDragAndDropViewButtonSpace);
        [imageView setFrame:r];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:imageView];
        
    }
    return self;
}

#pragma mark Settings

- (void)setPosition:(CGPoint)position {
    [self setCenter:position];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

#pragma mark Data

- (NSDictionary *)getInfo {
    NSMutableDictionary *d = [[NSMutableDictionary alloc] initWithDictionary:elementData];
    [d setValue:[NSString stringWithFormat:@"%f", realRotationValue] forKey:@"rotation"];
    [d setValue:[NSString stringWithFormat:@"%f", realScaleValue] forKey:@"scale"];

    [d setValue:NSStringFromCGPoint(self.center) forKey:@"center"];
    [d setValue:NSStringFromCGRect(self.frame) forKey:@"frame"];
    [d setValue:NSStringFromCGSize(imageView.image.size) forKey:@"imageSize"];
    [d setValue:imagePath forKey:@"imagePath"];

    [self setElementData:(NSDictionary *)d];
    [d release];
    return elementData;
}

#pragma mark Memory management

- (void)dealloc {
    [imageView release];
    [imagePath release];
    [elementData release];
    [super dealloc];
}


@end
