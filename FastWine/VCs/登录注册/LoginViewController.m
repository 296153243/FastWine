//
//  LoginViewController.m
//  QuDriver
//
//  Created by 朱青 on 2017/9/21.
//  Copyright © 2017年 com.Qyueche. All rights reserved.
//

#import "LoginViewController.h"
//#import "WXRegistViewController.h"
//#import "JPUSHService.h"
#import "PSLoginViewController.h"
//#import "PSRegistViewController.h"
#import "RegistVC.h"
#import "VersionAlertView.h"
@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *ibPhoneTf;
@property (weak, nonatomic) IBOutlet UITextField *ibCodeTf;
@property (weak, nonatomic) IBOutlet UIButton *ibLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *ibGetCodeBtn;
@property (strong, nonatomic) dispatch_source_t timer;
@property(nonatomic)NSInteger flag;// 1-》手机密码 2-》手机验证码 3-》第三方
@end

@implementation LoginViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = NavColor;
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //偏移问题
//    self.edgesForExtendedLayout = UIRectEdgeNone; 
//    self.navigationController.navigationBar.backgroundColor = NavColor;
//    self.navigationItem.title =@"手机号登录";

    //创建返回按钮
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 19,44);
//    leftBtn.backgroundColor = [UIColor redColor];
    [leftBtn setImage:[UIImage imageNamed:@"Back_icon"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];;
    //创建UIBarButtonSystemItemFixedSpace
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width = - 15;
    //将两个BarButtonItem都返回给NavigationItem
    self.navigationItem.leftBarButtonItems = @[spaceItem,leftBarBtn];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem rightItemWithTitle:@"注册" Target:self action:@selector(regiest)];
    
    [_ibPhoneTf addTarget:self action:@selector(phoneTfChange) forControlEvents:UIControlEventEditingChanged];
  
    [_ibCodeTf addTarget:self action:@selector(codeTfChange) forControlEvents:UIControlEventEditingChanged];
    _flag = 2;//默认验证码登录

}
- (void)regiest{
//      [self.navigationController pushViewController:[PSRegistViewController new] animated:YES];
}
//账号密码登录
- (IBAction)ibPassWordLoginBtnClick:(UIButton *)sender {
//    [sender setSelected:YES];
//    NSLog(@"%d",_isPassword);
    
    if (sender.selected != YES) {
        self.ibCodeTf.placeholder = @"请输入登录密码";
        self.ibGetCodeBtn.hidden = YES;
        _flag = 1;
    }else{
        self.ibCodeTf.placeholder = @"请输入短信验证码";
        self.ibGetCodeBtn.hidden = NO;
        _flag = 2;

    }
     sender.selected = !sender.selected;
}



#pragma mark Request
//获取验证码
- (void)requestVertrifyCode
{
    NSString *phone = [self.ibPhoneTf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL isPhone = phone.length==11;
    
    if (!isPhone) {
      
        [QuHudHelper qu_showMessage:@"请输入正确的11位手机号"];
        return;
    }
    GetCodeReq *req = [GetCodeReq new];
    req.phone = phone;
    req.type = @"login";//reg 注册 login 登陆 change修改
    [[HTTPRequest sharedManager]requestDataWithApiName:getCode withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        NSLog(@"验证码发送成功");
        [self.ibPhoneTf becomeFirstResponder];
        [self openCountdown];
    } withError:^(NSError *error) {
        
    }];
    
}

