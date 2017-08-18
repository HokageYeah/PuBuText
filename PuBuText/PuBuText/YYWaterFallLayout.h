//
//  YYWaterFallLayout.h
//  PuBuText
//
//  Created by 余晔 on 2017/4/18.
//  Copyright © 2017年 余晔. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YYWaterFallLayoutDatasource;

@interface YYWaterFallLayout : UICollectionViewLayout

@property (nonatomic, weak) id<YYWaterFallLayoutDatasource> delegate;



//列间距
@property (nonatomic,assign) NSInteger columnSpacing;
//行间距
@property (nonatomic, assign) NSInteger rowSpacing;
//四个边角间距设置
@property (nonatomic, assign) UIEdgeInsets sectionInset;

//同时设置列间距，行间距，sectionInset
- (void)setColumnSpacing:(NSInteger)columnSpacing rowSpacing:(NSInteger)rowSepacing sectionInset:(UIEdgeInsets)sectionInset;

+ (instancetype)waterFallLayoutWithColumnCount:(NSInteger)columnCount;
- (instancetype)initWithColumnCount:(NSInteger)columnCount;



@end


@protocol YYWaterFallLayoutDatasource <NSObject>

@required
//高度的计算
- (CGFloat)YYWaterFallLayout:(YYWaterFallLayout *)yyLayout itemHeight:(CGFloat)itemHeight atIndexPath:(NSIndexPath *)indexPath;

@end
