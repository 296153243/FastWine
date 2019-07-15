//
//  OwnersTitleCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/6/15.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "OwnersTitleCell.h"

@implementation OwnersTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setViewModel:(GetWalletModel *)viewModel{
    _viewModel = viewModel;
    if (_viewModel) {

        if ([viewModel.agent.agent_id integerValue] == 1) {
            self.ibDialiTitleLab.text = @"中级级代理权益：";
            self.ibDailiContent.text = viewModel.introduce;
            self.ibSubTitleLab.text = @"购买以下任意商品即可升级成为中级代理";
        }else if ([viewModel.agent.agent_id integerValue] == 2){
            self.ibDialiTitleLab.text = @"高级级级代理权益：";
            self.ibDailiContent.text = viewModel.introduce;
            self.ibSubTitleLab.text = @"购买以下任意商品即可升级成为高级代理";
        }else if ([viewModel.agent.agent_id integerValue] == 3){
            
        }
        
    }
}
@end
