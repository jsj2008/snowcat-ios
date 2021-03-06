//
//  SCActivityIndicatorView.m
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCNib.h"
#import "SCColor.h"
#import "SCActivityIndicatorView.h"

//typedef NS_ENUM(NSInteger, UIActivityIndicatorViewStyle) {
//    UIActivityIndicatorViewStyleWhiteLarge,
//    UIActivityIndicatorViewStyleWhite,
//    UIActivityIndicatorViewStyleGray,
//};
UIActivityIndicatorViewStyle UIActivityIndicatorViewStyleFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Large") // WhiteLarge
			return UIActivityIndicatorViewStyleWhiteLarge;
		SC_SWITCH_CASE(string, @"White")
			return UIActivityIndicatorViewStyleWhite;
#if !TARGET_OS_TV
		SC_SWITCH_CASE(string, @"Gray")
			return UIActivityIndicatorViewStyleGray;
#endif
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@implementation SCActivityIndicatorView

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
	[_nodeFile release];
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCActivityIndicatorView
{
	_scTag = 0;
	self.nodeFile = nil;
	
	// default attributes
	self.userInteractionEnabled = NO;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCActivityIndicatorView];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCActivityIndicatorView];
	}
	return self;
}

- (instancetype) initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style
{
	self = [super initWithActivityIndicatorStyle:style];
	if (self) {
		[self _initializeSCActivityIndicatorView];
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	// NOTICE: this initializer would NOT call 'initWithFrame:'
	self = [self initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIActivityIndicatorView *)activityIndicatorView
{
	if (![SCView setAttributes:dict to:activityIndicatorView]) {
		SCLog(@"failed to set attributes: %@", dict);
		return NO;
	}
	
	// activityIndicatorViewStyle
	NSString * style = [dict objectForKey:@"style"];
	if (style) {
		activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleFromString(style);
	}
	
	SC_SET_ATTRIBUTES_AS_BOOL(activityIndicatorView, dict, hidesWhenStopped);
	
	SC_SET_ATTRIBUTES_AS_UICOLOR(activityIndicatorView, dict, color);
	
	return YES;
}

@end
