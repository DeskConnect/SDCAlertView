//
//  SDCAnimationController.m
//  SDCAlertView
//
//  Created by Ari on 5/30/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCAnimationController.h"
#import "SDCAlertPresentationController.h"

// TODO: Write custom transition stuff for action sheet to use a spring animation
/*#import <objc/runtime.h>

static inline BOOL WFExchangeInstanceMethod(Class objectClass, SEL selector, SEL customSelector) {
    Method method1 = class_getInstanceMethod(objectClass, selector);
    Method method2 = class_getInstanceMethod(objectClass, customSelector);
    if (!method1 || !method2)
        return NO;
    
    method_exchangeImplementations(method1, method2);
    return YES;
}

static inline BOOL WFExchangeClassMethod(Class objectClass, SEL selector, SEL customSelector) {
    return WFExchangeInstanceMethod(object_getClass(objectClass), selector, customSelector);
}

static inline BOOL WFAddInstanceMethod(Class objectClass, SEL selector, SEL customSelector) {
    Method customMethod = class_getInstanceMethod(objectClass, customSelector);
    if (!customMethod)
        return NO;
    
    return class_addMethod(objectClass, selector, method_getImplementation(customMethod), method_getTypeEncoding(customMethod));
}

static inline BOOL WFAddClassMethod(Class objectClass, SEL selector, SEL customSelector) {
    return WFAddInstanceMethod(object_getClass(objectClass), selector, customSelector);
}
 
@interface UIView (DetermineAnimationAttributes)

@end

@implementation UIView (DetermineAnimationAttributes)

+ (void)load {
    WFExchangeClassMethod(self, @selector(animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:), @selector(__animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:));
}

+ (void)__animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion {
    [self __animateWithDuration:duration delay:delay usingSpringWithDamping:dampingRatio initialSpringVelocity:velocity options:options animations:animations completion:completion];
}

@end*/

static CGFloat const SDCAlertAnimationControllerSpringDamping = 600.0f;
static CGFloat const SDCAlertAnimationControllerSpringVelocity = 0.0f;
static CGFloat const SDCAlertAnimationControllerInitialScale = 1.2f;

@interface SDCAlertControllerTransitioningDelegate ()

@property (nonatomic, assign) SDCAlertControllerStyle alertStyle;

@end

@implementation SDCAlertControllerTransitioningDelegate

- (instancetype)initWithAlertStyle:(SDCAlertControllerStyle)alertStyle {
    self = [super init];
    if (!self)
        return nil;
    
    _alertStyle = alertStyle;
    
    return self;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[SDCAlertPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

- (SDCAnimationController *)animationControllerForPresentation:(BOOL)presentation {
    SDCAnimationController *animationController = [[SDCAnimationController alloc] init];
    animationController.presentation = presentation;
    return animationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if (self.alertStyle == SDCAlertControllerStyleActionSheet)
        return nil;
    
    SDCAnimationController *animationController = [[SDCAnimationController alloc] init];
    animationController.presentation = YES;
    return animationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return (self.alertStyle == SDCAlertControllerStyleAlert ? [SDCAnimationController new] : nil);
}

@end

@implementation SDCAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.404;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.isPresentation)
        [[transitionContext containerView] addSubview:toViewController.view];
    
    UIViewController *animatingViewController = (self.isPresentation ? toViewController : fromViewController);
    UIView *animatingView = animatingViewController.view;
    
    animatingView.frame = [transitionContext finalFrameForViewController:animatingViewController];
    
    if (self.isPresentation) {
        animatingView.transform = CGAffineTransformMakeScale(SDCAlertAnimationControllerInitialScale, SDCAlertAnimationControllerInitialScale);
        animatingView.alpha = 0;
        
        [self animate:^{
            animatingView.transform = CGAffineTransformMakeScale(1, 1);
            animatingView.alpha = 1;
        } inContext:transitionContext withCompletion:^(BOOL finished) {
            [transitionContext completeTransition:finished];
        }];
        
    } else {
        [self animate:^{
            animatingView.alpha = 0;
        } inContext:transitionContext withCompletion:^(BOOL finished) {
            [fromViewController.view removeFromSuperview];
            [transitionContext completeTransition:finished];
        }];
    }
}

- (void)animate:(void(^)(void))animations inContext:(id<UIViewControllerContextTransitioning>)context withCompletion:(void(^)(BOOL finished))completion {
    [UIView animateWithDuration:[self transitionDuration:context] delay:0 usingSpringWithDamping:SDCAlertAnimationControllerSpringDamping initialSpringVelocity:SDCAlertAnimationControllerSpringVelocity options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction) animations:animations completion:completion];
}

@end
