//
//  FTAlertView.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 27/09/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>


void FTAlertWithError(NSError *error);
void FTAlertWithTitleAndMessage(NSString *title, NSString *message);


@interface FTAlertView : UIAlertView

@end
