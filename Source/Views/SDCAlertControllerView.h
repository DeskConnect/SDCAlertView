//
//  SDCAlertControllerView.h
//  SDCAlertView
//
//  Created by Ari on 5/30/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCAlertVisualStyle.h"
#import "SDCAlertBehaviors.h"
#import "SDCAlertLabel.h"
#import "SDCActionsCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDCAlertControllerView : UIView

@property (nonatomic, copy, nullable) NSAttributedString *title;
@property (nonatomic, copy, nullable) NSAttributedString *message;

@property (nonatomic, copy) NSArray<SDCAlertAction *> *actions;
@property (nonatomic, copy, nullable) void (^actionTappedHandler)(SDCAlertAction *action);

@property (nonatomic, strong, null_unspecified) SDCAlertVisualStyle *visualStyle;
@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, readonly) UIView *topView;
@property (nonatomic, strong, null_unspecified) IBOutlet SDCAlertLabel *titleLabel;
@property (nonatomic, strong, null_unspecified) IBOutlet SDCAlertLabel *messageLabel;
@property (nonatomic, strong, null_unspecified) IBOutlet SDCActionsCollectionView *actionsCollectionView;

- (void)addBehaviors:(SDCAlertBehaviors)behaviors;
- (void)prepareLayout;
- (void)highlightActionForPanGesture:(UIPanGestureRecognizer *)sender;

@end

NS_ASSUME_NONNULL_END
