//
//  ZDWaterfallLayout.h
//  waterfall
//
//  Created by charlicar on 16/3/15.
//  Copyright © 2016年 charlicar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZDWaterfallLayout;

@protocol ZDWaterfallLayoutDelegate <NSObject>
@required
- (CGFloat)waterfallLayout:(ZDWaterfallLayout *)waterfallLayout heightForItemAtIndex:(NSInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (CGFloat)columnCountInWaterfallLayout:(ZDWaterfallLayout *)waterfallLayout;
- (CGFloat)columnMarginInWaterfallLayout:(ZDWaterfallLayout *)waterfallLayout;
- (CGFloat)rowMarginInWaterfallLayout:(ZDWaterfallLayout *)waterfallLayout;
- (UIEdgeInsets)edgeInsetsInWaterfallLayout:(ZDWaterfallLayout *)waterfallLayout;

@end

@interface ZDWaterfallLayout : UICollectionViewLayout
/**布局代理*/
@property (nonatomic,weak) id<ZDWaterfallLayoutDelegate>delegate ;
@end
