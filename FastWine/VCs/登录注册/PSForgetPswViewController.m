//
//  PSForgetPswViewController.m
//  ParkingSpace
//
//  Created by 那道 on 2018/5/28.
//  Copyright © 2018年 LWH. All rights reserved.
//

#import "PSForgetPswViewController.h"
#import "Save.h"
@interface PSForgetPswViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView  *bgView;
@property (nonatomic, strong) UIView  *phoneView;
@property (nonatomic, weak) UITextField *phoneField;

@property (nonatomic, strong) UIView  *verifyView;
@property (nonatomic, weak) UITextField *verifyField;

@property (nonatomic, strong) UIView  *pswView;
@property (nonatomic, weak) UITextField *pswField;


@property (nonatomic, strong) UIButton  *finishBtn;

@end

@implementation PSForgetPswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"忘记密码";

    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = TableColor;
    
    [self finishBtn];
}

- (void)setIsChangePsw:(BOOL)isChangePsw
{
    _isChangePsw = isChangePsw;
    [self.finishBtn setTitle:@"确认修改" forState:0];
    
    self.navigationItem.title = @"修改密码";
    
    self.phoneField.text = [NSString stringWithFormat:@"%@", [Save userPhone]];
    self.phoneField.userInteractionEnabled = NO;
}

#pragma mark - 发送验证码
- (void)clickVerify:(UIButton *)sender
{
    NSString *phone = [self.phoneField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL isPhone = phone.length==11;
    
    if (!isPhone) {
        [CommonMethod altermethord:@"请输入正确的11位手机号" andmessagestr:@"" andconcelstr:@"确定"];
        return;
    }
    GetCodeReq *req = [GetCodeReq new];
    req.phone = phone;
    [[HTTPRequest sharedManager]requestDataWithApiName:getCodeTwo withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        NSLog(@"验证码发送成功");
        [self.verifyField becomeFirstResponder];
        [CommonMethod GetVerificationCode:sender finish:nil];
    } withError:^(NSError *error) {
        
    }];
  
}

#pragma mark - 完成
- (void)clickFinish
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
        else if (!isPSW)
        {
            tip = @"密码需要6~20位";
        }
        [CommonMethod altermethord:tip andmessagestr:@"" andconcelstr:@"确定"];
        return;
    }
    
    NSDictionary *paraDict = @{
                               @"customer_id":[Save userID],
                               @"new_pass":self.pswField.text,
                               @"code":verify,
                               };
    
    [[HTTPRequest sharedManager] requestDataWithParameters:paraDict urlString:@"ChangePwd" isEnable:NO withSuccess:^(id responseObject) {
        
        [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        });
    } withError:nil];
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

- (UIView *)bgView
{
    if (!_bgView) {
        
        _bgView = [UIView viewWithBackgroundColor:WhiteColor superView:self.view];
        _bgView.layer.cornerRadius = HScale(5);
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WScale(10));
            make.top.mas_equalTo(HScale(10)+SafeAreaTopHeight);
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(HScale(150));
        }];
        
        [self pswView];
    }
    return _bgView;
}

- (UIView *)phoneView
{
    if (!_phoneView) {
        
        _phoneView = [UIView viewWithBackgroundColor:WhiteColor superView:self.bgView];
        [_phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.left.top.mas_equalTo(0);
            make.height.mas_equalTo(HScale(50));
        }];
        
        UILabel *leftLbl = [UILabel labelWithText:@"手机号" font:ZF_FONT(14) textColor:BlackColor backGroundColor:ClearColor superView:_phoneView];
        [leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WScale(7));
            make.centerY.mas_equalTo(0);
        }];
        
        UITextField *field = [[UITextField alloc]init];
        field.delegate = self;
        field.textAlignment = NSTextAlignmentRight;
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
            make.right.mas_equalTo(-WScale(7));
            make.left.mas_equalTo(leftLbl.mas_right).mas_equalTo(WScale(10));
            make.bottom.top.mas_equalTo(0);
        }];
        
        self.phoneField = field;
        
        UIView *line = [UIView viewWithBackgroundColor:SeparatorCOLOR superView:_phoneView];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.mas_equalTo(0);
            make.left.mas_equalTo(WScale(7));
            make.height.mas_equalTo(0.5);
        }];
    }
    return _phoneView;
}

