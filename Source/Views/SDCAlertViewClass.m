//
//  SDCAlertView.m
//  SDCAlertView
//
//  Created by Ari on 5/30/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCAlertViewClass.h"
#import "UIView+SDCAutoLayout.h"

@interface SDCAlertView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation SDCAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    [self commonAlertViewInit];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self)
        return nil;
    
    [self commonAlertViewInit];
    
    return self;
}

- (void)commonAlertViewInit {
    _actionLayout = SDCActionLayoutAutomatic;
    _scrollView = [UIScrollView new];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    self.messageLabel.font = [UIFont systemFontOfSize:13.0f];
}

- (UIView *)topView {
    return self.scrollView;
}

- (void (^)(SDCAlertAction *))actionTappedHandler {
    return self.actionsCollectionView.actionTapped;
}

- (void)setActionTappedHandler:(void (^)(SDCAlertAction *))actionTappedHandler {
    self.actionsCollectionView.actionTapped = actionTappedHandler;
}

- (void)setVisualStyle:(SDCAlertVisualStyle *)visualStyle {
    [super setVisualStyle:visualStyle];
    self.textFieldsViewController.visualStyle = visualStyle;
}

- (NSArray<UIView *> *)elements {
    NSMutableArray<UIView *> *elements = [NSMutableArray new];
    if (self.titleLabel)
        [elements addObject:self.titleLabel];
    if (self.messageLabel)
        [elements addObject:self.messageLabel];
    if (self.textFieldsViewController.view)
        [elements addObject:self.textFieldsViewController.view];
    if (self.contentView.subviews.count)
        [elements addObject:self.contentView];
    
    return elements;
}

- (CGFloat)bottomPadding {
    CGFloat padding = self.visualStyle.contentPadding.bottom;
    if (!self.textFieldsViewController.view && !self.contentView.subviews.count)
        padding += 8.5f;
    
    return padding;
}

- (CGFloat)contentHeight {
    UIView *lastElement = self.elements.lastObject;
    if (!lastElement)
        return 0;
    
    [lastElement layoutIfNeeded];
    return (CGRectGetMaxY(lastElement.frame) + [self bottomPadding]);
}

- (void)prepareLayout {
    [super prepareLayout];
    
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.scrollView];
    
    [self updateCollectionViewScrollDirection];
    
    [self createBackground];
    [self createUI];
    [self createContentConstraints];
    [self updateUI];
}

#pragma mark - Private methods

- (void)createBackground {
    UIColor *color = self.visualStyle.backgroundColor;
    if (color) {
        self.backgroundColor = color;
    } else {
        UIVisualEffectView *backgroundView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self insertSubview:backgroundView belowSubview:self.scrollView];
        [backgroundView sdc_alignEdges:UIRectEdgeAll withView:self];
    }
}

- (void)createUI {
    for (UIView *element in self.elements) {
        element.translatesAutoresizingMaskIntoConstraints = NO;
        [self.scrollView addSubview:element];
    }
    
    self.actionsCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.actionsCollectionView];
}

- (void)updateCollectionViewScrollDirection {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.actionsCollectionView.collectionViewLayout;
    if (![layout isKindOfClass:[UICollectionViewFlowLayout class]])
        return;
    
    if (self.actionLayout == SDCActionLayoutHorizontal || (self.actions.count == 2 && self.actionLayout == SDCActionLayoutAutomatic))
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    else
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
}

- (void)updateUI {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.visualStyle.cornerRadius;
    self.textFieldsViewController.visualStyle = self.visualStyle;
}

- (CGSize)intrinsicContentSize {
    CGFloat totalHeight = (self.contentHeight + self.actionsCollectionView.displayHeight);
    return CGSizeMake(UIViewNoIntrinsicMetric, totalHeight);
}

#pragma mark - Constraints

- (void)createContentConstraints {
    [self createTitleLabelConstraints];
    [self createMessageLabelConstraints];
    [self createTextFieldsConstraints];
    [self createCustomContentViewConstraints];
    [self createCollectionViewConstraints];
    [self createScrollViewConstraints];
}

