//
//  SCProgressView.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCNib.h"
#import "SCColor.h"
#import "SCImage.h"
#import "SCProgressView.h"

//typedef NS_ENUM(NSInteger, UIProgressViewStyle) {
//    UIProgressViewStyleDefault,     // normal progress bar
//    UIProgressViewStyleBar,         // for use in a toolbar
//};
UIProgressViewStyle UIProgressViewStyleFromString(NSString * string)
{
#if !TARGET_OS_TV
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Bar")
			return UIProgressViewStyleBar;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
#endif
	
	return UIProgressViewStyleDefault;
}

@implementation SCProgressView

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
	[_nodeFile release];
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		_scTag = 0;
		self.nodeFile = nil;
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		_scTag = 0;
		self.nodeFile = nil;
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	NSString * style = [dict objectForKey:@"style"];
	if (!style) {
		style = [dict objectForKey:@"progressViewStyle"];
	}
	
	self = [self initWithProgressViewStyle:UIProgressViewStyleFromString(style)];
	
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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIProgressView *)progressView
{
	// set general attributes after
	if (![SCView setAttributes:dict to:progressView]) {
		return NO;
	}
	
	// progress
	
	SC_SET_ATTRIBUTES_AS_UICOLOR(progressView, dict, progressTintColor);
	SC_SET_ATTRIBUTES_AS_UICOLOR(progressView, dict, trackTintColor);
	
	SC_SET_ATTRIBUTES_AS_UIIMAGE(progressView, dict, progressImage);
	SC_SET_ATTRIBUTES_AS_UIIMAGE(progressView, dict, trackImage);
	
	return YES;
}

@end
