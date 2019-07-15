//
//  OrderDetailsCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/3/26.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "OrderDetailsCell.h"

@implementation OrderDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setViewModel:(OrderListModel *)viewModel{
    _viewModel = viewModel;
    if (_viewModel) {
        self.orderStatusLab.text = _viewModel.s_status.title;
        self.orderStatusTitleLab.text = _viewModel.s_status.msg;
        self.ibNameLab.text = viewModel.real_name;
        self.ibPhoneLab.text = viewModel.user_phone;
        self.ibAddressLab.text = viewModel.user_address;
    
        self.ibGoodsAllPic.text = [NSString stringWithFormat:@"¥%@",viewModel.total_price];;
        self.ibPayFee.text = [NSString stringWithFormat:@"¥%@",viewModel.pay_price];
        self.ibYunfei.text = [NSString stringWithFormat:@"¥%@",viewModel.total_postage];
        
        self.ibOrderNumber.text = viewModel.order_id;
         self.ibZhifuFangshi.text = viewModel.s_status.payType;
        self.ibZhifushijian.text = [NSString returndate:viewModel.pay_time];
        self.ibZhifuzhuangtai.text = viewModel.s_status.title;
        
        PlaceOrderModel *model = _viewModel.cartInfos[0];
        self.ibOrderTime.text = [NSString returndate:model.add_time];
        
        if ([_viewModel.status integerValue] == 3) {
            _ibPingjiaBtn.hidden  = NO;
        }else{
            _ibPingjiaBtn.hidden  = YES;
            
        }
        
//        self.ibOrderTime.text = viewModel.create_time;
//        self.ibPayTime.text = viewModel.pay_time;
//        self.ibWuliu.text = viewModel.express_name;
//        self.ibWuliuNumber.text = viewModel.express_no;

    }
}
-(void)setGoodsModel:(PlaceOrderModel *)goodsModel{
    _goodsModel = goodsModel;
    if (_goodsModel) {
        self.ibGoodsName.text = _goodsModel.productInfo.store_name;
        self.ibGoodsNum.text = [NSString stringWithFormat:@"× %ld",_goodsModel.cart_num];
        self.ibGoodsPic.text = _goodsModel.truePrice;
        //    self.ibBuyTime.text = viewModel.create_time;
        [self.ibGoodsImg sd_setImageWithURL:[NSURL URLWithString:_goodsModel.productInfo.image]];
      

    }
}
- (IBAction)cancel:(id)sender {
    
    if (_CancelClick) {
        _CancelClick();
    }
}
- (IBAction)pay:(id)sender {
    if (_PayClick) {
        _PayClick();
    }
}
- (IBAction)ibPingjia:(id)sender {
    if (_EvaluationClick) {
        _EvaluationClick(_goodsModel);
    }
}

@end