- (void)createTitleLabelConstraints {
    UIEdgeInsets contentPadding = self.visualStyle.contentPadding;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeFirstBaseline relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:contentPadding.top]];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, contentPadding.left, 0, -contentPadding.right);
    [self.titleLabel sdc_alignEdges:(UIRectEdgeLeft | UIRectEdgeRight) withView:self insets:insets];
    
    [self pinBottomOfScrollViewToView:self.titleLabel withPriority:UILayoutPriorityDefaultLow];
}

- (void)createMessageLabelConstraints {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeFirstBaseline relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBaseline multiplier:1.0f constant:self.visualStyle.verticalElementSpacing]];
    
    UIEdgeInsets contentPadding = self.visualStyle.contentPadding;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, contentPadding.left, 0, -contentPadding.right);
    [self.messageLabel sdc_alignEdges:(UIRectEdgeLeft | UIRectEdgeRight) withView:self insets:insets];
    
    [self pinBottomOfScrollViewToView:self.messageLabel withPriority:UILayoutPriorityDefaultLow + 1];
}

- (void)createTextFieldsConstraints {
    // The text fields view controller needs the visual style to calculate its height
    self.textFieldsViewController.visualStyle = self.visualStyle;
    
    UIView *textFieldsView = self.textFieldsViewController.view;
    CGFloat height = self.textFieldsViewController.requiredHeight;
    if (!textFieldsView || !height)
        return;
    
    CGFloat widthOffset = (self.visualStyle.contentPadding.left + self.visualStyle.contentPadding.right);
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:textFieldsView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.messageLabel attribute:NSLayoutAttributeBaseline multiplier:1.0f constant:self.visualStyle.verticalElementSpacing]];
    
    [textFieldsView sdc_pinWidthToWidthOfView:self offset:-widthOffset];
    [textFieldsView sdc_alignHorizontalCenterWithView:self];
    [textFieldsView sdc_pinHeight:height];
    
    [self pinBottomOfScrollViewToView:textFieldsView withPriority:UILayoutPriorityDefaultLow + 2];
}

- (void)createCustomContentViewConstraints {
    if (![self.elements containsObject:self.contentView])
        return;
    
    UIView *aligningView = (self.textFieldsViewController.view ?: self.messageLabel);
    CGFloat widthOffset = (self.visualStyle.contentPadding.left + self.visualStyle.contentPadding.right);
    
    CGFloat topSpacing = self.visualStyle.verticalElementSpacing;
    [self.contentView sdc_alignEdge:UIRectEdgeTop withEdge:UIRectEdgeBottom ofView:aligningView inset:topSpacing];
    [self.contentView sdc_alignHorizontalCenterWithView:self];
    [self.contentView sdc_pinWidthToWidthOfView:self offset:-widthOffset];
    
    [self pinBottomOfScrollViewToView:self.contentView withPriority:UILayoutPriorityDefaultLow + 3];
}

- (void)createCollectionViewConstraints {
    CGFloat height = self.actionsCollectionView.displayHeight;
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.actionsCollectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:height];
    heightConstraint.priority = UILayoutPriorityDefaultHigh;
    [self.actionsCollectionView addConstraint:heightConstraint];
    [self.actionsCollectionView sdc_pinWidthToWidthOfView:self];
    [self.actionsCollectionView sdc_alignEdge:UIRectEdgeTop withEdge:UIRectEdgeBottom ofView:self.scrollView];
    [self.actionsCollectionView sdc_alignHorizontalCenterWithView:self];
    [self.actionsCollectionView sdc_alignEdges:UIRectEdgeBottom withView:self];
}

- (void)createScrollViewConstraints {
    [self.scrollView sdc_alignEdges:(UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeTop) withView:self];
    [self.scrollView layoutIfNeeded];
    
    CGFloat scrollViewHeight = self.scrollView.contentSize.height;
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:scrollViewHeight];
    constraint.priority = UILayoutPriorityDefaultHigh;
    
    [self.scrollView addConstraint:constraint];
}

- (void)pinBottomOfScrollViewToView:(UIView *)view withPriority:(UILayoutPriority)priority {
    NSLayoutConstraint *bottomAnchor = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-[self bottomPadding]];
    bottomAnchor.priority = priority;
    [self addConstraint:bottomAnchor];
}

@end
