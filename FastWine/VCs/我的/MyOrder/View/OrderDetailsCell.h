//
//  OrderDetailsCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/3/26.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailsCell : UITableViewCell
@property(nonatomic,strong)OrderListModel *viewModel;
@property(nonatomic,strong)PlaceOrderModel *goodsModel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLab;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusTitleLab;

@property (weak, nonatomic) IBOutlet UILabel *ibNameLab;
@property (weak, nonatomic) IBOutlet UILabel *ibPhoneLab;
@property (weak, nonatomic) IBOutlet UILabel *ibAddressLab;

@property (weak, nonatomic) IBOutlet UIImageView *ibGoodsImg;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodsName;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodsPic;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodsNum;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodsAllPic;
@property (weak, nonatomic) IBOutlet UILabel *ibPayFee;
@property (weak, nonatomic) IBOutlet UILabel *ibYunfei;

@property (weak, nonatomic) IBOutlet UILabel *ibOrderNumber;
@property (weak, nonatomic) IBOutlet UILabel *ibOrderTime;
@property (weak, nonatomic) IBOutlet UILabel *ibPayTime;
@property (weak, nonatomic) IBOutlet UILabel *ibZhifuFangshi;
@property (weak, nonatomic) IBOutlet UILabel *ibZhifuzhuangtai;
@property (weak, nonatomic) IBOutlet UILabel *ibZhifushijian;
@property (weak, nonatomic) IBOutlet UIButton *ibPingjiaBtn;
@property (weak, nonatomic) IBOutlet UIButton *ibKefuBtn;
@property(nonatomic,copy)void(^PayClick)(void);
@property(nonatomic,copy)void(^CancelClick)(void);
@property(nonatomic,strong)void(^EvaluationClick)(PlaceOrderModel *goodsModel);
@end

NS_ASSUME_NONNULL_END
