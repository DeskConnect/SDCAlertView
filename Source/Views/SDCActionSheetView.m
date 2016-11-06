//
//  SDCActionSheetView.m
//  SDCAlertView
//
//  Created by Ari on 5/30/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCActionSheetView.h"
#import "SDCActionCell.h"

@interface SDCActionSheetView ()

@property (nonatomic, strong) SDCAlertAction *cancelAction;

@property (nonatomic, weak) UIView *primaryView;
@property (nonatomic, weak) SDCCancelSheetCell *cancelActionView;

@end

@implementation SDCActionSheetView

- (void)setActionTappedHandler:(void (^)(SDCAlertAction *))actionTappedHandler {
    [super setActionTappedHandler:actionTappedHandler];
    self.actionsCollectionView.actionTapped = actionTappedHandler;
}

- (void)setCancelAction:(SDCAlertAction *)cancelAction {
    _cancelAction = cancelAction;
    if (cancelAction) {
        [self.cancelActionView setAction:cancelAction withVisualStyle:self.visualStyle];
        
        NSMutableArray<SDCAlertAction *> *mutableActions = [self.actions mutableCopy];
        [mutableActions removeObject:cancelAction];
        self.actions = mutableActions;
    }
}

- (void)highlightActionForPanGesture:(UIPanGestureRecognizer *)sender {
    [super highlightActionForPanGesture:sender];
    
    BOOL cancelIsSelected = CGRectContainsPoint(self.cancelActionView.frame, [sender locationInView:self]);
    self.cancelActionView.highlighted = cancelIsSelected;
    
    if (cancelIsSelected && sender.state == UIGestureRecognizerStateEnded)
        [self cancelTapped];
}

- (IBAction)cancelTapped {
    SDCAlertAction *action = self.cancelAction;
    if (!action)
        return;
    
    if (self.actionTappedHandler)
        self.actionTappedHandler(action);
}

#pragma mark - Accessibility

- (BOOL)accessibilityPerformEscape {
    [self cancelTapped];
    return YES;
}

#pragma mark - View setup

- (void)createPrimaryView {
    UIView *primaryView = [[UIView alloc] init];
    primaryView.translatesAutoresizingMaskIntoConstraints = NO;
    primaryView.layer.cornerRadius = self.visualStyle.cornerRadius;
    primaryView.layer.masksToBounds = YES;
    [self addSubview:primaryView];
    _primaryView = primaryView;
    
    UIView *primaryBackdropView = [self createBackdropView];
    primaryBackdropView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [primaryView insertSubview:primaryBackdropView atIndex:0];
    
    UIView *contentView = self.contentView;
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [primaryView addSubview:contentView];
    
    [primaryView addSubview:self.actionsCollectionView];
}

- (void)createCancelActionView {
    SDCCancelSheetCell *cancelActionView = [[SDCCancelSheetCell alloc] init];
    cancelActionView.translatesAutoresizingMaskIntoConstraints = NO;
    cancelActionView.layer.cornerRadius = self.visualStyle.cornerRadius;
    cancelActionView.layer.masksToBounds = YES;
    cancelActionView.target = self;
    cancelActionView.selector = @selector(cancelTapped);
    [self addSubview:cancelActionView];
    _cancelActionView = cancelActionView;
    
    UIView *cancelBackdropView = [self createBackdropView];
    cancelBackdropView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [cancelActionView insertSubview:cancelBackdropView atIndex:0];
}

