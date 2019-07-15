//
//  OBDCollectionCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/3/12.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "OBDCollectionCell.h"
@interface OBDCollectionCell()
@property (weak, nonatomic) IBOutlet UIView *ibBGView;
@property (weak, nonatomic) IBOutlet UIImageView *ibgoodsImg;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodName;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodsPic;
@property (weak, nonatomic) IBOutlet UIView *ibBgView;
@property (weak, nonatomic) IBOutlet UILabel *ibBaoyouLab;

@property (weak, nonatomic) IBOutlet UILabel *ibYueShouLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibgoodsImgH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibgoodsImgW;

@end
@implementation OBDCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [_ibBgView showViewShadowColorMasksToBounds];
    [_ibBGView showViewShadowColor];
    _ibBgView.clipsToBounds = YES;
    _ibBgView.layer.cornerRadius = 4;

}
-(void)setViewModel:(MainGoodsModel *)viewModel{
    _viewModel = viewModel;
    _ibBgView.clipsToBounds = YES;
    if (_viewModel) {
        self.ibGoodName.text = _viewModel.store_name;
        self.ibGoodsPic.text = [NSString stringWithFormat:@"¥%@",_viewModel.price];
        if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1) {
            self.ibGoodsPic.text = [NSString stringWithFormat:@"¥%@",_viewModel.vip_price];
            
            if (ACCOUNTINFO.userInfo.agent_id > 0) {
                //如果是代理都展示price
                self.ibGoodsPic.text = [NSString stringWithFormat:@"¥%@",_viewModel.price];
            }
        }
        self.ibBaoyouLab.text = _viewModel.keyword;
        [self.ibgoodsImg sd_setImageWithURL:[NSURL URLWithString:viewModel.image]placeholderImage:[UIImage imageNamed:@"goods_noImage"]];
        [self.ibgoodsImg sd_setImageWithURL:[NSURL URLWithString:viewModel.image] placeholderImage:[UIImage imageNamed:@"goods_noImage"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (!error && image.size.width >0) {
                CGFloat imageScale = image.size.height/image.size.width;
                CGFloat newImageWidth = image.size.width;
                CGFloat newImageHeight = imageScale * newImageWidth;
//            NSLog(@"newImageWidth:%f----newImageHeight:%f---imageScale:%f",newImageWidth,newImageHeight,imageScale);
                self.ibgoodsImgW.constant = newImageWidth;
                self.ibgoodsImgH.constant = newImageHeight;
                
            }
        }];
        
    }
}
@end
