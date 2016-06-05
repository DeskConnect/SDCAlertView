//
//  UIViewController+SDCExtension.h
//  SDCAlertView
//
//  Created by Ari on 6/1/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (SDCExtension)

/**
 *  Returns the currently visible view controller, taking into account navigation controllers and modally presented view controllers.
 */
+ (nullable UIViewController *)sdc_topViewController;

@end

NS_ASSUME_NONNULL_END
