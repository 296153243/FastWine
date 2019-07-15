//
//  PlaceOrderCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/3/29.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "PlaceOrderCell.h"

@implementation PlaceOrderCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _markPayTypeBtn = _ibWeixinPayTypeBtn;
}
- (void)setAddressModel:(EPAddressModel *)addressModel{
    _addressModel = addressModel;
    if (_addressModel) {
        self.ibAddressname.text = _addressModel.real_name;
        self.ibAddressPhone.text = _addressModel.phone;
        self.ibAddress.text = [NSString stringWithFormat:@"%@%@%@%@",_addressModel.province,_addressModel.city,_addressModel.district,_addressModel.detail];
    }
}
-(void)setGoodsModel:(PlaceOrderModel *)goodsModel{
    _goodsModel = goodsModel;
    if (_goodsModel) {
        
        self.ibGoodsName.text = _goodsModel.productInfo.store_name;
        [self.ibGoodsImg sd_setImageWithURL:[NSURL URLWithString:_goodsModel.productInfo.image]];
        self.ibGoodsPic.text = [NSString stringWithFormat:@"¥%@",_goodsModel.productInfo.attrInfo.vip_price];
        //有shu
        if (_goodsModel.productInfo.attrInfo) {
            if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1) {
                self.ibGoodsPic.text = [NSString stringWithFormat:@"¥%@",_goodsModel.productInfo.attrInfo.vip_price];
            }else{
                self.ibGoodsPic.text = [NSString stringWithFormat:@"¥%@",_goodsModel.productInfo.attrInfo.price];
            }
        }else{
            if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1) {
                self.ibGoodsPic.text = [NSString stringWithFormat:@"¥%@",_goodsModel.productInfo.vip_price];
            }else{
                self.ibGoodsPic.text = [NSString stringWithFormat:@"¥%@",_goodsModel.productInfo.price];
            }
        }
        self.ibGoodsStr.text = _goodsModel.productInfo.attrInfo.suk;
   
        self.ibGoodsNum.text = [NSString stringWithFormat:@"× %ld",_goodsModel.cart_num];
//        self.ibExpressWay.
        
        
    }
}

//TODO:-----支付方式点击BtnClick
- (IBAction)ibPayTypeBtnClick:(UIButton *)sender {
//    if (sender.tag == 3) {
//        if ([_walletRsp.data.allMoney floatValue] <= [self.detailFirstRsp.data.orderfee floatValue]) {
//            [QuHudHelper qu_showMessage:@"余额不足~"];
//            return;
//        }
//    }
    if (_markPayTypeBtn != sender) {
        sender.selected = YES;
        _markPayTypeBtn.selected = NO;
        _markPayTypeBtn = sender;
    }
    NSInteger payType = sender.tag;

    if (_payTypeBtnClick) {
        _payTypeBtnClick(payType);
    }
    NSLog(@"_=========payType:%ld",payType);
    
}
- (IBAction)ibAddBtn:(id)sender {
}
@end
