//
//  WithdrawalVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/4/30.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "WithdrawalVC.h"

@interface WithdrawalVC ()
@property (weak, nonatomic) IBOutlet UITextField *ibNameTf;
@property (weak, nonatomic) IBOutlet UITextField *iAliNumberTf;
@property (weak, nonatomic) IBOutlet UITextField *ibPicTf;
@property (weak, nonatomic) IBOutlet UILabel *ibAllPicLab;
@property(nonatomic,strong)WithdrawalRsp *rsp;
@end

@implementation WithdrawalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"提现";
    _ibAllPicLab.text = [NSString stringWithFormat:@"余额: ¥%@",ACCOUNTINFO.userInfo.now_money];
    [self requestKetixian];
    [self requestGetWallet];
}
- (IBAction)ibTiIXianAction:(id)sender {
 
    [self request];
}
-(void)requestKetixian{
   
    [[HTTPRequest sharedManager]requestDataWithApiName:myWithdralInfo withParameters:nil isEnable:YES withSuccess:^(id responseObject) {
        self.rsp = [WithdrawalRsp mj_objectWithKeyValues:responseObject[@"data"]];
        
        if (self.rsp) {
            self.ibNameTf.text = self.rsp.extractInfo.real_name;
            self.ibPicTf.text = self.rsp.extractInfo.extract_price;
            self.iAliNumberTf.text = self.rsp.extractInfo.alipay_code;
        
            

        }
    } withError:^(NSError *error) {
        
    }];
}
//TODO:----------获取钱包余额
- (void)requestGetWallet{
    
    [[HTTPRequest sharedManager]requestDataWithApiName:myUser_pro withParameters:nil isEnable:YES withSuccess:^(id responseObject) {
        GetWalletRsp *dataRsp = [GetWalletRsp mj_objectWithKeyValues:responseObject];
        self.ibAllPicLab.text = [NSString stringWithFormat:@"余额:%@元",dataRsp.data.userInfo.now_money];
       
    } withError:^(NSError *error) {
        
    }];
   
}
-(void)request{
    WithdrawalReq *req = [WithdrawalReq new];
    req.type = @"alipay";
    if (_ibNameTf.text.length == 0 || _iAliNumberTf.text.length == 0 || _ibPicTf.text.length == 0) {
        [QuHudHelper qu_showMessage:@"请输入完整信息"];
        return;
    }
    if ([_ibPicTf.text doubleValue] < [self.rsp.minExtractPrice doubleValue]) {
        [QuHudHelper qu_showMessage:[NSString stringWithFormat:@"最小提现金额%@元",self.rsp.minExtractPrice]];
        return ;
    }
    req.real_name = _ibNameTf.text;
    req.alipay_code = _iAliNumberTf.text;
    req.price = _ibPicTf.text;
    [[HTTPRequest sharedManager]requestDataWithApiName:myWithdral withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        [QuHudHelper qu_showMessage:@"提现成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } withError:^(NSError *error) {
        
    }];
}

- (IBAction)ibNameTf:(id)sender {
}
@end
