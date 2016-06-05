//
//  SDCTextFieldsViewController.h
//  SDCAlertView
//
//  Created by Ari on 5/29/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCAlertVisualStyle.h"

@interface SDCTextFieldsViewController : UIViewController

- (instancetype)initWithTextFields:(NSArray<UITextField *> *)textFields;

@property (nonatomic, strong) SDCAlertVisualStyle *visualStyle;
@property (nonatomic, readonly) CGFloat requiredHeight;

@end
