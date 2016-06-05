//
//  SDCActionSheetView.m
//  SDCAlertView
//
//  Created by Ari on 5/30/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCActionSheetView.h"

@interface SDCActionSheetView ()

@property (nonatomic, strong) SDCAlertAction *cancelAction;

@property (nonatomic, strong) IBOutlet UIView *primaryView;
@property (nonatomic, weak) IBOutlet UIView *cancelActionView;
@property (nonatomic, weak) IBOutlet UILabel *cancelLabel;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

@property (nonatomic, copy) IBOutlet NSArray<NSLayoutConstraint *> *contentViewConstraints;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *cancelHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *titleWidthConstraint;

@end

static UIImage *SDCImageWithColor(UIColor *color);

@implementation SDCActionSheetView

- (void)setActions:(NSArray<SDCAlertAction *> *)actions {
    SDCAlertAction *cancelAction = [[actions filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SDCAlertAction *action, NSDictionary<NSString *, id> * __nullable bindings) {
        return (action.style == SDCAlertActionStylePreferred);
    }]] firstObject];
    if (cancelAction) {
        self.cancelAction = cancelAction;
        NSMutableArray<SDCAlertAction *> *mutableActions = [actions mutableCopy];
        [mutableActions removeObject:cancelAction];
        actions = mutableActions;
    }
    
    [super setActions:actions];
}

- (void)setActionTappedHandler:(void (^)(SDCAlertAction * _Nonnull))actionTappedHandler {
    [super setActionTappedHandler:actionTappedHandler];
    self.actionsCollectionView.actionTapped = actionTappedHandler;
}

- (void)setVisualStyle:(SDCAlertVisualStyle *)visualStyle {
    [super setVisualStyle:visualStyle];
    CGFloat widthOffset = (self.visualStyle.contentPadding.left + self.visualStyle.contentPadding.right);
    self.titleWidthConstraint.constant -= widthOffset;
}

- (void)setCancelAction:(SDCAlertAction *)cancelAction {
    _cancelAction = cancelAction;
    self.cancelLabel.attributedText = cancelAction.attributedTitle;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    self.collectionViewHeightConstraint.constant = self.actionsCollectionView.displayHeight;
    self.collectionViewHeightConstraint.active = YES;
    
    self.primaryView.layer.cornerRadius = self.visualStyle.cornerRadius;
    self.primaryView.layer.masksToBounds = YES;
    self.cancelActionView.layer.cornerRadius = self.visualStyle.cornerRadius;
    self.cancelActionView.layer.masksToBounds = YES;
    
    self.cancelLabel.textColor = ([self.visualStyle textColorForAction:self.cancelAction] ?: self.tintColor);
    self.cancelLabel.font = [self.visualStyle fontForAction:self.cancelAction];
    UIImage *cancelButtonBackground = SDCImageWithColor(self.visualStyle.actionHighlightColor);
    [self.cancelButton setBackgroundImage:cancelButtonBackground forState:UIControlStateHighlighted];
    self.cancelHeightConstraint.constant = self.visualStyle.actionViewSize.height;
    
    BOOL showContentView = (self.contentView.subviews.count > 0);
    self.contentView.hidden = !showContentView;
    [self.contentViewConstraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        constraint.active = showContentView;
    }];
}

- (void)highlightActionForPanGesture:(UIPanGestureRecognizer *)sender {
    [super highlightActionForPanGesture:sender];
    
    BOOL cancelIsSelected = CGRectContainsPoint(self.cancelActionView.frame, [sender locationInView:self]);
    self.cancelButton.highlighted = cancelIsSelected;
    
    if (cancelIsSelected && sender.state == UIGestureRecognizerStateEnded)
        [self.cancelButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    self.cancelLabel.textColor = ([self.visualStyle textColorForAction:self.cancelAction] ?: self.tintColor);
}

- (IBAction)cancelTapped {
    SDCAlertAction *action = self.cancelAction;
    if (!action)
        return;
    
    if (self.actionTappedHandler)
        self.actionTappedHandler(action);
}

@end

static UIImage *SDCImageWithColor(UIColor *color) {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
