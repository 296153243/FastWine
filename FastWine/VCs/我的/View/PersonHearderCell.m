//
//  PersonHearderCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/6/10.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "PersonHearderCell.h"
#import "SettingVC.h"
#import "MessageVC.h"
#import "ChangeNicknameVC.h"
#import "CouPonVC.h"
#import "MyWalletVC.h"
#import "MycollectionVC.h"
#import "OwnersRightsVC.h"
@implementation PersonHearderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.ibUserIcon addGestureRecognizer:tapGesture];
}
-(void)setAccountinfo:(AccountInfo *)accountinfo{
    _accountinfo = accountinfo;
    if (_accountinfo) {
    
        [self.ibUserIcon sd_setImageWithURL:[NSURL URLWithString:ACCOUNTINFO.userInfo.avatar] placeholderImage:[UIImage imageNamed:AvatarDefault]];
        self.ibUserName.text = ACCOUNTINFO.userInfo.nickname;
        
        if (ACCOUNTINFO.userInfo.agent_id == 0) {
            self.ibUserRole.text = @"普通用户";
            [self.ibKaitongAction setTitle:@"立即开通" forState:UIControlStateNormal];
//            self.ibAddTimeLab.hidden = YES;
//            self.ibDianzhuqunyiLab.text = @"代理权益";
            self.ibYueValue.text = @"加入即享";
            self.ibYueLab.text = @"升级代理";
        }else if (ACCOUNTINFO.userInfo.agent_id == 1){
            self.ibUserRole.text = @"普通代理";
            self.ibYueValue.text = ACCOUNTINFO.userInfo.now_money;
            self.ibYueLab.text = @"我的余额";
            [self.ibKaitongAction setTitle:@"立即邀请" forState:UIControlStateNormal];
            self.ibYaoqingma.text = [NSString stringWithFormat:@"邀请码:%@",ACCOUNTINFO.userInfo.uid];
//            self.ibDianzhuqunyiLab.text = @"代理权益";
        }else if (ACCOUNTINFO.userInfo.agent_id == 2){
            self.ibUserRole.text = @"钻石代理";
            self.ibYueValue.text = ACCOUNTINFO.userInfo.now_money;
            self.ibYueLab.text = @"我的余额";
            [self.ibKaitongAction setTitle:@"立即邀请" forState:UIControlStateNormal];
            self.ibYaoqingma.text = [NSString stringWithFormat:@"邀请码:%@",ACCOUNTINFO.userInfo.uid];
//            self.ibDianzhuqunyiLab.text = @"代理权益";
        }
        self.ibYouhuiquanValue.text = [NSString stringWithFormat:@"%ld",accountinfo.coupon_num.count];
        self.ibShoucangValue.text = accountinfo.collect_number;
        self.ibYouhuiquanValue.text = accountinfo.coupon_number;
        self.ibZujiValue.text = ACCOUNTINFO.userInfo.integral;
        self.ibHUodongLab.text = accountinfo.remind;
        
    }
}
- (IBAction)editNameAction:(id)sender{
    //修改昵称
    ChangeNicknameVC *vc = [[ChangeNicknameVC alloc]initWithNibName:@"ChangeNicknameVC" bundle:nil];
    [self.controller.navigationController pushViewController:vc animated:YES];
  
}
- (IBAction)ibSettingAction:(id)sender{
    if (![Save isLogin]) {
        [self.controller presentLoginWithComplection:^{
        }];
        return;
    }
    //设置
  
    SettingVC *vc = [[SettingVC alloc]initWithNibName:@"SettingVC" bundle:nil];
    [self.controller.navigationController pushViewController:vc animated:YES];
}
- (IBAction)ibMessageAction:(id)sender {
    if (![Save isLogin]) {
        [self.controller presentLoginWithComplection:^{
        }];
        return;
    }
    MessageVC *vc= [[MessageVC alloc]initWithNibName:@"MessageVC" bundle:nil];
    [self.controller.navigationController pushViewController:vc animated:YES];
}
- (IBAction)ibGerenquanyiAction:(id)sender {
    if (![Save isLogin]) {
        [self.controller presentLoginWithComplection:^{
        }];
        return;
    }
    OwnersRightsVC *vc = [[OwnersRightsVC alloc]initWithNibName:@"OwnersRightsVC" bundle:nil];
//    vc.isMainInto = YES;
    [self.controller.navigationController pushViewController:vc animated:YES];
  
}
- (IBAction)ibShoucangAction:(id)sender {
    if (![Save isLogin]) {
        [self.controller presentLoginWithComplection:^{
        }];
        return;
    }
    //收藏
  
    MycollectionVC *vc = [[MycollectionVC alloc]initWithNibName:@"MycollectionVC" bundle:nil];
    [self.controller.navigationController pushViewController:vc animated:YES];
}
- (IBAction)ibZujiAction:(id)sender {
}
- (IBAction)ibYouhuiquanAction:(id)sender {
    if (![Save isLogin]) {
        [self.controller presentLoginWithComplection:^{
        }];
        return;
    }
    //优惠券
   
    CouPonVC *vc = [[CouPonVC alloc]initWithNibName:@"CouPonVC" bundle:nil];
    [self.controller.navigationController pushViewController:vc animated:YES];
}
-(void)tapClick:(UIGestureRecognizer *)ges{
    if (_iconClickBlock) {
        _iconClickBlock();
    }
}
@end
