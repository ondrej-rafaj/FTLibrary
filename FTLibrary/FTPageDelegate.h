//
//  FTPageDelegate.h
//  FTLibrary
//
//  Created by Fuerte on 04/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FTPage;

@protocol FTPageDelegate <NSObject>

- (void)pageWillDispose:(FTPage *)page;


@end
