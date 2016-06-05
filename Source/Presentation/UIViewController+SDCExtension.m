//
//  UIViewController+SDCExtension.m
//  SDCAlertView
//
//  Created by Ari on 6/1/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "UIViewController+SDCExtension.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UIViewController (SDCExtension)

+ (nullable UIViewController *)sdc_topViewController {
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    return [self sdc_topViewControllerForViewController:rootViewController];
}

+ (nullable UIViewController *)sdc_topViewControllerForViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)viewController viewControllers] count] > 0) {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        return [self sdc_topViewControllerForViewController:navigationController.viewControllers.lastObject];
    } else if ([viewController isKindOfClass:[UITabBarController class]] && [(UITabBarController *)viewController selectedViewController]) {
        UIViewController *selectedController = [(UITabBarController *)viewController selectedViewController];
        return [self sdc_topViewControllerForViewController:selectedController];
    } else if (viewController.presentedViewController) {
        return [self sdc_topViewControllerForViewController:viewController.presentedViewController];
    }
    
    return viewController;
}

@end

NS_ASSUME_NONNULL_END
