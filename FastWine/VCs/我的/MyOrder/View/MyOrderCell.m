//
//  MyOrderCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/3/20.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "MyOrderCell.h"

@implementation MyOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setViewModel:(OrderListModel *)viewModel{
    _viewModel = viewModel;
    if (_viewModel) {
        self.ibOrderNumberLab.text = [NSString stringWithFormat:@"订单号:%@",viewModel.order_id];
        self.ibOrderStatusLab.text = viewModel.s_status.title;

        //0 代付 1代发 2代收 3代评
        self.ibBootomView.hidden = YES;

        if ([viewModel.s_status.type integerValue] == 0 ) {
            self.ibBootomView.hidden = NO;
            self.ibLineLab.hidden = NO;
        [self.ibPayBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        }else if([viewModel.s_status.type integerValue] == 1){
            //代发
//            self.ibBootomView.hidden = YES;
//            self.ibLineLab.hidden = YES;
//            self.ibCnacelBtn.hidden = YES;
//            self.ibBootomView.hidden = NO;
//            self.ibLineLab.hidden = NO;
//            [self.ibPayBtn setTitle:@"立即评价" forState:UIControlStateNormal];
//            [self.ibCnacelBtn setTitle:@"查看物流" forState:UIControlStateNormal];
//            [self.ibPayBtn setTitle:@"确认收货" forState:UIControlStateNormal];

        }else if([viewModel.status integerValue] == 0 && viewModel.paid  == 1 && viewModel.refund_status == 0){
            //可以退款
            self.ibBootomView.hidden = NO;
            self.ibLineLab.hidden = NO;
            [self.ibPayBtn setTitle:@"退款" forState:UIControlStateNormal];
            
        }else if ([viewModel.s_status.type integerValue] == 2){
            //代收
//            self.ibPingJIaBtn.hidden = NO;
        }else if ([viewModel.s_status.type integerValue] == 3){
            //完成待评价
            self.ibPingJIaBtn.hidden = NO;
        }else{
      
            self.ibBootomView.hidden = YES;

        }
    }
    
   
}
-(void)setGoodsModel:(PlaceOrderModel *)goodsModel{
    _goodsModel = goodsModel;
    if (_goodsModel) {
      
        self.ibFootName.text = _goodsModel.productInfo.store_name;
        self.ibFootNum.text = [NSString stringWithFormat:@"× %ld",_goodsModel.cart_num];
        self.ibFootPic.text = _goodsModel.truePrice;
        //        self.ibBuyTime.text = viewModel.create_time;
        [self.IBGoodsImg sd_setImageWithURL:[NSURL URLWithString:_goodsModel.productInfo.image]];
    }
}
- (IBAction)ibCancel:(UIButton *)sender {
   
    if (self->_CancelClick) {
        self->_CancelClick(sender.titleLabel.text);
    }
  
}
- (IBAction)ibPay:(UIButton *)sender {
    if (_PayClick) {
        _PayClick(sender.titleLabel.text);
    }
}
- (IBAction)ibPingjia:(UIButton *)sender {
    if (_EvaluationClick) {
        _EvaluationClick(_goodsModel);
    }
}

@end
