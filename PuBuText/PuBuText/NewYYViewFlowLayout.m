//
//  NewYYViewFlowLayout.m
//  PuBuText
//
//  Created by 余晔 on 2017/4/19.
//  Copyright © 2017年 余晔. All rights reserved.
//

#import "NewYYViewFlowLayout.h"

#define COLUMNCOUNT 3

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

#define INTERITEMSPACING 10.0f

#define LINESPACING 10.0f

#define ITEMWIDTH (SCREENWIDTH - (COLUMNCOUNT - 1)*INTERITEMSPACING) / 3


@interface NewYYViewFlowLayout ()
@property (nonatomic, strong) NSMutableDictionary * attributes;

@property (nonatomic, strong) NSMutableArray * colArray;
@end

@implementation NewYYViewFlowLayout



- (void)prepareLayout
{
    [super prepareLayout];
    //初始化行间距
   self.minimumLineSpacing = LINESPACING;
    self.minimumInteritemSpacing = INTERITEMSPACING;
    
    //初始化存储容器
    _attributes = [NSMutableDictionary dictionary];
    _colArray = [NSMutableArray arrayWithCapacity:COLUMNCOUNT];
    for(int i = 0;i<COLUMNCOUNT;i++)
    {
        [_colArray addObject:@(.0f)];
    }
    
    //遍历所有的item获取位置信息并进行存储
    NSUInteger sectioncount = [self.collectionView numberOfSections];
    for(int section = 0; section < sectioncount; section++)
    {
        NSUInteger itemcount = [self.collectionView numberOfItemsInSection:section];
        for(int item = 0;item < itemcount; item++)
        {
            [self layoutItemFrameAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
        }
    }
}

//用来设置每一个item的尺寸，然后和indexPath存储起来
- (void)layoutItemFrameAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = CGSizeMake(ITEMWIDTH, 100+arc4random()%101);
    //获取当前三列高度中高度最低的一列
    NSUInteger smallestcol = 0;
    NSUInteger shortHeight = 0;
    CGFloat lessheight = [_colArray[smallestcol] doubleValue];
    for(int col = 1;col<_colArray.count;col++)
    {
        if(lessheight < [_colArray[col] doubleValue]){
            shortHeight = [_colArray[col] doubleValue];
            smallestcol = col;
        }
    }
     //在当前高度最低的列上面追加item并且存储位置信息
    UIEdgeInsets insets = self.collectionView.contentInset;
    CGFloat x = insets.left + smallestcol * (INTERITEMSPACING * ITEMWIDTH);
    CGRect frame = {x,insets.top + shortHeight,itemSize};
    [_attributes setValue: indexPath forKey: NSStringFromCGRect(frame)];
    [_colArray replaceObjectAtIndex:smallestcol withObject:@(CGRectGetMaxY(frame))];
}

//返回所有当前在可视范围内的item的布局属性

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    //获取当前所有可视item的indexpath。通过调用父类获取的布局属性数组会缺失一部分可视item的布局属性
    NSMutableArray *indexpaths = [NSMutableArray array];
    for (NSString *rectstr in _attributes)
    {
        CGRect cellrect = CGRectFromString(rectstr);
        if(CGRectIntersectsRect(cellrect, rect))
        {
            NSIndexPath *indexpath = _attributes[rectstr];
            [indexpaths addObject:indexpath];
        }
    }
    
    //获取当前要显示的所有item的布局属性并返回
    NSMutableArray *layoutattributes = [NSMutableArray arrayWithCapacity:indexpaths.count];
    [indexpaths enumerateObjectsUsingBlock:^(NSIndexPath *indexpath, NSUInteger idx, BOOL * _Nonnull stop) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexpath];
        [layoutattributes addObject:attributes];
    }];
    
    return layoutattributes;
}

//返回对应indexpath的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    CGFloat itemWidth = (collectionViewWidth - (COLUMNCOUNT - 1) * 10) / COLUMNCOUNT;
    CGFloat itemX =  (10 + itemWidth) * indexPath.row;

    for (NSString *frame in _attributes) {
        if(_attributes[frame] == indexPath)
        {
            attributes.frame = CGRectFromString(frame);
            CGRect frames = attributes.frame;
            frames.origin.x = itemX;
            attributes.frame = frames;
            break;
        }
    }
    return attributes;
}

//设置collectionview的可滚动范围(瀑布流必要实现)

- (CGSize)collectionViewContentSize
{
    __block CGFloat maxheight = [_colArray[0] floatValue];
    [_colArray enumerateObjectsUsingBlock:^(NSNumber *height, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if([height floatValue]>maxheight)
        {
            maxheight = [height floatValue];
        }
    }];
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), maxheight + self.collectionView.contentInset.bottom);
}

//在collecview的bounds发生变化的时候刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
   return !CGRectEqualToRect(self.collectionView.bounds, newBounds);
}

@end
