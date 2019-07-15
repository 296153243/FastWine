//
//  IhaveGoodsVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/6/27.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "IhaveGoodsVC.h"

@interface IhaveGoodsVC ()
@property (weak, nonatomic) IBOutlet UITextField *ibNameTf;
@property (weak, nonatomic) IBOutlet UITextField *ibUserName;
@property (weak, nonatomic) IBOutlet UITextField *ibUserPhone;
@property (weak, nonatomic) IBOutlet UITextField *ibClassTf;
@property (weak, nonatomic) IBOutlet UITextView *ibTextV;
@property (weak, nonatomic) IBOutlet UILabel *ibPlaceHoderlab;

@end

@implementation IhaveGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我有好货";
}
 #pragma mark - 监听输入框
 - (void)textViewDidChange:(UITextView *)textView{
        if (!textView.text.length) {
                 self.ibPlaceHoderlab.alpha = 1;
             }else{
                self.ibPlaceHoderlab.alpha = 0;
           }
     }
- (IBAction)ibphoneAction:(id)sender {
    [PublicManager callPhoneWithNumber:@"0512-66158078"];

}


- (IBAction)ibCommitAction:(id)sender {
    if (_ibNameTf.text.length == 0) {
         [QuHudHelper qu_showMessage:@"请输入公司名称或者商品品"];
        return;

    }else if (_ibUserName.text.length == 0){
         [QuHudHelper qu_showMessage:@"请输入您的姓名"];
        return;

    }else if (_ibUserPhone.text.length == 0){
        [QuHudHelper qu_showMessage:@"请输入您的电话"];
        
        return;
    }else if (_ibUserName.text.length == 0){
        [QuHudHelper qu_showMessage:@"请输入您货源种类"];
        return;

    }
    [self request];
}


//TODO:----------
- (void)request{
    IhavegoodsReq *req = [IhavegoodsReq new];
    req.phone = _ibUserPhone.text;
    req.model_type = _ibClassTf.text;
    req.com_name = _ibNameTf.text;
    req.name = _ibUserName.text;
    req.content = _ibTextV.text;
    [[HTTPRequest sharedManager]requestDataWithApiName:set_cooperate withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        
        [QuHudHelper qu_showMessage:responseObject[@"msg"]];
        [self performSelector:@selector(backAction) withObject:nil afterDelay:1.0];
        
    } withError:^(NSError *error) {
        
    }];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