//登录
- (void)requestVertrifyLoginWithStr:(NSString *)str
{
    
    LoginReq *req =[LoginReq new];
    req.account = self.ibPhoneTf.text;
    req.tel = self.ibPhoneTf.text;
    req.flag = [NSString stringWithFormat:@"%ld",_flag];
    //_flag  1-》手机密码 2-》手机验证码 3-》第三方
    if (_flag == 1) {
        req.passwd = [self.ibCodeTf.text md5_32bit];
    }else if(_flag == 2){
        req.code = self.ibCodeTf.text;
        
    }else{
        req.wx_code = str;
    }
    
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
        if ([[NSString stringWithFormat:@"%@",error] isEqualToString:@"登陆账号不存在!"] && self.flag == 1) {
            RegistVC *vc = [[RegistVC alloc]initWithNibName:@"RegistVC" bundle:nil];
            vc.type = [NSString stringWithFormat:@"%ld",self.flag];
            vc.isregist = YES;
            vc.phone = self.ibPhoneTf.text;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
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
//微信登录
- (void)requestWXLoginWithUid:(NSString *)uid nickName:(NSString *)nickName headUrl:(NSString *)headUrl
{
    [QuLoadingHUD loading];

    BindWeChatReq *req = [[BindWeChatReq alloc]init];
    req.winXinKey = uid;
    req.phone = @"";

//    [NetWorkReqManager requestDataWithApiName:bindWeChat params:req response:^(NSDictionary *responseObject) {
//
//        [QuLoadingHUD dismiss];
//
//        BindWeChatRsp *rsp = [BindWeChatRsp mj_objectWithKeyValues:responseObject];
//
//        if (rsp.code == 1) {
//
//            ACCOUNTINFO.isLogin = YES;
//            ACCOUNTINFO.userInfo = rsp.data;
//
//            if (self.loginCompletionBlock) {
//                self.loginCompletionBlock();
//            }
//
//            [JPUSHService setAlias:rsp.data.alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//
//                if (iResCode == 0) {
//
//                }
//            } seq:0];
//
//            [self dismissViewControllerAnimated:YES completion:nil];
//
//        }
//        else if (rsp.code == 3){
//
//            WXRegistViewController *vc = [[WXRegistViewController alloc]initWithNibName:@"WXRegistViewController" bundle:nil];
//            vc.wxUid = uid;
//            vc.nickName = nickName;
//            vc.imageUrl = headUrl;
//            vc.wxLoginCompletionBlock = ^{
//
//                if (self.loginCompletionBlock) {
//                    self.loginCompletionBlock();
//                }
//            };
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        else{
//            [QuLoadingHUD dismiss:rsp.message];
//        }
//
//
//    } errorResponse:^(NSString *error) {
//
//        [QuLoadingHUD dismiss:error];
//    }];

}


- (void)phoneTfChange{
  
//    if (_ibPhoneTf.text.length >11) {
//        [QuHudHelper qu_showMessage:@"手机号码超出范围"];
//        [_ibPhoneTf endEditing:YES];
//        _ibPhoneTf.text = [_ibPhoneTf.text substringToIndex:11];
//
//    }
    if (_ibPhoneTf.text.length >= 11) {
        [_ibGetCodeBtn setTitleColor:HEXCOLOR(@"#DA3B31") forState:UIControlStateNormal];
    }else{
         [_ibGetCodeBtn setTitleColor:HEXCOLOR(@"#DBDBDB") forState:UIControlStateNormal];
    }
}
- (void)codeTfChange{
   
    NSString *toBeString = _ibCodeTf.text;
    
//    //这里默认是最多输入8位
//    if (toBeString.length >= 8){
//
//        _ibCodeTf.text = [toBeString substringToIndex:8];
//
//    }

    if (_ibCodeTf.text.length >= 4){
        
        _ibLoginBtn.backgroundColor = HEXCOLOR(@"#DA3B31");
    }
    else{
        _ibLoginBtn.backgroundColor = HEXCOLOR(@"#DBDBDB");
    }
}
//微信登录操作
- (IBAction)wechatLoginBtnClick:(id)sender {
    
    WS(weakSelf)
    [[ThirdApiManager shareManager]getThirdUserInfoCompletion:^(NSString *uid,NSString *nickName,NSString *headUrl,NSString *wxToken) {
        
//        [weakSelf requestWXLoginWithUid:uid nickName:nickName headUrl:headUrl];
        weakSelf.flag = 3;
        [weakSelf requestVertrifyLoginWithStr:wxToken];

    }];
    
  
}
//获取验证码
- (IBAction)getCodeBtnClick:(id)sender {
    //验证手机号码
    if (_ibPhoneTf.text.length != 11) {
   
        [QuHudHelper qu_showMessage:@"请输入正确的11位手机号码"];
        return ;
    }
    
    [self requestVertrifyCode];
    
    
}
//登录方法
- (IBAction)loginBtnClick:(id)sender {
    
    NSString *phone = [self.ibPhoneTf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL isPhone = phone.length >=11;
    
    if (!isPhone) {
        [CommonMethod altermethord:@"你输入的号码不正确，请输入重新输入" andmessagestr:@"" andconcelstr:@"确定"];
        return;
    }
    [self requestVertrifyLoginWithStr:nil];
}

// 开启倒计时
-(void)openCountdown{
    
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(self->_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self->_ibGetCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
            
                self->_ibGetCodeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self->_ibGetCodeBtn setTitle:[NSString stringWithFormat:@"%.2ds", seconds] forState:UIControlStateNormal];
                self->_ibGetCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}


#pragma mark btnClickAction
- (void)leftBarButtonItemAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)protocalClickAction:(id)sender
{
    BaseRequest *req = [BaseRequest new];
    req.id = @"1";//1:用户协议2:关于我们3:隐私政策
    [[HTTPRequest sharedManager]requestDataWithApiName:article withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        BaseWKWebController *vc = [[BaseWKWebController alloc]init];
        vc.content = responseObject[@"data"][@"content"][@"content"];
        vc.titleStr = responseObject[@"data"][@"content"][@"title"];
        
        [self.navigationController pushViewController:vc animated:YES];
    } withError:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK:--------UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)eve{
    [self.view endEditing:YES];
}


@end
