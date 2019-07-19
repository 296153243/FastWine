//
//  PlaceOrderVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/3/29.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "PlaceOrderVC.h"
#import "PlaceOrderCell.h"
#import "AllAddressVC.h"
#import "EPAddressModel.h"
#import "OrderpayTypeVC.h"
#import "CouPonCell.h"
#import "MyOrderVC.h"
@interface PlaceOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *ibAllPicLab;
@property (weak, nonatomic) IBOutlet UIView *ibCouponView;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibCouponViewBottom;
@property (weak, nonatomic) IBOutlet UITableView *ibCouponTableView;
@property (weak, nonatomic) IBOutlet UILabel *ibChooseCouponPicLab;
@property (strong, nonatomic) UIButton *blackBtn;

@property(nonatomic,strong) EPAddressModel *addressModel;
@property(nonatomic,strong)NSString *noteStr;
@property(nonatomic,strong)NSString *payType;
@property(nonatomic,strong)NSString *payStr;

@property(nonatomic,strong)NSString *orderKey;
@property(nonatomic,strong)PlaceOrderRsp *dataRsp;
@property(nonatomic,assign)NSInteger allCount;//共几件
@property(nonatomic,strong)NSMutableArray *couponDataArr;
@property(nonatomic,strong)CouponListModel *couponModel;
@property(nonatomic)BOOL isChooseYue;
@end

