//
//  FTFingerDrawingView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 09/10/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTFingerDrawingView.h"

@implementation FTFingerDrawingView


#pragma mark Creating elements

- (void)configureView {
	[self setBackgroundColor:[UIColor whiteColor]];
	
	mouseMoved = 0;
}

- (void)createAllElements {
	drawImage = [[UIImageView alloc] initWithFrame:self.bounds];
	[self addSubview:drawImage];
	self.backgroundColor = [UIColor brownColor];
}

#pragma mark View initialization

- (void)initializeView {
	[self configureView];
	[self createAllElements];
}

#pragma mark Getting values

- (UIImage *)image {
	return drawImage.image;
}

#pragma mark Touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	mouseSwiped = NO;
	UITouch *touch = [touches anyObject];
	
	if ([touch tapCount] == 2) {
		drawImage.image = nil;
		return;
	}
	
	lastPoint = [touch locationInView:self];
	lastPoint.y -= 20;
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	mouseSwiped = YES;
	
	UITouch *touch = [touches anyObject];	
	CGPoint currentPoint = [touch locationInView:self];
	currentPoint.y -= 20;
	
	
	UIGraphicsBeginImageContext(self.frame.size);
	[drawImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
	CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
	CGContextBeginPath(UIGraphicsGetCurrentContext());
	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
	CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
	CGContextStrokePath(UIGraphicsGetCurrentContext());
	drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	lastPoint = currentPoint;
	
	mouseMoved++;
	
	if (mouseMoved == 10) {
		mouseMoved = 0;
	}
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	if ([touch tapCount] == 2) {
		drawImage.image = nil;
		return;
	}
	
	if(!mouseSwiped) {
		UIGraphicsBeginImageContext(self.frame.size);
		[drawImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
		CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
		CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
		CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextStrokePath(UIGraphicsGetCurrentContext());
		CGContextFlush(UIGraphicsGetCurrentContext());
		drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
}

#pragma mark Memory management

- (void)dealloc {
	[drawImage release];
	[super dealloc];
}


@end
