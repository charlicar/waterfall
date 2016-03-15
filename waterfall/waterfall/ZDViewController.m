//
//  ViewController.m
//  waterfall
//
//  Created by charlicar on 16/3/15.
//  Copyright © 2016年 charlicar. All rights reserved.
//

#import "ZDViewController.h"
#import "ZDWaterfallLayout.h"

@interface ZDViewController ()<UICollectionViewDataSource,ZDWaterfallLayoutDelegate>

@property (nonatomic,weak)UICollectionView *collectionView;

@end

@implementation ZDViewController

static NSString * const ZDShopID = @"shop";

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setUpLayout];
    
}

#pragma mark - 自定义方法
- (void)setUpLayout
{
    //创建布局
    ZDWaterfallLayout *layout = [[ZDWaterfallLayout alloc] init];
    layout.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    //注册
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ZDShopID];
    
    self.collectionView = collectionView;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZDShopID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1];
    
    NSInteger tag = 10;
    UILabel *label = [cell.contentView viewWithTag:tag];
    if (label == nil) {
        label = [[UILabel alloc] init];
        label.tag = tag;
        [cell.contentView addSubview:label];
    }
    label.frame = CGRectMake(0, 0, cell.frame.size.width, 20);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%zd",indexPath.item];
    
    return cell;
 }

#pragma mark - <ZDWaterfallLayoutDalegate>
- (CGFloat)waterfallLayout:(ZDWaterfallLayout *)waterfallLayout heightForItemAtIndex:(NSInteger)index itemWidth:(CGFloat)itemWidth
{
    return 100 + arc4random_uniform(100);
}

- (CGFloat)columnCountInWaterfallLayout:(ZDWaterfallLayout *)waterfallLayout
{
    return 5;
}

@end
