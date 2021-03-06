//
//  SCNavigationController.m
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCNib.h"
#import "SCNavigationBar.h"
#import "SCNavigationControllerDelegate.h"
#import "SCNavigationController.h"

@interface SCNavigationController ()

@property(nonatomic, retain) id<SCNavigationControllerDelegate> navigationControllerDelegate;

@end

@implementation SCNavigationController

@synthesize scTag = _scTag;
@synthesize navigationControllerDelegate = _navigationControllerDelegate;

- (void) dealloc
{
	[_navigationControllerDelegate release];
	
	[SCResponder onDestroy:self.view];
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCNavigationController
{
	_scTag = 0;
	// default properties
	//self.navigationBar.translucent = NO;
	
	self.navigationControllerDelegate = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCNavigationController];
	}
	return self;
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		[self _initializeSCNavigationController];
	}
	return self;
}

- (instancetype) initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass
{
	self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass];
	if (self) {
		[self _initializeSCNavigationController];
	}
	return self;
}

- (instancetype) initWithRootViewController:(UIViewController *)rootViewController
{
	self = [super initWithRootViewController:rootViewController];
	if (self) {
		[self _initializeSCNavigationController];
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	// initWithNibName:bundle:
	NSString * nibName = [SCNib nibNameFromDictionary:dict];
	
	// initWithNavigationBarClass:toobarClass:
	NSString * navigationBarClass = [dict objectForKey:@"navigationBarClass"];
	NSString * toolbarClass = [dict objectForKey:@"toolbarClass"];
	
	// initWithRootViewController:
	NSDictionary * rootViewController = [dict objectForKey:@"rootViewController"];
	
	if (nibName) {
		NSBundle * bundle = [SCNib bundleFromDictionary:dict];
		self = [self initWithNibName:nibName bundle:bundle];
	} else if (navigationBarClass || toolbarClass) {
		Class navClass = NSClassFromString(navigationBarClass);
		Class toolClass = NSClassFromString(toolbarClass);
		self = [self initWithNavigationBarClass:navClass toolbarClass:toolClass];
	} else {
		SCViewController * vc = [SCViewController create:rootViewController];
		self = [self initWithRootViewController:vc];
	}
	
	if (self) {
		[self buildHandlers:dict];
	}
	return self;
}

// buildHandlers:
- (void) buildHandlers:(NSDictionary *)dict
{
	[SCResponder onCreate:self withDictionary:dict];
	
	NSDictionary * delegate = [dict objectForKey:@"delegate"];
	if (delegate) {
		self.navigationControllerDelegate = [SCNavigationControllerDelegate create:delegate];
		// self.delegate only assign but won't retain the action delegate,
		// so don't release it now
		self.delegate = _navigationControllerDelegate;
	}
}

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UINavigationController *)navigationController
{
	if (![SCViewController setAttributes:dict to:navigationController]) {
		SCLog(@"failed to set attributes: %@", dict);
		return NO;
	}
	
	// rootViewController
	NSDictionary * rootViewController = [dict objectForKey:@"rootViewController"];
	if (rootViewController) {
		//NSAssert([navigationController.viewControllers count] > 0, @"root view controller error: %@", dict);
		SCViewController * vc = [navigationController.viewControllers firstObject];
		NSAssert(!vc || [vc isKindOfClass:[UIViewController class]], @"root view controller error: %@", rootViewController);
		SC_UIKIT_SET_ATTRIBUTES(vc, SCViewController, rootViewController);
	}
	
	// viewControllers
	NSArray * viewControllers = [dict objectForKey:@"viewControllers"];
	if (viewControllers) {
		NSAssert([viewControllers isKindOfClass:[NSArray class]], @"viewControllers must be an array: %@", viewControllers);
		NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:[viewControllers count]];
		
		NSDictionary * item;
		SCViewController * child;
		SC_FOR_EACH(item, viewControllers) {
			NSAssert([item isKindOfClass:[NSDictionary class]], @"viewControllers's item must be a dictionary: %@", item);
			SC_UIKIT_DIG_CREATION_INFO(item); // support ObjectFromFile
			child = [SCViewController create:item];
			NSAssert([child isKindOfClass:[UIViewController class]], @"viewControllers item's definition error: %@", item);
			SC_UIKIT_SET_ATTRIBUTES(child, SCViewController, item);
			SCArrayAddObject(mArray, child);
		}
		
		navigationController.viewControllers = mArray;
		[mArray release];
	}
	
	// navigationBarHidden
	SC_SET_ATTRIBUTES_AS_BOOL(navigationController, dict, navigationBarHidden);
	
	// navigationBar
	NSDictionary * navigationBar = [dict objectForKey:@"navigationBar"];
	if (navigationBar) {
		SC_UIKIT_SET_ATTRIBUTES(navigationController.navigationBar, SCNavigationBar, navigationBar);
	}
	
#if !TARGET_OS_TV
	// toolbarHidden
	SC_SET_ATTRIBUTES_AS_BOOL(navigationController, dict, toolbarHidden);
	
	// toolbar
	NSDictionary * toolbar = [dict objectForKey:@"toolbar"];
	if (toolbar) {
		SC_UIKIT_SET_ATTRIBUTES(navigationController.toolbar, SCToolbar, toolbar);
	}
#endif
	
	// delegate
	
	return YES;
}

// view loading functions
SC_UIKIT_VIEW_CONTROLLER_IMPLEMENT_LOAD_VIEW_FUNCTIONS()

// Autorotate
SC_UIKIT_IMPLEMENT_AUTOROTATE_FUNCTIONS_WITH_CHILD(self.topViewController)

@end
