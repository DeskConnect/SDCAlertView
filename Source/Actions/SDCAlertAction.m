//
//  SDCAlertAction.m
//  SDCAlertView
//
//  Created by Ari on 5/29/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCAlertActionPrivate.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDCAlertAction

- (instancetype)initWithTitle:(nullable NSString *)title style:(SDCAlertActionStyle)style handler:(nullable void (^)(SDCAlertAction *))handler {
    return [self initWithAttributedTitle:[[NSAttributedString alloc] initWithString:title] style:style handler:handler];
}

- (instancetype)initWithTitle:(nullable NSString *)title style:(SDCAlertActionStyle)style {
    return [self initWithTitle:title style:style handler:nil];
}

- (instancetype)initWithAttributedTitle:(nullable NSAttributedString *)attributedTitle style:(SDCAlertActionStyle)style handler:(nullable void (^)(SDCAlertAction *))handler {
    self = [super init];
    if (!self)
        return nil;
    
    _enabled = YES;
    _preferred = (style == SDCAlertActionStyleCancel);
    _attributedTitle = [attributedTitle copy];
    _style = style;
    _handler = [handler copy];
    
    return self;
}

- (nullable NSString *)title {
    return self.attributedTitle.string;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    self.actionView.enabled = enabled;
}

- (void)setActionView:(SDCActionCell *)actionView {
    _actionView = actionView;
    actionView.enabled = self.enabled;
}

- (Class)cellClass {
    return (_cellClass ?: [SDCActionCell class]);
}

@end

NS_ASSUME_NONNULL_END
