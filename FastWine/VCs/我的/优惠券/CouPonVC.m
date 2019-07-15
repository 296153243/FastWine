//
//  CouPonVC.m
//  CLTravel
//
//  Created by MOOSON_ on 2018/11/2.
//  Copyright © 2018年 MOOSON_. All rights reserved.
//

#import "CouPonVC.h"
#import "CouPonCell.h"

@interface CouPonVC ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,FSSegmentTitleViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property(nonatomic)NSInteger pageIndex;
@property(nonatomic,strong)CouponListRsp *couponListData;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UIView *ibTopView;
@property(nonatomic,strong) FSSegmentTitleView *navTitleView;
@property(nonatomic,strong)NSString *status;//all 全部（0：未使用，1：已使用, 2:已过期）
@end

@implementation CouPonVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.navigationItem.title = @"优惠券";
    _status = @"all";
    self.navTitleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, _ibTopView.qu_w, _ibTopView.qu_h) titles:@[@"全部",@"未使用",@"已使用",@"已过期"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.navTitleView.titleFont = [UIFont systemFontOfSize:12];
    self.navTitleView.titleSelectFont = [UIFont systemFontOfSize:13];
//    _navTitleView.selectIndex = 0;
    _navTitleView.titleNormalColor = [UIColor grayColor];
    _navTitleView.titleSelectColor = ThemeColor;
    _navTitleView.indicatorColor = ThemeColor;
    [self.ibTopView addSubview:_navTitleView];
    
    _ibTableView.backgroundColor = WhiteColor;
    _ibTableView.emptyDataSetSource = self;
    _ibTableView.emptyDataSetDelegate = self;
    _ibTableView.tableFooterView = [UIView new];
   
    self.pageIndex = 0;
    _dataArr = [NSMutableArray array];
    [self requestCouponListWithPageIndex:self.pageIndex];
//    self.ibTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        self.pageIndex++;
//        [self requestCouponListWithPageIndex:self.pageIndex];
//
//    }];
//    self.ibTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        self.pageIndex = 1;
//        [self requestCouponListWithPageIndex:self.pageIndex];
//
//    }];
    
}
//MARK:-----FSSegmentTitleViewDelegate
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
//    0：未使用，1：已使用, 2:已过期）
    if (endIndex == 0) {
        _status = @"all";

    }else if (endIndex == 1){
        _status = @"0";

    }else if (endIndex == 2){
        _status = @"1";

    }else if(endIndex == 3){
        _status = @"2";

    }
    NSLog(@"------%ld",endIndex);
    [self requestCouponListWithPageIndex:0];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CouPonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouPonCell"];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"CouPonCell" owner:nil options:nil][0];
    }
    cell.viewModel = _dataArr[indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_orderId.length > 0) {
         CouponListModel *model = self.dataArr[indexPath.row];
//        if (_ChooseCouponBlock) {
//            self.ChooseCouponBlock(model.couponsId, [model.money doubleValue]);
//        }
    }
    
}
//TODO:----------优惠券列表
- (void)requestCouponListWithPageIndex:(NSInteger )pageIndex{
    //    0：未使用，1：已使用, 2:已过期）

    BaseRequest *req = [BaseRequest new];
    req.status = _status;
   
    [_dataArr removeAllObjects];

    WS(weakSelf);
    [NetWorkReqManager requestDataWithApiName:mycoupon params:req response:^(NSDictionary *responseObject) {
  
        self.couponListData= [CouponListRsp mj_objectWithKeyValues:responseObject[@"data"]];
        
        NSMutableArray *arr = [NSMutableArray array];
        [self.couponListData.couponList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CouponListModel *model = obj;
            
            if ([[NSString stringWithFormat:@"%ld",model.status] isEqualToString:self.status]) {
                [arr addObject:model];
            }
            if ([self.status isEqualToString:@"all"] ) {
                [arr addObject:model];
            }
            
        }];
        [weakSelf.dataArr addObjectsFromArray:arr];
        [weakSelf.ibTableView reloadData];
     
        [self.ibTableView.mj_header endRefreshing];
        [self.ibTableView.mj_footer endRefreshing];
        if (weakSelf.couponListData.couponList.count == 0) {
            [self.ibTableView.mj_footer endRefreshingWithNoMoreData];
        }
    } errorResponse:^(NSString *error) {
        
    }];
    
}
#pragma mark - EmptyDataSet

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *titleStr;
    NSAttributedString *attributrStr;
    NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#b3b3b3"],
                          NSFontAttributeName : [UIFont systemFontOfSize:13]};
    titleStr = @"暂无优惠券";
    attributrStr = [[NSAttributedString alloc] initWithString:titleStr attributes:dic];
    return attributrStr;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"NoneData_Icon"];
}

@end
