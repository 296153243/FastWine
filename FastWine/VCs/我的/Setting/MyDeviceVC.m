//
//  MyDeviceVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/4/17.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "MyDeviceVC.h"

@interface MyDeviceVC ()
@property (weak, nonatomic) IBOutlet UILabel *ibNameLab;
@property (weak, nonatomic) IBOutlet UIView *ibDeviceView;

@end

@implementation MyDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的设备";
    if ([Save odb_macid].length > 0) {
        _ibDeviceView.hidden = NO;
        _ibNameLab.text = [Save odb_macid];
    }
}
- (IBAction)ibJiechuBangding:(id)sender {
    [self requestunBindMac];
}
-(void)requestunBindMac{
    BindingObdReq *req = [BindingObdReq new];
    req.customer_id = [Save userID];
    req.obd_macid = [Save odb_macid];
    
    [[HTTPRequest sharedManager]requestDataWithApiName:unbindMac withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
        [self.navigationController popViewControllerAnimated:YES];
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
