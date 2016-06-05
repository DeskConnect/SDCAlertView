//
//  SDCTextFieldCell.m
//  SDCAlertView
//
//  Created by Ari on 5/29/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCTextFieldCell.h"
#import "UIView+SDCAutoLayout.h"

@interface SDCTextFieldCell ()

@property (nonatomic, strong) IBOutlet UIView *borderView;
@property (nonatomic, strong) IBOutlet UIView *textFieldContainer;

@property (nonatomic, strong) NSLayoutConstraint *leading;
@property (nonatomic, strong) NSLayoutConstraint *trailing;
@property (nonatomic, strong) NSLayoutConstraint *top;
@property (nonatomic, strong) NSLayoutConstraint *bottom;

@end

@implementation SDCTextFieldCell

- (void)setTextField:(UITextField *)textField {
    [_textField removeFromSuperview];
    _textField = textField;
    if (_textField)
        [self addTextField:textField];
}

- (void)setVisualStyle:(SDCAlertVisualStyle *)visualStyle {
    _visualStyle = visualStyle;
    self.textField.font = visualStyle.textFieldFont;
    self.borderView.backgroundColor = visualStyle.textFieldBorderColor;
    
    UIEdgeInsets padding = visualStyle.textFieldMargins;
    if (UIEdgeInsetsEqualToEdgeInsets(padding, UIEdgeInsetsZero))
        return;
    
    self.leading.constant = padding.left;
    self.trailing.constant = -padding.right;
    self.top.constant = padding.top;
    self.bottom.constant = -padding.bottom;
}

- (void)addTextField:(UITextField *)textField {
    UIView *container = self.textFieldContainer;
    [container addSubview:textField];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIEdgeInsets insets = (self.visualStyle ? self.visualStyle.textFieldMargins : UIEdgeInsetsZero);
    NSArray<NSLayoutConstraint *> *constraints = [textField sdc_alignEdgesWithSuperview:UIRectEdgeAll insets:insets];
    
    // Assumes array order to be: top, right, bottom, left (compatible with SDCAutoLayout 2.0)
    self.leading = constraints[3];
    self.trailing = constraints[1];
    self.top = constraints[0];
    self.bottom = constraints[2];
}

@end
