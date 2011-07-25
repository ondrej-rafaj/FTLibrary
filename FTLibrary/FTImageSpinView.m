//
//  FTImageSpinView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 27/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTImageSpinView.h"
#import "FTMemTools.h"


@interface FTImageSpinView (Private)

- (void)doLayout;

- (void)displayCurrentImage;

@end


@implementation FTImageSpinView

@synthesize scrollView;
@synthesize currentIndex;
@synthesize animationSpeed;
@synthesize isReverse;
@synthesize debugMode;


#pragma mark Positioning

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	[self doLayout];
}

#pragma mark Layout

- (void)doLayout {
	// Layout for scrollview
	[scrollView setContentSize:CGSizeMake((self.frame.size.width * 40), self.frame.size.height)];
	int x = ((scrollView.contentSize.width / 2) - (self.frame.size.width / 2));
	currentOffset = x;
	[scrollView setContentOffset:CGPointMake(x, 0)];
	
	// Set the right image
	[self displayCurrentImage];
	
	if (debugMode) {
		if (!debugLabel) {
			debugLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 100, 240, 80)];
			[debugLabel setBackgroundColor:[UIColor orangeColor]];
			[debugLabel setTextColor:[UIColor blackColor]];
			[debugLabel setText:@"Debug mode"];
			[debugLabel setNumberOfLines:4];
			[self addSubview:debugLabel];
		}
	}
}

#pragma mark Initialization

- (void)doSetup {
	// Basic view settings
	[self setClipsToBounds:YES];
	currentIndex = 0;
	animationSpeed = 10.0f;
	isReverse = NO;
	
	// Setting array that holds paths for images
	imageNames = [[NSMutableArray alloc] init];
	
	// Creating image canvas
	imageCanvas = [[UIImageView alloc] initWithFrame:self.bounds];
	[imageCanvas setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[imageCanvas setContentMode:UIViewContentModeScaleAspectFit];
	[imageCanvas setBackgroundColor:[UIColor clearColor]];
	[self addSubview:imageCanvas];
	
	// Creating overlay scrollview
	scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
	[scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[scrollView setBackgroundColor:[UIColor clearColor]];
	[scrollView setDelegate:self];
	[scrollView setShowsHorizontalScrollIndicator:NO];
	[scrollView setShowsVerticalScrollIndicator:NO];
	[scrollView setDecelerationRate:UIScrollViewDecelerationRateNormal];
	[scrollView setBounces:NO];
	[self addSubview:scrollView];
	[scrollView release];
	
	// Layout all the views and contents
	[self doLayout];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self doSetup];
    }
    return self;
}

#pragma mark Rotating images

- (void)displayImageAtIndex:(int)index {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[imageCanvas setImage:[self imageAtIndex:index]];
	[pool drain];
}



- (void)displayCurrentImage {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	int count = [imageNames count];
	if (count > 0) {
		int index = currentIndex;
		if (index <= 0) index = count - 1;
		else if (index >= count) index = 0;
		//[imageCanvas setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:[imageNames objectAtIndex:index]]]];
		[self displayImageAtIndex:index];
		currentIndex = index;
	}
	[pool release];
}

#pragma mark Loading data

- (void)addImage:(NSString *)imagePath {
	if (imagePath) {
		[imageNames addObject:imagePath];		
	}
}

- (void)loadImagesWithFolderPath:(NSString *)folderPath withFormat:(NSString *)fileFormat withStartIndex:(int)startIndex andFinalIdex:(int)finalIndex {
	for (int i = startIndex; i <= finalIndex; i++) {
		NSString *path = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:fileFormat, i]];
		[self addImage:path];
	}
	[self displayCurrentImage];
}

- (void)loadImagesFromBundleWithFileFormat:(NSString *)format withStartIndex:(int)startIndex andFinalIdex:(int)finalIndex {
	//finalIndex = 30;
	for (int i = startIndex; i <= finalIndex; i++) {
		NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:format, i] ofType:nil];
		[self addImage:path];
	}
	[self displayCurrentImage];
}

#pragma mark Settings

- (void)showIndex:(int)index withAnimationCurve:(UIViewAnimationCurve)animationCurve {
	// TODO: Add animation effect with deceleration
	currentIndex = index;
	[self displayImageAtIndex:index];
}

- (void)showIndex:(int)index animated:(BOOL)animated {
	if (animated) {
		[self showIndex:index withAnimationCurve:UIViewAnimationCurveEaseInOut];
	}
	else {
		currentIndex = index;
		[self displayImageAtIndex:index];
	}
}

- (void)showIndex:(int)index {
	[self showIndex:index animated:NO];
}

- (UIImage *)imageAtIndex:(int)index {
	NSData *imageData = [[NSData alloc] initWithContentsOfFile:[imageNames objectAtIndex:index]];
	UIImage *image = [UIImage imageWithData:imageData];
	[imageData release];
	return image;
}

- (void)setContentModeForImageCanvas:(UIViewContentMode)contentMode {
	[imageCanvas setContentMode:contentMode];
}

- (void)removeAllImages {
	currentIndex = 0;
	currentOffset = 0;
	[imageNames release];
	imageNames = [[NSMutableArray alloc] init];
	[imageCanvas setImage:nil];
	[self doLayout];
}

#pragma mark ScrolView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)sv {
	NSDate *start;
	BOOL changeImage = NO;
	if (debugMode) {
		start = [NSDate date];
	}
	int absoluteOffsetDiffrence = abs(currentOffset - sv.contentOffset.x);
	if (sv.contentOffset.x < currentOffset - animationSpeed) {
		if (isReverse) {
			currentIndex++;
			if (absoluteOffsetDiffrence > 100) currentIndex += 6;
			else if (absoluteOffsetDiffrence > 80) currentIndex += 5;
			else if (absoluteOffsetDiffrence > 60) currentIndex += 4;
			else if (absoluteOffsetDiffrence > 40) currentIndex += 3;
			else if (absoluteOffsetDiffrence > 20) currentIndex += 2;
		}
		else {
			currentIndex--;
		}
		changeImage = YES;
	} 
	else if (sv.contentOffset.x > currentOffset + animationSpeed) {
		if (isReverse) {
			currentIndex--;
			if (absoluteOffsetDiffrence > 50) currentIndex -= 6;
			else if (absoluteOffsetDiffrence > 40) currentIndex -= 5;
			else if (absoluteOffsetDiffrence > 30) currentIndex -= 4;
			else if (absoluteOffsetDiffrence > 20) currentIndex -= 3;
			else if (absoluteOffsetDiffrence > 10) currentIndex -= 2;
		}
		else {
			currentIndex++;
		}
		changeImage = YES;
	}
	if (changeImage) {
		currentOffset = sv.contentOffset.x;
		[self displayCurrentImage];
		if (debugMode) {
			NSTimeInterval timeInterval = [start timeIntervalSinceNow];
			[debugLabel setText:[NSString stringWithFormat:@"Time: %f\nMemory: %d Kb\nCurrent index: %d\nOffset difference: %d", timeInterval, [FTMemTools getAvailableMemoryInKb], currentIndex, absoluteOffsetDiffrence]];
		}
	}
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
	[self doLayout];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[self doLayout];
}

#pragma mark Memory management

- (void)dealloc {
	[imageNames release];
	[imageCanvas release];
	[debugLabel release];
    [super dealloc];
}

@end
