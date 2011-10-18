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
@protocol FTDragAndDropCanvasViewDelegate;

@interface FTDragAndDropCanvasView : UIView <UIGestureRecognizerDelegate> {
    
	id <FTDragAndDropCanvasViewDelegate> delegate;

    NSMutableArray		*elements;
	FTDragAndDropView	*activeElement;
	FTDragAndDropView	*elementToDelete;
	UIBezierPath		*deleteImagePath;

	UIImageView			*deleteImageView;
    UIImageView			*backgroundImageView;
	UIView				*stickersContainerView;
	CGFloat				interfaceRotationFactor;
	
	CGRect				backgroundImageRectLandscape;
	CGRect				backgroundImageRectPortrait;
	
	BOOL				animatedLayout;
}

@property (nonatomic, assign) id <FTDragAndDropCanvasViewDelegate> delegate;
@property (nonatomic, retain) UIImageView *backgroundImageView;

- (void)setBackgroundImage:(UIImage *)backgroundImage;
- (void)addElementWithPath:(NSString *)imagePath withRandomPosition:(BOOL)randomPosition reversed:(BOOL)reversed;
- (void)addElementWithPath:(NSString *)imagePath reversed:(BOOL)reversed;
- (void)addElementWithPath:(NSString *)imagePath;
- (void)addElementWithData:(NSDictionary *)data reversed:(BOOL)reversed;
- (void)addElementWithData:(NSDictionary *)data;
- (void)addElementWithImage:(UIImage *)image;
- (void)layoutElements:(BOOL)animated;

- (UIImage *)imageWithSize:(CGSize)imageSize;

- (void)removeAllElements;

@end

@protocol FTDragAndDropCanvasViewDelegate <NSObject>

- (void)finishedEditingElement:(FTDragAndDropView *)element withData:(NSDictionary *)data;
- (void)sentElementToTheFront:(FTDragAndDropView *)element withData:(NSArray *)data;
- (void)deleteElement:(FTDragAndDropView *)element withData:(NSDictionary *)data;
- (void)createdElement:(FTDragAndDropView *)element withData:(NSDictionary *)data;

@end
