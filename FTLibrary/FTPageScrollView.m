//
//  FTPageScrollView.m
//  FTLibrary
//
//  Created by Fuerte on 04/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTPageScrollView.h"
#import "FTDummyPage.h"
#import "UIScrollView+Layout.h"
#import "UIView+Layout.h"


@interface FTPageScrollView (Private)

- (void)offsetChangedToOffset:(CGPoint)offset;

- (void)setLeftPage:(FTPage *)aPage;

- (void)setRightPage:(FTPage *)aPage;

- (void)requiredYPosition:(FTPage *)aPage;

@end


@implementation FTPageScrollView

@synthesize moving;
@synthesize dummyPageImage;


#pragma mark Initialization

- (void)doInit {
	verticalOffset = -self.frame.origin.y;
	touchCount = 1;
	[self setBounces:NO];
	[self setShowsHorizontalScrollIndicator:NO];
	[self setShowsVerticalScrollIndicator:NO];
	[self setPagingEnabled:YES];
	[self setScrollsToTop:NO];
	
	if(pages == nil) {
		pages = [[NSMutableArray alloc] initWithCapacity:0];
	}
	
	[super setDelegate:self];
}

- (id)init {
	self = [super init];
	if(self != nil) {
		[self doInit];
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if(self != nil) {
		[self doInit];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if(self != nil) {
		[self doInit];
	}
	
	return self;
}

- (void)awakeFromNib {
	[self doInit];
}

#pragma mark Memory management

- (void)dealloc {
	[centerPage release];
	[leftPage release];
	[rightPage release];
	[pages release];
	[dummyPageImage release];
	[super dealloc];
}

#pragma mark Settings

- (void)setInitialPage:(FTPage *)aPage withDelegate:(id <FTPageScrollViewDelegate>)aDelegate {
	
	NSLog(@"Size: %@", NSStringFromCGSize([aPage frame].size));
	pageScrollDelegate = aDelegate;
	enabled = NO;

	[self setPage:aPage];
		
	[self setContentWidth:[centerPage width] + 2];
	[self scrollContentToXPosition:1];	

	enabled = YES;
}

- (void)setPage:(FTPage *)aPage {
	[self setPage:aPage pageCount:0 animate:NO];
}

- (void)setPage:(FTPage *)aPage pageCount:(NSInteger)pageCount animate:(BOOL)animate {
	if (!aPage) return;
	if (pageSetInProgress) { 
		NSLog(@"Page set when scroll in progress, updating.");
		[self addSubview:aPage];
		[aPage setFrame:pendingPage.frame];
		[pendingPage removeFromSuperview];
		pendingPage = aPage;
	}
		
	if(!animate) {
		[centerPage removeFromSuperview];
		
		[centerPage release];
		centerPage = aPage;
		[centerPage retain];
		
		[self setContentWidth:[centerPage width] + 2];
		[self offsetChangedToOffset:CGPointMake(0, 0)];	
		[self addSubview:centerPage];
		[centerPage positionAtX:1 andY:-89];
		
		return;
	}
	
	pageSetInProgress = YES;
	pendingPage = aPage;
	
	[self setContentWidth:[aPage width] + 2];
	[self addSubview:aPage];
	
	//Normalise page count
	if(pageCount > 10) {
		pageCount = 10;
	} else if(pageCount < -10) {
		pageCount = -10;
	}
	
	NSInteger increment = 1;
	
	if(pageCount < 0) {
		increment = -1;
	}
	
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	[aPage positionAtX:[aPage width] * pageCount andY:verticalOffset];		
	NSMutableArray *dummyPages = [[NSMutableArray alloc] initWithCapacity:pageCount];
	
	//This lays out the dummy pages correctly based on the page count +ve/-ve 
	//i.e. +ve puts pages on right, -ve on left
	for(int i = 0; i < abs(pageCount) - 1; i++) {
		FTDummyPage *dummyPage = [[FTDummyPage alloc] initWithFrame:self.bounds andImage:dummyPageImage];
		[dummyPages addObject:dummyPage];
		[self addSubview:dummyPage];						
		[dummyPage positionAtX:[aPage width] * ((i + 1) * increment) andY:verticalOffset];
		[dummyPage release];
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	//Duration of animation is based on page count (make positive first)
	double duration = fabs(0.1 * pageCount);
	[UIView setAnimationDuration:duration];
	
	//Move center page to correct position based on page count direction
	[centerPage positionAtX:-[centerPage width] * pageCount];		
	[aPage positionAtX:1];	

	//Set final position of dummy pages based on their index
	for(FTDummyPage *dm in dummyPages) {
		[dm positionAtX:dm.frame.origin.x - ([dm width] * pageCount)];	
	}
	
	[dummyPages release];
	
	[UIView commitAnimations];
}

- (void)setLeftPage:(FTPage *)aPage {
	[leftPage removeFromSuperview];
	[leftPage release];
	leftPage = aPage;
	[leftPage retain];
}

- (void)setRightPage:(FTPage *)aPage {
	[rightPage removeFromSuperview];
	
	[rightPage release];
	rightPage = aPage;
	[rightPage retain];
}

- (void)offsetChangedToOffset:(CGPoint)offset {
	if([pageScrollDelegate respondsToSelector:@selector(pageScrollView:offsetDidChange:)]) {
		[pageScrollDelegate pageScrollView:self offsetDidChange:offset];
	}
}

- (FTPage *)currentPage {
	return centerPage;
}

- (void)cancelOperation {
	[self scrollViewDidEndDecelerating:self];
}

#pragma mark Layout

- (void)layout {
	// TODO: Position pages without auto-resizing options
	NSArray *arr = self.subviews;
	for(FTPage *page in arr) {
		NSLog(@"Stranka: %@", NSStringFromCGRect(page.frame));
	}
	
	CGSize size = self.contentSize;
	size.width = (self.frame.size.width + 2);
	size.height = self.frame.size.height;
	[self setContentSize:size];
	
	// TODO: Position page on 1px offset
	if (self.contentSize.width != 0) {
		//[self setContentOffset:CGPointMake(10, 0) animated:YES];
		//[self setContentOffset:CGPointZero animated:YES];
	}
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	[self layout];
}

#pragma mark Animation Delegate Methods

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[centerPage release];
	centerPage = pendingPage;
	[centerPage retain];
	
	pendingPage = nil;
	
	for(UIView *view in [self subviews]) {
		if(![view isEqual:centerPage]) {
			[view removeFromSuperview];
		}
	}
	
	if([pageScrollDelegate respondsToSelector:@selector(dummyScrollInPageScrollViewDidFinish:)]) {
		[pageScrollDelegate dummyScrollInPageScrollViewDidFinish:self];
	}
	
	if([pageScrollDelegate respondsToSelector:@selector(pageScrollView:didMakePageCurrent:)]) {			
		[pageScrollDelegate pageScrollView:self didMakePageCurrent:centerPage];
	}
	
	if([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
		[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	}
	
	pageSetInProgress = NO;
}

#pragma mark Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSSet *allTouches = [event allTouches];
	touchCount = [allTouches count];
	[self.superview touchesEnded:touches withEvent:event];
}

#pragma mark Scroll View Delegate Methods

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate {
	// nothing happens :)
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	if(!enabled || moving) {
		return;
	}

	CGPoint offset = [scrollView contentOffset];	
	
	moving = YES;
	[pages removeAllObjects];
	
	if ([pageScrollDelegate respondsToSelector:@selector(leftPageForPageScrollView:withTouchCount:)]) {
		[self setLeftPage:[pageScrollDelegate leftPageForPageScrollView:self withTouchCount:touchCount]];
	}
	if ([pageScrollDelegate respondsToSelector:@selector(rightPageForPageScrollView:withTouchCount:)]) {
		[self setRightPage:[pageScrollDelegate rightPageForPageScrollView:self withTouchCount:touchCount]];
	}
	
	if(leftPage != nil) {
		[pages addObject:leftPage];
	}
	
	[pages addObject:centerPage];
	
	if(rightPage != nil) {
		[pages addObject:rightPage];
	}
	
	if([pages count] == 1) {
		moving = NO;
		return;
	}
	
	[self setContentWidth:[centerPage width] * [pages count]];		
	
	NSInteger xPosition = 0;
	
	for(UIView *page in pages) {
		[self addSubview:page];
		[page positionAtX:xPosition andY:verticalOffset];
		
		xPosition += [centerPage width];
	}
	
	if(leftPage) {
		[scrollView setContentOffset:CGPointMake(offset.x + [centerPage width], 0)];
	}	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	touchCount = 1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if(moving) {
		CGPoint offset = [scrollView contentOffset];	
		[self offsetChangedToOffset:offset];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	if(!moving) {
		return;
	}
	
	// Work out page via offset		
	CGPoint offset = [scrollView contentOffset];
	NSInteger newIndex = 0;
	
	if(offset.x < [centerPage width]) {
		newIndex = 0;
	} 
	else if(offset.x < [centerPage width] * 2.0) {
		newIndex = 1;
	} 
	else if(offset.x < [centerPage width] * 3.0) {
		newIndex = 2;
	}
	
	if(newIndex > [pages count] - 1) {
		moving = NO;
		return;
	}
	
	moving = NO;

	FTPage *newPage = [pages objectAtIndex:newIndex];
	[self setContentWidth:[newPage width] + 2];
	
	if([pageScrollDelegate respondsToSelector:@selector(pageScrollView:didMakePageCurrent:)]) {			
		[pageScrollDelegate pageScrollView:self didMakePageCurrent:newPage];
	}
	
	if(![centerPage isEqual:newPage]) {			
		[centerPage removeFromSuperview];
		[centerPage release];
	}
		
	if(![leftPage isEqual:newPage]) {
		[self setLeftPage:nil];
	}
	else {
		leftPage = nil;
	}

	if(![rightPage isEqual:newPage]) {
		[self setRightPage:nil];
	}
	else {
		rightPage = nil;
	}
	
	centerPage = newPage;
	[pages removeAllObjects];	
		
	[centerPage positionAtX:1];	
	[self scrollContentToXPosition:1];		

}

- (void)reload {
	
}


@end
