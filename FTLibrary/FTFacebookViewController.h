//
//  FTFacebookViewController.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 31/10/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTViewController.h"
#import "Facebook.h"
#import "FTAppDelegate.h"
#import "FTShare.h"
#import "FTLang.h"
#import "FTDownload.h"
#import "AQGridView.h"
#import "FTGridViewCell.h"


@class FTFacebookViewController;

@protocol FTFacebookViewControllerDelegate <NSObject>

@optional

- (void)facebookViewController:(FTFacebookViewController *)controller didSelectPicture:(NSString *)url withData:(NSDictionary *)data;
- (void)facebookViewController:(FTFacebookViewController *)controller didSelectPicture:(UIImage *)picture;

@end


@interface FTFacebookViewController : FTViewController <FTShareFacebookDelegate, FTDownloadDelegate, AQGridViewDelegate, AQGridViewDataSource, UIAlertViewDelegate> {
	
	Facebook *_facebook;
	
	id <FTFacebookViewControllerDelegate> delegate;
	
	NSString *facebookAppId;
	
	FTDownload *download;
	
	UISearchBar *searchBar;
	
	AQGridView *grid;
	BOOL useGridView;
	
}

@property (nonatomic, assign) id <FTFacebookViewControllerDelegate> delegate;

@property (nonatomic, retain) NSString *facebookAppId;

@property (nonatomic, retain) FTDownload *download;

@property (nonatomic) BOOL useGridView;


- (Facebook *)facebook;

- (void)authorize;

- (void)reloadData;

- (void)startDownloadingDataForCurrentPage;

- (void)downloadDataFromUrl:(NSString *)url;

- (void)downloadFinishedWithResult:(NSString *)result;

- (void)noInternetConnection;

- (void)configureGridCell:(AQGridViewCell *)cell atIndex:(NSInteger)index forGridView:(AQGridView *)gridView;



@end
