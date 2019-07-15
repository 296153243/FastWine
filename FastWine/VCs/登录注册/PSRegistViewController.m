//
//  PSRegistViewController.m
//  ParkingSpace
//
//  Created by 那道 on 2018/5/28.
//  Copyright © 2018年 LWH. All rights reserved.
//

#import "PSRegistViewController.h"
#import "Save.h"
@interface PSRegistViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView  *titleView;
@property (nonatomic, strong) UIView  *phoneView;
@property (nonatomic, weak) UITextField *phoneField;

@property (nonatomic, strong) UIView  *verifyView;
@property (nonatomic, weak) UITextField *verifyField;

@property (nonatomic, strong) UIView  *pswView;
@property (nonatomic, strong) UIView  *invitationView;
@property (nonatomic, weak) UITextField *pswField;
@property (nonatomic, weak) UITextField *invitationField;


@property (nonatomic, strong) UIButton  *finishBtn;
@property (nonatomic, strong) UIButton  *xieyiBtn;


@end

@implementation PSRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    self.navigationItem.title = @"手机号注册";
//    [self titleView];
    [self finishBtn];
    [self xieyiBtn];
    
}

#pragma mark - 返回
- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 立即注册
- (void)clickRegist
{
    NSString *phone = [self.phoneField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL isPhone = phone.length==11;
    
    NSString *verify = [self.verifyField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL isVerify = verify.length > 3;
    
    BOOL isPSW = self.pswField.text.length>5 && self.pswField.text.length<21;
    
    if (!(isPhone && isVerify && isPSW)) {
        
        NSString *tip = TipFinish;
        if (!isPhone)
        {
            tip = @"你输入的号码不正确，请输入正确的手机号";
        }
        [CommonMethod altermethord:tip andmessagestr:@"" andconcelstr:@"确定"];
        [QuHudHelper qu_showMessage:tip];
        return;
    }
    
    RegistReq *req =[RegistReq new];
    req.phone = phone;
    req.passwd = [self.pswField.text md5_32bit];
    req.code = self.verifyField.text;
    req.invite_code = self.invitationField.text;
//    req.client = @"iOS";
//    req.jpush_id = @"";

    [[HTTPRequest sharedManager]requestDataWithApiName:regist withParameters:req isEnable:NO withSuccess:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
        
        [self login];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    } withError:^(NSError *error) {
        
    }];
}
-(void)xieyiBtnClick{
    
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
- (void)login
{
    NSString *phone = [self.phoneField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    LoginReq *req =[LoginReq new];
    req.account = phone;
    req.tel = phone;
    req.passwd = [self.pswField.text md5_32bit];
    //    1-》手机密码 2-》手机验证码 3-》第三方
    req.flag = @"2";
    
    [[HTTPRequest sharedManager] requestDataWithApiName:login withParameters:req isEnable:NO withSuccess:^(id responseObject) {
        
        [PublicManager saveUserUdToLocalWithToken:responseObject[@"data"]];
        NSLog(@"getLocalToken:%@",[PublicManager getLocalToken]);
        //        User *user = [User mj_objectWithKeyValues:responseObject[@"data"]];
        //        [Save saveUser:user];
        //        [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
        
    } withError:^(NSError *error) {
        
    }];
}


#pragma mark - 获取验证码
- (void)clickVerify:(UIButton *)sender
{
    NSString *phone = [self.phoneField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL isPhone = phone.length==11;
    
    if (!isPhone) {
//        [CommonMethod altermethord:@"请输入正确的11位手机号" andmessagestr:@"" andconcelstr:@"确定"];
        [QuHudHelper qu_showMessage:@"请输入正确的11位手机号"];
        return;
    }
    GetCodeReq *req = [GetCodeReq new];
    req.phone = phone;
    req.type = @"reg";//reg 注册 login 登陆 change修改
    [[HTTPRequest sharedManager]requestDataWithApiName:getCode withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        NSLog(@"验证码发送成功");
        [self.verifyField becomeFirstResponder];
        [CommonMethod GetVerificationCode:sender finish:nil];
    } withError:^(NSError *error) {
        
    }];
   
}

- (void)clickShowPsw:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.pswField.secureTextEntry = !sender.selected;
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - GET
- (UIView *)titleView
{
    if (!_titleView) {
        
        _titleView = [UIView viewWithBackgroundColor:WhiteColor superView:self.view];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(HScale(20));
            make.left.centerX.mas_equalTo(0);
            make.height.mas_equalTo(HScale(40));
        }];
        
        UILabel *titleLbl = [UILabel labelWithText:@"注册" font:ZF_FONT(17) textColor:BlackColor backGroundColor:ClearColor superView:_titleView];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
        
        UIButton *cancleBtn = [UIButton buttonWithImage:@"Back_icon" target:self action:@selector(clickBack) showView:_titleView];
        cancleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        cancleBtn.contentEdgeInsets = UIEdgeInsetsMake(0, WScale(10), 0, 0);
        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(WScale(50));
        }];
    }
    return _titleView;
}

