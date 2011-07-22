//
//  FTHorizontalTableView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 16/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTHorizontalTableView.h"
#import <QuartzCore/QuartzCore.h>
#import "FTHorizontalTableViewCell.h"


@implementation FTHorizontalTableView

@synthesize startPosition;

#pragma mark Initialization

- (void)doSetup {
	startPosition = FTHorizontalTableViewInitialRotationLeft;
	[self setBackgroundColor:[UIColor clearColor]];
	[super setDelegate:self];
	[super setDataSource:self];
}

- (id)init {
	self = [super init];
    if (self) {
        [self doSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
    if (self) {
        [self doSetup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self doSetup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
	self = [super initWithFrame:frame style:style];
	if (self) {
		[self doSetup];
	}
	return self;
}

#pragma mark Layout

- (void)setFrame:(CGRect)frame {
	float degrees = 0;
	startPosition = FTHorizontalTableViewInitialRotationLeft;
	if (startPosition == FTHorizontalTableViewInitialRotationLeft) degrees = -90;
	else if (startPosition == FTHorizontalTableViewInitialRotationRight) degrees = 90;
	float angle = (degrees * M_PI / 180);
	self.layer.transform = CATransform3DMakeRotation(angle, 0, 0.0, 1.0);
	[super setFrame:frame];
}

- (void)setContentSize:(CGSize)contentSize {
	CGSize s = contentSize;
	[super setContentSize:s];
}

#pragma mark Inverted values

- (void)setShowsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator {
	[super setShowsVerticalScrollIndicator:showsHorizontalScrollIndicator];
}

- (void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator {
	[super setShowsHorizontalScrollIndicator:showsVerticalScrollIndicator];
}

- (BOOL)showsHorizontalScrollIndicator {
	return [super showsVerticalScrollIndicator];
}

- (BOOL)showsVerticalScrollIndicator {
	return [super showsHorizontalScrollIndicator];
}

- (void)setScrollsToStart:(BOOL)scrollsToStart {
	[super setScrollsToTop:scrollsToStart];
}

- (BOOL)scrollsToStart {
	return [super scrollsToTop];
} 

#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}

#pragma mark Custom delegate & data source settings

- (id<FTHorizontalTableViewDelegate>)horizontalDelegate {
	return _horizontalTableDelegate;
}

- (void)setHorizontalDelegate:(id<FTHorizontalTableViewDelegate>)delegate {
	_horizontalTableDelegate = delegate;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
	// Do nothing
	NSLog(@"Use setHorizontalDelegate: instead!");
	//abort();
}


- (id<FTHorizontalTableViewDataSource>)dataSource {
	return _horizontalTableDataSource;
}

- (void)setDataSource:(id<FTHorizontalTableViewDataSource>)dataSource {
	_horizontalTableDataSource = dataSource;
}

#pragma mark Custom data source implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([_horizontalTableDataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
		return [_horizontalTableDataSource tableView:self numberOfRowsInSection:section];
	}
	else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([_horizontalTableDataSource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
		FTHorizontalTableViewCell *cell = [_horizontalTableDataSource tableView:self cellForRowAtIndexPath:indexPath];
		[cell setTableView:self];
		[cell setIndexPath:indexPath];
		return cell;
	}
	else return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if ([_horizontalTableDataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
		return [_horizontalTableDataSource numberOfSectionsInTableView:self];
	}
	else return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if ([_horizontalTableDataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
		return [_horizontalTableDataSource tableView:self titleForHeaderInSection:section];
	}
	else return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if ([_horizontalTableDataSource respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
		return [_horizontalTableDataSource tableView:self titleForFooterInSection:section];
	}
	else return nil;
}

// Editing

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([_horizontalTableDataSource respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) {
		return [_horizontalTableDataSource tableView:self canEditRowAtIndexPath:indexPath];
	}
	else return NO;
}

// Moving/reordering

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([_horizontalTableDataSource respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)]) {
		return [_horizontalTableDataSource tableView:self canMoveRowAtIndexPath:indexPath];
	}
	else return NO;
}

// Index

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	if ([_horizontalTableDataSource respondsToSelector:@selector(sectionIndexTitlesForTableView:)]) {
		return [_horizontalTableDataSource sectionIndexTitlesForTableView:self];
	}
	else return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	if ([_horizontalTableDataSource respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)]) {
		return [_horizontalTableDataSource tableView:self sectionForSectionIndexTitle:title atIndex:index];
	}
	else return 0;
}

// Data manipulation - insert and delete support

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([_horizontalTableDataSource respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
		return [_horizontalTableDataSource tableView:self commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
	}
}

// Data manipulation - reorder / moving support

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	if ([_horizontalTableDataSource respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)]) {
		return [_horizontalTableDataSource tableView:self moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
	}
}

#pragma mark Custom delegate implementation

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([_horizontalTableDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
		[_horizontalTableDelegate tableView:self willDisplayCell:(FTHorizontalTableViewCell *)cell forRowAtIndexPath:indexPath];
	}
}

// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([_horizontalTableDelegate respondsToSelector:@selector(tableView:widthForRowAtIndexPath:)]) {
		return [_horizontalTableDelegate tableView:self widthForRowAtIndexPath:indexPath];
	}
	else {
		return 0;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if ([_horizontalTableDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
		return [_horizontalTableDelegate tableView:self heightForHeaderInSection:section];
	}
	else {
		if ([self style] == UITableViewStyleGrouped) return 10;
		else return 22;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if ([_horizontalTableDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
		return [_horizontalTableDelegate tableView:self heightForFooterInSection:section];
	}
	else return 0;
}

// Section header & footer information. Views are preferred over title should you decide to provide both

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if ([_horizontalTableDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
		return [_horizontalTableDelegate tableView:self viewForHeaderInSection:section];
	}
	else return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	if ([_horizontalTableDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
		return [_horizontalTableDelegate tableView:self viewForFooterInSection:section];
	}
	else return nil;
}

// Accessories (disclosures). 

// Has been deprecated !!!
//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
//	if ([_horizontalTableDelegate respondsToSelector:@selector(tableView:accessoryTypeForRowWithIndexPath:)]) {
//		return [_horizontalTableDelegate tableView:self accessoryTypeForRowWithIndexPath:indexPath];
//	}
//	else return UITableViewCellAccessoryNone;
//}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	if ([_horizontalTableDelegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)]) {
		[_horizontalTableDelegate tableView:self accessoryButtonTappedForRowWithIndexPath:indexPath];
	}
}

// Selection

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([_horizontalTableDelegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
		return [_horizontalTableDelegate tableView:self willSelectRowAtIndexPath:indexPath];
	}
	else return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([_horizontalTableDelegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)]) {
		return [_horizontalTableDelegate tableView:self willDeselectRowAtIndexPath:indexPath];
	}
	else return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([_horizontalTableDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
		[_horizontalTableDelegate tableView:self didSelectRowAtIndexPath:indexPath];
	}
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([_horizontalTableDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
		[_horizontalTableDelegate tableView:self didDeselectRowAtIndexPath:indexPath];
	}
}

// Editing

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([_horizontalTableDelegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) {
		return [_horizontalTableDelegate tableView:self editingStyleForRowAtIndexPath:indexPath];
	}
	else return UITableViewCellEditingStyleNone;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0) {
	if ([_horizontalTableDelegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)]) {
		return [_horizontalTableDelegate tableView:self titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
	}
	else return nil;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([_horizontalTableDelegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)]) {
		return [_horizontalTableDelegate tableView:self shouldIndentWhileEditingRowAtIndexPath:indexPath];
	}
	else return NO;
}

- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([_horizontalTableDelegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)]) {
		[_horizontalTableDelegate tableView:self willBeginEditingRowAtIndexPath:indexPath];
	}
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([_horizontalTableDelegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)]) {
		[_horizontalTableDelegate tableView:self didEndEditingRowAtIndexPath:indexPath];
	}
}

// Moving / reordering

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
	if ([_horizontalTableDelegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)]) {
		return [_horizontalTableDelegate tableView:self targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
	}
	else return nil;
}               

// Indentation

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([_horizontalTableDelegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)]) {
		return [_horizontalTableDelegate tableView:self indentationLevelForRowAtIndexPath:indexPath];
	}
	else return 0;
}

#pragma mark Resizing cells helpers

- (CGFloat)widthForCell:(FTHorizontalTableViewCell *)cell {
	NSIndexPath *ip = [self indexPathForCell:cell];
	CGFloat f = [self tableView:self heightForRowAtIndexPath:ip];
	return f;
}

- (CGFloat)heightForCell:(FTHorizontalTableViewCell *)cell {
	CGFloat f = self.frame.size.height;
	return f;
}

- (CGFloat)heightForHeader {
	CGFloat f = self.frame.size.height;
	return f;
}

- (CGFloat)heightForFooter {
	CGFloat f = self.frame.size.height;
	return f;
}


@end
