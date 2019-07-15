//
//  MoreCreditRecordVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/4/19.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "MoreCreditRecordVC.h"
#import "MoreCreditRecordCell.h"
@interface MoreCreditRecordVC ()<DZNEmptyDataSetSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property(nonatomic,strong)CarInfoRsp *carInfoRsp;
@property(nonatomic)NSInteger pageIndex;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)PhoneOrderListRsp *phoneOrderRsp;
@end

@implementation MoreCreditRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.ibTableView.rowHeight = 85;
    self.ibTableView.tableFooterView = [UIView new];
    self.ibTableView.backgroundColor = TableView_bgColor;
//    self.ibTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        self.pageIndex++;
//        [self requestOrderListWithPageIndex:self.pageIndex];
//
//    }];
    [self requestOrderListWithPageIndex:1];
    self.ibTableView.tableFooterView = [UIView new];
    _ibTableView.emptyDataSetSource = self;
    _ibTableView.emptyDataSetDelegate = self;
    self.navigationItem.title = @"话费充值记录";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoreCreditRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCreditRecordCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MoreCreditRecordCell" owner:nil options:nil][0];
    }
    if (_dataArr.count > 0) {
        PhoneOrderListModel *model = _dataArr[indexPath.row];
        cell.viewModel = model;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}
//TODO:----------获取充值记录
- (void)requestOrderListWithPageIndex:(NSInteger )pageIdx{
    BaseRequest *req = [BaseRequest new];
    req.userid = [Save userID];
  
    weakSelf(weakSelf);
    [NetWorkReqManager requestDataWithApiName:phoneSelectuserdata params:req response:^(NSDictionary *responseObject) {
        BaseResponse *rsp = [BaseResponse mj_objectWithKeyValues:responseObject];
        if (rsp.code == 0) {
            self.phoneOrderRsp = [PhoneOrderListRsp mj_objectWithKeyValues:responseObject];
            [weakSelf.dataArr addObjectsFromArray:self.phoneOrderRsp.data];
            [self.ibTableView reloadData];
            
        }else{
            [QuHudHelper qu_showMessage:rsp.msg];
        }
        [self.ibTableView.mj_header endRefreshing];
        [self.ibTableView.mj_footer endRefreshing];
        if (weakSelf.phoneOrderRsp.data.count == 0) {
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
    titleStr = @"暂无数据";
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
