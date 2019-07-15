//
//  OrderpayTypeVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/4/1.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "OrderpayTypeVC.h"

@interface OrderpayTypeVC ()
@property (weak, nonatomic) IBOutlet UIButton *ibSureBtn;
@property(strong,nonatomic) UIButton *markBtn;
@property(nonatomic,strong)NSString *payType;
@property (weak, nonatomic) IBOutlet UIButton *ibAliPayBtn;

@end

@implementation OrderpayTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = TableView_bgColor;
    self.title = @"立即支付";
    //默认支付宝支付
    _ibAliPayBtn.selected = YES;
    _markBtn = _ibAliPayBtn;
    _payType = @"1";
    
    [_ibSureBtn setTitle:[NSString stringWithFormat:@"确认支付 ¥ %@",_pic] forState:UIControlStateNormal];
}
- (IBAction)ibSuerPayBtnClick:(id)sender {
    [self requesGoodsPay];
    
}
- (IBAction)ibpayTypeBtn:(UIButton *)sender {
  
    if (_markBtn != sender) {
        sender.selected = YES;
        _markBtn.selected = NO;
        _markBtn = sender;
    }
    if (sender.tag == 0) {
        _payType = @"1";
    }else{
        _payType = @"2";
    }
    
}
//请求支付参数
- (void)requesGoodsPay{
    PayMoneyReq *req = [PayMoneyReq new];
    req.pay_type = _payType;
    if (_apiName == goodsPay) {
        //商品支付
        req.customer_id = [Save userID];
        req.order_id =_orderId;
    }else{
        //充值订单支付
        req.orderid = _orderId;
        req.pervalue = @"0.01";
    }
    [[HTTPRequest sharedManager]requestDataWithApiName:_apiName withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        QuPayType quPayType;
        NSObject *data;
        if ([req.pay_type integerValue] == 2) {
            //微信支付
            WXPayRsp *wxModel =[WXPayRsp mj_objectWithKeyValues:responseObject];
            quPayType = QuPayType_WX;
//            data = wxModel.data;
            data = wxModel.jsConfig;
            [[ThirdApiManager shareManager]sendThirdPayReqWithPayType:quPayType payModel:data success:^{
                [QuHudHelper qu_showMessage:@"微信支付成功"];
//                [weakSelf requestPaysSubmit];
                
            } fail:^{
                [QuHudHelper qu_showMessage:@"微信支付失败"];
            }];
            
            
        }else if([req.pay_type integerValue] == 1){
            //支付宝支付
            AliPreOrderRsp *aliModel =[AliPreOrderRsp mj_objectWithKeyValues:responseObject];
            quPayType = QuPayType_Alipay;
            data = aliModel.jsConfig;
            [[ThirdApiManager shareManager]sendThirdPayReqWithPayType:quPayType payModel:data success:^{
                
                [QuHudHelper qu_showMessage:@"支付宝支付成功"];
//                [weakSelf requestPaysSubmit];
                [self requestpphoneUpdateorder];
                
            } fail:^{
                
                [QuHudHelper qu_showMessage:@"支付宝支付失败"];
            }];
        }
    } withError:^(NSError *error) {
        
    }];
    
}

-(void)requestpphoneUpdateorder{
    PhoneCheckReq *req = [PhoneCheckReq new];
    req.userid = [Save userID];
    req.orderid = _orderId;
    [[HTTPRequest sharedManager]requestDataWithApiName:_updateOrderApiName withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        BaseResponse *rsp = [BaseResponse mj_objectWithKeyValues:responseObject];
        if (rsp.code == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [QuHudHelper qu_showMessage:rsp.msg];
        }
    } withError:^(NSError *error) {
        
    }];
    
}
@end
