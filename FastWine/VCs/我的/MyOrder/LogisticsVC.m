//
//  LogisticsVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/4/4.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "LogisticsVC.h"
#import "LogisticsCell.h"
@interface LogisticsVC ()
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property(nonatomic,strong)ExpressInfoRsp *expressInfoRsp;
@property(nonatomic,strong)OrderDetailsModel *orderDetailsModel;

@end

@implementation LogisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"物流详情";
    _ibTableView.tableFooterView = [UIView new];
    _ibTableView.backgroundColor = TableView_bgColor;
    [self requestOrderExpressInfo];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 150;

    }else if (indexPath.row == 1){
        return 60;

    }
    return 130;
}
//MARK:-------UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _expressInfoRsp.data.count + 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   LogisticsCell  *cell =[tableView dequeueReusableCellWithIdentifier:@"LogisticsCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"LogisticsCell" owner:nil options:nil][0];
        
    }
    if (indexPath.row == 0) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"LogisticsCell" owner:nil options:nil][0];
        cell.goodsModel = _orderListModel;
    }else if (indexPath.row == 1){
        cell = [[NSBundle mainBundle]loadNibNamed:@"LogisticsCell" owner:nil options:nil][1];
        cell.iBWuliu.text = _expressInfoRsp.com;
    }else{
        cell = [[NSBundle mainBundle]loadNibNamed:@"LogisticsCell" owner:nil options:nil][2];
        cell.viewModel = _expressInfoRsp.data[indexPath.row - 2];
    }
    
    return cell;
}
- (void)requestOrderDetalis{
    OrderDetailsReq *req = [OrderDetailsReq new];
    req.customer_id = [Save userID];
    req.order_id = _orderListModel.id;
    [[HTTPRequest sharedManager]requestDataWithApiName:expressInfo withParameters:req isEnable:NO withSuccess:^(id responseObject) {
        self.orderDetailsModel = [OrderDetailsModel mj_objectWithKeyValues:responseObject[@"data"]];
        if (self.orderDetailsModel.express_no.length > 0) {
            [self requestOrderExpressInfo];
        }else{
            [QuHudHelper qu_showMessage:@"暂未查到物流信息"];
        }
    } withError:^(NSError *error) {
        
    }];
}
//c查询快递信息
-(void)requestOrderExpressInfo{
    ExpressInfoReq *req = [ExpressInfoReq new];
    req.uni = _orderListModel.order_id;//self.orderDetailsModel.express_no;//804122937703732577
    [[HTTPRequest sharedManager]requestDataWithApiName:expressInfo withParameters:req isEnable:NO withSuccess:^(id responseObject) {
//        [SVProgressHUD showInfoWithStatus:responseObject[@"info"]];
        self->_expressInfoRsp = [ExpressInfoRsp mj_objectWithKeyValues:responseObject];
        [self.ibTableView reloadData];
        
    } withError:^(NSError *error) {
        
    }];
    
}
@end
