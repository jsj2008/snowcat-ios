//
//  SCSegmentedButton.m
//  SnowCat
//
//  Created by Moky on 15-4-13.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCNib.h"
#import "SCButton.h"
#import "SCSegmentedButton.h"

@implementation SCSegmentedButton

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
	self.nodeFile = nil;
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCSegmentedScrollView
{
	_scTag = 0;
	self.nodeFile = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCSegmentedScrollView];
	}
	return self;
}

// default initializer
- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCSegmentedScrollView];
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
SC_UIKIT_IMELEMENT_BUILD_HANDLERS_FUNCTION()

// awakeFromNib
SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UISegmentedButton *)segmentedButton
{
	if (![SCControl setAttributes:dict to:segmentedButton]) {
		return NO;
	}
	
	// items
	NSArray * items = [dict objectForKey:@"items"];
	if (items) {
		NSUInteger count = [items count];
		NSDictionary * d;
		SCButton * btn;
		for (NSUInteger i = 0; i < count; ++i) {
			d = [items objectAtIndex:i];
			NSAssert([d isKindOfClass:[NSDictionary class]], @"segmented button's item must be a dictionary: %@", d);
			SC_UIKIT_DIG_CREATION_INFO(d); // support ObjectFromFile
			
			btn = [SCButton create:d autorelease:NO];
			[segmentedButton insertSegmentWithButton:btn atIndex:i animated:NO];
			SC_UIKIT_SET_ATTRIBUTES(btn, SCButton, d);
			[btn release];
		}
	}
	
	// selectedSegmentIndex
	id selectedSegmentIndex = [dict objectForKey:@"selectedSegmentIndex"];
	if (selectedSegmentIndex) {
		segmentedButton.selectedSegmentIndex = [selectedSegmentIndex integerValue];
	}
	
	// direction
	NSString * direction = [dict objectForKey:@"direction"];
	if (direction) {
		segmentedButton.direction = UISegmentedButtonAutoLayoutDirectionFromString(direction);
	}
	
	return YES;
}

@end