- (void)configureLabels {
    SDCAlertLabel *titleLabel = self.titleLabel;
    titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    titleLabel.textColor = [UIColor colorWithWhite:0.557 alpha:1.000];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    [titleLabel setContentHuggingPriority:(UILayoutPriorityDefaultLow + 1) forAxis:UILayoutConstraintAxisHorizontal];
    [titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.primaryView addSubview:titleLabel];
    
    SDCAlertLabel *messageLabel = self.messageLabel;
    messageLabel.font = [UIFont systemFontOfSize:13.0f];
    messageLabel.textColor = [UIColor colorWithWhite:0.557 alpha:1.000];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    [messageLabel setContentHuggingPriority:(UILayoutPriorityDefaultLow + 1) forAxis:UILayoutConstraintAxisHorizontal];
    [messageLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [messageLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.primaryView addSubview:messageLabel];
}

- (void)prepareLayout {
    [self createPrimaryView];
    [self createCancelActionView];
    [self configureLabels];
    
    self.cancelAction = [[self.actions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"style = %ld", (long)SDCAlertActionStyleCancel]] firstObject];
    
    self.titleLabel.hidden = !self.titleLabel.attributedText.length;
    self.messageLabel.hidden = !self.messageLabel.attributedText.length;
    
    BOOL showContentView = !!self.contentView.subviews.count;
    self.contentView.hidden = !showContentView;
    
    [super prepareLayout];
    
    [self createConstraints];
}

- (void)createConstraints {
    SDCAlertVisualStyle *visualStyle = self.visualStyle;
    SDCActionsCollectionView *actionsCollectionView = self.actionsCollectionView;
    UIView *primaryView = self.primaryView;
    SDCAlertLabel *titleLabel = self.titleLabel;
    SDCAlertLabel * messageLabel = self.messageLabel;
    SDCCancelSheetCell *cancelActionView = self.cancelActionView;
    UIView *contentView = self.contentView;
    
    CGFloat widthOffset = (visualStyle.contentPadding.left + visualStyle.contentPadding.right);
    BOOL hideTopSection = (titleLabel.hidden && messageLabel.hidden);
    actionsCollectionView.collectionViewLayout.hideFirstSeparator = hideTopSection;
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:actionsCollectionView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    bottomConstraint.priority = UILayoutPriorityDefaultLow;
    
    NSLayoutConstraint *collectionViewHeightConstraint = [NSLayoutConstraint constraintWithItem:actionsCollectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:actionsCollectionView.displayHeight];
    collectionViewHeightConstraint.priority = UILayoutPriorityDefaultHigh;
    
    [NSLayoutConstraint activateConstraints:@[
        // Primary view
        [NSLayoutConstraint constraintWithItem:primaryView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f],
        [NSLayoutConstraint constraintWithItem:primaryView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f],
        [NSLayoutConstraint constraintWithItem:primaryView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f],
        bottomConstraint,
        
        // Title label
        [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:primaryView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f],
        [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:primaryView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:-widthOffset],
        [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeFirstBaseline relatedBy:NSLayoutRelationEqual toItem:primaryView attribute:NSLayoutAttributeTop multiplier:1.0f constant:(hideTopSection ? 0.0f : 27.0f)],
        
        // Message label
        [NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeFirstBaseline relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeBaseline multiplier:1.0f constant:20.0f],
        [NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f],
        [NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f],
        
        // Actions collection view
        collectionViewHeightConstraint,
        [NSLayoutConstraint constraintWithItem:actionsCollectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:(hideTopSection ? primaryView : messageLabel) attribute:(hideTopSection ? NSLayoutAttributeTop : NSLayoutAttributeBaseline) multiplier:1.0f constant:(hideTopSection ? 0.0f : 18.0f)],
        [NSLayoutConstraint constraintWithItem:actionsCollectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:primaryView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f],
        [NSLayoutConstraint constraintWithItem:actionsCollectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:primaryView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f],
        [NSLayoutConstraint constraintWithItem:actionsCollectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:primaryView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f],
        
        // Cancel cell
        [NSLayoutConstraint constraintWithItem:cancelActionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:primaryView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:8.0f],
        [NSLayoutConstraint constraintWithItem:cancelActionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:visualStyle.actionViewSize.height],
        [NSLayoutConstraint constraintWithItem:cancelActionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f],
        [NSLayoutConstraint constraintWithItem:cancelActionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f],
        [NSLayoutConstraint constraintWithItem:cancelActionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f]
    ]];
    
    // Content view constraints
    if (!contentView.hidden)
        [NSLayoutConstraint activateConstraints:@[
            [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:59.0f],
            [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:primaryView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f],
            [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:primaryView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f],
            [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:primaryView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f],
            [NSLayoutConstraint constraintWithItem:actionsCollectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]
        ]];
}

@end
