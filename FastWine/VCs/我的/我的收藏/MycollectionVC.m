//
//  MycollectionVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/5/5.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "MycollectionVC.h"
#import "MycollectionCell.h"
#import "GoodsDetalisVC.h"
@interface MycollectionVC ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,FSSegmentTitleViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property(nonatomic)NSInteger pageIndex;
@property(nonatomic,strong)CollectListRsp *collectListData;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong) FSSegmentTitleView *navTitleView;
@end

@implementation MycollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的收藏";
 
    
    _ibTableView.backgroundColor = WhiteColor;
    _ibTableView.emptyDataSetSource = self;
    _ibTableView.emptyDataSetDelegate = self;
    _ibTableView.tableFooterView = [UIView new];
    
    self.pageIndex = 0;
    _dataArr = [NSMutableArray array];
    [self requestCouponListWithPageIndex:self.pageIndex];
    self.ibTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
      self.pageIndex  =  self.pageIndex +10;
        [self requestCouponListWithPageIndex:self.pageIndex];
        
    }];
    self.ibTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 0;
        [self requestCouponListWithPageIndex:self.pageIndex];
        
    }];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MycollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MycollectionCell"];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MycollectionCell" owner:nil options:nil][0];
    }
    if (_dataArr.count > 0) {
        cell.viewModel = _dataArr[indexPath.row];
    }
    cell.clickDelectBlock = ^(CollectListModel * _Nonnull model) {
        [self requestCancelCollectGoodsWithModel:model];
    };
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GoodsDetalisVC *vc = [[GoodsDetalisVC alloc]initWithNibName:@"GoodsDetalisVC" bundle:nil];
    CollectListModel *model = _dataArr[indexPath.row];
    vc.goodsId = model.pid;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//TODO:----------data列表
- (void)requestCouponListWithPageIndex:(NSInteger )pageIndex{
    BaseRequest *req = [BaseRequest new];
    req.limit =@"10";
    req.first = [NSString stringWithFormat:@"%ld",(long)pageIndex];
    if (pageIndex == 0) {
        [_dataArr removeAllObjects];
    }
    [[HTTPRequest sharedManager]requestDataWithApiName:mycollect_product withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        
        self.collectListData= [CollectListRsp mj_objectWithKeyValues:responseObject];
        [self.dataArr addObjectsFromArray:self.collectListData.data];
        [self.ibTableView reloadData];
        [self.ibTableView.mj_header endRefreshing];
        [self.ibTableView.mj_footer endRefreshing];
        if (self.collectListData.data.count == 0) {
            [self.ibTableView.mj_footer endRefreshingWithNoMoreData];
        }
    } withError:^(NSError *error) {
        
    }];
  
}
//MARK:---删除收藏商品
- (void)requestCancelCollectGoodsWithModel:(CollectListModel *)model
{
    AddCarReq *req= [AddCarReq new];
    req.productId = model.pid;
    [[HTTPRequest sharedManager]requesGetDataWithApiName:delete_product withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        [QuHudHelper qu_showMessage:@"删除收藏"];
        [self requestCouponListWithPageIndex:0];
    } withError:^(NSError *error) {
        
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
