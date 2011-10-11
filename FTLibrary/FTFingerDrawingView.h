//
//  FTFingerDrawingView.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 09/10/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTView.h"

@interface FTFingerDrawingView : FTView {
	
	CGPoint lastPoint;
	UIImageView *drawImage;
	BOOL mouseSwiped;	
	int mouseMoved;
	
}

- (UIImage *)image;


@end
