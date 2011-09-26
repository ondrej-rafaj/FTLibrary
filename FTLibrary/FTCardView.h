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


@interface FTCardView : FTView {
	
	UIView *shadow;
	UIView *border;
	UIView *cardView;
	UIView *cardViewOverlay;
	UIView *contentView;
	FTImageView *contentViewImage;
	UIView *contentViewOvelay;
	
	FTCardViewStyle _style;
	
}

@property (nonatomic, retain) UIView *shadow;
@property (nonatomic, retain) UIView *border;
@property (nonatomic, retain) UIView *cardView;
@property (nonatomic, retain) UIView *cardViewOverlay;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) FTImageView *contentViewImage;
@property (nonatomic, retain) UIView *contentViewOvelay;

@property (nonatomic) FTCardViewStyle style;


@end
