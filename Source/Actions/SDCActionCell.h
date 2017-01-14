//
//  SDCActionCell.h
//  SDCAlertView
//
//  Created by Ari on 5/29/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCAlertVisualStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDCActionCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, getter=isEnabled) BOOL enabled;

- (void)setAction:(SDCAlertAction *)action withVisualStyle:(SDCAlertVisualStyle *)visualStyle;
- (nullable UIView *)customView;

@end

@interface SDCCancelSheetCell : SDCActionCell

@property (nonatomic, weak) id target;
@property (nonatomic, assign, nullable) SEL selector;

@end

@interface SDCActionSeparatorView : UICollectionReusableView
@end

NS_ASSUME_NONNULL_END
