//
//  SDCAlertVisualStyle.h
//  SDCAlertView
//
//  Created by Ari on 5/29/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import <UIKit/UIKIt.h>
#import "SDCAlertAction.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SDCAlertControllerStyle) {
    SDCAlertControllerStyleActionSheet = 0,
    SDCAlertControllerStyleAlert = 1,
};

typedef NS_ENUM(NSInteger, SDCActionLayout) {
    SDCActionLayoutAutomatic,
    SDCActionLayoutVertical,
    SDCActionLayoutHorizontal
};

@interface SDCAlertVisualStyle : NSObject

/// The width of the alert. A value of 1 or below is interpreted as a percentage of the width of the view controller that presents the alert.
@property (nonatomic) CGFloat width;

/// The corner radius of the alert
@property (nonatomic) CGFloat cornerRadius;

/// The minimum distance between alert elements and the alert itself
@property (nonatomic) UIEdgeInsets contentPadding;

/// The minimum distance between the alert and its superview
@property (nonatomic) UIEdgeInsets margins;

/// The parallax magnitude
@property (nonatomic) UIOffset parallax;

/// The background color of the alert. The standard blur effect will be added if nil. (Not supported on action sheets).
@property (nonatomic, strong, nullable) UIColor *backgroundColor;

/// The vertical spacing between elements
@property (nonatomic) CGFloat verticalElementSpacing;

/// The size of an action. The specified width is treated as a minimum width. The actual width is automatically determined.
@property (nonatomic) CGSize actionViewSize;

/// The color of an action when the user is tapping it
@property (nonatomic, strong) UIColor *actionHighlightColor;

/// The color of the separators between actions
@property (nonatomic, strong) UIColor *actionViewSeparatorColor;

/// The thickness of the separators between actions
@property (nonatomic) CGFloat actionViewSeparatorThickness;

/// The font used in text fields
@property (nonatomic, strong) UIFont *textFieldFont;

/// The height of a text field if added using the standard method call. Won't affect text fields added directly to the alert's content view.
@property (nonatomic) CGFloat textFieldHeight;

/// The border color of a text field if added using the standard method call. Won't affect text fields added directly to the alert's content view.
@property (nonatomic, strong) UIColor *textFieldBorderColor;

/// The inset of the text within the text field if added using the standard method call. Won't affect text fields added directly to the alert's content view.
@property (nonatomic) UIEdgeInsets textFieldMargins;

/// The color for a nondestructive action's text
@property (nonatomic, strong, nullable) UIColor *normalTextColor;

/// The color for a destructive action's text
@property (nonatomic, strong) UIColor *destructiveTextColor;

/// The font for an alert's preferred action
@property (nonatomic, strong) UIFont *alertPreferredFont;

/// The font for an alert's other actions
@property (nonatomic, strong) UIFont *alertNormalFont;

/// The font for an action sheet's preferred action
@property (nonatomic, strong) UIFont *actionSheetPreferredFont;

/// The font for an action sheet's other actions
@property (nonatomic, strong) UIFont *actionSheetNormalFont;

- (instancetype)initWithAlertStyle:(SDCAlertControllerStyle)alertStyle NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) SDCAlertControllerStyle alertStyle;

/**
 The text color for a given action.
 
 - parameter action: The action that determines the text color
 
 - returns: The text color. A nil value will use the alert's `tintColor`.
 */
- (nullable UIColor *)textColorForAction:(nullable SDCAlertAction *)action;

/**
 The font for a given action
 
 - parameter action: The action that determines the font
 
 - returns: The font
 */
- (UIFont *)fontForAction:(nullable SDCAlertAction *)action;

@end

NS_ASSUME_NONNULL_END
