//
//  SDCActionsCollectionViewFlowLayout.m
//  SDCAlertView
//
//  Created by Ari on 5/29/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCActionsCollectionViewFlowLayout.h"

NS_ASSUME_NONNULL_BEGIN

NSString * const SDCHorizontalActionSeparator = @"horizontal";
NSString * const SDCVerticalActionSeparator = @"vertical";

@implementation SDCActionsCollectionViewFlowLayout

+ (Class)layoutAttributesClass {
    return [SDCActionsCollectionViewLayoutAttributes class];
}

- (instancetype)init {
    self = [super init];
    if (!self)
        return nil;
    
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
    
    return self;
}

- (nullable id)initWithCoder:(NSCoder *)aDecoder {
    return [super init];
}

- (nullable NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray<UICollectionViewLayoutAttributes *> *attributes = [super layoutAttributesForElementsInRect:rect];
    if (!attributes)
        return nil;
    
    NSMutableArray<UICollectionViewLayoutAttributes *> *mutableAttributes = [attributes mutableCopy];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        UICollectionViewLayoutAttributes *horizontal = [self layoutAttributesForDecorationViewOfKind:SDCHorizontalActionSeparator atIndexPath:attribute.indexPath];
        if (horizontal)
            [mutableAttributes addObject:horizontal];
        
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal && attribute.indexPath.item > 0) {
            UICollectionViewLayoutAttributes *vertical = [self layoutAttributesForDecorationViewOfKind:SDCVerticalActionSeparator atIndexPath:attribute.indexPath];
            if (vertical)
                [mutableAttributes addObject:vertical];
        }
    }
    
    return mutableAttributes;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    SDCActionsCollectionViewLayoutAttributes *attributes = [SDCActionsCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
    
    UICollectionViewLayoutAttributes *itemAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    if (!itemAttributes)
        return nil;
    
    attributes.zIndex = itemAttributes.zIndex + 1;
    attributes.backgroundColor = self.visualStyle.actionViewSeparatorColor;
    
    CGRect decorationViewFrame = itemAttributes.frame;
    if ([elementKind isEqualToString:SDCHorizontalActionSeparator])
        decorationViewFrame.size.height = (self.visualStyle.actionViewSeparatorThickness ?: 0.5);
    else
        decorationViewFrame.size.width = (self.visualStyle.actionViewSeparatorThickness ?: 0.5);
    
    attributes.frame = decorationViewFrame;
    return attributes;
}

@end

@implementation SDCActionsCollectionViewLayoutAttributes
@end

NS_ASSUME_NONNULL_END
