//
//  WaitReceivingVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/3/15.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "WaitReceivingVC.h"
#import "MyOrderCell.h"
#import "OrderDetailsVC.h"
#import "LogisticsVC.h"
#define ShowType @"2"

@interface WaitReceivingVC ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic)NSInteger pageIndex;
@property(nonatomic,strong)NSString  *showType;//订单类型
@property(nonatomic,strong)OrderListRsp *orderModelArr;
@end

@implementation WaitReceivingVC
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
            if ([btnTitleStr isEqualToString:@"支付"]) {
                //付款
                [self requestOrderPay:model];
                
            }if ([btnTitleStr isEqualToString:@"确认收货"]) {
                [self requestOrderConfirmTaked:model];
            }
            
        };
        cell.CancelClick = ^(NSString * _Nonnull btnTitleStr){
            if ([btnTitleStr isEqualToString:@"取消订单"]) {
                OrderDetailsReq *req = [OrderDetailsReq new];
                req.customer_id = [Save userID];
                req.order_id = model.id;
                [[HTTPRequest sharedManager]requestDataWithApiName:cancelOrder withParameters:req isEnable:YES withSuccess:^(id responseObject) {
                    [QuHudHelper qu_showMessage:responseObject[@"info"]];
                    [self requestOrderListWithPageIndex:1];
                    
                } withError:^(NSError *error) {
                    
                }
                 ];
            }else  if ([btnTitleStr isEqualToString:@"查看物流"]) {
                LogisticsVC *vc= [[LogisticsVC alloc]initWithNibName:@"LogisticsVC" bundle:nil];
                vc.orderListModel = model;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
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
//TODO:--------- 获取CatId
- (void)requestOrderPay:(OrderListModel *)model{
    
    OrderDetailsReq *req = [OrderDetailsReq new];
    req.uni = model.order_id;
    [[HTTPRequest sharedManager]requestDataWithApiName:pay_order withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        //        PlaceOrderVC *vc  =[[PlaceOrderVC alloc]initWithNibName:@"PlaceOrderVC" bundle:nil];
        //        //            vc.cartId = model.;
        //        //            vc.pic = model.goods_price;
        //        [self.navigationController pushViewController:vc animated:YES];
        
        
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
