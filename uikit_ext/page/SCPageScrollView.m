//
//  SCPageScrollView.m
//  SnowCat
//
//  Created by Moky on 14-3-29.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCNib.h"
#import "SCEventHandler.h"
#import "SCScrollView.h"
#import "SCPageControl.h"
#import "SCPageScrollView.h"

//typedef NS_ENUM(NSInteger, SCPageScrollViewScrollDirection) {
//	UIPageScrollViewDirectionVertical,
//	UIPageScrollViewDirectionHorizontal,
//};
UIPageScrollViewDirection UIPageScrollViewDirectionFromString(NSString * string)
{
	S9_SWITCH_BEGIN(string)
	S9_SWITCH_CASE(string, @"Vertical")
	return UIPageScrollViewDirectionVertical;
	S9_SWITCH_DEFAULT
	S9_SWITCH_END
	
	return UIPageScrollViewDirectionHorizontal;
}

@interface SCPageScrollView ()

@property(nonatomic, retain) id<UIPageScrollViewDataSource> pageScrollViewDataSource;

@end

@implementation SCPageScrollView

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

@synthesize pageScrollViewDataSource = _pageScrollViewDataSource;

- (void) dealloc
{
	[_pageScrollViewDataSource release];
	
	[_nodeFile release];
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCPageScrollView
{
	_scTag = 0;
	self.nodeFile = nil;
	
	self.pageScrollViewDataSource = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCPageScrollView];
	}
	return self;
}

// default initializer
- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCPageScrollView];
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self initWithFrame:CGRectZero];
	if (self) {
		[self buildHandlers:dict];
	}
	return self;
}

// buildHandlers:
- (void) buildHandlers:(NSDictionary *)dict
{
	[SCResponder onCreate:self withDictionary:dict];
	
	NSDictionary * dataSource = [dict objectForKey:@"dataSource"];
	if (dataSource) {
		self.pageScrollViewDataSource = [SCPageScrollViewDataSource create:dataSource];
		// self.dataSource only assign but won't retain the data delegate,
		// so don't release it now
		self.dataSource = _pageScrollViewDataSource;
	}
}

// awakeFromNib
SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIPageScrollView *)pageScrollView
{
	if (![SCView setAttributes:dict to:pageScrollView]) {
		return NO;
	}
	
	// page control view
	NSDictionary * pageControl = [dict objectForKey:@"pageControl"];
	if (pageControl) {
		SC_UIKIT_DIG_CREATION_INFO(pageControl); // support ObjectFromFile
		SCPageControl * pc = [SCPageControl create:pageControl];
		NSAssert([pc isKindOfClass:[UIPageControl class]], @"pageControl's definition error: %@", pageControl);
		if (pc) {
			//[pageScrollView addSubview:pc];
			[pageScrollView insertSubview:pc aboveSubview:pageScrollView.scrollView];
			
			pc.userInteractionEnabled = NO;
			SC_UIKIT_SET_ATTRIBUTES(pc, SCPageControl, pageControl);
			pageScrollView.pageControl = pc;
		}
	}
	
	// direction
	NSString * direction = [dict objectForKey:@"direction"];
	if (direction) {
		pageScrollView.direction = UIPageScrollViewDirectionFromString(direction);
	}
	
	SC_SET_ATTRIBUTES_AS_BOOL(pageScrollView, dict, animated);
	SC_SET_ATTRIBUTES_AS_INTEGER(pageScrollView, dict, preloadedPageCount);
	
	// load data
	[pageScrollView reloadData];
	
	return YES;
}

- (void) setCurrentPage:(NSUInteger)currentPage
{
	[super setCurrentPage:currentPage];
	[self onFocus:currentPage];
}

- (void) onFocus:(NSUInteger)page
{
	// onFocus:0
	NSString * event = [[NSString alloc] initWithFormat:@"onFocus:%u", (unsigned int)page];
	//SCLog(@"%@: %@", event, self);
	id<SCEventDelegate> delegate = [SCEventHandler delegateForResponder:self];
	if (delegate) {
		[delegate doEvent:event withResponder:self];
	}
	[event release];
	
	// onFocus
	UIView * view = page < [self.scrollView.subviews count] ? [self.scrollView.subviews objectAtIndex:page] : nil;
	event = @"onFocus";
	//SCLog(@"%@: %@", event, view);
	delegate = [SCEventHandler delegateForResponder:view];
	if (delegate) {
		[delegate doEvent:event withResponder:view];
	}
}

@end
