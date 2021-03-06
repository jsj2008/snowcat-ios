//
//  SCVisualEffectView.h
//  SnowCat
//
//  Created by Moky on 15-1-5.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "SCUIKit.h"

UIKIT_EXTERN UIBlurEffectStyle UIBlurEffectStyleFromString(NSString * string) NS_AVAILABLE_IOS(8_0);

//
//  Description:
//      creator for 'BlurEffect' and 'VibrancyEffect'
//
//  Usage:
//      'Class' => 'BlurEffect', 'VibrancyEffect'
//      'style' => 'ExtraLight', 'Light', 'Dark'
//
NS_CLASS_AVAILABLE_IOS(8_0) @interface SCVisualEffect : UIVisualEffect<SCUIKit> @end

#pragma mark -

NS_CLASS_AVAILABLE_IOS(8_0) @interface SCVisualEffectView : UIVisualEffectView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIVisualEffectView *)visualEffectView;

@end
