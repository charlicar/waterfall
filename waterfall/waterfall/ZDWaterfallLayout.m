//
//  ZDWaterfallLayout.m
//  waterfall
//
//  Created by charlicar on 16/3/15.
//  Copyright © 2016年 charlicar. All rights reserved.
//

#import "ZDWaterfallLayout.h"

/**默认的列数*/
static const NSInteger ZDDefaultColumnCount = 3;
/**默认每一行之间的间距*/
static const CGFloat ZDDefaultColumnMargin = 10;
/**默认每一行之间的间距*/
static const CGFloat ZDDefaultRowMargin = 10;
/**默认的边缘间距*/
static const UIEdgeInsets ZDDefaultEdgeInsets = {20,10,10,10};

@interface ZDWaterfallLayout()
/**所有cell的布局属性*/
@property (nonatomic,strong)NSMutableArray *attrsArray;
/**所有列的当前高度*/
@property (nonatomic,strong)NSMutableArray *columnHeights;
/**内容的高度*/
@property (nonatomic,assign)CGFloat contentHeight;

- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
- (UIEdgeInsets)edgeInsets;

@end

@implementation ZDWaterfallLayout

#pragma mark - lazy
- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (NSMutableArray *)colunmHeights
{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

#pragma mark - 数据处理
- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterfallLayout:)]) {
        return [self.delegate rowMarginInWaterfallLayout:self];
    }else{
        return ZDDefaultRowMargin;
    }
}

- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterfallLayout:)]) {
        return [self.delegate columnMarginInWaterfallLayout:self];
    }else{
        return ZDDefaultColumnMargin;
    }
}

- (NSInteger)columnCount
{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterfallLayout:)]) {
        return [self.delegate columnCountInWaterfallLayout:self];
    }else{
        return ZDDefaultColumnCount;
    }
}

- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterfallLayout:)]) {
        return [self.delegate edgeInsetsInWaterfallLayout:self];
    }else{
        return ZDDefaultEdgeInsets;
    }
}

#pragma mark - 初始化方法
- (void)prepareLayout
{
    [super prepareLayout];
    
    //清除之前计算的所有高度
    [self.colunmHeights removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.colunmHeights addObject:@(self.edgeInsets.top)];
    }
    
    //清除之前所有的布局
    [self.attrsArray removeAllObjects];
    
    //创建每一个cell对应的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        //创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        //获取indexPath位置cell对应的布局属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}

#pragma mark - 决定cell的排布
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

#pragma mark - 返回indexPath位置对应cell的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //collectionView的宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    //设置布局属性的frame
    CGFloat w = (collectionViewW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
//    CGFloat h = 50 + arc4random_uniform(100);
    CGFloat h = [self.delegate waterfallLayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    
    //找出高度最短的那一列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.colunmHeights[0] doubleValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {
        CGFloat columnHeight = [self.colunmHeights[i] doubleValue];
        
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat x = self.edgeInsets.left + destColumn * (w + self.columnMargin);
    CGFloat y = minColumnHeight;
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
    }
    attrs.frame = CGRectMake(x, y, w, h);
    
    //更新最短那列的高度
    self.colunmHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    // 记录内容的高度
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    return attrs;
}

#pragma mark - 让collctionView可以滚动
- (CGSize)collectionViewContentSize
{
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}

@end
