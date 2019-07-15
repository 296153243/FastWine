//
//  AllOrderVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/3/15.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "AllOrderVC.h"
#import "MyOrderCell.h"
#import "OrderDetailsVC.h"
#import "LogisticsVC.h"
#import "PlaceOrderVC.h"
#import "EvaluationVC.h"
#define ShowType @""

@interface AllOrderVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic)NSInteger pageIndex;
@property(nonatomic,strong)OrderListRsp *orderModelArr;


@end

@implementation AllOrderVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.pageIndex = 0;
    _dataArr = [NSMutableArray array];
    //    [self requestOrderListWithPageIndex:self.pageIndex];
    self.ibTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 0;
        [self requestOrderListWithPageIndex:self.pageIndex];
    }];
    [self.ibTableView.mj_header beginRefreshing];//自动刷新一下
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.ibTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
       self.pageIndex =  self.pageIndex +10;
        [self requestOrderListWithPageIndex:self.pageIndex];
        NSLog(@"+++++%ld",self.pageIndex);
        
    }];
    
    self.ibTableView.tableFooterView = [UIView new];
    _ibTableView.emptyDataSetSource = self;
    _ibTableView.emptyDataSetDelegate = self;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (_dataArr) {
        OrderListModel *model = _dataArr[indexPath.section];
        if (indexPath.row == 0) {
            return 44;
        }else if (indexPath.row == model.cartInfos.count + 1){
            return 60;
        }else{
            return 100;
        }
    }
    return 0;

}
//MARK:-------UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return _dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArr) {
        OrderListModel *model = _dataArr[section];
        return model.cartInfos.count + 2;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderCell *cell =[tableView dequeueReusableCellWithIdentifier:@"MyOrderCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MyOrderCell" owner:nil options:nil][0];
        
    }
    if (_dataArr) {
        OrderListModel *model = _dataArr[indexPath.section];
        if (indexPath.row == 0) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"MyOrderCell" owner:nil options:nil][0];
        }else if(indexPath.row == model.cartInfos.count + 1){
            cell = [[NSBundle mainBundle]loadNibNamed:@"MyOrderCell" owner:nil options:nil][2];
        }else{
            cell = [[NSBundle mainBundle]loadNibNamed:@"MyOrderCell" owner:nil options:nil][1];
            PlaceOrderModel *goodsmodel  = model.cartInfos[indexPath.row - 1];
            cell.goodsModel = goodsmodel;
          
            
        }
        
        cell.viewModel = model;
        
        cell.PayClick = ^(NSString * _Nonnull btnTitleStr) {
            if ([btnTitleStr isEqualToString:@"立即支付"]) {
                //付款
                [self requestOrderPay:model];
                
            }
            
        };
        cell.EvaluationClick = ^(PlaceOrderModel * _Nonnull goodsModel) {
            
            EvaluationVC *vc= [[EvaluationVC alloc]initWithNibName:@"EvaluationVC" bundle:nil];
            vc.orderModel = goodsModel;
            [self.navigationController pushViewController:vc animated:YES];
        };

//        return cell;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailsVC *vc = [[OrderDetailsVC alloc]initWithNibName:@"OrderDetailsVC" bundle:nil];
    OrderListModel *model = _dataArr[indexPath.section];
    vc.orderId = model.order_id;
    vc.orderModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}
//TODO:----------获取全部订单
- (void)requestOrderListWithPageIndex:(NSInteger )pageIdx{
    OrderListReq *req = [OrderListReq new];
    req.customer_id = [Save userID];
    req.first = [NSString stringWithFormat:@"%ld",pageIdx];
    req.limit = @"10";
    req.type = ShowType.length > 0?ShowType:@"";
    NSLog(@"first:%@-----limit:%@", req.first,req.limit);
//    _pageIndex = pageIdx;
    if (pageIdx == 0) {
        [_dataArr removeAllObjects];
        
    }
    weakSelf(weakSelf);
    [NetWorkReqManager requestDataWithApiName:orderList params:req response:^(NSDictionary *responseObject) {
      
        self.orderModelArr = [OrderListRsp mj_objectWithKeyValues:responseObject];
        [weakSelf.dataArr addObjectsFromArray:self.orderModelArr.data];
        [self.ibTableView reloadData];
        [self.ibTableView.mj_header endRefreshing];
        [self.ibTableView.mj_footer endRefreshing];
        if (weakSelf.orderModelArr.data.count == 0) {
            [self.ibTableView.mj_footer endRefreshingWithNoMoreData];
        }
    } errorResponse:^(NSString *error) {
        
    }];
    
}
//TODO:--------- 获取支付参数直接支付
- (void)requestOrderPay:(OrderListModel *)model{
    
    OrderDetailsReq *req = [OrderDetailsReq new];
    req.uni = model.order_id;
    [[HTTPRequest sharedManager]requestDataWithApiName:pay_order withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        QuPayType quPayType;
        NSObject *data;
        if ([model.pay_type isEqualToString:@"weixin"]) {
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
            
            
        }else if([model.pay_type isEqualToString:@"ali"]){
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
        }else if([model.pay_type isEqualToString:@"yue"]){
            
            [self performSelector:@selector(goBack) withObject:nil afterDelay:1.0f];
        }
        
    } withError:^(NSError *error) {
        
    }];
    
    
}
//TODO:----------确认收货
- (void)requestOrderConfirmTaked:(OrderListModel *)model{
    
    OrderDetailsReq *req = [OrderDetailsReq new];
    req.customer_id = [Save userID];
    req.order_id = model.order_id;
    [[HTTPRequest sharedManager]requestDataWithApiName:confirmTaked withParameters:req isEnable:YES withSuccess:^(id responseObject) {
       
        
    } withError:^(NSError *error) {
        
    }];
    
    
}
#pragma mark - EmptyDataSet

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *titleStr;
    NSAttributedString *attributrStr;
    NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#b3b3b3"],
                          NSFontAttributeName : [UIFont systemFontOfSize:13]};
    titleStr = @"暂无订单";
    attributrStr = [[NSAttributedString alloc] initWithString:titleStr attributes:dic];
    return attributrStr;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"NoneData_Icon"];
}
//MARK:----------Get
- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}
@end
