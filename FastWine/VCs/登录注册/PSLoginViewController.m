//
//  PSLoginViewController.m
//  ParkingSpace
//
//  Created by 那道 on 2018/5/28.
//  Copyright © 2018年 LWH. All rights reserved.
//

#import "PSLoginViewController.h"
#import "PSRegistViewController.h"
#import "PSForgetPswViewController.h"

@interface PSLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView  *titleView;
@property (nonatomic, strong) UIView  *phoneView;
@property (nonatomic, weak) UITextField *phoneField;
@property (nonatomic, strong) UIView  *pswView;
@property (nonatomic, weak) UITextField *pswField;

@property (nonatomic, strong) UIButton  *finishBtn;

@end

@implementation PSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WhiteColor;
    
//    [self titleView];
    self.navigationItem.title = @"密码登录";
    [self finishBtn];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
//    self.navigationController.navigationBar.barTintColor = TableColor;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];

//    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - 返回
- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 登录
- (void)clickLogin
{
    
    NSString *phone = [self.phoneField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL isPhone = phone.length==11;
    
    if (!isPhone) {
        [CommonMethod altermethord:@"你输入的号码不正确，请输入重新输入" andmessagestr:@"" andconcelstr:@"确定"];
        return;
    }

    LoginReq *req =[LoginReq new];
    req.account = phone;
    req.tel = phone;
    req.passwd = [self.pswField.text md5_32bit];
//    1-》手机密码 2-》手机验证码 3-》第三方
    req.flag = @"1";
    
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
#pragma mark - 忘记密码
- (void)clickForgetPsw
{
    [self.navigationController pushViewController:[PSForgetPswViewController new] animated:YES];
}

#pragma mark - 立即注册
- (void)clickRegist
{
    [self.navigationController pushViewController:[PSRegistViewController new] animated:YES];
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
        
        UILabel *titleLbl = [UILabel labelWithText:@"登录" font:ZF_FONT(17) textColor:BlackColor backGroundColor:ClearColor superView:_titleView];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
        
        UIButton *cancleBtn = [UIButton buttonWithImage:@"cha_dl" target:self action:@selector(clickBack) showView:_titleView];
        cancleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        cancleBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, WScale(10));
        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(0);
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
            make.top.mas_equalTo(HScale(115));
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

- (UIView *)pswView
{
    if (!_pswView) {
        
        _pswView = [UIView viewWithBackgroundColor:WhiteColor superView:self.view];
        [_pswView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.phoneView.mas_bottom);
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

- (UIButton *)finishBtn
{
    if (!_finishBtn) {
        
        UIButton *forgetBtn = [UIButton buttonWithTitle:@"忘记密码" font:ZF_FONT(12) titleColor:UIColorFromRGB(0x888a96) backGroundColor:ClearColor buttonTag:0 target:self action:@selector(clickForgetPsw) showView:self.view];
        [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.phoneView.mas_left);
            make.top.mas_equalTo(self.pswView.mas_bottom);
            make.height.mas_equalTo(HScale(40));
        }];
        
//        UIButton *registBtn = [UIButton buttonWithTitle:@"立即注册" font:ZF_FONT(12) titleColor:HEXCOLOR(@"#DA3B31") backGroundColor:ClearColor buttonTag:0 target:self action:@selector(clickRegist) showView:self.view];
//        [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(self.phoneView.mas_right);
//            make.top.height.mas_equalTo(forgetBtn);
//        }];
        
        _finishBtn = [UIButton buttonWithTitle:@"登录" font:ZF_FONT(14) titleColor:WhiteColor backGroundColor:ClearColor buttonTag:0 target:self action:@selector(clickLogin) showView:self.view];
        [_finishBtn setBackgroundImage:[UIImage imageNamed:@"button_dlzc"] forState:0];
        _finishBtn.backgroundColor = HEXCOLOR(@"#DA3B31");
        _finishBtn.clipsToBounds = YES;
        _finishBtn.layer.cornerRadius = 24;
        [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(forgetBtn.mas_bottom).mas_equalTo(HScale(30));
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

@end
