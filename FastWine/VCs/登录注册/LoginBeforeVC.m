//
//  LoginBeforeVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/6/15.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "LoginBeforeVC.h"
#import "RegistVC.h"
#import "LoginViewController.h"
@interface LoginBeforeVC ()
@property(nonatomic)NSInteger flag;// 1-》手机密码 2-》手机验证码 3-》第三方

@end

@implementation LoginBeforeVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = NavColor;
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)bBackAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)ibWeChatLoginAction:(id)sender {
    WS(weakSelf)
    [[ThirdApiManager shareManager]getThirdUserInfoCompletion:^(NSString *uid,NSString *nickName,NSString *headUrl,NSString *wxToken) {
        
        //        [weakSelf requestWXLoginWithUid:uid nickName:nickName headUrl:headUrl];
        weakSelf.flag = 3;
        [weakSelf requestVertrifyLoginWithStr:wxToken];
        
    }];
}
- (IBAction)ibPhoneLogin:(id)sender {
    LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}
//登录
- (void)requestVertrifyLoginWithStr:(NSString *)str
{
    
    LoginReq *req =[LoginReq new];

    req.flag = [NSString stringWithFormat:@"%ld",_flag];
    //_flag  1-》手机密码 2-》手机验证码 3-》第三方
    req.wx_code = str;
    
    
    [[HTTPRequest sharedManager] requestDataWithApiName:login withParameters:req isEnable:NO withSuccess:^(id responseObject) {
        
        [PublicManager saveUserUdToLocalWithToken:responseObject[@"data"][@"token"]];
        if ([responseObject[@"data"][@"first"] integerValue] == 1) {
            //没有完善信息 要去注册页完善信息
            RegistVC *vc = [[RegistVC alloc]initWithNibName:@"RegistVC" bundle:nil];
            vc.type = [NSString stringWithFormat:@"%ld",self.flag];
            
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self requestUserInfo];
            
        }
        
        //        NSLog(@"getLocalToken:%@",[PublicManager getLocalToken]);
        
    } withError:^(NSError *error) {
    
    }];
    
}
//MARK:----获取个人信息
-(void)requestUserInfo{
    [[HTTPRequest sharedManager]requesGetDataWithApiName:getInformation withParameters:nil isEnable:YES withSuccess:^(id responseObject) {
        
        User *user = [User mj_objectWithKeyValues:responseObject[@"data"][@"user_info"]];
        [Save saveUser:user];
        QuUserInfo *userInfo = [QuUserInfo mj_objectWithKeyValues:responseObject[@"data"][@"user_info"]];
        ACCOUNTINFO.userInfo = userInfo;
        
        [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:LOGIN_SUCCESS_NOTIFICATION object:nil];
            
            
        });
    } withError:^(NSError *error) {
        
    }];
}
- (IBAction)protocalClickAction:(UIButton *)sender
{
    BaseRequest *req = [BaseRequest new];
    if (sender.tag == 1) {
        req.id = @"16";//16:用户协议  17:服务条款 2:关于我们3:隐私政策
        
    }else{
        req.id = @"17";
    }
    [[HTTPRequest sharedManager]requestDataWithApiName:article withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        BaseWKWebController *vc = [[BaseWKWebController alloc]init];
        vc.content = responseObject[@"data"][@"content"][@"content"];
        vc.titleStr = responseObject[@"data"][@"content"][@"title"];
        [self.navigationController pushViewController:vc animated:YES];
    } withError:^(NSError *error) {
        
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
