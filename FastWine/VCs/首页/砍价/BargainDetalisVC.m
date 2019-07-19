//
//  BargainDetalisVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/7/17.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "BargainDetalisVC.h"
#import "BargainHeardCell.h"
#import "BargainTitleCell.h"
#import "OBDCollectionCell.h"
#import "QuShareView.h"
#import <ShareSDK/ShareSDK.h>
#import "PlaceOrderVC.h"
#import "GoodsDetalisVC.h"
@interface BargainDetalisVC ()
@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionView;
@property(nonatomic,strong) CutDetailsRsp *dataRsp;
@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic)NSInteger pageIndex;

@end

@implementation BargainDetalisVC
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:CATDETALISEND_NOTIFICATION object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"砍价免费拿";
    [self configCollectionView];
    [self requestCat];
    self.pageIndex = 0;
    [self requestMainGoodsListWithIdx:self.pageIndex];
    self.ibCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex  =  self.pageIndex +10;
        [self requestMainGoodsListWithIdx:self.pageIndex];
        
    }];
}
- (void)configCollectionView{
    
    [_ibCollectionView registerNib:[UINib nibWithNibName:@"BargainHeardCell" bundle:nil] forCellWithReuseIdentifier:BargainHeardID];
    [_ibCollectionView registerNib:[UINib nibWithNibName:@"BargainTitleCell" bundle:nil] forCellWithReuseIdentifier:BargainTitleID];
    [_ibCollectionView registerNib:[UINib nibWithNibName:@"OBDCollectionCell" bundle:nil] forCellWithReuseIdentifier:OBDCollectionCellID];
    
  
    //    _ibCollectionView.backgroundColor = WhiteColor;
    
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 2) return self.dataArr.count;
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    

    if (indexPath.section == 0) {
         BargainHeardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BargainHeardID forIndexPath:indexPath];
        cell.viewModel = _dataRsp;
        [cell.ibCutbtn addTarget:self action:@selector(cutShareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if (indexPath.section == 1){
        BargainTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BargainTitleID forIndexPath:indexPath];
        return cell;
        
    }else if (indexPath.section == 2){
        OBDCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OBDCollectionCellID forIndexPath:indexPath];
        MainGoodsModel *model = _dataArr[indexPath.row];
        cell.viewModel = model;
        
        return cell;
    }else{
        return nil;
    }

    
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        GoodsDetalisVC *vc = [[GoodsDetalisVC alloc]initWithNibName:@"GoodsDetalisVC" bundle:nil];
        MainGoodsModel *model = _dataArr[indexPath.row];
        vc.goodsId = model.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return CGSizeMake(SCREEN_WIDTH, 660);
    if (indexPath.section == 1) return CGSizeMake(SCREEN_WIDTH, 125);
    if (indexPath.section == 2) return CGSizeMake((SCREEN_WIDTH -20)/2, ((SCREEN_WIDTH -20)/2) * 1.4);
    return CGSizeMake(SCREEN_WIDTH, 0.1);
    
}
#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 2) return 10;
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 2) return 5;
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 2) return UIEdgeInsetsMake(10, 5, 10, 5);
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
-(void)cutShareBtnAction:(UIButton *)sender{
    
    if ([sender.titleLabel.text isEqualToString:@"立即购买"]) {
        [self requestconPlaceOrder];
        return ;
    }
    QuShareModel *model = [QuShareModel new];
    model.title = @"帮我砍个价";
    model.content = [NSString stringWithFormat: @"我在同城快酒上发现意外好货,一起来砍价低至%@元拿",_dataRsp.bargain.min_price];
    model.imageUrl = _dataRsp.bargain.image;
    model.targetUrl = [NSString stringWithFormat:@"http://test.jiudicar.com/wap/store/cut_con/id/%@/bargainUid/%@.html",_catId,_dataRsp.userInfoBargain.uid];
    
    [self loadAppShareWithModel:model];
}
- (void)loadAppShareWithModel:(QuShareModel *)model
{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:@(SSDKPlatformSubTypeWechatTimeline)];
    [array addObject:@(SSDKPlatformSubTypeWechatSession)];
    [array addObject:@(SSDKPlatformSubTypeQQFriend)];
    
    model.platforms = [NSArray arrayWithArray:array];
    
    [QuShareView showShareWithModel:model success:^{
        
        [QuHudHelper qu_showMessage:@"分享成功"];
        //暂时不用告知H5
        //        [weakSelf.ocjsWebBridge callHandler:@"shareComplete" data:@{ @"code":@"1" }];
        
    } fail:^{
        
        [QuHudHelper qu_showMessage:@"分享失败"];
    }];
}
-(void)requestCat{
    CutReq *req = [CutReq new];
    req.id = _catId;
    req.bargainUid = @"0";
    [[HTTPRequest sharedManager]requestDataWithApiName:cut_con withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        self.dataRsp = [CutDetailsRsp mj_objectWithKeyValues:responseObject[@"data"]];
        [self.ibCollectionView reloadData];
    } withError:^(NSError *error) {
        
    }];
}
//MARK:---下单
- (void)requestconPlaceOrder
{
    AddCarReq *req = [AddCarReq new];
    req.productId = _dataRsp.bargain.product_id;
    req.cartNum = [NSString stringWithFormat:@"%@",_dataRsp.bargain.bargain_num];
    req.bargainId = _dataRsp.bargain.id;
    
    [[HTTPRequest sharedManager]requesGetDataWithApiName:mainGoodsPalceOrder withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        
        PlaceOrderVC *vc = [[PlaceOrderVC alloc]initWithNibName:@"PlaceOrderVC" bundle:nil];
        vc.cartId = responseObject[@"data"][@"cartId"];
        [self.navigationController pushViewController:vc animated:YES];
        
    } withError:^(NSError *error) {
        
    }];
    
}
//可能喜欢商品
- (void)requestMainGoodsListWithIdx:(NSInteger)page
{
    
    BaseRequest *req = [BaseRequest new];
    req.first = [NSString stringWithFormat:@"%ld",page];
    req.limit = @"10";
    req.cId = @"0";
    if (_pageIndex == 0) {
        [_dataArr removeAllObjects];
        
    }
    [[HTTPRequest sharedManager]requesGetDataWithApiName:mainGoodsList withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        MainGoodsRsp *mainGoodsRsp = [MainGoodsRsp mj_objectWithKeyValues:responseObject];
        [self.dataArr addObjectsFromArray:mainGoodsRsp.data];
        [UIView performWithoutAnimation:^{
            [self.ibCollectionView reloadData];
//            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:2];
//            [self.ibCollectionView reloadSections:indexSet];
        }];
        [self.ibCollectionView.mj_footer endRefreshing];
        if (mainGoodsRsp.data.count == 0) {
            [self.ibCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
    } withError:^(NSError *error) {
        
    }];
    
}
-(NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
