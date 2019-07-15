//
//  CouPonCell.m
//  CLTravel
//
//  Created by MOOSON_ on 2018/11/2.
//  Copyright © 2018年 MOOSON_. All rights reserved.
//

#import "CouPonCell.h"

@implementation CouPonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //
//    [_ibPicLab setGradientLabelColors:@[(__bridge id)[UIColor colorWithRed:252/255.0 green:183/255.0 blue:79/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:252/255.0 green:183/255.0 blue:79/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:240/255.0 green:97/255.0 blue:44/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:150/255.0 blue:56/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:174/255.0 blue:64/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:184/255.0 blue:77/255.0 alpha:1].CGColor]];
//    _ibPicLab.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"currentPage"]];

  
}
-(void)setViewModel:(CouponListModel *)viewModel{
    _viewModel =viewModel;
    if (_viewModel) {

        self.ibPicLab.text = [NSString stringWithFormat:@"¥%@",_viewModel.coupon_price];
        self.ibMenkanLab.text = [NSString stringWithFormat:@"满%@元可用",_viewModel.use_min_price];
        self.ibEndTimeLab.text = [NSString returndate:_viewModel.end_time];
        [self.ibStatusLab setTitle:_viewModel.n_msg forState: UIControlStateNormal];
        //    0：未使用，1：已使用, 2:已过期）
        if (_viewModel.status == 0) {
            self.ibConponbgImg.image = [UIImage imageNamed:@"coupon_bg_red"];
        }else if (_viewModel.status == 1){
            self.ibConponbgImg.image = [UIImage imageNamed:@"coupon_bg_pink"];
        }else if (_viewModel.status == 2){
            self.ibConponbgImg.image = [UIImage imageNamed:@"coupon_bg_gray"];
            
        }
    }
}
-(void)setCouponModel:(CouponListModel *)couponModel{
    _couponModel =couponModel;
    if (_couponModel) {
        self.ibPic.text = [NSString stringWithFormat:@"¥%@",_viewModel.coupon_price];
        self.ibMenkan.text = [NSString stringWithFormat:@"满%@元可用",_viewModel.use_min_price];
        self.ibEndTime.text = [NSString returndate:_viewModel.end_time];
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)ibChooseBtn:(id)sender {
}
- (IBAction)ibStatusLab:(id)sender {
}
@end
