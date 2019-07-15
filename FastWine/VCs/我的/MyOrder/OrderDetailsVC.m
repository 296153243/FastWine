//
//  OrderDetailsVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/3/26.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "OrderDetailsVC.h"
#import "OrderDetailsCell.h"
#import "EvaluationVC.h"
#import "LogisticsVC.h"
#import "PlaceOrderVC.h"
#import "QMHomeViewController.h"
@interface OrderDetailsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UIView *ibBottomView;
@property (weak, nonatomic) IBOutlet UIButton *ibBtnOne;
@property (weak, nonatomic) IBOutlet UIButton *ibBtnTwo;
@property(nonatomic,strong)OrderListModel *orderDetailsModel;
@end

@implementation OrderDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //偏移问题
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"订单详情";
    [self requestOrderDetalis];
    
//    [self requestOrderExpressInfo];
    self.ibTableView.tableFooterView = [UIView new];
    self.ibTableView.backgroundColor = TableView_bgColor;
}
- (IBAction)ibBtnOneAction:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"支付"]) {
        [self requestOrderPay];
    }else if ([sender.titleLabel.text isEqualToString:@"退款"]) {
        [self requestCancelOrder];
    }else if ([sender.titleLabel.text isEqualToString:@"查看物流"]) {
        LogisticsVC *vc= [[LogisticsVC alloc]initWithNibName:@"LogisticsVC" bundle:nil];
        vc.orderListModel = _orderDetailsModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)ibBtnTwoBtnAction:(UIButton *)sender {
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([_orderDetailsModel.status integerValue]== 0) {
        //待付款不显示物流信息
         return  _orderDetailsModel.cartInfos.count + 4;
    }
    return  _orderDetailsModel.cartInfos.count + 5;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
           return [_orderDetailsModel.user_address stringHeighFontSize:12 width:SCREEN_WIDTH - 83]  + 150;

    }else if (indexPath.section == 1){
        return 40;

    }else if(indexPath.section == 2){
       //商品
        return 120;
    
    }else if(indexPath.section == 3){
        
        return 130;
    }else{
        return 150;
    }
   
}
//MARK:-------UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return _orderDetailsModel.cartInfos.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailsCell *cell =[tableView dequeueReusableCellWithIdentifier:@"OrderDetailsCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"OrderDetailsCell" owner:nil options:nil][0];
    }
    
    if (indexPath.section == 0) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"OrderDetailsCell" owner:nil options:nil][0];
    }else if (indexPath.section == 1){
        cell = [[NSBundle mainBundle]loadNibNamed:@"OrderDetailsCell" owner:nil options:nil][1];

    }else if (indexPath.section == 2){
        cell = [[NSBundle mainBundle]loadNibNamed:@"OrderDetailsCell" owner:nil options:nil][2];
        PlaceOrderModel *model = _orderDetailsModel.cartInfos[indexPath.row];
        cell.goodsModel = model;
        [cell.ibKefuBtn addTarget:self action:@selector(ibKefuBtnAction) forControlEvents:UIControlEventTouchUpInside];
        cell.EvaluationClick = ^(PlaceOrderModel * _Nonnull goodsModel) {
            //评价
            EvaluationVC *vc= [[EvaluationVC alloc]initWithNibName:@"EvaluationVC" bundle:nil];
            vc.orderModel = goodsModel;
            [self.navigationController pushViewController:vc animated:YES];
            
        };
      
        
    }else if (indexPath.section ==  3){
        cell = [[NSBundle mainBundle]loadNibNamed:@"OrderDetailsCell" owner:nil options:nil][3];
        
    }else if (indexPath.section ==  4){
     
        if ([_orderDetailsModel.status integerValue]== 0) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"OrderDetailsCell" owner:nil options:nil][5];
        }else{
             cell = [[NSBundle mainBundle]loadNibNamed:@"OrderDetailsCell" owner:nil options:nil][4];
        }

    }else if(indexPath.section == 5){
        cell = [[NSBundle mainBundle]loadNibNamed:@"OrderDetailsCell" owner:nil options:nil][5];
    }
    cell.viewModel = _orderDetailsModel;//
    
    return cell;
}
-(void)ibKefuBtnAction{
    QMHomeViewController *vc= [QMHomeViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)loadBottomView{
   // /订单状态  全部 0代付款 1代发货 2待收货 3代评
    if ([_orderDetailsModel.status integerValue] == 0) {
        _ibBtnOne.hidden = NO;
        [_ibBtnOne setTitle:@"支付" forState:UIControlStateNormal];
    }else if ([_orderDetailsModel.status integerValue] == 1){
        _ibBtnOne.hidden = NO;
        [_ibBtnOne setTitle:@"退款" forState:UIControlStateNormal];
    }else if ([_orderDetailsModel.status integerValue] == 2){
        _ibBtnOne.hidden = NO;
        [_ibBtnOne setTitle:@"查看物流" forState:UIControlStateNormal];
    }else{
        _ibBottomView.hidden = YES;
        _ibBtnOne.hidden = YES;
        _ibBtnTwo.hidden = YES;
    }
   
    
}
//MARK:------订单详情

- (void)requestOrderDetalis{
    OrderDetailsReq *req = [OrderDetailsReq new];
    req.uni = _orderId;
    [[HTTPRequest sharedManager]requestDataWithApiName:orderDetalis withParameters:req isEnable:NO withSuccess:^(id responseObject) {
        self.orderDetailsModel = [OrderListModel mj_objectWithKeyValues:responseObject[@"data"]];
        [self loadBottomView];
        [self.ibTableView reloadData];
    } withError:^(NSError *error) {
        
    }];
}
//MARK:------物流详情
- (void)requestOrderExpressInfo{
    OrderDetailsReq *req = [OrderDetailsReq new];
    req.customer_id = [Save userID];
    req.uni = _orderId;
    [[HTTPRequest sharedManager]requestDataWithApiName:expressInfo withParameters:req isEnable:NO withSuccess:^(id responseObject) {
   
    } withError:^(NSError *error) {
        
    }];
}
//MARK:------退款
- (void)requestCancelOrder{
    OrderDetailsReq *req = [OrderDetailsReq new];
    req.uni = _orderDetailsModel.order_id;
    [[HTTPRequest sharedManager]requestDataWithApiName:cancelOrder withParameters:req isEnable:NO withSuccess:^(id responseObject) {
        [QuHudHelper qu_showMessage:responseObject[@"info"]];
    } withError:^(NSError *error) {
        
    }];
}
//TODO:--------- 获取支付参数直接支付
- (void)requestOrderPay{
    
    OrderDetailsReq *req = [OrderDetailsReq new];
    req.uni = _orderDetailsModel.order_id;
    [[HTTPRequest sharedManager]requestDataWithApiName:pay_order withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        QuPayType quPayType;
        NSObject *data;
        if ([self.orderDetailsModel.pay_type isEqualToString:@"weixin"]) {
            //微信支付
            WXPayRsp *wxModel =[WXPayRsp mj_objectWithKeyValues:responseObject[@"data"][@"result"]];
            NSLog(@"%@",responseObject[@"data"][@"result"]);
            quPayType = QuPayType_WX;
            data = wxModel.jsConfig;
            
            [[ThirdApiManager shareManager]sendThirdPayReqWithPayType:quPayType payModel:data success:^{
                [QuHudHelper qu_showMessage:@"微信支付成功"];
                //                [weakSelf requestPaysSubmit];
                
            } fail:^{
                [QuHudHelper qu_showMessage:@"微信支付失败"];
            }];
            
            
        }else if([self.orderDetailsModel.pay_type isEqualToString:@"ali"]){
            //支付宝支付
            //            AliPreOrderRsp *aliModel =[AliPreOrderRsp mj_objectWithKeyValues:responseObject[@"data"][@"result"]];
            quPayType = QuPayType_Alipay;
            data = responseObject[@"data"][@"result"][@"jsConfig"];
            
            [[ThirdApiManager shareManager]sendThirdPayReqWithPayType:quPayType payModel:data success:^{
                
                [QuHudHelper qu_showMessage:@"支付宝支付成功"];
                //                [weakSelf requestPaysSubmit];
                //                [self requestpphoneUpdateorder];
                
            } fail:^{
                
                [QuHudHelper qu_showMessage:@"支付宝支付失败"];
            }];
        }else if([self.orderDetailsModel.pay_type isEqualToString:@"yue"]){
            
            [self performSelector:@selector(goBack) withObject:nil afterDelay:1.0f];
        }
        
    } withError:^(NSError *error) {
        
    }];
    
    
}



- (IBAction)ibBtnOne:(id)sender {
}
@end
