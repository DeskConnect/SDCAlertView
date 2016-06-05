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
@property (nonatomic, strong) UIColor *textColor;

@end

@implementation SDCActionCell

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
    
    self.accessibilityLabel = action.attributedTitle.string;
    self.accessibilityTraits = UIAccessibilityTraitButton;
    self.isAccessibilityElement = YES;
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    self.titleLabel.textColor = (self.textColor ?: self.tintColor);
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
