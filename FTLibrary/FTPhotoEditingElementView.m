//
//  FTPhotoEditingElementView.m
//  Fuerte International
//
//  Created by Ondrej Rafaj on 11/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTPhotoEditingElementView.h"


@implementation FTPhotoEditingElementView

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
