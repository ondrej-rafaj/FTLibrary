//
//  FTDragDropMenuView.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 09/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FTDragDropMenuView;

@protocol FTDragDropMenuViewItem <NSObject>

@end

@protocol FTDragDropMenuViewDelegate <NSObject>

- (void)dragAndDropMenuView:(FTDragDropMenuView *)ddView didSelectItem:(UIView <FTDragDropMenuViewItem> *)item atIndex:(int)index;

@end


@interface FTDragDropMenuView : UIScrollView {
    
	NSArray *items;
	
}

//@property (nonatomic, readonly) NSArray *items;
//
//
//- (void)addItem:(UIView <FTDragDropMenuViewItem> *)item;
//
//- (void)addItems:(NSArray *)arr;
//
//- (void)removeItemAtIndex:(int)index animated:(BOOL)animated;


@end
