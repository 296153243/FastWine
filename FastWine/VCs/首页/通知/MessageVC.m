//
//  MessageVC.m
//  CLTravel
//
//  Created by MOOSON_ on 2018/11/5.
//  Copyright © 2018年 MOOSON_. All rights reserved.
//

#import "MessageVC.h"
#import "MessageCell.h"
@interface MessageVC ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property(nonatomic,strong)MessageListRsp *messageRsp;
@property(nonatomic,strong)NSMutableArray *dataArr;

@property(nonatomic)NSInteger pageIndex;

@end

@implementation MessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.edgesForExtendedLayout = UIRectEdgeBottom;
//    self.navigationController.navigationBar.backgroundColor = NavColor;
    self.navigationItem.title = @"通知";

    _ibTableView.backgroundColor = HEXCOLOR(@"#FFF8F8F8");
    _ibTableView.tableFooterView = [UIView new];
    _ibTableView.emptyDataSetSource = self;
    _ibTableView.emptyDataSetDelegate = self;
    self.pageIndex = 0;
    _dataArr = [NSMutableArray array];
    [self requestMessageListWith:self.pageIndex];
    self.ibTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
         self.pageIndex++;
         [self requestMessageListWith:self.pageIndex];
        
    }];
    self.ibTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         self.pageIndex = 0;
         [self requestMessageListWith:self.pageIndex];
        
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MessageCell" owner:nil options:nil][0];
    }
    if (self.dataArr) {
        MessageListModel *model = self.dataArr[indexPath.row];
        cell.ibTitleLab.text = model.title;
        cell.ibContentLab.text = model.content;
        cell.ibTimeLab.text = model.add_time;
        if (model.isReaded == 1) {
            //已读消息
            cell.contentView.alpha = 0.5;
        }
     
    }
   
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessageListModel *model = self.dataArr[indexPath.row];
//    if (model.) {
//        <#statements#>
//    }
}
//TODO:----------消息列表
- (void)requestMessageListWith:(NSInteger )pageIdx{
    
    BaseRequest *req = [BaseRequest new];
    req.limit = @"10";
    req.page = [NSString stringWithFormat:@"%ld",pageIdx];
    if (pageIdx == 0) {
        [_dataArr removeAllObjects];
    }
    WS(weakSelf);
    [[HTTPRequest sharedManager]requestDataWithApiName:mymessageList withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        self.messageRsp = [MessageListRsp mj_objectWithKeyValues:responseObject[@"data"]];
        if (weakSelf.messageRsp.list.count == 0) {
            self.ibTableView.mj_footer.state = MJRefreshStateNoMoreData;
            return ;
        }
        [weakSelf.dataArr addObjectsFromArray:self.messageRsp.list];
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
    titleStr = @"暂无消息";
    attributrStr = [[NSAttributedString alloc] initWithString:titleStr attributes:dic];
    return attributrStr;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"NoneData_Icon"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
