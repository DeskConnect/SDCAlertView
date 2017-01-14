//
//  SDCActionCell.m
//  SDCAlertView
//
//  Created by Ari on 5/29/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCActionCell.h"
#import "SDCAlertActionPrivate.h"
#import "SDCActionsCollectionViewFlowLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDCActionCell ()

@property (nonatomic, strong) UIView *highlightedBackgroundView;
@property (nonatomic, strong, nullable) UIColor *textColor;
@property (nonatomic, strong) UIView *checkmarkView;
@property (nonatomic, strong) UIView *titleView;

@end

@implementation SDCActionCell

- (nullable instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (!self)
        return nil;
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    [self commonInit];
    
    return self;
}

- (void)commonInit {
    _highlightedBackgroundView = [UIView new];
    _highlightedBackgroundView.hidden = YES;
    _highlightedBackgroundView.alpha = 0.7f;
    _highlightedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    _highlightedBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self insertSubview:_highlightedBackgroundView atIndex:0];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_highlightedBackgroundView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_highlightedBackgroundView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_highlightedBackgroundView]|" options:0 metrics:nil views:views]];

    UIView *titleView = self.titleView;
    titleView.translatesAutoresizingMaskIntoConstraints = NO;
    titleView.userInteractionEnabled = NO;
    [self.contentView addSubview:titleView];

    [NSLayoutConstraint activateConstraints:@[
        [NSLayoutConstraint constraintWithItem:titleView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0],
        [NSLayoutConstraint constraintWithItem:titleView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0],
        [NSLayoutConstraint constraintWithItem:titleView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeLeadingMargin multiplier:1.0 constant:0.0],
        [NSLayoutConstraint constraintWithItem:titleView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeTrailingMargin multiplier:1.0 constant:0.0],
        [NSLayoutConstraint constraintWithItem:titleView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0],
        [NSLayoutConstraint constraintWithItem:titleView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0],
    ]];
}

- (UIView *)titleView {
    if (!_titleView) {
        if ([self customView]) {
            _titleView = [self customView];
        } else {
            UILabel *label = [UILabel new];
            label.font = [UIFont systemFontOfSize:17.0f];
            label.numberOfLines = 1;
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label.adjustsFontSizeToFitWidth = YES;
            label.minimumScaleFactor = 0.75;
            label.textAlignment = NSTextAlignmentCenter;
            self.titleLabel = label;
            _titleView = label;
        }
    }
    
    return _titleView;
}

- (nullable UIView *)customView {
    return nil;
}

- (UIView *)checkmarkView {
    if (!_checkmarkView) {
        UIImageView *checkmarkView = [[UIImageView alloc] init];
        checkmarkView.image = [UIImage imageNamed:@"checkmark" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        checkmarkView.translatesAutoresizingMaskIntoConstraints = NO;
        _checkmarkView = checkmarkView;
    }
    
    return _checkmarkView;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    self.titleLabel.enabled = self.enabled;
}

- (void)setShowsCheckmark:(BOOL)showsCheckmark {
    _showsCheckmark = showsCheckmark;
    if (showsCheckmark) {
        [self.contentView addSubview:self.checkmarkView];
        [NSLayoutConstraint activateConstraints:@[
            [NSLayoutConstraint constraintWithItem:self.checkmarkView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0],
            [NSLayoutConstraint constraintWithItem:self.checkmarkView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.titleView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:8.0],
            [NSLayoutConstraint constraintWithItem:self.checkmarkView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeTrailingMargin multiplier:1.0 constant:0.0],
        ]];
    } else {
        [self.checkmarkView removeFromSuperview];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.highlightedBackgroundView.hidden = !highlighted;
}

- (void)setAction:(SDCAlertAction *)action withVisualStyle:(SDCAlertVisualStyle *)visualStyle {
    action.actionView = self;
    
    self.titleLabel.font = [visualStyle fontForAction:action];
    self.textColor = [visualStyle textColorForAction:action];
    self.titleLabel.textColor = (self.textColor ?: self.tintColor);
    self.titleLabel.attributedText = action.attributedTitle;
    
    self.highlightedBackgroundView.backgroundColor = visualStyle.actionHighlightColor;
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    self.titleLabel.textColor = (self.textColor ?: self.tintColor);
}

#pragma mark - Accessibility

- (BOOL)isAccessibilityElement {
    return YES;
}

- (nullable NSString *)accessibilityLabel {
    return self.titleLabel.attributedText.string;
}

- (UIAccessibilityTraits)accessibilityTraits {
    return UIAccessibilityTraitButton;
}

@end

@implementation SDCCancelSheetCell

- (BOOL)touchesInside:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches)
        if ([self pointInside:[touch locationInView:self] withEvent:event])
            return YES;
    
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.highlighted = YES;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    self.highlighted = [self touchesInside:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.highlighted = NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.highlighted = NO;
    
    id target = self.target;
    SEL selector = self.selector;
    if (self.enabled && [self touchesInside:touches withEvent:event] && target && selector) {
        NSMethodSignature *methodSignature = [target methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        id selfArgument = self;
        [invocation setSelector:selector];
        if ([methodSignature numberOfArguments] > 2)
            [invocation setArgument:&selfArgument atIndex:2];
        [invocation invokeWithTarget:target];
    }
}

@end

@implementation SDCActionSeparatorView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    if ([layoutAttributes isKindOfClass:[SDCActionsCollectionViewLayoutAttributes class]]) {
        SDCActionsCollectionViewLayoutAttributes *attributes = (SDCActionsCollectionViewLayoutAttributes *)layoutAttributes;
        self.backgroundColor = attributes.backgroundColor;
    }
}

@end

NS_ASSUME_NONNULL_END
