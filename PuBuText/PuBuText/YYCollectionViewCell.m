//
//  YYCollectionViewCell.m
//  PuBuText
//
//  Created by 余晔 on 2017/4/18.
//  Copyright © 2017年 余晔. All rights reserved.
//

#import "YYCollectionViewCell.h"
#import <UIImageView+WebCache.h>

@interface YYCollectionViewCell ()
@property (nonatomic,strong) UIImageView *imageURL;

@end

@implementation YYCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        _imageURL = [[UIImageView alloc] init];
        [_imageURL setContentMode:UIViewContentModeScaleAspectFill];
        _imageURL.translatesAutoresizingMaskIntoConstraints = NO;
        _imageURL.contentMode = UIViewContentModeScaleToFill;
//        _imageURL.layer.cornerRadius = 48/2;
//        _imageURL.clipsToBounds = YES;
        _imageURL.userInteractionEnabled = YES;
        [self.contentView addSubview:self.imageURL];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageURL]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageURL)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageURL]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageURL)]];
    }
    
    return self;
}

-(void)reloadData:(NSString *)rowInfo
{
    NSLog(@"%@",rowInfo);
    [self.imageURL sd_setImageWithURL:[NSURL URLWithString:rowInfo] placeholderImage:[UIImage imageNamed:@"placeholder"]];

}


@end
