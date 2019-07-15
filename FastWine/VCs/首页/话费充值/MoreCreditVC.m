
//
//  MoreCreditVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/4/16.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "MoreCreditVC.h"
#import "OrderpayTypeVC.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "MoreCreditRecordVC.h"
#define Line_Num  3 //行个数
#define Start_X   (SCREEN_WIDTH - Button_Width * Line_Num)/4       // X
#define Start_Y 0.0f           // Y
#define Width_Space (SCREEN_WIDTH - Button_Width * Line_Num)/4       // 横间距
#define Height_Space 10.0f      // 竖间距
#define Button_Height 64.0f    // 高
#define Button_Width 104.0f      // 宽
@interface MoreCreditVC ()<CNContactPickerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ibPhoneTf;
@property (weak, nonatomic) IBOutlet UIView *ibPicView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibPicViewH;
@property(nonatomic,strong)ChargPicListRsp * dataRsp;
@property(nonatomic,strong)NSString *amount;
@property(nonatomic,strong)PicListButton *markBtn;

@end

@implementation MoreCreditVC
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.view endEditing:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"话费充值";
    [self requestTelephone_note];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem rightItemWithTitle:@"记录" Target:self action:@selector(moreCreditRecord)];
}
-(void)moreCreditRecord{
    MoreCreditRecordVC  *vc = [[MoreCreditRecordVC alloc]initWithNibName:@"MoreCreditRecordVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)loadPicView{
    
    //改变高度
    NSString *stringInt = [NSString stringWithFormat:@"%ld",_dataRsp.data.count];
    _ibPicViewH.constant = (ceil([stringInt floatValue]/Line_Num) * Button_Height) + (ceil([stringInt floatValue]/Line_Num) - 1) * Height_Space;
    
    for (int i = 0 ; i < _dataRsp.data.count; i++) {
        NSInteger col = i % Line_Num;
        NSInteger row = i / Line_Num;
        PicListButton *aBt = [[PicListButton alloc]initWithFrame:CGRectMake(col * (Button_Width + Width_Space) + Start_X, row  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height)];
        aBt.tag = i;
        [aBt addTarget:self action:@selector(ibAmountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i < _dataRsp.data.count) {
            ChargPicListModel *model = self.dataRsp.data[i];
            aBt.titleStr =  [NSString stringWithFormat:@"%@元",model.old_money];
            aBt.subtitleStr = [NSString stringWithFormat:@"售价:%@元",model.money];
        }
//        if (i == 0) {
//            _ibAmountOne = aBt;
//            //默认第一个
//            [UIButton addBtnGradualChange:_ibAmountOne withcornerRadius:10];
//            [_ibAmountOne setTitleColor:HEXCOLOR(@"#FFFFFF") forState:UIControlStateNormal];
//            ChargPicListModel *model = self.dataRsp.data[i];
//            _amount = model.targetValue;
//            _markBtn = _ibAmountOne;
//        }
        [self.ibPicView addSubview:aBt];
      
    }
    
}
- (void)ibAmountBtnClick:(PicListButton *)sender {
    
    ChargPicListModel * model = self.dataRsp.data[sender.tag];
    _amount = model.money;
    [self requestphonecheck];
}
- (IBAction)ibAddressBookBtnClick:(id)sender {
    // 1.创建选择联系人的控制器
    CNContactPickerViewController *contactVc = [[CNContactPickerViewController alloc] init];
    // 2.设置代理
    contactVc.delegate = self;
    // 3.弹出控制器
    [self presentViewController:contactVc animated:YES completion:nil];
    
  
}
#pragma mark - <CNContactPickerDelegate>
// 当选中某一个联系人时会执行该方法
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    // 1.获取联系人的姓名
    NSString *lastname = contact.familyName;
    NSString *firstname = contact.givenName;
    NSLog(@"%@ %@", lastname, firstname);
    
    // 2.获取联系人的电话号码
    NSArray *phoneNums = contact.phoneNumbers;
    for (CNLabeledValue *labeledValue in phoneNums) {
        // 2.1.获取电话号码的KEY
        NSString *phoneLabel = labeledValue.label;
        
        // 2.2.获取电话号码
        CNPhoneNumber *phoneNumer = labeledValue.value;
        NSString *phoneValue = phoneNumer.stringValue;
     
        //去掉电话中的特殊字符
        phoneValue = [phoneValue stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        phoneValue = [phoneValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
        phoneValue = [phoneValue stringByReplacingOccurrencesOfString:@"(" withString:@""];
        phoneValue = [phoneValue stringByReplacingOccurrencesOfString:@")" withString:@""];
        phoneValue = [phoneValue stringByReplacingOccurrencesOfString:@" " withString:@""];
        phoneValue = [phoneValue stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        self.ibPhoneTf.text = phoneValue;
    }
}

// 当选中某一个联系人的某一个属性时会执行该方法
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
}

// 点击了取消按钮会执行该方法
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
}
-(void)requestTelephone_note{
    
    [[HTTPRequest sharedManager]requestDataWithApiName:phoneNote withParameters:nil isEnable:YES withSuccess:^(id responseObject) {
        self.dataRsp = [ChargPicListRsp mj_objectWithKeyValues:responseObject];
        [self loadPicView];
    } withError:^(NSError *error) {
        
    }];
    
}
-(void)requestphonecheck{
    PhoneCheckReq *req = [PhoneCheckReq new];
    req.telephone = self.ibPhoneTf.text;
    req.pervalue  = _amount;
    [[HTTPRequest sharedManager]requestDataWithApiName:phonecheck withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        BaseResponse *rsp = [BaseResponse mj_objectWithKeyValues:responseObject];
        if (rsp.code == 0) {
            [self requestphoneMakeorder];
        }else{
            [QuHudHelper qu_showMessage:rsp.msg];
        }
    } withError:^(NSError *error) {
        
    }];
    
}
-(void)requestphoneMakeorder{
    PhoneCheckReq *req = [PhoneCheckReq new];
    req.telephone = self.ibPhoneTf.text;
    req.pervalue  = _amount;
    req.userid = [Save userID];
    [[HTTPRequest sharedManager]requestDataWithApiName:phoneMakeorder withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        BaseResponse *rsp = [BaseResponse mj_objectWithKeyValues:responseObject];
        if (rsp.code == 0) {
            OrderpayTypeVC *vc = [[OrderpayTypeVC alloc]initWithNibName:@"OrderpayTypeVC" bundle:nil];
            vc.orderId = responseObject[@"data"];
            vc.pic = self.amount;
            vc.isTopUp = YES;
            vc.apiName = phoneGoodspay;
            vc.updateOrderApiName = phoneUpdateorder;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [QuHudHelper qu_showMessage:rsp.msg];
        }
    } withError:^(NSError *error) {
        
    }];
    
}



@end
