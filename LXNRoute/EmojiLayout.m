//
//  EmojiLayout.m
//  StarFactory
//
//  Created by 李晓宁 on 2017/2/4.
//  Copyright © 2017年 Joygo. All rights reserved.
//

#import "EmojiLayout.h"

@interface EmojiLayout()
// 保存所有item属性
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributes;
// screen
@property (nonatomic, assign) CGSize mainRect;
// section
@property (nonatomic, assign) NSInteger sections;
// item
@property (nonatomic, assign) NSInteger items;

@end

@implementation EmojiLayout

- (instancetype)init
{
    if (self = [super init]) {
        self.sections = 0;
        self.items = 0;
        self.mainRect = [UIScreen mainScreen].bounds.size;
        self.maxColumn = 0;
        self.maxRow = 0;
        self.margin = 0;
    }
    return self;
}

- (NSMutableArray<UICollectionViewLayoutAttributes *> *)attributes
{
    if (!_attributes) {
        _attributes = [NSMutableArray array];
    }
    return _attributes;
}

//允许重新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    [self.attributes removeAllObjects];
    
    // 根据设置的Column Row, 计算得到每个item的大小
    CGSize itemsize =  [self getItemSizeWithColumn:self.maxColumn row:self.maxRow margin:self.margin];
    // 获取组数
    self.sections = [self.collectionView numberOfSections] >= 0 ? [self.collectionView numberOfSections] : 0;
    // 遍历每组里面的所有item
    for (int section = 0; section < self.sections; section++) {
        self.items = [self.collectionView numberOfItemsInSection:section] >= 0 ? [self.collectionView numberOfItemsInSection:section] : 0;
        // 遍历每一个item
        for (int item = 0; item < self.items; item++) {
            // 根据 section, item 获取每一个item的indexPath值
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            // 根据indexPath值, 获取每一个item的属性
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            // 通过一系列脑残计算, 得到x, y值
            CGFloat x = self.margin + (itemsize.width + self.margin) * (item % self.maxColumn) + ((CGFloat)section * self.mainRect.width);
            CGFloat y = self.margin + (itemsize.height + self.margin) * (CGFloat)(item /self.maxColumn);
            attribute.frame = CGRectMake(x, y, itemsize.width, itemsize.height);
            // 把每一个新的属性保存起来
            [self.attributes addObject:attribute];
        }
    }
}

//返回当前可见的
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    [super layoutAttributesForElementsInRect:rect];
    NSMutableArray<UICollectionViewLayoutAttributes *> *rectAttributes = [NSMutableArray array];
    // 遍历所有属性, 返回当前处于可见区域的item(在屏幕可见的item)
    [self.attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsRect(rect, obj.frame)) {
            [rectAttributes addObject:obj];
        }
    }];
    return rectAttributes;
}

- (CGSize)collectionViewContentSize
{
    [super collectionViewContentSize];
    CGSize itemsize =  [self getItemSizeWithColumn:self.maxColumn row:self.maxRow margin:self.margin];
    return CGSizeMake((CGFloat)self.sections * self.mainRect.width, self.margin + (self.maxRow * (itemsize.height + self.margin)));
}

// MARK: - itemSize
// 为了使得表情不变形, 因此 height = width
- (CGSize)getItemSizeWithColumn:(CGFloat)column row:(CGFloat)row margin:(CGFloat)margin
{
    CGFloat width = (self.mainRect.width - ((column + 1) * margin)) / column;
    return CGSizeMake(width, width);
}


@end
