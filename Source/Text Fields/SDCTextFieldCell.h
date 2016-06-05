//
//  SDCTextFieldCell.h
//  SDCAlertView
//
//  Created by Ari on 5/29/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCAlertVisualStyle.h"

@interface SDCTextFieldCell : UITableViewCell

@property (nonatomic, strong) SDCAlertVisualStyle *visualStyle;
@property (nonatomic, strong) UITextField *textField;

@end
