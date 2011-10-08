//
//  FTDragDropCropElementView.m
//  Regaine
//
//  Created by Ondrej Rafaj on 11/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTDragDropCropElementView.h"


@implementation FTDragDropCropElementView

@synthesize positionX;
@synthesize positionY;


- (id)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        [self setUserInteractionEnabled:YES];
    }
    return self;
}


@end
