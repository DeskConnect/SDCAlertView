//
//  SDCAnimationController.h
//  SDCAlertView
//
//  Created by Ari on 5/30/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCAlertVisualStyle.h"

@interface SDCAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, getter=isPresentation) BOOL presentation;

@end

@interface SDCAlertControllerTransitioningDelegate : NSObject <UIViewControllerTransitioningDelegate>

- (instancetype)initWithAlertStyle:(SDCAlertControllerStyle)alertStyle;

@end
