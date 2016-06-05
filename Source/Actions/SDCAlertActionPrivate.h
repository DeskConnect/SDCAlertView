//
//  SDCAlertActionPrivate.h
//  SDCAlertView
//
//  Created by Ari on 6/4/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCAlertAction.h"
#import "SDCActionCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDCAlertAction ()

@property (nonatomic, strong) SDCActionCell *actionView;
@property (nonatomic, assign) SDCAlertActionStyle style;

@end

NS_ASSUME_NONNULL_END