- (UIView *)phoneView
{
    if (!_phoneView) {
        
        _phoneView = [UIView viewWithBackgroundColor:WhiteColor superView:self.view];
        [_phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(HScale(100));
            make.left.mas_equalTo(WScale(45));
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(HScale(70));
        }];
        
        UIImageView *leftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone"]];
        leftImg.contentMode = UIViewContentModeCenter;
        [_phoneView addSubview:leftImg];
        
        UITextField *field = [[UITextField alloc]init];
        field.delegate = self;
        field.returnKeyType = UIReturnKeyDone;
        field.keyboardType = UIKeyboardTypeNumberPad;
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.textColor = BlackColor;
        field.font = ZF_FONT(14);
        field.placeholder = @"请输入手机号";
        [field setValue:UIColorFromRGB(0xd9dce8) forKeyPath:@"_placeholderLabel.textColor"];
        [field setValue:ZF_FONT(14) forKeyPath:@"_placeholderLabel.font"];
        [_phoneView addSubview:field];
        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(HScale(45));
            make.left.mas_equalTo(leftImg.mas_right).mas_equalTo(WScale(10));
            make.bottom.right.mas_equalTo(0);
        }];
        
        [leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.centerY.mas_equalTo(field.mas_centerY);
            make.size.mas_equalTo(leftImg.image.size);
        }];
        
        UIView *line = [UIView viewWithBackgroundColor:SeparatorCOLOR superView:_phoneView];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.centerX.bottom.mas_equalTo(0);
        }];
        
        self.phoneField = field;
    }
    return _phoneView;
}

- (UIView *)verifyView
{
    if (!_verifyView) {
        
        _verifyView = [UIView viewWithBackgroundColor:WhiteColor superView:self.view];
        [_verifyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.phoneView.mas_bottom);
            make.left.centerX.height.mas_equalTo(self.phoneView);
        }];
        
        UIButton *verifyBtn = [UIButton buttonWithTitle:@"发送验证码" font:ZF_FONT(14) titleColor:ThemeColor backGroundColor:ClearColor buttonTag:0 target:self action:@selector(clickVerify:) showView:_verifyView];
        CGFloat width = [NSString sizeWithText:verifyBtn.currentTitle font:ZF_FONT(14) maxSize:CGSizeMake(MAXFLOAT, HScale(20))].width+WScale(10);
        verifyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        verifyBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, WScale(7));
        [verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(width);
        }];
        
        UIImageView *leftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emi"]];
        leftImg.contentMode = UIViewContentModeCenter;
        [_verifyView addSubview:leftImg];
        
        UITextField *field = [[UITextField alloc]init];
        field.delegate = self;
        field.returnKeyType = UIReturnKeyDone;
        field.keyboardType = UIKeyboardTypeNumberPad;
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.textColor = BlackColor;
        field.font = ZF_FONT(14);
        field.placeholder = @"请输入验证码";
        [field setValue:UIColorFromRGB(0xd9dce8) forKeyPath:@"_placeholderLabel.textColor"];
        [field setValue:ZF_FONT(14) forKeyPath:@"_placeholderLabel.font"];
        [_verifyView addSubview:field];
        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(HScale(45));
            make.left.mas_equalTo(leftImg.mas_right).mas_equalTo(WScale(10));
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(verifyBtn.mas_left).mas_equalTo(-WScale(7));
        }];
        
        [leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.centerY.mas_equalTo(field.mas_centerY);
            make.size.mas_equalTo(leftImg.image.size);
        }];
        
        UIView *line = [UIView viewWithBackgroundColor:SeparatorCOLOR superView:_verifyView];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.centerX.bottom.mas_equalTo(0);
        }];
        self.verifyField = field;
    }
    return _verifyView;
}

