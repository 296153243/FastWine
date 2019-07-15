//
//  GoodsImgCollectionCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/5/30.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "GoodsImgCollectionCell.h"

@implementation GoodsImgCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    if (_imageUrl) {
        [_ibImgView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:[UIImage imageNamed:@"goods_noImage"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
        }];
    }
}
@end
