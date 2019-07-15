//
//  PersonOrderCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/6/10.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "PersonOrderCell.h"
#import "MyOrderVC.h"
@implementation PersonOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setAccountinfo:(AccountInfo *)accountinfo{
    _accountinfo = accountinfo;
    if (_accountinfo) {
      
        if ([ACCOUNTINFO.orderStatusNum.noBuy integerValue] > 0) {
            
            self.ibDaifuNumLab.hidden = NO;
            self.ibDaifuNumLab.text = ACCOUNTINFO.orderStatusNum.noBuy;
            
        }
        if ([ACCOUNTINFO.orderStatusNum.noPostage integerValue] > 0) {
            self.ibDaifaNumLab.hidden = NO;
            self.ibDaifaNumLab.text = ACCOUNTINFO.orderStatusNum.noPostage;
            
        }
        if ([ACCOUNTINFO.orderStatusNum.noTake integerValue] > 0) {
            self.ibDaishouNumLab.hidden = NO;
            self.ibDaishouNumLab.text = ACCOUNTINFO.orderStatusNum.noTake;
            
        }
        if ([ACCOUNTINFO.orderStatusNum.noReply integerValue] > 0) {
            self.ibDaipingLab.hidden = NO;
            self.ibDaipingLab.text = ACCOUNTINFO.orderStatusNum.noReply;
            
        }

    }
}
- (IBAction)ibOrderBtnClick:(UIButton *)sender {
    if (![Save isLogin]) {
        [self.controller presentLoginWithComplection:^{
        }];
        return;
    }
    MyOrderVC *vc = [[MyOrderVC alloc]initWithNibName:@"MyOrderVC" bundle:nil];
    vc.selectOrderIdx = sender.tag;
    [self.controller.navigationController pushViewController:vc animated:NO];
}
- (IBAction)ibAllOrder:(id)sender {
    if (![Save isLogin]) {
        [self.controller presentLoginWithComplection:^{
        }];
        return;
    }
    MyOrderVC *vc = [[MyOrderVC alloc]initWithNibName:@"MyOrderVC" bundle:nil];
    [self.controller.navigationController pushViewController:vc animated:NO];
}

@end
