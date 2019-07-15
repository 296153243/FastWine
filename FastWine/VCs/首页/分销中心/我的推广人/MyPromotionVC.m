//
//  MyPromotionVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/4/30.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "MyPromotionVC.h"
#import "MyWalletCell.h"
@interface MyPromotionVC ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,FSSegmentTitleViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (strong, nonatomic) IBOutlet UIView *ibTableHeardView;
@property (weak, nonatomic) IBOutlet UILabel *ibPromotionNum;
@property (weak, nonatomic) IBOutlet UILabel *ibMoneyLab;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UIView *ibTopView;
@property(nonatomic,strong) FSSegmentTitleView *navTitleView;
@property(nonatomic)NSInteger type;//1:代理 2:粉丝
@property(nonatomic)NSInteger pageIndex;
@property (weak, nonatomic) IBOutlet UILabel *ibTitleOne;
@property (weak, nonatomic) IBOutlet UILabel *ibTitleTwo;
@property (weak, nonatomic) IBOutlet UILabel *ibTitleThree;


@end

@implementation MyPromotionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    self.navigationItem.title = @"客户管理";
    self.navTitleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, _ibTopView.qu_w, _ibTopView.qu_h) titles:@[@"我的加盟商",@"我的粉丝"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.navTitleView.titleFont = [UIFont systemFontOfSize:12];
    self.navTitleView.titleSelectFont = [UIFont systemFontOfSize:13];
    //    _navTitleView.selectIndex = 0;
    _navTitleView.titleNormalColor = [UIColor grayColor];
    _navTitleView.titleSelectColor = ThemeColor;
    _navTitleView.indicatorColor = ThemeColor;
    [self.ibTopView addSubview:_navTitleView];
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
    self.type = 1;
}
- (void)initUI{
    [_ibTableView showViewShadowColor];
    //    _ibTableView.tableHeaderView = _ibTableHeardView;
    _ibTableView.backgroundColor = self.view.backgroundColor;
    _ibTableView.tableFooterView = [UIView new];
    _ibTableView.emptyDataSetSource = self;
    _ibTableView.emptyDataSetDelegate = self;
    
}
//MARK:-----FSSegmentTitleViewDelegate
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    //   1:代理, 2:粉丝）
    if (endIndex == 0) {
        self.type = 1;
        
    }else if (endIndex == 1){
        self.type =2;
        
    }
//    NSLog(@"------%ld",endIndex);
    [self requestListWithPageIndex:0];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _ibTableHeardView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return _ibTableHeardView.qu_h;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyWalletCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MyWalletCell" owner:nil options:nil][3];
    }
    
    cell.tag = indexPath.row;
    cell.viewModel = _dataArr[indexPath.row];
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


//TODO:----------requestData
- (void)requestListWithPageIndex:(NSInteger )pageIdx{
    BaseRequest *req = [BaseRequest new];
    req.limit = @"10";
    req.first = [NSString stringWithFormat:@"%ld",pageIdx];
    req.type = [NSString stringWithFormat:@"%ld",self.type];
    if (pageIdx == 0) {
        [_dataArr removeAllObjects];
        
    }
    [[HTTPRequest sharedManager]requestDataWithApiName:myPread_list withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        //        self.dataRsp = [GetWalletRsp mj_objectWithKeyValues:responseObject];
        PromoterListRsp *rsp = [PromoterListRsp mj_objectWithKeyValues:responseObject[@"data"]];
        [self.dataArr addObjectsFromArray:rsp.info];
        [self.ibTableView reloadData];
         self.ibPromotionNum.text =rsp.number;
         self.ibMoneyLab.text = rsp.total_money;
        if (self.type == 1) {
            self.ibTitleOne.text = @"您有";
            self.ibTitleTwo.text = @"位成为了代理，为您分成累计";
           
        }else{
            self.ibTitleOne.text = @"您的粉丝中有";
            self.ibTitleTwo.text = @"位成为了代理，为您分成累计";

        }
        [self.ibTableView.mj_header endRefreshing];
        [self.ibTableView.mj_footer endRefreshing];
        if (rsp.info.count == 0) {
            [self.ibTableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.ibTableView reloadData];
    } withError:^(NSError *error) {
        
    }];
    //
}

#pragma mark - EmptyDataSet

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *titleStr;
    NSAttributedString *attributrStr;
    NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#b3b3b3"],
                          NSFontAttributeName : [UIFont systemFontOfSize:13]};
    titleStr = @"暂无数据";
    attributrStr = [[NSAttributedString alloc] initWithString:titleStr attributes:dic];
    return attributrStr;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"NoneData_Icon"];
}
-(NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
