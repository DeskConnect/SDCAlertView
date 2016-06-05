//
//  SDCAlertAction.h
//  SDCAlertView
//
//  Created by Ari on 5/29/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The action's style
 
 - Default:     The action will have default font and text color
 - Preferred:   The action will take a style that indicates it's the preferred option
 - Destructive: The action will convey that this action will do something destructive
 */
typedef NS_ENUM(NSInteger, SDCAlertActionStyle) {
    SDCAlertActionStyleDefault = 0,
    SDCAlertActionStylePreferred = 1,
    SDCAlertActionStyleDestructive = 2,
};

@interface SDCAlertAction : NSObject

/**
 Creates an action with a title.
 
 - parameter title:   An optional title for the action
 - parameter style:   The action's style
 - parameter handler: An optional closure that's called when the user taps on this action
 */
- (instancetype)initWithTitle:(nullable NSString *)title style:(SDCAlertActionStyle)style;
- (instancetype)initWithTitle:(nullable NSString *)title style:(SDCAlertActionStyle)style handler:(nullable void (^)(SDCAlertAction *))handler;
- (instancetype)initWithAttributedTitle:(nullable NSAttributedString *)attributedTitle style:(SDCAlertActionStyle)style handler:(nullable void (^)(SDCAlertAction *))handler;

/// A closure that gets executed when the user taps on this actions in the UI
@property (nonatomic, copy, nullable) void (^handler)(SDCAlertAction *);

/// The plain title for the action. Uses attributedTitle directly.
@property (nonatomic, readonly, copy, nullable) NSString *title;

/// The stylized title for the action.
@property (nonatomic, readonly, copy, nullable) NSAttributedString *attributedTitle;

/// The action's style.
@property (nonatomic, readonly) SDCAlertActionStyle style;

/// Whether this action can be interacted with by the user.
@property (nonatomic) BOOL enabled;

@end

NS_ASSUME_NONNULL_END
