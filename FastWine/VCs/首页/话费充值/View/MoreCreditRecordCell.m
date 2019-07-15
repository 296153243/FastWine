//
//  MoreCreditRecordCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/4/19.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "MoreCreditRecordCell.h"

@implementation MoreCreditRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setViewModel:(PhoneOrderListModel *)viewModel{
    _viewModel = viewModel;
    if (_viewModel) {
        self.ibTitleLab.text = @"手机充值";
        self.ibPhoneLab.text = [NSString stringWithFormat:@"号码:%@",_viewModel.telephone];
        
        self.ibTimeLab.text = [NSString timeFormatted:_viewModel.create_time];
        self.ibPicLab.text = [NSString stringWithFormat:@"+ %@",_viewModel.telephone_money];

    }
}

@end
