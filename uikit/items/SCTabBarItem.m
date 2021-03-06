//
//  SCTabBarItem.m
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCTabBarItem.h"
#import "SCImage.h"

//typedef NS_ENUM(NSInteger, UITabBarSystemItem) {
//    UITabBarSystemItemMore,
//    UITabBarSystemItemFavorites,
//    UITabBarSystemItemFeatured,
//    UITabBarSystemItemTopRated,
//    UITabBarSystemItemRecents,
//    UITabBarSystemItemContacts,
//    UITabBarSystemItemHistory,
//    UITabBarSystemItemBookmarks,
//    UITabBarSystemItemSearch,
//    UITabBarSystemItemDownloads,
//    UITabBarSystemItemMostRecent,
//    UITabBarSystemItemMostViewed,
//};
UITabBarSystemItem UITabBarSystemItemFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"More")
			return UITabBarSystemItemMore;
		SC_SWITCH_CASE(string, @"Favor")    // Favorites
			return UITabBarSystemItemFavorites;
		SC_SWITCH_CASE(string, @"Feature")  // Featured
			return UITabBarSystemItemFeatured;
		SC_SWITCH_CASE(string, @"Top")      // TopRated
			return UITabBarSystemItemTopRated;
		SC_SWITCH_CASE(string, @"MostRecent")
			return UITabBarSystemItemMostRecent;
		SC_SWITCH_CASE(string, @"Recent")   // Recents
			return UITabBarSystemItemRecents;
		SC_SWITCH_CASE(string, @"Contact")  // Contacts
			return UITabBarSystemItemContacts;
		SC_SWITCH_CASE(string, @"History")
			return UITabBarSystemItemHistory;
		SC_SWITCH_CASE(string, @"Book")     // Bookmarks
			return UITabBarSystemItemBookmarks;
		SC_SWITCH_CASE(string, @"Search")
			return UITabBarSystemItemSearch;
		SC_SWITCH_CASE(string, @"Download") // Downloads
			return UITabBarSystemItemDownloads;
		SC_SWITCH_CASE(string, @"View")     // MostViewed
			return UITabBarSystemItemMostViewed;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return UITabBarSystemItemMore;
}

@implementation SCTabBarItem

//- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag;
//- (instancetype)initWithTabBarSystemItem:(UITabBarSystemItem)systemItem tag:(NSInteger)tag;
//- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage NS_AVAILABLE_IOS(7_0);

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	NSInteger tag = [[dict objectForKey:@"tag"] integerValue];
	NSString * tabBarSystemItem = [dict objectForKey:@"tabBarSystemItem"];
	
	if (tabBarSystemItem) {
		// initWithTabBarSystemItem:tag:
		UITabBarSystemItem item = UITabBarSystemItemFromString(tabBarSystemItem);
		self = [self initWithTabBarSystemItem:item tag:tag];
	} else {
		// initWithTitle:image:tag:
		NSString * title = [dict objectForKey:@"title"];
		title = SCLocalizedString(title, nil);
		id image = [dict objectForKey:@"image"];
		if (image) {
			image = [SCImage create:image]; // load image
		}
		self = [self initWithTitle:title image:image tag:tag];
	}
	
	if (self) {
	}
	return self;
}

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UITabBarItem *)tabBarItem
{
	if (![SCBarItem setAttributes:dict to:tabBarItem]) {
		return NO;
	}
	
	// finishedSelectedImage
	id selectedImage = [dict objectForKey:@"finishedSelectedImage"];
	if (!selectedImage) {
		selectedImage = [dict objectForKey:@"selectedImage"];
	}
	if (selectedImage) {
		selectedImage = [SCImage create:selectedImage];
	}
	
	// finishedUnselectedImage
	id unselectedImage = [dict objectForKey:@"finishedUnselectedImage"];
	if (!unselectedImage) {
		unselectedImage = [dict objectForKey:@"unselectedImage"];
	}
	if (!unselectedImage) {
		unselectedImage = [dict objectForKey:@"image"];
	}
	if (unselectedImage) {
		unselectedImage = [SCImage create:unselectedImage];
	}
	
	//if (selectedImage && unselectedImage) {
	//	[tabBarItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:unselectedImage];
	//}
	tabBarItem.selectedImage = selectedImage;
	tabBarItem.image = unselectedImage;
	
	return YES;
}

@end
