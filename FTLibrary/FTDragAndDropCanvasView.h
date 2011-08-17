//
//  FTDragAndDropCanvasView.h
//  DDrop
//
//  Created by Ondrej Rafaj on 03/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTDragAndDropView.h"


typedef enum {
    
    FTDragAndDropCanvasViewStatusMoving,
    FTDragAndDropCanvasViewStatusRotating
    
} FTDragAndDropCanvasViewStatus;


@class FTDragAndDropCanvasView;

@protocol FTDragAndDropCanvasViewDelegate <NSObject>

- (void)finishedEditingElement:(FTDragAndDropView *)element withData:(NSDictionary *)data;

- (void)deletedElement:(FTDragAndDropView *)element withIndex:(int)index;

- (void)createdElement:(FTDragAndDropView *)element withData:(NSDictionary *)data;

@end


@interface FTDragAndDropCanvasView : UIView <UIGestureRecognizerDelegate> {
    
    NSMutableArray *elements;
    
    UIImageView *backgroundImageView;
    
	UIView	*stickersContainerView;
	
    FTDragAndDropView *activeElement;
    
    id <FTDragAndDropCanvasViewDelegate> delegate;
    
}

@property (nonatomic, retain) UIImageView *backgroundImageView;

@property (nonatomic, assign) id <FTDragAndDropCanvasViewDelegate> delegate;


- (void)setBackgroundImage:(UIImage *)backgroundImage;

- (void)addElementFromPath:(NSString *)imagePath;

- (void)addElementFromData:(NSDictionary *)data;

- (void)layoutElements:(BOOL)animated;

- (void)willAnimateToInterfaceOrientation:(UIInterfaceOrientation)newOrientation;

@end
