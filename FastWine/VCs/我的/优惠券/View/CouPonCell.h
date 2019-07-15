//
//  CouPonCell.h
//  CLTravel
//
//  Created by MOOSON_ on 2018/11/2.
//  Copyright © 2018年 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CouPonCell : UITableViewCell
@property(nonatomic,strong)CouponListModel *viewModel;
@property(nonatomic,strong)CouponListModel *couponModel;//可用

@property (weak, nonatomic) IBOutlet UIImageView *ibConponbgImg;
@property (weak, nonatomic) IBOutlet UILabel *ibPicLab;
@property (weak, nonatomic) IBOutlet UILabel *ibMenkanLab;
@property (weak, nonatomic) IBOutlet UILabel *ibEndTimeLab;
@property (weak, nonatomic) IBOutlet UIButton *ibStatusLab;

@property (weak, nonatomic) IBOutlet UIButton *ibChooseCouponBtn;
@property (weak, nonatomic) IBOutlet UILabel *ibPic;
@property (weak, nonatomic) IBOutlet UILabel *ibMenkan;
@property (weak, nonatomic) IBOutlet UILabel *ibEndTime;
@end

NS_ASSUME_NONNULL_END
