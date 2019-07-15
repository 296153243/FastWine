//
//  PlaceOrderCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/3/29.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPAddressModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PlaceOrderCell : UITableViewCell
@property(nonatomic,strong)EPAddressModel *addressModel;
@property(nonatomic,strong)PlaceOrderModel *goodsModel;
@property (weak, nonatomic) IBOutlet UILabel *ibAddressname;
@property (weak, nonatomic) IBOutlet UILabel *ibAddressPhone;
@property (weak, nonatomic) IBOutlet UILabel *ibAddress;

@property (weak, nonatomic) IBOutlet UIImageView *ibGoodsImg;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodsName;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodsPic;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodsNum;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodsStr;

@property (weak, nonatomic) IBOutlet UILabel *ibExpressWay;
@property (weak, nonatomic) IBOutlet UITextField *ibTextTf;
@property (weak, nonatomic) IBOutlet UILabel *ibAllNum;
@property (weak, nonatomic) IBOutlet UIButton *ibWeixinPayTypeBtn;
@property (weak, nonatomic) IBOutlet UILabel *ibGongLab;
@property(strong,nonatomic) UIButton *markPayTypeBtn;//记录支付方式
@property(nonatomic,copy)void(^payTypeBtnClick)(NSInteger payType);
@property (weak, nonatomic) IBOutlet UIButton *ibAddBtn;

@property (weak, nonatomic) IBOutlet UILabel *ibkeyongYouhuiquanLab;
@property (weak, nonatomic) IBOutlet UILabel *ibKeYongXianjinLab;
@property (weak, nonatomic) IBOutlet UIButton *ibYueBtn;
@property (weak, nonatomic) IBOutlet UILabel *ibYuanbaoNumLab;

@end

NS_ASSUME_NONNULL_END
