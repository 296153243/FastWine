//
//  AllEvaluationVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/5/13.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "AllEvaluationVC.h"
#import "GoodsDetalisCell.h"
@interface AllEvaluationVC ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic)NSInteger pageIndex;

@end

@implementation AllEvaluationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.navigationItem.title = @"全部评价";
    _ibTableView.backgroundColor = HEXCOLOR(@"#FFF8F8F8");
    _ibTableView.tableFooterView = [UIView new];
    _ibTableView.emptyDataSetSource = self;
    _ibTableView.emptyDataSetDelegate = self;
    self.pageIndex = 0;
    _dataArr = [NSMutableArray array];
    [self requestDataWith:self.pageIndex];
    self.ibTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
      self.pageIndex  =  self.pageIndex + 10;
        [self requestDataWith:self.pageIndex];
        
    }];
    self.ibTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 0;
        [self requestDataWith:self.pageIndex];
        
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_dataArr.count > 0) {
        ReplyModel *model = [ReplyModel mj_objectWithKeyValues:_dataArr[indexPath.row]];
        if (model.pics.count > 0) {
            //
            return 180;
            
        }else{
            
            return [model.comment stringHeighFontSize:14 width:SCREEN_WIDTH - 20] + 70;
        }
    }
    return 0.1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodsDetalisCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetalisCell"];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"GoodsDetalisCell" owner:nil options:nil][2];
    }
    if (_dataArr.count > 0) {
        ReplyModel *model = [ReplyModel mj_objectWithKeyValues:_dataArr[indexPath.row]];
        cell.replyModel = model;
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    MessageListModel *model = self.dataArr[indexPath.row];
    //    if (model.) {
    //        <#statements#>
    //    }
}
//TODO:----------列表
- (void)requestDataWith:(NSInteger )pageIdx{
    
    BaseRequest *req = [BaseRequest new];
    req.limit = @"10";
    req.productId = _goodsDetalisRsp.storeInfo.id;
    req.first = [NSString stringWithFormat:@"%ld",pageIdx];
    if (pageIdx == 0) {
        [_dataArr removeAllObjects];
    }
    WS(weakSelf);
    [[HTTPRequest sharedManager]requestDataWithApiName:evaluationlist withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        ReplyListRsp *rsp = [ReplyListRsp mj_objectWithKeyValues:responseObject];
        if (rsp.data.count == 0) {
            self.ibTableView.mj_footer.state = MJRefreshStateNoMoreData;
            return ;
        }
        [weakSelf.dataArr addObjectsFromArray:rsp.data];
        [self.ibTableView reloadData];
        [self.ibTableView.mj_header endRefreshing];
        [self.ibTableView.mj_footer endRefreshing];
    } withError:^(NSError *error) {
        
    }];
    
}

#pragma mark - EmptyDataSet

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *titleStr;
    NSAttributedString *attributrStr;
    NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#b3b3b3"],
                          NSFontAttributeName : [UIFont systemFontOfSize:13]};
    titleStr = @"暂无评价";
    attributrStr = [[NSAttributedString alloc] initWithString:titleStr attributes:dic];
    return attributrStr;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"NoneData_Icon"];
}

@end
