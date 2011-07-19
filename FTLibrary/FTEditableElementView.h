//
//  FTEditableElementView.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 13/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kFTEditableElementViewStopEdittingNotification						@"FTEditableElementViewStopEdittingNotification"


#pragma mark Type definitions

typedef enum {
	
	FTEditableElementViewBorderTypeInnerBorder,
	FTEditableElementViewBorderTypeRoundedInside
	
} FTEditableElementViewBorderType;

typedef enum {
	
	FTEditableElementViewBorderStyleFullLine,
	FTEditableElementViewBorderStyleDotted,
	FTEditableElementViewBorderStyleDashed
	
} FTEditableElementViewBorderStyle;


#pragma mark FTEditableElementReturnObject

@interface FTEditableElementReturnObject : NSObject {
	
	NSString *returnString;
	UIImage *returnImage;
	NSData *returnData;
	
	id returnObject;
	
}

+ (id)instance;

@property (nonatomic, retain) NSString *returnString;
@property (nonatomic, retain) UIImage *returnImage;
@property (nonatomic, retain) NSData *returnData;
@property (nonatomic, retain) id returnObject;

@end


#pragma mark FTEditableElementView


@class FTEditableElementView;

@protocol FTEditableElementViewDelegate <NSObject>

@optional

- (void)editableElement:(FTEditableElementView *)element didStartEditingWithData:(FTEditableElementReturnObject *)data;

- (void)editableElement:(FTEditableElementView *)element didFinishEditingWithData:(FTEditableElementReturnObject *)data;

- (void)editableElementDidStopEditing:(FTEditableElementView *)element;

@end


@interface FTEditableElementView : UIView {
	
	UIButton *toggleEditModeButton;
	
	BOOL isEditMode;
	
	UIColor *_edittingBorderColorForElement;
	CGFloat _edittingBorderLineWidth;
	FTEditableElementViewBorderType _borderType;
	FTEditableElementViewBorderStyle _borderStyle;
	
	BOOL _toggleEditModeAutomatically;
	
	UIImageView *editIcon;
	UIImage *enabledIcon;
	UIImage *disabledIcon;
    
}

@property (nonatomic, retain) UIButton *toggleEditModeButton;

@property (nonatomic, readonly) BOOL isEditMode;

@property (nonatomic, retain) UIColor *edittingBorderColorForElement;
@property (nonatomic) CGFloat edittingBorderLineWidth;
@property (nonatomic) FTEditableElementViewBorderType borderType;
@property (nonatomic) FTEditableElementViewBorderStyle borderStyle;

@property (nonatomic) BOOL toggleEditModeAutomatically;

@property (nonatomic, retain) UIImageView *editIcon;


- (void)setupElement;

- (void)toggleEditMode;

- (void)startEditing;

- (void)stopEditing;

- (void)configureForEditMode:(BOOL)isEditting;

- (void)enableEditIcon:(BOOL)enable animated:(BOOL)animated;

- (void)enableEditIcon:(BOOL)enable;


@end
