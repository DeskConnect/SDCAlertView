//
//  SDCAlertBehaviors.m
//  SDCAlertView
//
//  Created by Ari on 5/30/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCAlertBehaviors.h"

SDCAlertBehaviors SDCDefaultAlertBehaviorsForAlertStyle(SDCAlertControllerStyle alertStyle) {
    SDCAlertBehaviors behaviors = 0;
    
    BOOL isiOS9 = [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){9,0,0}];
    if (isiOS9)
        behaviors |= SDCAlertBehaviorDragTap;
    else if (alertStyle == SDCAlertControllerStyleAlert)
        behaviors |= SDCAlertBehaviorParallax;
    
    switch (alertStyle) {
        case SDCAlertControllerStyleActionSheet:
            behaviors |= SDCAlertBehaviorDismissOnOutsideTap;
            break;
        case SDCAlertControllerStyleAlert:
            behaviors |= SDCAlertBehaviorAutomaticallyFocusTextField;
            break;
    }
    
    return behaviors;
}
