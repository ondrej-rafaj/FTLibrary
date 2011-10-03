//
//  FTVerticalSlider.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 30/09/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
	
	FTVerticalSliderOrientationLowOnTop,
	FTVerticalSliderOrientationLowOnBottom

} FTVerticalSliderOrientation;


@interface FTVerticalSlider : UISlider {
	
	FTVerticalSliderOrientation orientation;
	
}

@property (nonatomic) FTVerticalSliderOrientation orientation;


@end
