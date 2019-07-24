//
//  SettingVC.m
//  CLTravel
//
//  Created by MOOSON_ on 2018/10/26.
//  Copyright © 2018年 MOOSON_. All rights reserved.
//

#import "SettingVC.h"
#import "AllAddressVC.h"
#import "PSForgetPswViewController.h"
#import "ChangeNicknameVC.h"
#import "MyDeviceVC.h"
#import "AboutUsVC.h"
//#import <SDImageCache.h>
//#import "UIImageView+WebCache.h"
//#import "UIButton+WebCache.h"
#import "SDImageCache.h"
@interface SettingVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *titleArr;
    
}
@property (weak, nonatomic) IBOutlet UITableView *settingTableView;
@property(nonatomic,strong)NSString *memery;
@end

@implementation SettingVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    [self requestMacReLogin];
    [self.settingTableView reloadData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    //偏移问题
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.navigationController.navigationBar.backgroundColor = NavColor;
    [self setNavItem];
    titleArr = @[@[@"昵称",@"手机号"],@[@"地址管理",@"清除缓存",@"关于我们"]];
    
    [self.settingTableView registerNib:[UINib nibWithNibName:@"SetSwitchCell" bundle:nil] forCellReuseIdentifier:@"SetSwitchCell"];
    
}
- (void)setNavItem{

    self.title= @"设置";
    self.settingTableView.backgroundColor = HEXCOLOR(@"#f2f2f2");
    self.settingTableView.rowHeight = 44;
    self.settingTableView.tableFooterView = [self tableFootView];
    
//    //计算缓存大小
  NSUInteger intg = [[SDImageCache sharedImageCache] totalDiskSize];
    
  NSString * currentVolum = [NSString stringWithFormat:@"%@",[self fileSizeWithInterge:intg]];
    _memery = currentVolum;
}
- (UIView *)tableFootView{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.backgroundColor = [UIColor whiteColor];
    but.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    [but setTitle:@"退出登录" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(logOutClick:) forControlEvents:UIControlEventTouchUpInside];
    [but setTitleColor:HEXCOLOR(@"#323337") forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [view addSubview:but];
    return but;
}
//MARK:-----退出登录
- (void)logOutClick:(UIButton *)sender{
    
    UIAlertController * altController = [UIAlertController alertControllerWithTitle:@"是否退出账号" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [altController addAction:cancelAction];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
        [cancelAction setValue:[UIColor grayColor] forKey:@"titleTextColor"];
    }
    UIAlertAction * yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self logOut];
    }];
    
    [altController addAction:yesAction];
    [self presentViewController:altController animated:YES completion:nil];
    
}
- (void)logOut{
    [self requestCustomerlogout];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    view.backgroundColor = HEXCOLOR(@"#f2f2f2");
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == titleArr.count - 1) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
        view.backgroundColor = HEXCOLOR(@"#f2f2f2");
        return view;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == titleArr.count - 1) {
        return 15;
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    return 15;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return titleArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr =titleArr[section];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [cell.textLabel setTextColor:HEXCOLOR(@"#404040")];
    cell.textLabel.text = titleArr[indexPath.section][indexPath.row];
//    [self.nameLabel setText:[NSString stringWithFormat:@"您当前的手机号为：%@",[NSString showPhoneNumberWithNumber:ACCOUNTINFO.userInfo.phone]]];
 
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
       
          for (UIView *subview in [cell.contentView subviews]){
              [subview removeFromSuperview];
          }
            UILabel *phonelab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 130, 0, 100, 44)];
            phonelab.text = [Save userName];
            phonelab.textColor =HEXCOLOR(@"#CCCCCC");
            phonelab.font = [UIFont systemFontOfSize:14];
            phonelab.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:phonelab];
        }else{
            UILabel *phonelab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 130, 0, 100, 44)];
            phonelab.text = [Save userPhone];
            phonelab.textColor =HEXCOLOR(@"#CCCCCC");
            phonelab.font = [UIFont systemFontOfSize:14];
            phonelab.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:phonelab];
        }
    }else{
        if (indexPath.row == 1) {
            //清除缓存
            for (UIView *subview in [cell.contentView subviews]){
                [subview removeFromSuperview];
            }
            UILabel *phonelab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 130, 0, 100, 44)];
            phonelab.text = _memery;
            
            phonelab.textColor =HEXCOLOR(@"#CCCCCC");
            phonelab.font = [UIFont systemFontOfSize:14];
            phonelab.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:phonelab];
        
        }
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
       
        if (indexPath.row == 0) {
            //修改昵称
            ChangeNicknameVC *vc = [[ChangeNicknameVC alloc]initWithNibName:@"ChangeNicknameVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else{
        //
        if (indexPath.row == 0) {
            //收货地址
            AllAddressVC *vc = [[AllAddressVC alloc]initWithNibName:@"AllAddressVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 1){
            //清除缓存
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
            _memery = @"0B";
            [_settingTableView reloadData];
        }else{
            //关于我们
            AboutUsVC *vc= [[AboutUsVC alloc]initWithNibName:@"AboutUsVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
         
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//计算出大小
- (NSString *)fileSizeWithInterge:(NSInteger)size{
    // 1k = 1024, 1m = 1024k
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat aFloat = size/1024;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.1fM",aFloat];
    }else{
        CGFloat aFloat = size/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.1fG",aFloat];
    }
}
-(void)requestCustomerlogout{
    
    [Save saveUser:[User new]];
    [self.navigationController popViewControllerAnimated:YES];
    ACCOUNTINFO.userInfo = nil;
    ACCOUNTINFO.isLogin = NO;
//    LoginOutReq *req = [LoginOutReq new];
//    NSString *uid = [PublicManager getLocalUserId];
//    NSString *phone = [PublicManager getLocalPhone];
//    NSString *token = [PublicManager getLocalToken];
//    req.phone = phone;
//    req.token = token;
//    req.userId = uid;
//    [[HTTPRequest sharedManager]requestDataWithApiName:customerlogout withParameters:req isEnable:YES withSuccess:^(id responseObject) {
//
//
//    } withError:^(NSError *error) {
//
//    }];
//    [NetWorkReqManager requestDataWithApiName:customerlogout params:req response:^(NSDictionary *responseObject) {
//        BaseResponse *rsp = [BaseResponse mj_objectWithKeyValues:responseObject];
//        if (rsp.code == 1) {
//            [QuHudHelper qu_showMessage:rsp.msg];
//            //移除推送标签
////            NSString *identifier = [NSString stringWithFormat:@"%@_1",[PublicManager getLocalPhone]];
////            [[XGPushTokenManager defaultTokenManager]unbindWithIdentifer:identifier type:XGPushTokenBindTypeAccount];
////            //停止推送
////            [[XGPush defaultManager]stopXGNotification];
//
//            ACCOUNTINFO.userInfo = nil;
//            ACCOUNTINFO.isLogin = NO;
//            [PublicManager removelocalUserId];
//            [PublicManager removelocalPhone];
//            [PublicManager removelocalToken];
//            [self.navigationController popViewControllerAnimated:YES];
//            if (self.loginoutBlock) {
//                self.loginoutBlock();
//            }
//        }else{
//            [QuHudHelper qu_showMessage:rsp.msg];
//        }
//    } errorResponse:^(NSString *error) {
//
//    }];
}
-(void)requestMacReLogin{
    BaseRequest *req = [BaseRequest new];
    req.customer_id = [Save userID];
    
    [[HTTPRequest sharedManager]requestDataWithApiName:macReLogin withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        User *user = [User mj_objectWithKeyValues:responseObject[@"data"]];
        [Save saveUser:user];
        [self.settingTableView reloadData];

    } withError:^(NSError *error) {
        
    }];
}
@end
