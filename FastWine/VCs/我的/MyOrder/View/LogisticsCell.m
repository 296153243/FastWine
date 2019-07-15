//
//  LogisticsCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/4/4.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "LogisticsCell.h"

@implementation LogisticsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setViewModel:(ExpressInfoModel *)viewModel{
    _viewModel = viewModel;
    if (_viewModel) {
        self.ibTime.text = _viewModel.time;
        self.ibContent.text = _viewModel.context;
    }
}
- (void)setGoodsModel:(OrderListModel *)goodsModel{
    _goodsModel = goodsModel;
    if (_goodsModel) {
        [self.ibGoodsImg sd_setImageWithURL:[NSURL URLWithString:_goodsModel.goods_img]];
        self.ibgoodsNum.text = [NSString stringWithFormat:@"共%@个商品",_goodsModel.total_num];
        self.ibOrderNumber.text = [NSString stringWithFormat:@"订单编号:%@",_goodsModel.order_id];
    }
}
@end
