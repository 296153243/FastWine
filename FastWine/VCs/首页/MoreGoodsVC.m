//
//  MoreGoodsVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/4/17.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "MoreGoodsVC.h"
#import "OBDCollectionCell.h"
#import "GoodsDetalisVC.h"
@interface MoreGoodsVC ()
@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionView;
@property(nonatomic,strong)MainGoodsRsp *mainGoodsRsp;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic)NSInteger pageIndex;
@end

@implementation MoreGoodsVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.pageIndex = 1;
    _dataArr = [NSMutableArray array];
    //    [self requestOrderListWithPageIndex:self.pageIndex];
    
    self.ibCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self requestGoodsListWithPage:self.pageIndex];
        
    }];
    [self.ibCollectionView.mj_header beginRefreshing];//自动刷新一下
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"车主精选";
    
    self.ibCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex++;
        [self requestGoodsListWithPage:self.pageIndex];

    }];
    _ibCollectionView.backgroundColor = WhiteColor;
    [_ibCollectionView registerNib:[UINib nibWithNibName:@"OBDCollectionCell" bundle:nil] forCellWithReuseIdentifier:OBDCollectionCellID];
    
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //OBD 商品
    OBDCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OBDCollectionCellID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"OBDCollectionCell" owner:nil options:nil][0];
    }
    MainGoodsModel *model = _dataArr[indexPath.row];
    cell.viewModel = model;
    return cell;
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    
    return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
    GoodsDetalisVC *vc = [[GoodsDetalisVC alloc]initWithNibName:@"GoodsDetalisVC" bundle:nil];
    MainGoodsModel *model = _mainGoodsRsp.data[indexPath.row];
    vc.goodsId = model.id;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((SCREEN_WIDTH -50)/2, ((SCREEN_WIDTH -50)/2) * 1.43);
    
}
#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
   
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
   return 20;
  
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 12, 15, 12);
   
}

//首页商品
- (void)requestGoodsListWithPage:(NSInteger)page
{
    BaseRequest *req = [BaseRequest new];
    req.page = [NSString stringWithFormat:@"%ld",page];
    req.limit = @"10";
    if (page == 1) {
        [_dataArr removeAllObjects];
    }
    weakSelf(weakSelf)
    [[HTTPRequest sharedManager]requestDataWithApiName:mainGoodsList withParameters:req isEnable:YES withSuccess:^(id responseObject) {
       
        BaseResponse *rsp = [BaseResponse mj_objectWithKeyValues:responseObject];
        if (rsp.code == 0) {
           weakSelf.mainGoodsRsp = [MainGoodsRsp mj_objectWithKeyValues:responseObject];
            [weakSelf.dataArr addObjectsFromArray:weakSelf.mainGoodsRsp.data];
            [weakSelf.ibCollectionView reloadData];

        }else{
            [QuHudHelper qu_showMessage:rsp.msg];
        }
        [self.ibCollectionView.mj_header endRefreshing];
        [self.ibCollectionView.mj_footer endRefreshing];
        if (weakSelf.mainGoodsRsp.data.count == 0) {
            [self.ibCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } withError:^(NSError *error) {
        
    }];
    
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
