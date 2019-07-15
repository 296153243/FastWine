//
//  OwersCustomerCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/6/15.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "OwersCustomerCell.h"
#import "MyPromotionVC.h"
@implementation OwersCustomerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDataRsp:(GetWalletModel *)dataRsp{
    _dataRsp = dataRsp;
    if (_dataRsp) {

        self.ibWodejiamengshang.text = [NSString stringWithFormat:@"%@ 位",_dataRsp.directNum];
        self.ibWodeyaoqingren.text = [NSString stringWithFormat:@"%@ ",_dataRsp.userInfo.spread_name?self.dataRsp.userInfo.spread_name:@"无"];
        self.wodefensi.text = [NSString stringWithFormat:@"%@ 位 ",_dataRsp.teamNum];
        
    }
}
- (IBAction)ibXinagqingActionnn:(id)sender {
    MyPromotionVC *vc = [[MyPromotionVC alloc]initWithNibName:@"MyPromotionVC" bundle:nil];
    [self.controller.navigationController pushViewController:vc animated:YES];
  
}
@end
