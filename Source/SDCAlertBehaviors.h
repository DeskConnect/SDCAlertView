//
//  SDCAlertBehaviors.h
//  SDCAlertView
//
//  Created by Ari on 5/30/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCAlertVisualStyle.h"

/**
 Defines behaviors that can be added to an alert or action sheet.
 */
typedef NS_OPTIONS(NSInteger, SDCAlertBehaviors) {
    /// When applied, the user can dismiss the alert or action sheet by tapping outside of it. Enabled for
    /// action sheets by default.
    SDCAlertBehaviorDismissOnOutsideTap = 1 << 0,
    
    /// Applies the "drag tap" behavior, meaning when the user taps on an action and then drags their finger
    /// to another action the new action will be selected. Enabled on iOS 9 by default for both alerts and
    /// action sheets.
    SDCAlertBehaviorDragTap = 1 << 1,
    
    /// Adds a parallax effect to the alert. Does not apply to action sheets. Enabled on iOS 8 by default.
    SDCAlertBehaviorParallax = 1 << 2,
    
    /// Automatically focuses the first text field in an alert. This doesn't work for text fields added to an
    /// alert's content view.
    SDCAlertBehaviorAutomaticallyFocusTextField = 1 << 3
};

extern SDCAlertBehaviors SDCDefaultAlertBehaviorsForAlertStyle(SDCAlertControllerStyle alertStyle);
