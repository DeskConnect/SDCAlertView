//
//  SDCActionsCollectionView.m
//  SDCAlertView
//
//  Created by Ari on 5/29/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCActionsCollectionView.h"
#import "SDCActionsCollectionViewFlowLayout.h"
#import "SDCActionCell.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const SDCActionCellIdentifier = @"actionCell";

@interface SDCActionsCollectionView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong, nullable) UICollectionViewCell *highlightedCell;

@end

@implementation SDCActionsCollectionView

- (instancetype)init {
    self = [super initWithFrame:CGRectZero collectionViewLayout:[SDCActionsCollectionViewFlowLayout new]];
    if (!self)
        return nil;
    
    _actions = @[];
    self.dataSource = self;
    self.delegate = self;
    self.backgroundColor = [UIColor clearColor];
    self.delaysContentTouches = NO;
    
    [self.collectionViewLayout registerClass:[SDCActionSeparatorView class] forDecorationViewOfKind:SDCHorizontalActionSeparator];
    [self.collectionViewLayout registerClass:[SDCActionSeparatorView class] forDecorationViewOfKind:SDCVerticalActionSeparator];
    
    NSString *nibName = NSStringFromClass([SDCActionCell class]);
    UINib *nib = [UINib nibWithNibName:nibName bundle:[NSBundle bundleForClass:[self class]]];
    [self registerNib:nib forCellWithReuseIdentifier:SDCActionCellIdentifier];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    return [self init];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self init];
}

- (void)setVisualStyle:(SDCAlertVisualStyle *)visualStyle {
    _visualStyle = visualStyle;
    SDCActionsCollectionViewFlowLayout *layout = (SDCActionsCollectionViewFlowLayout *)self.collectionViewLayout;
    if ([layout isKindOfClass:[SDCActionsCollectionViewFlowLayout class]])
        layout.visualStyle = visualStyle;
}

- (CGFloat)displayHeight {
    SDCActionsCollectionViewFlowLayout *layout = (SDCActionsCollectionViewFlowLayout *)self.collectionViewLayout;
    SDCAlertVisualStyle *visualStyle = self.visualStyle;
    if (![layout isKindOfClass:[SDCActionsCollectionViewFlowLayout class]] || !visualStyle)
        return -1;
    
    if (layout.scrollDirection == UICollectionViewScrollDirectionHorizontal)
        return visualStyle.actionViewSize.height;
    else
        return (visualStyle.actionViewSize.height * (CGFloat)[self numberOfItemsInSection:0]);
}

- (void)highlightActionForPanGesture:(UIGestureRecognizer *)sender {
    CGPoint touchPoint = [sender locationInView:self];
    BOOL touchIsInCollectionView = CGRectContainsPoint(self.bounds, touchPoint);
    
    UIGestureRecognizerState state = sender.state;
    
    if (state == UIGestureRecognizerStateCancelled || state == UIGestureRecognizerStateFailed || state == UIGestureRecognizerStateEnded || !touchIsInCollectionView) {
        self.highlightedCell.highlighted = NO;
        self.highlightedCell = nil;
    }
    
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:touchPoint];
    if (!indexPath)
        return;
    
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
    if (!cell || cell == self.highlightedCell || !self.actions[indexPath.item].enabled)
        return;
    
    if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged) {
        self.highlightedCell.highlighted = NO;
        cell.highlighted = YES;
        self.highlightedCell = cell;
        
        [[UISelectionFeedbackGenerator new] selectionChanged];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.actionTapped)
            self.actionTapped(self.actions[indexPath.item]);
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.actions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SDCActionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SDCActionCellIdentifier forIndexPath:indexPath];
    [cell setAction:self.actions[indexPath.item] withVisualStyle:self.visualStyle];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat actionWidth = self.visualStyle.actionViewSize.width;
    CGFloat actionHeight = self.visualStyle.actionViewSize.height;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    if (layout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGFloat width = MAX(self.bounds.size.width / (CGFloat)[self numberOfItemsInSection:0], actionWidth);
        return CGSizeMake(width, actionHeight);
    } else {
        return CGSizeMake(self.bounds.size.width, actionHeight);
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    SDCAlertAction *action = self.actions[indexPath.item];
    return action.enabled;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.actionTapped)
        self.actionTapped(self.actions[indexPath.item]);
}

@end

NS_ASSUME_NONNULL_END