- (UIView *)pswView
{
    if (!_pswView) {
        
        _pswView = [UIView viewWithBackgroundColor:WhiteColor superView:self.view];
        [_pswView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.verifyView.mas_bottom);
            make.left.centerX.height.mas_equalTo(self.phoneView);
        }];
        
        UIButton *showBtn = [UIButton buttonWithImage:@"eye_close" target:self action:@selector(clickShowPsw:) showView:_pswView];
        [showBtn setImage:[UIImage imageNamed:@"eye_open"] forState:UIControlStateSelected];
        [showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(WScale(40), HScale(45)));
        }];
        
        
        UIImageView *leftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"key"]];
        leftImg.contentMode = UIViewContentModeCenter;
        [_pswView addSubview:leftImg];
        
        UITextField *field = [[UITextField alloc]init];
        field.delegate = self;
        field.keyboardType = UIKeyboardTypeEmailAddress;
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.returnKeyType = UIReturnKeyDone;
        field.secureTextEntry = YES;
        field.textColor = BlackColor;
        field.font = ZF_FONT(14);
        field.placeholder = @"请输入密码";
        [field setValue:UIColorFromRGB(0xd9dce8) forKeyPath:@"_placeholderLabel.textColor"];
        [field setValue:ZF_FONT(14) forKeyPath:@"_placeholderLabel.font"];
        [_pswView addSubview:field];
        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(HScale(45));
            make.left.mas_equalTo(leftImg.mas_right).mas_equalTo(WScale(10));
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(showBtn.mas_left);
        }];
        
        [leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.centerY.mas_equalTo(field.mas_centerY);
            make.size.mas_equalTo(leftImg.image.size);
        }];
        
        UIView *line = [UIView viewWithBackgroundColor:SeparatorCOLOR superView:_pswView];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.centerX.bottom.mas_equalTo(0);
        }];
        
        self.pswField = field;
        
    }
    return _pswView;
}
- (UIView *)invitationView
{
    if (!_invitationView) {
        
        _invitationView = [UIView viewWithBackgroundColor:WhiteColor superView:self.view];
        [_invitationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.pswView.mas_bottom);
            make.left.centerX.height.mas_equalTo(self.phoneView);
        }];
        
       
        
        UIImageView *leftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"key"]];
        leftImg.contentMode = UIViewContentModeCenter;
        [_invitationView addSubview:leftImg];
        
        UITextField *field = [[UITextField alloc]init];
        field.delegate = self;
        field.keyboardType = UIKeyboardTypeEmailAddress;
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.returnKeyType = UIReturnKeyDone;
//        field.secureTextEntry = YES;
        field.textColor = BlackColor;
        field.font = ZF_FONT(14);
        field.placeholder = @"请输入邀请码";
        [field setValue:UIColorFromRGB(0xd9dce8) forKeyPath:@"_placeholderLabel.textColor"];
        [field setValue:ZF_FONT(14) forKeyPath:@"_placeholderLabel.font"];
        [self.invitationView addSubview:field];
        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(HScale(45));
            make.left.mas_equalTo(leftImg.mas_right).mas_equalTo(WScale(10));
            make.bottom.right.mas_equalTo(0);
        }];
        
        [leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.centerY.mas_equalTo(field.mas_centerY);
            make.size.mas_equalTo(leftImg.image.size);
        }];
        
        
        UIView *line = [UIView viewWithBackgroundColor:SeparatorCOLOR superView:self.invitationView];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.centerX.bottom.mas_equalTo(0);
        }];
        
        self.invitationField = field;
        
    }
    return _invitationView;
}

- (UIButton *)finishBtn
{
    if (!_finishBtn) {
        
        
        _finishBtn = [UIButton buttonWithTitle:@"注册" font:ZF_FONT(14) titleColor:WhiteColor backGroundColor:ClearColor buttonTag:0 target:self action:@selector(clickRegist) showView:self.view];
        [_finishBtn setBackgroundImage:[UIImage imageNamed:@"button_dlzc"] forState:0];
        _finishBtn.backgroundColor = HEXCOLOR(@"#DA3B31");
        _finishBtn.clipsToBounds = YES;
        _finishBtn.layer.cornerRadius = 24;
        [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.invitationView.mas_bottom).mas_equalTo(HScale(45));
            make.left.centerX.mas_equalTo(self.phoneView);
            make.height.mas_equalTo(HScale(40));
        }];
        
        UIImageView *bottomImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"car_bg"]];
        bottomImg.contentMode = UIViewContentModeCenter;
        [self.view addSubview:bottomImg];
        [bottomImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(bottomImg.image.size);
        }];
        
    }
    return _finishBtn;
}
- (UIButton *)xieyiBtn
{
    if (!_xieyiBtn) {
        
        _xieyiBtn = [UIButton buttonWithTitle:@"用户注册代表同意《服务条款》" font:ZF_FONT(12) titleColor:HEXCOLOR(@"#7F7F7F") backGroundColor:ClearColor buttonTag:0 target:self action:@selector(xieyiBtnClick) showView:self.view];
        NSString *str = @"用户注册代表同意《服务条款》";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
        [attr setAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:NSMakeRange(8, str.length - 8)];
        [attr setAttributes:@{NSForegroundColorAttributeName :HEXCOLOR(@"#7F7F7F")} range:NSMakeRange(0, 8)];
        [_xieyiBtn setAttributedTitle:attr forState:UIControlStateNormal];
        
        [_xieyiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.finishBtn.mas_bottom).mas_equalTo(HScale(10));
            make.left.mas_equalTo(self.phoneView);
            make.height.mas_equalTo(HScale(20));
        }];
        
   
        
    }
    return _xieyiBtn;
}



@end
