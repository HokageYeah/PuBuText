//
//  YYWaterFallLayout.m
//  PuBuText
//
//  Created by 余晔 on 2017/4/18.
//  Copyright © 2017年 余晔. All rights reserved.
//

#import "YYWaterFallLayout.h"

@interface YYWaterFallLayout ()
//用来记录每一列的最大y值
@property (nonatomic, strong) NSMutableDictionary *maxYDic;
//保存每一个item的attributes
@property (nonatomic, strong) NSMutableArray *attributesArray;
//总共多少列
@property (nonatomic, assign) NSInteger columnCount;
@end

@implementation YYWaterFallLayout

- (NSMutableDictionary *)maxYDic
{
    if(!_maxYDic)
    {
        _maxYDic = [NSMutableDictionary new];
    }
    return _maxYDic;
}

- (NSMutableArray *)attributesArray
{
    if(!_attributesArray)
    {
        _attributesArray = [NSMutableArray new];
    }
    return _attributesArray;
}

- (instancetype)initWithColumnCount:(NSInteger)columnCount
{
    if(self = [super init])
    {
        self.columnCount = columnCount;
    }
    return self;
}

+ (instancetype)waterFallLayoutWithColumnCount:(NSInteger)columnCount
{
    return [[self alloc] initWithColumnCount:columnCount];
}

#pragma mark- 相关设置方法
- (void)setColumnSpacing:(NSInteger)columnSpacing rowSpacing:(NSInteger)rowSepacing sectionInset:(UIEdgeInsets)sectionInset
{
    self.columnSpacing = columnSpacing;
    self.rowSpacing = rowSepacing;
    self.sectionInset = sectionInset;
}

#pragma mark- 布局
- (void)prepareLayout
{
    [super prepareLayout];
    for(int i =0;i<self.columnCount;i++)
    {   //初始值上內边距
        self.maxYDic[@(i)] = @(self.sectionInset.top);
    }
    NSInteger itemcount = [self.collectionView numberOfItemsInSection:0];
    [self.attributesArray removeAllObjects];
    //每个item穿件attributes存入数组
    for(int i =0;i<itemcount;i++)
    {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attributesArray addObject:attributes];
    }
}

- (CGSize)collectionViewContentSize
{
    __block NSNumber *maxIndex = @0;
    [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSNumber *obj, BOOL *stop) {
        if ([self.maxYDic[maxIndex] floatValue] < obj.floatValue) {
            maxIndex = key;
        }
    }];
    
    CGFloat h = [self.maxYDic[maxIndex] floatValue] + self.sectionInset.bottom;
    NSLog(@"计算高度：%f",h);
    //collectionView的contentSize.height就等于最长列的最大y值+下内边距
    return CGSizeMake(0, [self.maxYDic[maxIndex] floatValue] + self.sectionInset.bottom);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    CGFloat itemWidth = (collectionViewWidth - self.sectionInset.left - self.sectionInset.right - (self.columnCount - 1) * self.columnSpacing) / self.columnCount;
    CGFloat itemHeight = 0;
    if ([self.delegate respondsToSelector:@selector(YYWaterFallLayout:itemHeight:atIndexPath:)] && self.delegate)
    {
    itemHeight = [self.delegate YYWaterFallLayout:self itemHeight:itemWidth atIndexPath:indexPath];
    }
    //找出最短的那一列
    NSLog(@"indexpath.row：%ld",(long)indexPath.row);
    __block NSNumber *minIndex = @0;
    [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSNumber *obj, BOOL *stop) {
        NSLog(@"数字1： %f，数字2: %f",[self.maxYDic[minIndex] floatValue],obj.floatValue);
        NSLog(@"ninindex： %@，key: %@",minIndex,key);
        if ([self.maxYDic[minIndex] floatValue] > obj.floatValue) {
            minIndex = key;
        }
    }];
    CGFloat itemX = self.sectionInset.left + (self.columnSpacing + itemWidth) * minIndex.integerValue;
    //item的y值 = 最短列的最大y值 + 行间距
    CGFloat itemY = [self.maxYDic[minIndex] floatValue] + self.rowSpacing;
    
    //设置attributes的frame
    attributes.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    
    //更新字典中的最大y值
    self.maxYDic[minIndex] = @(CGRectGetMaxY(attributes.frame));
    
    return attributes;

}

//返回ritem的attributes
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributesArray;
}


@end