@implementation PlaceOrderVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
   
    [self requestPlaceOrderKey];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _ibTableView.backgroundColor  = TableView_bgColor;
    _ibTableView.tableFooterView = [UIView new];
    _ibCouponTableView.backgroundColor  = TableView_bgColor;
    _ibCouponTableView.tableFooterView = [UIView new];
    //偏移问题
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeBottom;
//    self.navigationController.navigationBar.backgroundColor = NavColor;
    self.title = @"订单详情";
    [self requestAddress];
    [self requestUserInfo];
    UIButton *blackbg = [UIButton buttonWithType:UIButtonTypeCustom];
    [blackbg setFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - _ibCouponView.qu_h)];
    blackbg.alpha = 0.0f;
    [blackbg addTarget:self action:@selector(selectBackAction:) forControlEvents:UIControlEventTouchUpInside];
    blackbg.backgroundColor = [UIColor blackColor];
    _blackBtn = blackbg;
    //    [[UIApplication sharedApplication].keyWindow insertSubview:blackbg belowSubview:self.ibDateChooseView];
    [[[UIApplication sharedApplication] keyWindow]addSubview:blackbg];
    //
    self.payType = @"weixin";
    self.payStr = @"微信支付";

}
-(IBAction)selectBackAction:(UIButton *)sender{
    
    self.ibAllPicLab.text = [NSString stringWithFormat:@"%.2f",self.dataRsp.priceGroup.totalPrice - [_couponModel.coupon_price doubleValue]];
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.blackBtn.alpha = 0.0f;
                         self.ibCouponViewBottom.constant = 400;
                         [self.view layoutIfNeeded];
                     }
     
                     completion:^(BOOL finished) {
                     }];
}
- (IBAction)ibGoPlaceOrder:(id)sender {
    
//    if (_addressModel == nil) {
//        [QuHudHelper qu_showMessage:@"请选择收货地址"];
//        return;
//    }
    UIAlertController * altController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确定使用%@？",_payStr] message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [altController addAction:cancelAction];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
        [cancelAction setValue:[UIColor grayColor] forKey:@"titleTextColor"];
    }
    UIAlertAction * yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        //立即下单
        [self requestPlaceOrder];
    }];
    
    [altController addAction:yesAction];
    [self presentViewController:altController animated:YES completion:nil];
  
    
}
//MARK:-----UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _ibCouponTableView) {
        return 1;
    }else{
        return 8;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _ibCouponTableView) {
         return 100;
    }
    
    if (indexPath.section == 0) {
        return 75;
    }else if (indexPath.section == 1){
        return 145;
    }else if (indexPath.section == 7){
        return 150;
    }
    return 50;
}
//MARK:-----UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _ibCouponTableView) {
        return self.couponDataArr.count;
    }
    if (section == 1) {
        return _dataRsp.cartInfo.count;
    }
    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _ibCouponTableView) {
        CouPonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouPonCell"];
        
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"CouPonCell" owner:nil options:nil][1];
        }
        [cell.ibChooseCouponBtn addTarget:self action:@selector(chooseCouponAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.ibChooseCouponBtn.tag = indexPath.row;
        if (_couponDataArr) {
            CouponListModel *model =_couponDataArr[indexPath.row];
//            cell.couponModel = _couponRsp.data[indexPath.row];
            cell.ibPic.text = [NSString stringWithFormat:@"¥%@",model.coupon_price];
            cell.ibMenkan.text = [NSString stringWithFormat:@"满%@元可用",model.use_min_price];
            cell.ibEndTime.text = [NSString returndate:model.end_time];
            if (model.id == self.couponModel.id) {
                //选择的优惠券
                cell.ibChooseCouponBtn.selected = YES;
                self.ibChooseCouponPicLab.text = [NSString stringWithFormat:@"已选中推荐优惠，使用优惠券1张，共抵扣%@",model.coupon_price];
             
            }
        }
        
        return cell;
    }
    PlaceOrderCell *cell =[tableView dequeueReusableCellWithIdentifier:@"PlaceOrderCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"PlaceOrderCell" owner:nil options:nil][0];
    }
    if (indexPath.section == 0) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"PlaceOrderCell" owner:nil options:nil][0];
        if (_addressModel) {
            cell.ibAddBtn.hidden = YES;
            cell.addressModel = _addressModel;

        }else{
            cell.ibAddBtn.hidden = NO;
        }
        
    }else if(indexPath.section == 1){
        cell = [[NSBundle mainBundle]loadNibNamed:@"PlaceOrderCell" owner:nil options:nil][1];
        if (_dataRsp) {
            cell.goodsModel = _dataRsp.cartInfo[indexPath.row];
            
        }
    
    }else if(indexPath.section == 2){
        cell = [[NSBundle mainBundle]loadNibNamed:@"PlaceOrderCell" owner:nil options:nil][2];
        
        
    }else if(indexPath.section == 3){
        cell = [[NSBundle mainBundle]loadNibNamed:@"PlaceOrderCell" owner:nil options:nil][3];
        if (self.couponModel) {
            //选择的优惠券
            cell.ibkeyongYouhuiquanLab.text = [NSString stringWithFormat:@"使用优惠券1张，共抵扣%@",self.couponModel.coupon_price];
        }
      
        
    }else if(indexPath.section == 4){
        cell = [[NSBundle mainBundle]loadNibNamed:@"PlaceOrderCell" owner:nil options:nil][4];
        [cell.ibYueBtn addTarget:self action:@selector(ibChooseYueAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.ibYuanbaoNumLab.text = [NSString stringWithFormat:@"可用元宝%@",_dataRsp.userInfo.integral];
        if (self.dataRsp.integral == 1) {
            //代理商品时默认勾选元宝
            cell.ibYueBtn.selected = YES;
            _isChooseYue = YES;
        }
        
    }else if(indexPath.section == 5){
        cell = [[NSBundle mainBundle]loadNibNamed:@"PlaceOrderCell" owner:nil options:nil][5];
        [cell.ibTextTf addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        
    }else if(indexPath.section == 6){
        cell = [[NSBundle mainBundle]loadNibNamed:@"PlaceOrderCell" owner:nil options:nil][6];
        [_dataRsp.cartInfo enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PlaceOrderModel *placemodel = self.dataRsp.cartInfo[idx];
//            self.allCount +=  placemodel.cart_num  * [placemodel.truePrice intValue];
            self.allCount += placemodel.cart_num;
            cell.ibGongLab.text = [NSString stringWithFormat:@"共%ld件商品 小计:",self.allCount];
            cell.ibAllNum.text = [NSString stringWithFormat:@"¥ %@",placemodel.truePrice];
            
        }];
      
    }else if(indexPath.section == 7){
        cell = [[NSBundle mainBundle]loadNibNamed:@"PlaceOrderCell" owner:nil options:nil][7];
        cell.ibKeYongXianjinLab.text = [NSString stringWithFormat:@"可用现金%@元",ACCOUNTINFO.userInfo.now_money];
//        NSLog(@"now_money:----%@",ACCOUNTINFO.userInfo.now_money);
//        self.allCount = 0;
      
        
    }else{
        cell = [[NSBundle mainBundle]loadNibNamed:@"PlaceOrderCell" owner:nil options:nil][0];
   
    }
//    cell.goodsModel =  _goodsModel;
 
    cell.payTypeBtnClick = ^(NSInteger payType ) {
        if (payType == 3) {
            self.payType = @"yue";
            self.payStr = @"余额支付";
        }else if (payType == 2){
            self.payType = @"ali";
             self.payStr = @"支付宝支付";
        }else if(payType == 1){
            self.payType = @"weixin";
            self.payStr = @"微信支付";
        }
      
    };
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _ibCouponTableView){
        
        self.couponModel = _couponDataArr[indexPath.row];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
        [_ibTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        [self selectBackAction:nil];
    }else{
        if (indexPath.section == 0) {
            AllAddressVC *vc = [[AllAddressVC alloc]initWithNibName:@"AllAddressVC" bundle:nil];
            vc.isFeedUp = YES;
            vc.addressBlock = ^(EPAddressModel *newAddress){
                if (newAddress) {
                    self.addressModel = newAddress;

                }
                
                [self.ibTableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.section == 3){
            if (_isChooseYue) {
                [QuHudHelper qu_showMessage:@"余额与优惠券不可同时使用"];
                return;
            }
            if (self.couponDataArr.count > 0) {
                [UIView animateWithDuration:0.2f
                                      delay:0.f
                                    options:UIViewAnimationOptionBeginFromCurrentState
                                 animations:^{
                                     
                                     self.blackBtn.alpha = 0.3f;
                                     self.ibCouponViewBottom.constant = 0;
                                     [self.view layoutIfNeeded];
                                     //                             [self loadDatePicker];
                                 }
                 
                                 completion:^(BOOL finished) {
                                     
                                 }];
              
                [self.ibCouponTableView reloadData];
           
            }else{
                [QuHudHelper qu_showMessage:@"暂无优惠券可用"];
            }
        }
    }
    
    
}
- (void)textFieldChange:(UITextField *)sender{
    _noteStr = sender.text;
}
-(void)ibChooseYueAction:(UIButton *)sender{
    if (self.couponModel) {
        [QuHudHelper qu_showMessage:@"余额与优惠券不可同时使用"];
        return ;
    }
    self.isChooseYue = !sender.selected;
    
    sender.selected = !sender.selected;
}
- (void)chooseCouponAction:(UIButton *)sender{
    
    if (!sender.selected) {
         _couponModel = _couponDataArr[sender.tag];
        
        [self selectBackAction:nil];
    }else{
        _couponModel = nil;
        [self selectBackAction:nil];
    }
    //刷新
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
    [_ibTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    sender.selected = !sender.selected;
}
//默认收货地址

- (void)requestAddress
{

    [[HTTPRequest sharedManager]requesGetDataWithApiName:defaddress  withParameters:nil isEnable:YES withSuccess:^(id responseObject) {
        self.addressModel = [EPAddressModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [self requestCouponList];//

        [self.ibTableView reloadData];
    } withError:^(NSError *error) {

    }];
    
}
//MARK:---下单前获得Key
- (void)requestPlaceOrderKey
{
    AddShoppingReq *req = [AddShoppingReq new];
    req.cartId = _cartId;
    
    [[HTTPRequest sharedManager]requesGetDataWithApiName:confirm_order withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        self.orderKey = responseObject[@"data"][@"orderKey"];
        self.dataRsp = [PlaceOrderRsp mj_objectWithKeyValues:responseObject[@"data"]];
        self.ibAllPicLab.text = [NSString stringWithFormat:@"%.2f",self.dataRsp.priceGroup.totalPrice];
        [self.ibTableView reloadData];
        
    } withError:^(NSError *error) {
        
    }];
    
}
//MARK:---------商品下单支付
- (void)requestPlaceOrder
{
    PlaceOrderReq *req = [PlaceOrderReq new];
    req.addressId = _addressModel.id;
    req.payType = _payType;//weixin  yue ali
    req.key = _orderKey;
    req.mark = _noteStr;
    
    if (_couponModel.id.length > 0) {
        req.couponId = _couponModel.id;
        
    }
    if (_isChooseYue == YES) {
        req.useIntegral = @"1";

    }
    
    [[HTTPRequest sharedManager]requestDataWithApiName:create_order  withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        if ([responseObject[@"msg"] isEqualToString:@"支付成功"]) {
            [QuHudHelper qu_showMessage:responseObject[@"msg"]];
            [self goOrderListVC];//去订单列表
            return ;
        }
        QuPayType quPayType;
        NSObject *data;
        if ([self.payType isEqualToString:@"weixin"]) {
            //微信支付
            WXPayRsp *wxModel =[WXPayRsp mj_objectWithKeyValues:responseObject[@"data"][@"result"]];
            NSLog(@"%@",responseObject[@"data"][@"result"]);
            quPayType = QuPayType_WX;
            data = wxModel.jsConfig;
            
            [[ThirdApiManager shareManager]sendThirdPayReqWithPayType:quPayType payModel:data success:^{
                [QuHudHelper qu_showMessage:@"微信支付成功"];
                [self goOrderListVC];

                //                [weakSelf requestPaysSubmit];
                
            } fail:^{
                [QuHudHelper qu_showMessage:@"微信支付失败"];
                [self goOrderListVC];

            }];
            
            
        }else if([self.payType isEqualToString:@"ali"]){
            //支付宝支付
//            AliPreOrderRsp *aliModel =[AliPreOrderRsp mj_objectWithKeyValues:responseObject[@"data"][@"result"]];
            quPayType = QuPayType_Alipay;
            data = responseObject[@"data"][@"result"][@"jsConfig"];
            
            [[ThirdApiManager shareManager]sendThirdPayReqWithPayType:quPayType payModel:data success:^{
                
                [QuHudHelper qu_showMessage:@"支付宝支付成功"];
                [self goOrderListVC];

                //                [weakSelf requestPaysSubmit];
//                [self requestpphoneUpdateorder];
                
            } fail:^{
                
                [QuHudHelper qu_showMessage:@"支付宝支付失败"];
                [self goOrderListVC];
            }];
        }else if([self.payType isEqualToString:@"yue"]){
       
            [self performSelector:@selector(goBack) withObject:nil afterDelay:1.0f];
        }
    } withError:^(NSError *error) {
        
    }];
    
}
-(void)goBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)goOrderListVC{
    MyOrderVC *vc = [[MyOrderVC alloc]initWithNibName:@"MyOrderVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:----获取个人信息
-(void)requestUserInfo{
    [[HTTPRequest sharedManager]requesGetDataWithApiName:getInformation withParameters:nil isEnable:YES withSuccess:^(id responseObject) {
        QuUserInfo *userInfo = [QuUserInfo mj_objectWithKeyValues:responseObject[@"data"][@"user_info"]];
        
        ACCOUNTINFO.userInfo = userInfo;
        [self.ibTableView reloadData];
        
    } withError:^(NSError *error) {
        
    }];
}
//TODO:----------可用优惠券
- (void)requestCouponList{
    _couponDataArr = [NSMutableArray array];
    [NetWorkReqManager requestDataWithApiName:get_use_coupon params:nil response:^(NSDictionary *responseObject) {
        CouponRsp *couponRsp = [CouponRsp mj_objectWithKeyValues:responseObject];
        NSMutableArray *arr = [NSMutableArray array];
        [couponRsp.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CouponListModel *model = obj;
            if (self.dataRsp.priceGroup.totalPrice > [model.use_min_price doubleValue] ) {
              //可用的
                [arr addObject:model];
            }
        }];
        [self.couponDataArr addObjectsFromArray:arr];
        
       NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:3];
        PlaceOrderCell *cell = [self.ibTableView cellForRowAtIndexPath:indexPath];
        if (self.couponDataArr.count > 0) {
            [self.ibCouponTableView reloadData];
            cell.ibkeyongYouhuiquanLab.text = [NSString stringWithFormat:@"%ld张优惠券可以使用",self.couponDataArr.count];
            
        }else{
            
            cell.ibkeyongYouhuiquanLab.text = @"无可用优惠券";
        }
       
    } errorResponse:^(NSString *error) {
        
    }];
    
}
@end
