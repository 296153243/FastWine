//
//  AddressShowTableViewController.m
//  EricProject
//
//  Created by boosal on 17/3/20.
//  Copyright © 2017年 enzuo. All rights reserved.
//

#import "AddressShowTableViewController.h"
#import "Create_EditTableViewCell.h"
#import "EPAddressModel.h"
//#import "AddressPickerV.h"
#import "AddressPickerView.h"

@interface AddressShowTableViewController ()<UITextFieldDelegate,AddressPickerViewDelegate,UITextViewDelegate> {
    NSArray *textArray;
    BOOL isDefault;
}
@property (nonatomic, strong) AddressPickerView *addresspickerView;
@property(nonatomic,strong)AddMyAddressReq *myAddressReq;
@property(nonatomic,strong)NSString *province;
@property (nonatomic,strong)NSString *is_default;
@property (nonatomic,strong)NSString *detail;
@property (nonatomic,strong)NSString *post_code;
@property (nonatomic,strong)NSString *district;
@property (nonatomic,strong)NSString *real_name;
@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *regionStr;
@property (nonatomic,strong)NSString *region;

@end

static NSString *identifier = @"address_cell";

@implementation AddressShowTableViewController

-(instancetype)initWithPageType:(page_Type)pageType {
    if (pageType == Address_Edit) {
        self.title = @"编辑地址";
    }else
        self.title = @"新建地址";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavView];
    _myAddressReq = [AddMyAddressReq new];
    _myAddressReq.is_default = @"0";
    if (_epaddressModel != nil) {
        _regionStr = [NSString stringWithFormat:@"%@%@",_epaddressModel.province,_epaddressModel.city];
        
    }

}

-(void)initNavView {

   self.navigationItem.rightBarButtonItem = [UIBarButtonItem rightItemWithTitle:@"保存" Target:self action:@selector(saveAddressMsg)];
    
    isDefault = NO;
    textArray = @[@"姓名",@"手机号码",@"省份、城市、区县",@"详细地址，如街道、牌楼号等"];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 84, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = TableView_bgColor;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"Create_EditTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];


}

