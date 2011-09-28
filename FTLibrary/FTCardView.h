//
//  FTCardView.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 26/09/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTView.h"
#import "FTImageView.h"


typedef enum {
	
	FTCardViewStyleBasic,
	FTCardViewStylePhoto,
	FTCardViewStyleCustom,
	FTCardViewStyleSmallBorder
	
} FTCardViewStyle;


@class FTCardView;

@protocol FTCardViewDelegate <NSObject>

@optional

- (void)cardView:(FTCardView *)view didTapWithNumberOfTouches:(NSInteger)touches;

@end


@interface FTCardView : FTView <FTImageViewDelegate> {
	
	UIView *mainView;
	UIView *shadow;
	UIView *border;
	UIView *cardView;
	UIView *cardViewOverlay;
	UIView *contentView;
	FTImageView *contentViewImage;
	UIActivityIndicatorView *preloader;
	UIView *contentViewOvelay;
	
	// Styles
	FTCardViewStyle _style;
	CGFloat _borderThickness;
	CGFloat _contentMargin;
	
	id <FTCardViewDelegate> delegate;
	
}

@property (nonatomic, retain) UIView *mainView;
@property (nonatomic, retain) UIView *shadow;
@property (nonatomic, retain) UIView *border;
@property (nonatomic, retain) UIView *cardView;
@property (nonatomic, retain) UIView *cardViewOverlay;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) FTImageView *contentViewImage;
@property (nonatomic, retain) UIActivityIndicatorView *preloader;
@property (nonatomic, retain) UIView *contentViewOvelay;

@property (nonatomic) FTCardViewStyle style;
@property (nonatomic) CGFloat borderThickness;
@property (nonatomic) CGFloat contentMargin;

@property (nonatomic, assign) id <FTCardViewDelegate> delegate;


- (void)toggleContentViewOverlay:(BOOL)animated;

- (void)loadImageOnTheBackground:(NSString *)url withActivityIndicator:(BOOL)indicator;

- (void)loadImageOnTheBackground:(NSString *)url;


@end
