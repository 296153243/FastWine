//
//  OwnersHeardCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/6/15.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "OwnersHeardCell.h"
#import "WithdrawalVC.h"
#import "QrCodeVC.h"
@implementation OwnersHeardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setAccountinfo:(AccountInfo *)accountinfo{
    _accountinfo = accountinfo;
    if (_accountinfo) {
        
        [self.ibUserIcon sd_setImageWithURL:[NSURL URLWithString:ACCOUNTINFO.userInfo.avatar] placeholderImage:[UIImage imageNamed:AvatarDefault]];
        self.ibUserName.text = ACCOUNTINFO.userInfo.nickname;
        
        if (ACCOUNTINFO.userInfo.agent_id == 0) {
            self.ibshenfen.text = @"普通用户";
            _ibMoneyView.hidden = YES;
            self.ibYaoqingma.text = @"";
          
        }else if (ACCOUNTINFO.userInfo.agent_id == 1){
            self.ibshenfen.text = @"普通代理";
            _ibMoneyView.hidden = NO;
            self.ibYaoqingma.text = [NSString stringWithFormat:@"邀请码:%@",ACCOUNTINFO.userInfo.uid];
            // self.ibDianzhuqunyiLab.text = @"代理权益";
         
        }else if (ACCOUNTINFO.userInfo.agent_id == 2){
            self.ibshenfen.text = @"钻石代理";
            self.ibYaoqingma.text = [NSString stringWithFormat:@"邀请码:%@",ACCOUNTINFO.userInfo.uid];

            _ibMoneyView.hidden = NO;

        }
        if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1) {
            
        }else{
            _ibCodeBtn.hidden = YES;
        }
//        self.ibYe.text = ACCOUNTINFO.userInfo.now_money;
//        NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"我的现金余额 %@",ACCOUNTINFO.userInfo.now_money]];
//        [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, attriStr.length - 6)];
//        [self.ibYe setAttributedText:attriStr];
        
    }
}

-(void)setDataModel:(GetWalletModel *)dataModel{
    _dataModel = dataModel;
    if (_dataModel) {
        if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1) {
            //            self.ibLeijihuode.text = [NSString stringWithFormat:@"开店以来已为你赚取%@元",_dataRsp.data.allnumber];
            
            self.ibYujihuodeLab.text = _dataModel.agent.promotion_text;
        }else{
            self.ibLeijihuode.text = @"";
        }
    }
}
- (IBAction)ibYonghuxieyi:(id)sender {
    BaseRequest *req = [BaseRequest new];
    req.id = @"16";//1:用户协议2:关于我们3:隐私政策  16 代理协议
    [[HTTPRequest sharedManager]requestDataWithApiName:article withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        BaseWKWebController *vc = [[BaseWKWebController alloc]init];
        vc.content = responseObject[@"data"][@"content"][@"content"];
        vc.titleStr = responseObject[@"data"][@"content"][@"title"];
        [self.controller.navigationController pushViewController:vc animated:YES];
    } withError:^(NSError *error) {
        
    }];
}
- (IBAction)ibCodeAction:(id)sender {
    QrCodeVC *vc = [[QrCodeVC alloc]initWithNibName:@"QrCodeVC" bundle:nil];
    [self.controller.navigationController pushViewController:vc animated:YES];
}

- (IBAction)ibQushengjiBtn:(id)sender {
}
@end
