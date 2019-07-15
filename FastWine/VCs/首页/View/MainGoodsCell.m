//
//  MainGoodsCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/6/13.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "MainGoodsCell.h"
@interface MainGoodsCell()
@property (weak, nonatomic) IBOutlet UIView *ibBGView;
@property (weak, nonatomic) IBOutlet UIImageView *ibgoodsImg;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodName;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodsPic;
@property (weak, nonatomic) IBOutlet UIView *ibBgView;
@property (weak, nonatomic) IBOutlet UILabel *ibBaoyouLab;

@property (weak, nonatomic) IBOutlet UILabel *ibYueShouLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibgoodsImgH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibgoodsImgW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibXiaoliangLabW;
@property (weak, nonatomic) IBOutlet UILabel *ibBaifenLab;
@property (weak, nonatomic) IBOutlet UILabel *ibYiqianggouLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iblabW;
@property (weak, nonatomic) IBOutlet UIView *ibXiaoliangBgV;

@end
@implementation MainGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setViewModel:(MainGoodsModel *)viewModel{
    _viewModel = viewModel;
    _ibBgView.clipsToBounds = YES;
    if (_viewModel) {
        self.ibGoodName.text = _viewModel.store_name;
        self.ibGoodsPic.text = [NSString stringWithFormat:@"%@",_viewModel.price];
        if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1) {
            self.ibGoodsPic.text = [NSString stringWithFormat:@"%@",_viewModel.vip_price];
        }
  
//        NSString *sss = @"200";
        float baifen;
        float xiaoliang ;
        xiaoliang = [_viewModel.ficti floatValue] +  [_viewModel.sales floatValue];
        baifen = ([_viewModel.ficti floatValue] +  [_viewModel.sales floatValue]) /[_viewModel.stock floatValue];
        self.ibBaifenLab.text = [NSString stringWithFormat:@"%.0f%%",baifen * 100];
        self.ibYiqianggouLab.text = [NSString stringWithFormat:@"  已抢购:%.0f",xiaoliang];
//        [self changeMultiplierOfConstraint:_iblabW multiplier:baifen];
        self.ibXiaoliangLabW.constant = _ibXiaoliangBgV.qu_size.width  * baifen;
//        NSLog(@"%.2f-----%.2f-----%.0f",[_viewModel.sales floatValue],[_viewModel.stock floatValue], baifen * 100);
        self.ibBaoyouLab.text = _viewModel.keyword;
        [self.ibgoodsImg sd_setImageWithURL:[NSURL URLWithString:viewModel.image]placeholderImage:[UIImage imageNamed:@"goods_noImage"]];
        [self.ibgoodsImg sd_setImageWithURL:[NSURL URLWithString:viewModel.transverse_image] placeholderImage:[UIImage imageNamed:@"goods_noImage"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (!error && image.size.width >0) {
                CGFloat imageScale = image.size.height/image.size.width;
                CGFloat newImageWidth = image.size.width;
                CGFloat newImageHeight = imageScale * newImageWidth;
//            NSLog(@"newImageWidth:%f----newImageHeight:%f---imageScale:%f",newImageWidth,newImageHeight,imageScale);
//                self.ibgoodsImgH.constant = newImageHeight;
                CGSize size=image.size;
                float proportion = SCREEN_WIDTH/size.width;//根据屏幕大小算出比例
//                self.ibgoodsImgH.constant = image.size.width*proportion;
                self.ibgoodsImgW.constant = image.size.width * proportion;
                self.ibgoodsImgH.constant = 175;
//          NSLog(@"proportion:%f----image.size.width * proportion:%f---imageScale:%f",proportion,image.size.width * proportion,imageScale);
                
            }
        }];
        
    }
}
- (void)changeMultiplierOfConstraint:(NSLayoutConstraint *)constraint multiplier:(CGFloat)multiplier {
    
    [NSLayoutConstraint deactivateConstraints:[NSArray arrayWithObjects:constraint, nil]];
    
    NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:constraint.firstItem attribute:constraint.firstAttribute relatedBy:constraint.relation toItem:constraint.secondItem attribute:constraint.secondAttribute multiplier:multiplier constant:constraint.constant];
    [newConstraint setPriority:constraint.priority];
    newConstraint.shouldBeArchived = constraint.shouldBeArchived;
    newConstraint.identifier = constraint.identifier;
    newConstraint.active = true;
    
    [NSLayoutConstraint activateConstraints:[NSArray arrayWithObjects:newConstraint, nil]];
    //NSLayoutConstraint.activateConstraints([newConstraint])
}
- (IBAction)ibBuyAction:(id)sender {
    if (_buyBtnCickBlock) {
        _buyBtnCickBlock(_viewModel);
    }
}
@end
