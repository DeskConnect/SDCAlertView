//
//  SDCAlertController.h
//  SDCAlertView
//
//  Created by Ari on 6/1/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCAlertBehaviors.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDCAlertController : UIViewController

/// The alert's title. Directly uses attributedTitle without any attributes.
@property (nonatomic, copy, nullable) NSString *title;

/// The alert's message. Directly uses attributedMessage without any attributes.
@property (nonatomic, copy, nullable) NSString *message;

/// A stylized title for the alert.
@property (nonatomic, strong, nullable) NSAttributedString *attributedTitle;

/// A stylized message for the alert.
@property (nonatomic, strong, nullable) NSAttributedString *attributedMessage;

/// The alert's content view. This can be used to add custom views to your alert. The width of the content view is equal to the width of the alert, minus padding. The height must be defined manually since it depends on the size of the subviews.
@property (nonatomic, readonly, strong) UIView *contentView;

/// The alert's actions (buttons).
@property (nonatomic, readonly, copy) NSArray<SDCAlertAction *> *actions;

/// The alert's preferred action, if one is set. Setting this value to nil will remove the preferred style from all actions.
@property (nonatomic, strong, nullable) SDCAlertAction *preferredAction;

/// The layout of the actions in the alert.
@property (nonatomic, assign) SDCActionLayout actionLayout;

/// The text fields that are added to the alert. Does nothing when used with an action sheet.
@property (nonatomic, readonly, copy, nullable) NSArray<UITextField *> *textFields;

/// The alert's custom behaviors. See `SDCAlertBehaviors` for possible options.
@property (nonatomic, readonly) SDCAlertBehaviors behaviors;

/// A closure that, when set, returns whether the alert or action sheet should dismiss after the user taps on an action. If it returns false, the AlertAction handler will not be executed.
@property (nonatomic, copy, nullable) BOOL (^shouldDismissHandler)(SDCAlertAction * __nullable);

/// The visual style that applies to the alert or action sheet.
@property (nonatomic, strong) SDCAlertVisualStyle *visualStyle;

/// The alert's presentation style.
@property (nonatomic, readonly) SDCAlertControllerStyle preferredStyle;

/**
 Create an alert with an stylized title and message. If no styles are necessary, consider using
 `init(title:message:preferredStyle:)`
 
 - parameter title:          An optional stylized title
 - parameter message:        An optional stylized message
 - parameter preferredStyle: The preferred presentation style of the alert. Default is Alert.
 */
- (instancetype)initWithAttributedTitle:(nullable NSAttributedString *)attributedTitle attributedMessage:(nullable NSAttributedString *)attributedMessage preferredStyle:(SDCAlertControllerStyle)preferredStyle;

/**
 Creates an alert with a plain title and message. To add styles to the title or message, use
 `init(title:message:)`.
 
 - parameter title:          An optional title
 - parameter message:        An optional message
 - parameter preferredStyle: The preferred presentation style of the alert. Default is Alert.
 */
- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(SDCAlertControllerStyle)preferredStyle;

/**
 Adds the provided action to the alert. Unlike the `UIAlertController` API, this method adds and shows
 buttons in the order they were added. This gives you the flexibility to place buttons of any style in any
 position.
 
 - parameter action: The action to add
 */
- (void)addAction:(SDCAlertAction *)action;

/**
 Adds a text field to the alert.
 
 - parameter configurationHandler: An optional closure that can be used to configure the text field, which
 is provided as a parameter to the closure
 */
- (void)addTextFieldWithConfigurationHandler:(nullable void (^)(UITextField *))configurationHandler;

@end

NS_ASSUME_NONNULL_END