-(void)saveAddressMsg {
    NSLog(@"保存地址信息");
    if ( _myAddressReq.real_name == nil ) {
        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        return;
    }
    if ( _myAddressReq.phone == nil || _myAddressReq.phone.length != 11 ) {
        
        [QuHudHelper qu_showMessage:@"请输入正确的手机号"];
        return;
        
    }
    if ( _regionStr == nil ) {
        [SVProgressHUD showErrorWithStatus:@"请选择地区"];
        [QuHudHelper qu_showMessage:@"请选择地区"];
        
        
        return;
    }
    if ( _myAddressReq.detail == nil ) {
        [QuHudHelper qu_showMessage:@"请输入详细地址"];
        return;
    }
    
    [self addAddressRequest];

}
- (void)addAddressRequest{
    
    _myAddressReq.id = @"";
    _myAddressReq.region = _region;
    _myAddressReq.city = _city;
    _myAddressReq.district = _district;
//    _myAddressReq.is_default
    _myAddressReq.post_code = @"215100";
//    if (_regionStr != nil) {
//        _myAddressReq.region = _regionStr;
//    }
    XQApiName apiName;
    if (_epaddressModel != nil) {
        //编辑
        apiName = editAddress;
        _myAddressReq.id = _epaddressModel.id;
        
    }else {
        //新增
        apiName = editAddress;
    }
        
    [[HTTPRequest sharedManager]requestDataWithApiName:apiName withParameters:_myAddressReq isEnable:YES withSuccess:^(id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    } withError:^(NSError *error) {
        
    }];
  
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        return 120;
    }
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([self.title isEqualToString:@"编辑地址"]) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.title isEqualToString:@"编辑地址"]) {
        if (section == 0) {
            return 5;
        }
        return 1;
    }
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 12;
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12)];
        view.backgroundColor = TableView_bgColor;
        return view;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

     Create_EditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Create_EditTableViewCell"];
    if (indexPath.section == 0) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"Create_EditTableViewCell" owner:nil options:nil][0];
            if (indexPath.row == 0) {
                cell.ibTitleLab.text = @"收货人";
                if (_epaddressModel != nil) {
                    cell.textField.text = _epaddressModel.real_name;
                    _myAddressReq.real_name = _epaddressModel.real_name;

                }
                
                [cell.textField addTarget:self action:@selector(nameTfChange:) forControlEvents:UIControlEventEditingChanged];
            }else{
                cell.ibTitleLab.text = @"手机号码";
                cell.textField.placeholder = @"请输入手机号码";
                cell.textField.keyboardType = UIKeyboardTypePhonePad;
                if (_epaddressModel != nil) {
                    cell.textField.text = _epaddressModel.phone;
                    _myAddressReq.phone = _epaddressModel.phone;
                    
                }
                [cell.textField addTarget:self action:@selector(phoneTfChange:) forControlEvents:UIControlEventEditingChanged];
            }
        }else if (indexPath.row == 2){
            cell = [[NSBundle mainBundle]loadNibNamed:@"Create_EditTableViewCell" owner:nil options:nil][1];
       
                cell.ibAddressLab.text = _regionStr;


        }else if (indexPath.row == 3){
            cell = [[NSBundle mainBundle]loadNibNamed:@"Create_EditTableViewCell" owner:nil options:nil][2];
            if (_epaddressModel != nil) {
                cell.ibAddressDtalisTV.text = _epaddressModel.detail;
                _myAddressReq.detail = _epaddressModel.detail;
                
            }
            cell.ibAddressDtalisTV.delegate = self;
            cell.ibAddressDtalisTV.placeholder = @"请输入详细地址，如道路，门牌号等";
            cell.ibAddressDtalisTV.placeholderColor = RGBCOLOR(199, 199, 204);
          
            weakSelf(weakSelf);
            cell.ibAddressDtalisTV.textViewTextBlock = ^(NSString * _Nonnull textViewtextStr) {
                weakSelf.myAddressReq.detail = textViewtextStr;
            };
            
        }else if(indexPath.row == 4){
            cell = [[NSBundle mainBundle]loadNibNamed:@"Create_EditTableViewCell" owner:nil options:nil][3];
            if (_epaddressModel != nil) {
                if ([_epaddressModel.is_default integerValue] == 1) {
                    [cell.ibSwitch setOn:YES animated:YES];
                    _myAddressReq.is_default = @"1";
                }else{
                    [cell.ibSwitch setOn:NO animated:YES];
                    _myAddressReq.is_default = @"0";
                }
                
            }
            [cell.ibSwitch setTintColor:HEXCOLOR(@"0x99999")];
            [cell.ibSwitch setOnTintColor:RGBCOLOR(48, 155, 230)];
            //        [cell.ibSwitch setThumbTintColor:[UIColor whiteColor]];
            cell.ibSwitch.layer.cornerRadius = 15.5f;
            cell.ibSwitch.layer.masksToBounds = YES;
            [cell.ibSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            
        }
    }else {
          cell = [[NSBundle mainBundle]loadNibNamed:@"Create_EditTableViewCell" owner:nil options:nil][4];
    }
    
    return cell;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 2) {
        //去选择地址
        [self.view endEditing:YES];
        _addresspickerView= [[AddressPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 80)];
        _addresspickerView.delegate = self;
        _addresspickerView.backMaskAlpha = 0.2;
        [_addresspickerView setTitleHeight:60 pickerViewHeight:165];
        
        // 关闭默认支持打开上次的结果
        //            _pickerView.isAutoOpenLast = NO;
        //        [self.view addSubview:self.addresspickerView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.addresspickerView];
        [self.addresspickerView show];
    }
    if ( indexPath.section == 1 && indexPath.row == 0) {
       //删除地址
        DeleteAddressReq *req = [DeleteAddressReq new];
//        req.customer_id = [Save userID];
        req.addressId = _epaddressModel.id;
        [[HTTPRequest sharedManager]requestDataWithApiName:deleteAddress withParameters:req isEnable:YES withSuccess:^(id responseObject) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
            [self performSelector:@selector(goback) withObject:nil afterDelay:1];
        } withError:^(NSError *error) {
            
        }];
    }
}
-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)nameTfChange:(UITextField *)sender{
    _myAddressReq.real_name = sender.text;
}
- (void)phoneTfChange:(UITextField *)sender{
    _myAddressReq.phone = sender.text;
}
- (void)switchAction:(UISwitch *)sender{
    if (sender.isOn == YES) {
        _myAddressReq.is_default = @"1";
    }else{
        _myAddressReq.is_default = @"0";
    }
}
#pragma mark - AddressPickerViewDelegate
- (void)cancelBtnClick{
//    NSLog(@"点击了取消按钮");
//    [self btnClick:_addressBtn];
    [self.addresspickerView hide];
}
- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area cityCode:(NSInteger )code{
//    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",province,city,area];
//    [self btnClick:_addressBtn];
    [self.addresspickerView hide];
    _province = province;
    _city = city;
    _district = area;
    _regionStr = [NSString stringWithFormat:@"%@%@%@",province,city,area];
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@%@",province,city,area]);

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}


@end
