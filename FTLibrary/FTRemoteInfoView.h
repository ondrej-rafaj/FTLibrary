//
//  FTRemoteInfoView.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 24/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FTRemoteInfoView : UIView {
    
	NSURL *dataUrl;
	
	NSDictionary *data;
	
	UILabel *title;
	
	UILabel *content;
	
}

@property (nonatomic, retain) NSURL *dataUrl;

@property (nonatomic, retain) NSDictionary *data;

@property (nonatomic, retain) UILabel *title;

@property (nonatomic, retain) UILabel *content;


@end
