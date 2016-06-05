//
//  SDCAlertPresentationController.m
//  SDCAlertView
//
//  Created by Ari on 5/30/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCAlertPresentationController.h"

@interface SDCAlertPresentationController ()

@property (nonatomic, strong) UIView *dimmingView;

@end

@implementation SDCAlertPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentedViewController];
    if (!self)
        return nil;
    
    _dimmingView = [[UIView alloc] init];
    _dimmingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    return self;
}

- (void)presentationTransitionWillBegin {
    [super presentationTransitionWillBegin];
    
    self.presentingViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    
    self.dimmingView.alpha = 0;
    [[self containerView] addSubview:self.dimmingView];
    
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 1;
    } completion:nil];
}

- (void)dismissalTransitionWillBegin {
    [super dismissalTransitionWillBegin];
    
    self.presentingViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
    
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0;
    } completion:nil];
}

- (void)containerViewWillLayoutSubviews {
    [super containerViewWillLayoutSubviews];
    if (!self.containerView)
        return;
    
    self.dimmingView.frame = self.containerView.frame;
}

@end
