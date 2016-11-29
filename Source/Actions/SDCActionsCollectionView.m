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
#import "SDCAlertActionPrivate.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDCActionsCollectionView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong, nullable) UICollectionViewCell *highlightedCell;

@end

@implementation SDCActionsCollectionView

@dynamic collectionViewLayout;

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
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    return [self init];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self init];
}

- (void)setActions:(NSArray<SDCAlertAction *> *)actions {
    _actions = [actions copy];
    
    NSMutableSet<Class> *cellClasses = [NSMutableSet new];
    for (SDCAlertAction *action in actions)
        [cellClasses addObject:action.cellClass];
    
    for (Class cellClass in cellClasses)
        [self registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
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
    
    CGFloat height = 0;
    for (NSInteger i = 0; i < [self numberOfItemsInSection:0]; i++)
        height += [self heightAtIndex:i];
    
    return height;
}

- (CGFloat)heightAtIndex:(NSInteger)actionIndex {
    SDCAlertAction *action = [self.actions objectAtIndex:actionIndex];
    CGFloat height = self.visualStyle.actionViewSize.height;
    // Size custom cells on iOS 8 the same as regular cells on iOS 9
    if (action.cellClass != [SDCActionCell class] && self.visualStyle.alertStyle == SDCAlertControllerStyleActionSheet)
        height = 57.0f;
    
    return height;
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
    SDCAlertAction *action = [self.actions objectAtIndex:indexPath.item];
    SDCActionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(action.cellClass) forIndexPath:indexPath];
    [cell setAction:action withVisualStyle:self.visualStyle];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat actionHeight = [self heightAtIndex:indexPath.item];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    if (layout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGFloat width = MAX(self.bounds.size.width / (CGFloat)[self numberOfItemsInSection:0], self.visualStyle.actionViewSize.width);
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
