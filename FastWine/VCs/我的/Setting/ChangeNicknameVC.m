//
//  ChangeNicknameVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/3/18.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "ChangeNicknameVC.h"

@interface ChangeNicknameVC ()
@property (weak, nonatomic) IBOutlet UITextField *ibNameTf;

@end

@implementation ChangeNicknameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改昵称";
      self.navigationItem.rightBarButtonItem = [UIBarButtonItem rightItemWithTitle:@"保存" Target:self action:@selector(saveNikeName)];
}
-(void)saveNikeName{
    
    if (_ibNameTf.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入有效的昵称"];
        return ;
    }
    [self requestCustomerupdateInformation:_ibNameTf.text];
}
-(void)requestCustomerupdateInformation:(NSString *)str{
    UserInfoUploadImgReq *req = [UserInfoUploadImgReq new];
    req.type = @"2";
    req.nickname = str;
    [[HTTPRequest sharedManager]requestDataWithApiName:customerupdateInformation withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        [QuHudHelper qu_showMessage:@"修改成功"];
        [self requestUserInfo];
        [self performSelector:@selector(popBack) withObject:nil afterDelay:0.5];
      
    } withError:^(NSError *error) {
        
    }];
}
-(void)popBack{
      [self.navigationController popViewControllerAnimated:YES];
}
//MARK:----获取个人信息
-(void)requestUserInfo{
    [[HTTPRequest sharedManager]requesGetDataWithApiName:getInformation withParameters:nil isEnable:YES withSuccess:^(id responseObject) {
        
        User *user = [User mj_objectWithKeyValues:responseObject[@"data"][@"user_info"]];
        [Save saveUser:user];
        
        QuUserInfo *userInfo = [QuUserInfo mj_objectWithKeyValues:responseObject[@"data"][@"user_info"]];
        ACCOUNTINFO.userInfo = userInfo;
        
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
