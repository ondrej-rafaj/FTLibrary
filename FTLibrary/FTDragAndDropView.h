//
//  FTDragAndDropView.h
//  DDrop
//
//  Created by Ondrej Rafaj on 03/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FTDragAndDropView : UIView {
    
    UIImageView *_imageView;
    
    CGFloat _rotationValue;
    CGFloat _scaleValue;
	CGFloat _positionX;
	CGFloat _positionY;
	
	UIImageOrientation imageOrientation;
	
    NSString *_imagePath;
    NSDictionary *_elementData;
	
	BOOL _dragged;
}

@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic) CGFloat rotationValue;
@property (nonatomic) CGFloat scaleValue;
@property (nonatomic) CGFloat positionX;
@property (nonatomic) CGFloat positionY;

@property (nonatomic) UIImageOrientation imageOrientation;

@property (nonatomic, retain) NSString *imagePath;
@property (nonatomic, retain) NSDictionary *elementData;

@property (nonatomic, getter = isDragged) BOOL dragged;


- (id)initWithImagePath:(NSString *)path reversed:(BOOL)reversed;
- (id)initWithImagePath:(NSString *)path;

- (id)initWithImageData:(NSDictionary *)data reversed:(BOOL)reversed;
- (id)initWithImageData:(NSDictionary *)data;

- (id)initWithImage:(UIImage *)image;

- (NSDictionary *)getInfo;


@end
