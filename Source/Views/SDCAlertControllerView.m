//
//  SDCAlertControllerView.m
//  SDCAlertView
//
//  Created by Ari on 5/30/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCAlertControllerView.h"

@implementation SDCAlertControllerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self)
        return nil;
    
    [self commonInit];
    
    return self;
}

- (void)commonInit {
    _actions = @[];
    _contentView = [UIView new];
    _titleLabel = [SDCAlertLabel new];
    _messageLabel = [SDCAlertLabel new];
    _actionsCollectionView = [SDCActionsCollectionView new];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _actionsCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)prepareLayout {
    self.actionsCollectionView.actions = self.actions;
    self.actionsCollectionView.visualStyle = self.visualStyle;
}

- (void)highlightActionForPanGesture:(UIPanGestureRecognizer *)sender {
    [self.actionsCollectionView highlightActionForPanGesture:sender];
}

#pragma mark - SDCAlertControllerViewRepresentable

- (NSAttributedString *)title {
    return self.titleLabel.attributedText;
}

- (void)setTitle:(NSAttributedString *)title {
    self.titleLabel.attributedText = title;
}

- (NSAttributedString *)message {
    return self.messageLabel.attributedText;
}

- (void)setMessage:(NSAttributedString *)message {
    self.messageLabel.attributedText = message;
}

- (void)setTitleLabel:(SDCAlertLabel *)titleLabel {
    _titleLabel = titleLabel;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setMessageLabel:(SDCAlertLabel *)messageLabel {
    _messageLabel = messageLabel;
    _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setActionsCollectionView:(SDCActionsCollectionView *)actionsCollectionView {
    _actionsCollectionView = actionsCollectionView;
    _actionsCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (UIView *)topView {
    return self;
}

- (void)addBehaviors:(SDCAlertBehaviors)behaviors {
    if ((behaviors & SDCAlertBehaviorDragTap) == SDCAlertBehaviorDragTap) {
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(highlightActionForPanGesture:)];
        panGesture.cancelsTouchesInView = NO;
        [self addGestureRecognizer:panGesture];
    }
    
    if ((behaviors & SDCAlertBehaviorParallax) == SDCAlertBehaviorParallax) {
        [self addParallax];
    }
}

- (void)addParallax {
    UIOffset parallax = self.visualStyle.parallax;
    
    UIInterpolatingMotionEffect *horizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontal.minimumRelativeValue =  @(-parallax.horizontal);
    horizontal.maximumRelativeValue = @(parallax.horizontal);
    
    UIInterpolatingMotionEffect *vertical = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    vertical.minimumRelativeValue = @(-parallax.vertical);
    vertical.maximumRelativeValue = @(parallax.vertical);
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontal, vertical];
    [self addMotionEffect:group];
}

@end
