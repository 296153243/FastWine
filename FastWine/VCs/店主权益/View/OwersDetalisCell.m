//
//  OwersDetalisCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/6/15.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "OwersDetalisCell.h"
#import "CommissionVC.h"
#import "WithdrawalVC.h"

@implementation OwersDetalisCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDataRsp:(GetWalletModel *)dataRsp{
    _dataRsp = dataRsp;
    if (_dataRsp) {
        self.ibleijishouyi.text = [NSString stringWithFormat:@"¥%@",_dataRsp.allnumber];
        self.ibYitixian.text = [NSString stringWithFormat:@"¥%@",_dataRsp.extractNumber];
        self.ibWeidaozhang.text = [NSString stringWithFormat:@"¥%@",_dataRsp.number];
        
        self.ibJInrishouyi.text = [NSString stringWithFormat:@"今日:  +%@元",_dataRsp.todayAllNumber];
        self.jinriyitixian.text = [NSString stringWithFormat:@"今日:  +%@元",_dataRsp.todayExtractNumber];
       self.ibJinriweidaozhang.text = [NSString stringWithFormat:@"今日:  +%@元",_dataRsp.todayNumber];
        self.ibKetixianyueLab.text = [NSString stringWithFormat:@"%@元",ACCOUNTINFO.userInfo.now_money];
        
        self.ibYueLab.text = [NSString stringWithFormat:@"%.2f元",[ACCOUNTINFO.userInfo.now_money doubleValue] + [_dataRsp.number doubleValue]];

    }
}
- (IBAction)ibXinagqingAction:(id)sender {
    //佣金明细
    CommissionVC *vc = [[CommissionVC alloc]initWithNibName:@"CommissionVC" bundle:nil];
    vc.walletRsp = self.dataRsp;
    [self.controller.navigationController pushViewController:vc animated:YES];
}
- (IBAction)ibTixianAction:(id)sender {
    WithdrawalVC *vc =[[WithdrawalVC alloc]initWithNibName:@"WithdrawalVC" bundle:nil];
    [self.controller.navigationController pushViewController:vc animated:YES];
}

@end
