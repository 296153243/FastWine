//
//  MyBalanceVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/5/16.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "MyBalanceVC.h"
#import "MyWalletCell.h"
@interface MyBalanceVC ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (strong, nonatomic) IBOutlet UIView *ibTableHeardView;
@property (weak, nonatomic) IBOutlet UILabel *ibWalletPicLab;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic)NSInteger pageIndex;
@property(nonatomic,strong)BalanceListRsp *dataRsp;

@end

@implementation MyBalanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    self.navigationItem.title = @"我的余额";
    
    self.ibWalletPicLab.text = ACCOUNTINFO.userInfo.integral;
    
    self.ibTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 0;
        [self requestListWithPageIndex:self.pageIndex];
    }];
    [self.ibTableView.mj_header beginRefreshing];//自动刷新一下
    
    self.ibTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex  =  self.pageIndex +10;
        [self requestListWithPageIndex:self.pageIndex];
        //        NSLog(@"+++++%ld",self.pageIndex);
        
    }];
    
}
- (void)initUI{
    [_ibTableView showViewShadowColor];
    //    _ibTableView.tableHeaderView = _ibTableHeardView;
    _ibTableView.backgroundColor = self.view.backgroundColor;
    _ibTableView.tableFooterView = [UIView new];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _ibTableHeardView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return _ibTableHeardView.qu_h;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyWalletCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MyWalletCell" owner:nil options:nil][2];
    }
    
    if (_dataArr) {
        //        cell.viewModel = _dataArr[indexPath.row];
        cell.tag = indexPath.row;
        [cell setData:_dataArr];
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    if (indexPath.row == 0) {
    //        //提现
    //        if ([APPCONFIGININFO.appCanfigModel.withDrawCashEnabled integerValue] != 1){
    //            [QuHudHelper qu_showMessage:@"提现功能暂时还未开放哦"];
    //            return ;
    //        }
    //        WithdrawVC *vc = [[WithdrawVC alloc]initWithNibName:@"WithdrawVC" bundle:nil];
    //        [self.navigationController pushViewController:vc animated:YES];
    //    }else if (indexPath.row == 1){
    //        //优惠券
    //        CouPonVC *vc= [[CouPonVC alloc]initWithNibName:@"CouPonVC" bundle:nil];
    //        [self.navigationController pushViewController:vc animated:YES];
    //
    //    }else{
    //        //返佣
    //        BaseWKWebController *web = [[BaseWKWebController alloc]init];
    //        web.url = APPCONFIGININFO.appCanfigModel.rakeBackListUrl;
    //        [self.navigationController pushViewController:web animated:YES];
    //    }
}

- (IBAction)goRechargeBtnClick:(id)sender {
    //    if ([APPCONFIGININFO.appCanfigModel.chargeEnabled integerValue]== 2){
    //        [QuHudHelper qu_showMessage:@"暂时还未开放哦"];
    //        return ;
    //    }
    //    //去充值
    //    RechargeVC *vc = [[RechargeVC alloc]initWithNibName:@"RechargeVC" bundle:nil];
    //    [self.navigationController pushViewController:vc animated:YES];
}
//TODO:----------requestData
- (void)requestListWithPageIndex:(NSInteger )pageIdx{
    BaseRequest *req = [BaseRequest new];
    req.limit = @"10";
    req.first = [NSString stringWithFormat:@"%ld",pageIdx];
    if (pageIdx == 0) {
        [_dataArr removeAllObjects];
        
    }
    [[HTTPRequest sharedManager]requestDataWithApiName:myintegral_list withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        //        self.dataRsp = [GetWalletRsp mj_objectWithKeyValues:responseObject];
        self.dataRsp = [BalanceListRsp mj_objectWithKeyValues:responseObject];
        [self.dataArr addObjectsFromArray:self.dataRsp.list];
        [self.ibTableView reloadData];
        [self.ibTableView.mj_header endRefreshing];
        [self.ibTableView.mj_footer endRefreshing];
        if (self.dataRsp.list.count == 0) {
            [self.ibTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.ibTableView reloadData];
    } withError:^(NSError *error) {
        
    }];
    //
}
-(NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
