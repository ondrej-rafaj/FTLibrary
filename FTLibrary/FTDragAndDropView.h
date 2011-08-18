//
//  FTDragAndDropView.h
//  DDrop
//
//  Created by Ondrej Rafaj on 03/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FTDragAndDropView : UIView {
    
    UIImageView *imageView;
    
    CGFloat lastRotation;
    CGFloat lastScale;
    CGFloat interfaceRotationScaling;
	
    NSString *imagePath;
    
    NSDictionary *elementData;
    
    CGFloat positionX;
	CGFloat positionY;
    
    // Real return values
    CGFloat realRotationValue;
    CGFloat realScaleValue;
	
}

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic) CGFloat lastRotation;

@property (nonatomic) CGFloat lastScale;
@property (nonatomic) CGFloat interfaceRotationScaling;

@property (nonatomic, retain) NSString *imagePath;

@property (nonatomic, retain) NSDictionary *elementData;

@property (nonatomic) CGFloat positionX;
@property (nonatomic) CGFloat positionY;

@property (nonatomic) CGFloat realRotationValue;
@property (nonatomic) CGFloat realScaleValue;


- (id)initWithImagePath:(NSString *)path;

- (id)initWithImageData:(NSDictionary *)data;

- (void)setPosition:(CGPoint)position;

- (NSDictionary *)getInfo;

@end
