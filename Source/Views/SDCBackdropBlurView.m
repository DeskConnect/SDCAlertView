//
//  SDCBlurBackdropView.m
//  ActionKit
//
//  Created by Ari on 11/5/16.
//  Copyright © 2016 DeskConnect. All rights reserved.
//

#import "SDCBackdropBlurView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 These functions retrieve the backdrop blur view from the standard UIAlertController, because
 it's not possible to create an equivalent style using public APIs.
 
 This is hacky, but it's the best option right now and it will gracefully degrade to a regular
 visual effect view if the backdrop view is unavailable.
 */

static NSArray<__kindof UIView *> *SDCSubviewsOfClass(UIView *view, Class subviewClass) {
    NSMutableArray<__kindof UIView *> *matchingSubviews = [NSMutableArray new];
    
    for (UIView *subview in view.subviews) {
        [matchingSubviews addObjectsFromArray:SDCSubviewsOfClass(subview, subviewClass)];
        
        if ([subview isKindOfClass:subviewClass])
            [matchingSubviews addObject:subview];
    }
    
    return matchingSubviews;
}

static UIView * __nullable SDCFindBackdropSubview(UIView *view) {
    NSArray<UIVisualEffectView *> *visualEffectViews = SDCSubviewsOfClass(view, [UIVisualEffectView class]);
    for (UIVisualEffectView *visualEffectView in visualEffectViews) {
        UIView *backdropView = visualEffectView.superview;
        if ([NSStringFromClass([backdropView class]) containsString:@"Backdrop"])
            return backdropView;
    }
    
    return nil;
}

UIView *SDCCreateBackdropBlurView(UIViewController *presentingViewController) {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Title" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [presentingViewController addChildViewController:alertController];
    [presentingViewController.view addSubview:alertController.view];
    [alertController didMoveToParentViewController:presentingViewController];

    UIView *backdropView = SDCFindBackdropSubview(alertController.view);

    [alertController willMoveToParentViewController:nil];
    [alertController.view removeFromSuperview];
    [alertController removeFromParentViewController];
    
    if (backdropView) {
        [backdropView removeFromSuperview];
        backdropView.translatesAutoresizingMaskIntoConstraints = YES;
    } else {
        backdropView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    }
    
    return backdropView;
}

NS_ASSUME_NONNULL_END