- (UIView *)verifyView
{
    if (!_verifyView) {
        
        _verifyView = [UIView viewWithBackgroundColor:WhiteColor superView:self.bgView];
        [_verifyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerX.height.mas_equalTo(self.phoneView);
            make.top.mas_equalTo(self.phoneView.mas_bottom);
        }];
        
        UIButton *verifyBtn = [UIButton buttonWithTitle:@"发送验证码" font:ZF_FONT(14) titleColor:ThemeColor backGroundColor:ClearColor buttonTag:0 target:self action:@selector(clickVerify:) showView:_verifyView];
        CGFloat width = [NSString sizeWithText:verifyBtn.currentTitle font:ZF_FONT(14) maxSize:CGSizeMake(MAXFLOAT, HScale(20))].width+WScale(10);
        verifyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        verifyBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, WScale(7));
        [verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(width);
        }];
        
        UITextField *field = [[UITextField alloc]init];
        field.delegate = self;
        field.returnKeyType = UIReturnKeyDone;
        field.keyboardType = UIKeyboardTypeNumberPad;
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.textColor = BlackColor;
        field.font = ZF_FONT(14);
        field.placeholder = @"验证码";
        [field setValue:UIColorFromRGB(0xd9dce8) forKeyPath:@"_placeholderLabel.textColor"];
        [field setValue:ZF_FONT(14) forKeyPath:@"_placeholderLabel.font"];
        [_verifyView addSubview:field];
        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WScale(7));
            make.right.mas_equalTo(verifyBtn.mas_left).mas_equalTo(-WScale(10));
            make.bottom.top.mas_equalTo(0);
        }];
        
        UIView *line = [UIView viewWithBackgroundColor:SeparatorCOLOR superView:_verifyView];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.mas_equalTo(0);
            make.left.mas_equalTo(WScale(7));
            make.height.mas_equalTo(0.5);
        }];
        
        self.verifyField = field;
    }
    return _verifyView;
}

- (UIView *)pswView
{
    if (!_pswView) {
        
        _pswView = [UIView viewWithBackgroundColor:WhiteColor superView:self.bgView];
        [_pswView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerX.height.mas_equalTo(self.phoneView);
            make.top.mas_equalTo(self.verifyView.mas_bottom);
        }];
        
        UITextField *field = [[UITextField alloc]init];
        field.delegate = self;
        field.returnKeyType = UIReturnKeyDone;
        field.keyboardType = UIKeyboardTypeEmailAddress;
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.textColor = BlackColor;
        field.font = ZF_FONT(14);
        field.placeholder = @"新密码";
        [field setValue:UIColorFromRGB(0xd9dce8) forKeyPath:@"_placeholderLabel.textColor"];
        [field setValue:ZF_FONT(14) forKeyPath:@"_placeholderLabel.font"];
        [_pswView addSubview:field];
        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WScale(7));
            make.centerX.bottom.top.mas_equalTo(0);
        }];
        
        self.pswField = field;
    }
    return _pswView;
}

- (UIButton *)finishBtn
{
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithTitle:@"完成" font:ZF_FONT(14) titleColor:WhiteColor backGroundColor:ClearColor buttonTag:0 target:self action:@selector(clickFinish) showView:self.view];
        [_finishBtn setBackgroundImage:[UIImage imageNamed:@"button_wjmm"] forState:0];
        _finishBtn.backgroundColor = HEXCOLOR(@"#DA3B31");
        _finishBtn.clipsToBounds = YES;
        _finishBtn.layer.cornerRadius = 24;
        [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgView.mas_bottom).mas_equalTo(HScale(55));
            make.left.mas_equalTo(WScale(40));
            make.height.mas_equalTo(HScale(40));
            make.centerX.mas_equalTo(0);
        }];
    }
    return _finishBtn;
}


@end
