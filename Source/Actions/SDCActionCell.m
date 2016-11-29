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
    
    [self createLabel];
}

- (void)createLabel {
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:17.0f];
    _titleLabel.numberOfLines = 1;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.minimumScaleFactor = 0.75;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_titleLabel];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    self.titleLabel.enabled = self.enabled;
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
