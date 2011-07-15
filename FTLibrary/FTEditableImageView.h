//
//  FTEditableImageView.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 14/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTEditableElementView.h"


@interface FTEditableImageView : FTEditableElementView <UIScrollViewDelegate> {
    
	UIButton *noImageOverlayButton;
	
	UIScrollView *edittingCanvas;
	
}

@end
