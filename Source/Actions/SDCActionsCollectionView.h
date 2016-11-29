//
//  SDCActionsCollectionView.h
//  SDCAlertView
//
//  Created by Ari on 5/29/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCAlertVisualStyle.h"
#import "SDCActionsCollectionViewFlowLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDCActionsCollectionView : UICollectionView

@property (nonatomic, copy) NSArray<SDCAlertAction *> *actions;
@property (nonatomic, strong) SDCAlertVisualStyle *visualStyle;
@property (nonatomic, copy, nullable) void (^actionTapped)(SDCAlertAction *action);

@property (nonatomic, strong) SDCActionsCollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, readonly) CGFloat displayHeight;

- (void)highlightActionForPanGesture:(UIGestureRecognizer *)sender;

- (instancetype)init NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
