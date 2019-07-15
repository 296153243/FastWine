//
//  PersonServiceCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/6/10.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "PersonServiceCell.h"
#import "QMHomeViewController.h"
#import "QrCodeVC.h"
#import "AllAddressVC.h"
//#import "MyWalletVC.h"
#import "OwnersRightsVC.h"
#import "IhaveGoodsVC.h"
@implementation PersonServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
  
}
- (IBAction)ibDianzhuQuanyiAction:(id)sender {
    if (![Save isLogin]) {
        [self.controller presentLoginWithComplection:^{
        }];
        return;
    }
    OwnersRightsVC *vc = [[OwnersRightsVC alloc]initWithNibName:@"OwnersRightsVC" bundle:nil];
//    vc.isMainInto = YES;
    [self.controller.navigationController pushViewController:vc animated:YES];
  
}
- (IBAction)iberweimaAction:(id)sender {
    if (![Save isLogin]) {
        [self.controller presentLoginWithComplection:^{
        }];
        return;
    }
//    //推广二维码
//    [MobClick event:@"C_personal_tgm"];
//    QrCodeVC *vc = [[QrCodeVC alloc]initWithNibName:@"QrCodeVC" bundle:nil];
//    [self.controller.navigationController pushViewController:vc animated:YES];
    IhaveGoodsVC *vc= [[IhaveGoodsVC alloc]initWithNibName:@"IhaveGoodsVC" bundle:nil];
    [self.controller.navigationController pushViewController:vc animated:YES];
}
- (IBAction)ibLianxikefuAction:(id)sender {
    if (![Save isLogin]) {
        [self.controller presentLoginWithComplection:^{
        }];
        return;
    }
    QMHomeViewController *vc= [QMHomeViewController new];
 
    [self.controller.navigationController pushViewController:vc animated:YES];
}
- (IBAction)ibDizhiguanli:(id)sender{
    if (![Save isLogin]) {
        [self.controller presentLoginWithComplection:^{
        }];
        return;
    }
    AllAddressVC *vc = [[AllAddressVC alloc]initWithNibName:@"AllAddressVC" bundle:nil];
    [self.controller.navigationController pushViewController:vc animated:YES];
}

@end
