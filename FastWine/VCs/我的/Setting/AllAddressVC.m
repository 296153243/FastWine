//
//  AllAddressVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/5/14.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "AllAddressVC.h"
#import <MJExtension.h>
#import "AddressShowTableViewController.h"
#import "AddressTableViewCell.h"
@interface AllAddressVC ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate> {
    NSMutableArray *addressDataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;

@end

static NSString *reuserIdentifier = @"AddreTableViewCell";

@implementation AllAddressVC

//#warning didSelectRowAtIndexPath逻辑还没写
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //    [self requestOrderListWithPageIndex:self.pageIndex];
    
    //  self.tableView.frame = CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - SafeAreaTopHeight);
        self.ibTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getAddressList];
    
        }];
        [self.ibTableView.mj_header beginRefreshing];//自动刷新一下
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //        self.automaticallyAdjustsScrollViewInsets = YES;
    //    //偏移问题
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    //    self.navigationController.navigationBar.backgroundColor = NavColor;
    //
    

    [self inintNavViews];
    [self getAddressList];
    [self initTableView];
    
    
    self.ibTableView.rowHeight = 220;
    self.ibTableView.tableFooterView = [UIView new];
    self.ibTableView.emptyDataSetSource = self;
    self.ibTableView.emptyDataSetDelegate = self;
    
    
}


-(void)inintNavViews {
    self.title = @"收货地址";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem rightItemWithTitle:@"添加" Target:self action:@selector(addNewAddress)];
}
-(void)addNewAddress{
    AddressShowTableViewController *vc = [[AddressShowTableViewController alloc] initWithPageType:Address_Create];
    [self.navigationController pushViewController:vc animated:YES];
}
//编辑地址
-(void)editBtnClick:(UIButton *)sender{
    AddressShowTableViewController *vc = [[AddressShowTableViewController alloc] initWithPageType:Address_Edit];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)initTableView {
    
    
    [self.ibTableView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:reuserIdentifier];
    self.ibTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.ibTableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [addressDataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     AddressTableViewCell *addrsCell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier forIndexPath:indexPath];
     addrsCell.rightImgView.image = IMAGE(@"edit_address");
     [addrsCell setAddressModel:addressDataArray[indexPath.section]];
     */
    AddressTableViewCell *addrsCell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier forIndexPath:indexPath];
    //    [addrsCell.ibeditAdderssBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //排序
    [addressDataArray sortUsingComparator:^NSComparisonResult(EPAddressModel *obj1, EPAddressModel *obj2) {
        return [obj2.is_default compare:obj1.is_default];
    }];
    [addrsCell setEpaddressModel:addressDataArray[indexPath.section]];
    
    return addrsCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EPAddressModel *address = addressDataArray[indexPath.section];
    if (!_isFeedUp) {
        AddressShowTableViewController *vc = [[AddressShowTableViewController alloc] initWithPageType:Address_Edit];
        //vc.addressModel = address;
        vc.epaddressModel = address;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        
        if (self.addressBlock) {
            self.addressBlock(address);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EPAddressModel *model = addressDataArray[indexPath.section];
    
    return [model.detail stringHeighFontSize:13 width:SCREEN_WIDTH - 65]  + 70;
}


-(void)setAddressBlock:(ChangeReceiceAddress)block {
    if (_receiveAddress != block) {
        _receiveAddress = [block copy];
    }
}

-(ChangeReceiceAddress)addressBlock {
    return _receiveAddress;
}

// 获取地址列表
- (void)getAddressList
{
    
    OrderListReq *req = [OrderListReq new];
    req.customer_id = [Save userID];
    [[HTTPRequest sharedManager]requesGetDataWithApiName:addressList withParameters:nil isEnable:NO withSuccess:^(id responseObject) {
        NSArray *dataarr =responseObject[@"data"][@"address"];
        self->addressDataArray = [EPAddressModel mj_objectArrayWithKeyValuesArray:dataarr];
        [self.ibTableView.mj_header endRefreshing];
        [self.ibTableView reloadData];
    } withError:^(NSError *error) {
        
    }];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了删除");
        DeleteAddressReq *req = [DeleteAddressReq new];
        //        req.customer_id = [Save userID];
        EPAddressModel *model = self->addressDataArray[indexPath.section];
        req.addressId = model.id;
        [[HTTPRequest sharedManager]requestDataWithApiName:deleteAddress withParameters:req isEnable:NO withSuccess:^(id responseObject) {
            
            [self getAddressList];
        } withError:^(NSError *error) {
            
        }];
        
    }];
    
    return @[deleteAction];
}
#pragma mark - EmptyDataSet

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *titleStr;
    NSAttributedString *attributrStr;
    NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#b3b3b3"],
                          NSFontAttributeName : [UIFont systemFontOfSize:13]};
    titleStr = @"暂无收货地址哦";
    attributrStr = [[NSAttributedString alloc] initWithString:titleStr attributes:dic];
    return attributrStr;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"NoneData_Icon"];
}


@end
