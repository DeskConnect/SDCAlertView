//
//  SDCAlertVisualStyle.m
//  SDCAlertView
//
//  Created by Ari on 5/29/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCAlertVisualStyle.h"
#import "SDCAlertActionPrivate.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDCAlertVisualStyle ()

@property (nonatomic, assign) SDCAlertControllerStyle alertStyle;

@end

@implementation SDCAlertVisualStyle

- (instancetype)init {
    return [self initWithAlertStyle:SDCAlertControllerStyleAlert];
}

- (instancetype)initWithAlertStyle:(SDCAlertControllerStyle)alertStyle {
    self = [super init];
    if (!self)
        return nil;
    
    _alertStyle = alertStyle;
    _contentPadding = UIEdgeInsetsMake(36, 16, 12, 16);
    _parallax = UIOffsetMake(15.75, 15.75);
    _verticalElementSpacing = 24;
    _actionViewSeparatorThickness = (1.0f / [[UIScreen mainScreen] scale]);
    _textFieldHeight = 25;
    _textFieldMargins = UIEdgeInsetsMake(4, 4, 4, 4);
    
    BOOL isiOS9 = [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){9,0,0}];
    
    switch (alertStyle) {
        case SDCAlertControllerStyleAlert:
            self.width = 270;
            self.actionViewSize = CGSizeMake(90, 44);
            
            if (isiOS9) {
                self.cornerRadius = 13;
                self.margins = UIEdgeInsetsMake(10, 0, 10, 0);
            } else {
                self.cornerRadius = 7;
                self.margins = UIEdgeInsetsZero;
            }
            
            break;
            
        case SDCAlertControllerStyleActionSheet:
            self.width = 1;
            self.margins = UIEdgeInsetsMake(30, 10, -10, 10);
            
            if (isiOS9) {
                self.cornerRadius = 13;
                self.actionViewSize = CGSizeMake(90, 57);
            } else {
                self.cornerRadius = 4;
                self.actionViewSize = CGSizeMake(90, 44);
            }
            
            break;
    }
    
    return self;
}

- (nullable UIColor *)textColorForAction:(nullable SDCAlertAction *)action {
    return (action.style == SDCAlertActionStyleDestructive ? self.destructiveTextColor : self.normalTextColor);
}

- (UIFont *)fontForAction:(nullable SDCAlertAction *)action {
    switch (self.alertStyle) {
        case SDCAlertControllerStyleAlert:
            if (action.preferred)
                return self.alertPreferredFont;
            else
                return self.alertNormalFont;
        case SDCAlertControllerStyleActionSheet:
            if (action.style == SDCAlertActionStyleCancel)
                return self.actionSheetPreferredFont;
            else
                return self.actionSheetNormalFont;
    }
}

#pragma mark - Properties

- (UIColor *)actionHighlightColor {
    if (!_actionHighlightColor)
        _actionHighlightColor = [UIColor colorWithWhite:0.8 alpha:0.7];
    
    return _actionHighlightColor;
}

- (UIColor *)actionViewSeparatorColor {
    if (!_actionViewSeparatorColor)
        _actionViewSeparatorColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    return _actionViewSeparatorColor;
}

- (UIFont *)textFieldFont {
    if (!_textFieldFont)
        _textFieldFont = [UIFont systemFontOfSize:13.0f];
    
    return _textFieldFont;
}

- (UIColor *)textFieldBorderColor {
    if (!_textFieldBorderColor)
        _textFieldBorderColor = [UIColor colorWithRed:142.0f/255.0f green:142.0f/255.0f blue:142.0f/255.0f alpha:1.0f];
    
    return _textFieldBorderColor;
}

- (UIColor *)destructiveTextColor {
    if (!_destructiveTextColor)
        _destructiveTextColor = [UIColor colorWithRed:1.0f green:0.23f blue:0.19f alpha:1.0f];
    
    return _destructiveTextColor;
}

- (UIFont *)alertPreferredFont {
    if (!_alertPreferredFont)
        _alertPreferredFont = [UIFont boldSystemFontOfSize:17.0f];
    
    return _alertPreferredFont;
}

- (UIFont *)alertNormalFont {
    if (!_alertNormalFont)
        _alertNormalFont = [UIFont systemFontOfSize:17.0f];
    
    return _alertNormalFont;
}

- (UIFont *)actionSheetPreferredFont {
    if (!_actionSheetPreferredFont)
        _actionSheetPreferredFont = [UIFont boldSystemFontOfSize:20.0f];
    
    return _actionSheetPreferredFont;
}

- (UIFont *)actionSheetNormalFont {
    if (!_actionSheetNormalFont)
        _actionSheetNormalFont = [UIFont systemFontOfSize:20.0f];
    
    return _actionSheetNormalFont;
}

@end

NS_ASSUME_NONNULL_END
