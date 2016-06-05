//
//  SDCAlertView.h
//  SDCAlertView
//
//  Created by Ari on 5/30/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCAlertControllerView.h"
#import "SDCTextFieldsViewController.h"

@interface SDCAlertView : SDCAlertControllerView

@property (nonatomic) SDCActionLayout actionLayout;
@property (nonatomic, strong) SDCTextFieldsViewController *textFieldsViewController;

@end
