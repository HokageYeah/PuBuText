//
//  ViewController.m
//  PuBuText
//
//  Created by 余晔 on 2017/4/18.
//  Copyright © 2017年 余晔. All rights reserved.
//

#import "ViewController.h"
#import "YYCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "YYWaterFallLayout.h"
#import "NewYYViewFlowLayout.h"

static NSString *identify = @"cell";

//屏幕的宽、高
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,YYWaterFallLayoutDatasource>
@property(nonatomic,retain)UICollectionView *collectionView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.dataArray = [NSMutableArray array];

    //1.创建布局对象
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    flowLayout.minimumInteritemSpacing = 0;
//    flowLayout.minimumLineSpacing = 40;

    //（1）itemSize ： 单元格的尺寸
//    flowLayout.itemSize = CGSizeMake(80, 80);
    //    //(2)headerReferenceSize 头视图的尺寸
//    flowLayout.headerReferenceSize = CGSizeMake(0, 30);
    //    //（3）minimumInteritemSpacing  水平方向单元格之间的最小间隙
    //    flowLayout.minimumInteritemSpacing = 80;
    //    //(4)minimumLineSpacing  垂直方向的单元格之间的最小间隙
    //    flowLayout.minimumLineSpacing = 40;
//    NewYYViewFlowLayout *waterfall = [[NewYYViewFlowLayout alloc] init];
    
    YYWaterFallLayout *waterfall = [[YYWaterFallLayout alloc] initWithColumnCount:3];
    [waterfall setColumnSpacing:10 rowSpacing:10 sectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    waterfall.delegate = self;

    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:waterfall];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    
    //注册单元格类型
    [_collectionView registerClass:[YYCollectionViewCell class] forCellWithReuseIdentifier:identify];
    [self reloadData];

}

- (void)reloadData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1.plist" ofType:nil];
    NSArray *imageDics = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *imageDic in imageDics)
    {
        NSString *imgstr = imageDic[@"img"];
        NSLog(@"%@",imageDic);
        UIImageView * imageView = [[UIImageView alloc] init];
        NSURL * url = [NSURL URLWithString:imgstr];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        BOOL existBool = [manager diskImageExistsForURL:url];//判断是否有缓存
        UIImage * image;
        if (existBool)
        {
            image = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
        }
        else
        {
            NSData *data = [NSData dataWithContentsOfURL:url];
            image = [UIImage imageWithData:data];
            if(!image){
                image = [UIImage imageNamed:@"placeholder"];
            }
        }
        float height = (image.size.height/image.size.width)*(kScreenWidth/2);
        if(height==0)
        {
            height = 90.0;
        }
        height = [imageDic[@"h"] floatValue];
        float wite = [imageDic[@"w"] floatValue];
        NSDictionary *dic = @{  @"img":imgstr,
                              @"height":@(height),
                              @"wite":@(wite)
                              };
        [self.dataArray addObject:dic];
        
        
        
       /*  第二种方法判断是否缓存了图片
        if([[SDImageCache sharedImageCache] diskImageExistsWithKey:imgstr])
            
        {
            
            UIImage* image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imgstr];
            
            if(!image)
                
            {
                
                NSData* data = [[SDImageCache sharedImageCache] performSelector:@selector(diskImageDataBySearchingAllPathsForKey:) withObject:imgstr];
                
                image = [UIImage imageWithData:data];
                
            }
            
            if(image)
                
            {
                
                NSLog(@"%f",image.size);
            }
            
        }
        */

        
        
        
        
        
    }
    NSLog(@"%@",self.dataArray);
    
    [_collectionView reloadData];
}

#pragma mark - UICollectionView delegate


//2.指定单元格的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
    
}

//3.获取单元格对象
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YYCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (cell==nil)
    {
        cell = [[YYCollectionViewCell alloc] init];
        
    }
    
    
    cell.backgroundColor = [UIColor purpleColor];
    NSString *rowInfo = [self.dataArray[indexPath.row] objectForKey:@"img"];
    cell.tag = indexPath.row;
    [cell reloadData:rowInfo];
    
    return cell;
}

- (CGFloat)YYWaterFallLayout:(YYWaterFallLayout *)yyLayout itemHeight:(CGFloat)itemHeight atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataArray[indexPath.item];
    CGFloat h = [dic[@"height"] floatValue];
    CGFloat w = [dic[@"wite"] floatValue];
    return h / w * itemHeight;
}


////5.组的头视图的创建
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    
//    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifyHeader forIndexPath:indexPath];
//    
//    headView.backgroundColor = [UIColor redColor];
//    
//    return headView;
//}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
