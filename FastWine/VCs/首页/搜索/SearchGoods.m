//
//  SearchGoods.m
//  FastWine
//
//  Created by MOOSON_ on 2019/5/14.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "SearchGoods.h"
#import "OBDCollectionCell.h"
#import "GoodsDetalisVC.h"
@interface SearchGoods ()<UITextFieldDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionView;
@property (weak, nonatomic) IBOutlet UITextField *ibTextF;
@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic)NSInteger pageIndex;

@end

@implementation SearchGoods
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    _ibCollectionView.emptyDataSetSource = self;
    _ibCollectionView.emptyDataSetDelegate = self;
    
    //    [self.ibMainCollectionV.mj_header beginRefreshing];//自动刷新一下
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = NavColor;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navigationItem.title = @"商品搜索";
    [self configCollectionView];
    _ibTextF.text = _searchStr;
    self.pageIndex = 0;
    [self requestGoodsListWithIdx:self.pageIndex];
    self.ibCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 0;
        [self requestGoodsListWithIdx:self.pageIndex];
    }];
    self.ibCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex  =  self.pageIndex +10;
        [self requestGoodsListWithIdx:self.pageIndex];
        
    }];
    [self.ibTextF addTarget:self action:@selector(ibTextVanlueChange:) forControlEvents:UIControlEventEditingChanged];
    _ibTextF.returnKeyType = UIReturnKeySearch;//变为搜索按钮
    
    _ibTextF.delegate = self;//设置代理
    

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self requestGoodsListWithIdx:0];

    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    [self.navigationController popViewControllerAnimated:NO];
    return YES;
}

- (void)configCollectionView{
 
    [_ibCollectionView registerNib:[UINib nibWithNibName:@"OBDCollectionCell" bundle:nil] forCellWithReuseIdentifier:OBDCollectionCellID];
    _ibCollectionView.backgroundColor = WhiteColor;
}
- (IBAction)ibGoBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)ibTextVanlueChange:(UITextField *)sender {
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
 
        //OBD 商品
        OBDCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OBDCollectionCellID forIndexPath:indexPath];
        MainGoodsModel *model = _dataArr[indexPath.row];
        cell.viewModel = model;
        
        return cell;
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    
    return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (![Save isLogin]) {
        [self presentLoginWithComplection:^{
        }];
        return;
    }
    GoodsDetalisVC *vc = [[GoodsDetalisVC alloc]initWithNibName:@"GoodsDetalisVC" bundle:nil];
    MainGoodsModel *model = _dataArr[indexPath.row];
    vc.goodsId = model.id;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
 
   return CGSizeMake((SCREEN_WIDTH -20)/2, ((SCREEN_WIDTH -20)/2) * 1.4);

}
#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
     return 10;
   
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;

}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 5, 10, 5);
}

#pragma mark 获取商品

//商品
- (void)requestGoodsListWithIdx:(NSInteger)page
{
    GoodsSearchReq *req = [GoodsSearchReq new];
    req.first = [NSString stringWithFormat:@"%ld",page];
    req.limit = @"10";
    req.cId = _cid?_cid:@"0";
    req.sId = @"0";
    req.priceOrder = @"0";
    req.salesOrder = @"0";
    req.news = @"0";
    req.keyword =  [NSString encodeBase:_searchStr];
    
    if (page == 0) {
        [self.dataArr removeAllObjects];
    }
    [[HTTPRequest sharedManager]requestDataWithApiName:goodsSearch withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        MainGoodsRsp *mainGoodsRsp = [MainGoodsRsp mj_objectWithKeyValues:responseObject];
        [self.dataArr addObjectsFromArray:mainGoodsRsp.data];
        [self.ibCollectionView reloadData];
        [self.ibCollectionView.mj_header endRefreshing];
        [self.ibCollectionView.mj_footer endRefreshing];
        
        if (mainGoodsRsp.data.count == 0) {
            [self.ibCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
    } withError:^(NSError *error) {
        
    }];
    
}

#pragma mark - EmptyDataSet

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *titleStr;
    NSAttributedString *attributrStr;
    NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#b3b3b3"],
                          NSFontAttributeName : [UIFont systemFontOfSize:13]};
    titleStr = @"暂无合适商品";
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
