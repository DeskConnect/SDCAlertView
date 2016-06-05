//
//  SDCAlertLabel.m
//  SDCAlertView
//
//  Created by Ari on 5/30/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCAlertLabel.h"

@implementation SDCAlertLabel

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (!self)
        return nil;
    
    self.textAlignment = NSTextAlignmentCenter;
    self.numberOfLines = 0;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    return self;
}

- (void)layoutSubviews {
    self.preferredMaxLayoutWidth = self.bounds.size.width;
    [super layoutSubviews];
}

@end
