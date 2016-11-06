//
//  SDCActionsCollectionViewFlowLayout.h
//  SDCAlertView
//
//  Created by Ari on 5/29/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCAlertVisualStyle.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const SDCHorizontalActionSeparator;
extern NSString * const SDCVerticalActionSeparator;

@interface SDCActionsCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, strong, nullable) SDCAlertVisualStyle *visualStyle;
@property (nonatomic, assign) BOOL hideFirstSeparator;

@end

@interface SDCActionsCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic, strong, nullable) UIColor *backgroundColor;

@end


NS_ASSUME_NONNULL_END
