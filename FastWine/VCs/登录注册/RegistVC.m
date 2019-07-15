//
//  RegistVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/5/29.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "RegistVC.h"

@interface RegistVC ()
@property (weak, nonatomic) IBOutlet UITextField *ibPhoneTf;
@property (weak, nonatomic) IBOutlet UITextField *ibCodeTf;
@property (weak, nonatomic) IBOutlet UITextField *ibPasswordTf;
@property (weak, nonatomic) IBOutlet UITextField *ibInvitationCodeTf;
@property (weak, nonatomic) IBOutlet UIButton *ibregistBtn;
@property (weak, nonatomic) IBOutlet UIButton *ibGetCodeBtn;
@property (weak, nonatomic) IBOutlet UIView *ibPhoneView;
@property (weak, nonatomic) IBOutlet UIView *ibCodeView;
@property (strong, nonatomic) dispatch_source_t timer;
//@property(nonatomic)NSInteger flag;// 1-》手机密码 2-》手机验证码 3-》第三方
@end

@implementation RegistVC
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
- (IBAction)ibRegistBtnClick:(id)sender {
    [self requestRegist];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_ibPhoneTf addTarget:self action:@selector(phoneTfChange) forControlEvents:UIControlEventEditingChanged];
    if ([_type isEqualToString:@"2"]) {
        //验证码登录 不用再展示 手机和验证码输入框
        _ibPhoneView.hidden = YES;
        _ibCodeView.hidden = YES;
    }
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
    req.type = @"reg";//reg 注册 login 登陆 change修改
    [[HTTPRequest sharedManager]requestDataWithApiName:getCode withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        NSLog(@"验证码发送成功");
        [self.ibPhoneTf becomeFirstResponder];
        [self openCountdown];
    } withError:^(NSError *error) {
        
    }];
    
}

//注册
- (void)requestRegist
{
    if (_ibInvitationCodeTf.text.length == 0) {
        UIAlertController * altController = [UIAlertController alertControllerWithTitle:@"你未输入邀请码,确认提交吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [altController addAction:cancelAction];
        
        if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
            [cancelAction setValue:[UIColor grayColor] forKey:@"titleTextColor"];
        }
        UIAlertAction * yesAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [self registAction];
        }];
        
        [altController addAction:yesAction];
        [self presentViewController:altController animated:YES completion:nil];
    }else{
        [self registAction];
    }
   
  
}
-(void)registAction{
    _phone = [self.ibPhoneTf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL isPhone = _phone.length==11;
    
    NSString *verify = [self.ibCodeTf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL isVerify = verify.length > 3;
    
    BOOL isPSW = self.ibPasswordTf.text.length>5 && self.ibPasswordTf.text.length<21;
    
    //    if (!(isPhone && isVerify && isPSW)) {
    //
    //        NSString *tip = TipFinish;
    //        if (!isPhone)
    //        {
    //            tip = @"你输入的号码不正确，请输入正确的手机号";
    //        }
    //        [CommonMethod altermethord:tip andmessagestr:@"" andconcelstr:@"确定"];
    //        [QuHudHelper qu_showMessage:tip];
    //        return;
    //    }
    
    RegistReq *req =[RegistReq new];
    req.phone = _phone;
    req.code = self.ibCodeTf.text;
    req.invite_code = self.ibInvitationCodeTf.text;
    req.type = _type;
    //    req.client = @"iOS";
    //    req.jpush_id = @"";
    XQApiName apiName;
    if (_isregist == YES) {
        //走注册接口
        apiName = regist;
        req.pwd = [self.ibPasswordTf.text md5_32bit];
        
    }else{
        apiName = loginSavephone;
        req.passwd = [self.ibPasswordTf.text md5_32bit];
        
    }
    
    
    [[HTTPRequest sharedManager]requestDataWithApiName:apiName withParameters:req isEnable:NO withSuccess:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
        
        [self login];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
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
- (void)login
{
    NSString *phone = [self.ibPhoneTf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    LoginReq *req =[LoginReq new];
    req.account = phone;
    req.tel = phone;
    req.passwd = [self.ibPasswordTf.text md5_32bit];
    //    1-》手机密码 2-》手机验证码 3-》第三方
    req.flag = @"1";
    
    [[HTTPRequest sharedManager] requestDataWithApiName:login withParameters:req isEnable:NO withSuccess:^(id responseObject) {
        
        [PublicManager saveUserUdToLocalWithToken:responseObject[@"data"][@"token"]];
        NSLog(@"getLocalToken:%@",[PublicManager getLocalToken]);
        //        User *user = [User mj_objectWithKeyValues:responseObject[@"data"]];
        //        [Save saveUser:user];
        //        [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
        [self requestUserInfo];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:LOGIN_SUCCESS_NOTIFICATION object:nil];
       
        });
        
    } withError:^(NSError *error) {
        
    }];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
