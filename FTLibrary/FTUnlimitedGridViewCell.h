//
//  FTUnlimitedGridViewCell.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 13/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTView.h"


struct FTUnlimitedGridViewCellCoordinate {
	CGFloat x;
	CGFloat y;
};
typedef struct FTUnlimitedGridViewCellCoordinate FTUnlimitedGridViewCellCoordinate;


@interface FTUnlimitedGridViewCell : FTView {
	
	NSString *reuseIdentifier;
	
	FTUnlimitedGridViewCellCoordinate coordinate;
	
}

@property (nonatomic, retain) NSString *reuseIdentifier;
@property (nonatomic) FTUnlimitedGridViewCellCoordinate coordinate;


- (id)initWithFrame:(CGRect)frame andReusableIdentifier:(NSString *)identifier;

- (void)prepareForReuse;


@end
