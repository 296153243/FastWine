//
//  MainVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/6/13.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "MainVC.h"
#import "DHGuidePageHUD.h"
#import "MainBannerCollectionCell.h"
#import "MainCollectionCell.h"
#import "TitleCollectionCell.h"
#import "MainGoodsCell.h"
#import "MainHotSaleCell.h"
#import "MainHotCakesCell.h"
#import "MainHotGoodsCell.h"
#import "GoodsDetalisVC.h"
#import "MoreCreditVC.h"
#import "MoreGoodsVC.h"
#import "MyWalletVC.h"
#import "QrCodeVC.h"
#import "MyPromotionVC.h"
#import "MessageVC.h"
#import "SearchGoods.h"
#import <PYSearch.h>
#import "VersionAlertView.h"
#import "GoodsVC.h"
#import "RegistVC.h"
#import "MainOneVC.h"
#import "CouPonVC.h"
#import "OwnersRightsVC.h"
#import "IhaveGoodsVC.h"
#import "BargainingVC.h"
@interface MainVC ()<UICollectionViewDataSource, UIScrollViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,FSPageContentViewDelegate,FSSegmentTitleViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *ibSearchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *ibMainCollectionV;
@property(nonatomic,strong) NSArray * titleArr;
@property(nonatomic,strong) NSArray * titleIconArr;
@property (nonatomic, strong) NSArray *slideArray; ///<轮播图数组
@property (nonatomic, strong) NSArray *categoryArray; ///商品分类数组
@property (nonatomic, strong) NSMutableArray *classArray; ///分类数组
@property (nonatomic, strong) NSArray *hotGoodsArray; ///商品热卖数组
@property (nonatomic, strong) NSArray *productArray; ///热销数组
@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,strong)NSArray *hotkeywordArr;
@property(nonatomic)NSInteger pageIndex;
@property (strong, nonatomic) UIView *activityView;//活动View
@property (strong, nonatomic) UIButton *blackBtn;
@property(strong,nonatomic)NSString *cid;//分类id
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibNavTop;
@property(nonatomic)NSInteger endIdx;
@property(nonatomic)BOOL isRefresh;
@property(nonatomic)BOOL isRefreshOne;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibcollctionVBootom;

@end

@implementation MainVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    [self.navigationController setNavigationBarHidden:YES animated:animated];

    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = NavColor;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
 
    //接收登录成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess)
                                                 name:LOGIN_SUCCESS_NOTIFICATION
                                               object:nil];
    
    self.titleArr = @[@"招商代理",@"商务合作",@"砍价",@"优惠券"];
    self.titleIconArr = @[@"main_daili",@"main_hezuo",@"main_kanjia",@"main_youhuiquan"];
    [self requestDataWithGetFlash];
    [self requestHotkeyword];
    self.pageIndex = 0;
    [self requestMainGoodsListWithIdx:self.pageIndex];
    self.ibMainCollectionV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 0;
//        self.isRefresh = NO;
//        self.isRefreshOne = NO;
        [self requestMainGoodsListWithIdx:self.pageIndex];
        [self requestDataWithGetFlash];
    }];
//    [self.ibMainCollectionV.mj_header beginRefreshing];//自动刷新一下
    _ibMainCollectionV.backgroundColor = HEXCOLOR(@"#F9F9F9");
    
    self.ibMainCollectionV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex  =  self.pageIndex +10;
        [self requestMainGoodsListWithIdx:self.pageIndex];
        
    }];
    //    [self initNav];
    self.navigationController.navigationBar.barTintColor = TableColor;
    
    self.ibcollctionVBootom.constant = SafeAreaBottomHeight + 49;
   
    //头部搜索框
    self.ibSearchBar.backgroundImage = [[UIImage alloc]init];
    UITextField *searchField=[self.ibSearchBar valueForKey:@"_searchField"];
    searchField.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    searchField.clipsToBounds =YES;
    searchField.layer.cornerRadius = 5;
    
    //接收刷新数据通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(uploadData:)
                                                 name:UPLOADMAINDATA_NOTIFICATION
                                               object:nil];
    //接收登录成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess)
                                                 name:LOGIN_SUCCESS_NOTIFICATION
                                               object:nil];
    
}
-(void)uploadData:(NSNotification *)notification{
    NSString *str = [notification object];
    _cid = str;
    [self requestDataWithGetFlash];
    [self requestMainGoodsListWithIdx:_pageIndex];
    
}
-(void)loginSuccess{
    [self requestDataWithGetFlash];
    [self requestMainGoodsListWithIdx:_pageIndex];
    
}
//第一次进入 展示广告
- (void)addGuideView {
    _activityView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //    _ibBgBlackView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    UIButton *blackbg = [UIButton buttonWithType:UIButtonTypeCustom];
    [blackbg setFrame:CGRectMake(0, 0, _activityView.qu_size.width,  _activityView.qu_size.height)];
    [blackbg setBackgroundImage:[UIImage imageNamed:@"yinying_black"] forState:UIControlStateNormal];
    [blackbg addTarget:self action:@selector(selectBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //    _blackBtn = blackbg;
    //    [[[UIApplication sharedApplication] keyWindow]addSubview:blackbg];
    
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guanggao_bg"]];
    UIButton *joinbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [joinbtn setImage:[UIImage imageNamed:@"jikejiaru"] forState:UIControlStateNormal];
    [joinbtn addTarget:self action:@selector(joinBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelbtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [cancelbtn addTarget:self action:@selector(selectBackAction:) forControlEvents:UIControlEventTouchUpInside];
    [_activityView addSubview:blackbg];
    [_activityView addSubview:img];
    [_activityView addSubview:joinbtn];
    [_activityView addSubview:cancelbtn];
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.centerX.mas_equalTo(self.activityView.mas_centerX);
    }];
    [joinbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(img.mas_bottom);
        make.centerX.mas_equalTo(self.activityView.mas_centerX);
        
        
    }];
    [cancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(img.mas_right).mas_equalTo(WScale(10));
        make.top.mas_equalTo(50);
    }];
    _activityView.tag=1220;
    
    [[UIApplication sharedApplication].keyWindow addSubview:_activityView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_activityView];
    
    
}
-(void)selectBackAction:(UIButton *)sender{
    [_activityView removeFromSuperview];
    [_blackBtn removeFromSuperview];
    [[[UIApplication sharedApplication].keyWindow viewWithTag:1220] removeFromSuperview];
    //记录操作——用于广告展示
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AfterLoggingIn];
}

- (void)configCollectionView{
    [_ibMainCollectionV registerNib:[UINib nibWithNibName:@"MainBannerCollectionCell" bundle:nil] forCellWithReuseIdentifier:MainBannerCollectionCellID];
    [_ibMainCollectionV registerNib:[UINib nibWithNibName:@"MainCollectionCell" bundle:nil] forCellWithReuseIdentifier:MainCollectionCellID];
    [_ibMainCollectionV registerNib:[UINib nibWithNibName:@"MainHotGoodsCell" bundle:nil] forCellWithReuseIdentifier:MainHotGoodsCellID];
    [_ibMainCollectionV registerNib:[UINib nibWithNibName:@"MainHotCakesCell" bundle:nil] forCellWithReuseIdentifier:MainHotCakesCellID];
        [_ibMainCollectionV registerNib:[UINib nibWithNibName:@"MainGoodsCell" bundle:nil] forCellWithReuseIdentifier:MainGoodsCellID];
    _ibMainCollectionV.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];;
    _ibMainCollectionV.delegate = self;
    _ibMainCollectionV.dataSource = self;
   
    
    
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) return 1;
    if (section == 1) return _titleArr.count;
    if (section == 4) return _dataArr.count;
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MainBannerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MainBannerCollectionCellID forIndexPath:indexPath];
        NSMutableArray *arr= [NSMutableArray array];
        
        for (PSSlideModel *model in self.slideArray) {
            [arr addObject:model.pic];
        }
        
        cell.cycleScrollView.imageURLStringsGroup = arr;
        cell.mainBannerBlock = ^(NSInteger idx){
            PSSlideModel *model = self.slideArray[idx];
            NSArray *arr = [model.url componentsSeparatedByString:@"/"];
            GoodsDetalisVC *vc = [[GoodsDetalisVC alloc]initWithNibName:@"GoodsDetalisVC" bundle:nil];
            vc.goodsId = [arr lastObject];
            [self.navigationController pushViewController:vc animated:YES];
            
        };
        return cell;
    } else if (indexPath.section == 1) {
        //热卖
        MainCollectionCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:MainCollectionCellID forIndexPath:indexPath];
        cell.ibTitleLab.text = _titleArr[indexPath.row];
        cell.ibIconImg.image = [UIImage imageNamed:_titleIconArr[indexPath.row]];
        return cell;
    } else if (indexPath.section == 2) {
        //热卖
        MainHotGoodsCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:MainHotGoodsCellID forIndexPath:indexPath];

        if (_isRefresh != YES) {
            
            if (_productArray) {
               cell.dataArr = _productArray;
                _isRefresh = YES;
            }
        }
        
        cell.newsClickBlock = ^{
            if (![Save isLogin]) {
                [self presentLoginWithComplection:^{
                }];
                return ;
            }
            [self requestget_coupon_user];
        };
        cell.itemClickBlock = ^(MainCategoryModel * _Nonnull model) {
            GoodsDetalisVC *vc = [[GoodsDetalisVC alloc]initWithNibName:@"GoodsDetalisVC" bundle:nil];
            vc.goodsId = model.product_id;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }else if (indexPath.section == 3) {
        //热销
        MainHotCakesCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:MainHotCakesCellID forIndexPath:indexPath];
//        cell.dataArr = _hotGoodsArray;

        if (_isRefreshOne != YES) {
            if (_hotGoodsArray) {
                cell.dataArr = _hotGoodsArray;
                _isRefreshOne = YES;
            }
        }
        cell.itemClickBlock = ^(MainCategoryModel * _Nonnull model) {
            GoodsDetalisVC *vc = [[GoodsDetalisVC alloc]initWithNibName:@"GoodsDetalisVC" bundle:nil];
            vc.goodsId = model.product_id;
            [self.navigationController pushViewController:vc animated:YES];
           
        };
        return cell;
        
    }else{
        //分类
        //        TitleCollectionCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:TitleCollectionCellID forIndexPath:indexPath];
        //        //        NSMutableArray *childVCs = [NSMutableArray array];
        //        //        [_classArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //        ////            UIViewController *vc = [UIViewController new];
        //        ////            vc.view.backgroundColor = RGBACOLOR(arc4random() % 255, arc4random() % 255, arc4random() % 255, 1.0);
        //        //            GoodsVC *vc = [[GoodsVC alloc]initWithNibName:@"GoodsVC" bundle:nil];
        //        //            [childVCs addObject:vc];
        //        //        }];
        //        //        self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - 114) childVCs:childVCs parentVC:self delegate:self];
        //        //
        //        ////        self.pageContentView.contentViewCurrentIndex = 0;
        //        //        //  self.pageContentView.contentViewCanScroll = NO;//设置滑动属性
        //        //        self.automaticallyAdjustsScrollViewInsets = NO;
        //        //
        //        //        [cell.ibBgView addSubview:_pageContentView];
        //        return cell;
        //商品
        MainGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MainGoodsCellID forIndexPath:indexPath];
        if (_dataArr.count > 0) {
            MainGoodsModel *model = _dataArr[indexPath.row];
            cell.viewModel = model;
        }
       
        cell.buyBtnCickBlock = ^(MainGoodsModel * _Nonnull goodsmodel) {
            GoodsDetalisVC *vc = [[GoodsDetalisVC alloc]initWithNibName:@"GoodsDetalisVC" bundle:nil];
            vc.goodsId = goodsmodel.id;
            [self.navigationController pushViewController:vc animated:YES];
          
        };
        return cell;
    }
    
}
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        if (![Save isLogin]) {
            [self presentLoginWithComplection:^{
            }];
            return ;
        }
        if (indexPath.row == 0) {
           //招商代理
            OwnersRightsVC *vc = [[OwnersRightsVC alloc]initWithNibName:@"OwnersRightsVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1){
           //商务合作
            IhaveGoodsVC *vc = [[IhaveGoodsVC alloc]initWithNibName:@"IhaveGoodsVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 2){
            //砍价
            BargainingVC *vc = [[BargainingVC alloc]initWithNibName:@"BargainingVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            //优惠券
            CouPonVC *vc = [[CouPonVC alloc]initWithNibName:@"CouPonVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } else  if (indexPath.section == 4) {
        GoodsDetalisVC *vc = [[GoodsDetalisVC alloc]initWithNibName:@"GoodsDetalisVC" bundle:nil];
        MainGoodsModel *model = _dataArr[indexPath.row];
        vc.goodsId = model.id;
        [self.navigationController pushViewController:vc animated:YES];
      
    }
    
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return CGSizeMake(SCREEN_WIDTH, 200);
    if (indexPath.section == 1) return CGSizeMake((SCREEN_WIDTH - 140)/4, 80);
    if (indexPath.section == 2) return CGSizeMake(SCREEN_WIDTH, 230);
    if (indexPath.section == 3) return CGSizeMake(SCREEN_WIDTH, 170);
    if (indexPath.section == 4) return CGSizeMake(SCREEN_WIDTH, 265);

    return CGSizeMake((int)((SCREEN_WIDTH-48)/2), (SCREEN_WIDTH-48)/2 *3 /5 );
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 1) return 20;
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 1) return UIEdgeInsetsMake(10, 20, 10, 20);
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark 获取轮播图数据
///获取轮播图
- (void)requestDataWithGetFlash
{
    
    [[HTTPRequest sharedManager]requesGetDataWithApiName:getHomeIcon withParameters:nil isEnable:YES withSuccess:^(id responseObject) {
        self.slideArray = [PSSlideModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"banner"]];
        self.categoryArray = [MainCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"category_recommend"]];
        self.classArray = [GoodsClassModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"category"]];
        GoodsClassModel *model = [GoodsClassModel new];
        model.id = @"0";
        model.cate_name = @"推荐";
        [self.classArray  insertObject:model atIndex:0];
        self.hotGoodsArray = [MainCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"store_hot"]];
        self.productArray = [MainCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"store_product"]];
        
        [self configCollectionView];
        [UIView performWithoutAnimation:^{
            [self.ibMainCollectionV reloadData];

        }];

        [UIView performWithoutAnimation:^{
            //刷新界面
        
//            NSIndexSet *indexSet1 = [[NSIndexSet alloc] initWithIndex:1];
//            [self.ibMainCollectionV reloadSections:indexSet1];
//            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
//            [self.ibMainCollectionV reloadSections:indexSet];
//            NSIndexSet *indexSet2 = [[NSIndexSet alloc] initWithIndex:2];
//            [self.ibMainCollectionV reloadSections:indexSet2];

//            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
//            [self.ibMainCollectionV reloadSections:indexSet];
//            NSIndexSet *indexSet1 = [[NSIndexSet alloc] initWithIndex:1];
//            [self.ibMainCollectionV reloadSections:indexSet1];
//            NSIndexSet *indexSet2 = [[NSIndexSet alloc] initWithIndex:2];
//            [self.ibMainCollectionV reloadSections:indexSet2];
//            NSIndexSet *indexSet3 = [[NSIndexSet alloc] initWithIndex:3];
//            [self.ibMainCollectionV reloadSections:indexSet3];
        }];
        
    } withError:^(NSError *error) {
        
    }];
    
}

//首页商品
- (void)requestMainGoodsListWithIdx:(NSInteger)page
{
    
    BaseRequest *req = [BaseRequest new];
    req.first = [NSString stringWithFormat:@"%ld",page];
    req.limit = @"10";
    req.cId = _cid?_cid:@"0";
    if (_pageIndex == 0) {
        [_dataArr removeAllObjects];
        
    }
    
    [[HTTPRequest sharedManager]requesGetDataWithApiName:mainGoodsList withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        MainGoodsRsp *mainGoodsRsp = [MainGoodsRsp mj_objectWithKeyValues:responseObject];
        [self.dataArr addObjectsFromArray:mainGoodsRsp.data];
//        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:3];
//        [self.ibMainCollectionV reloadSections:indexSet];
        [UIView performWithoutAnimation:^{
            [self.ibMainCollectionV reloadData];

        }];
        [self.ibMainCollectionV.mj_header endRefreshing];
        [self.ibMainCollectionV.mj_footer endRefreshing];
        if (mainGoodsRsp.data.count == 0) {
            [self.ibMainCollectionV.mj_footer endRefreshingWithNoMoreData];
        }
    } withError:^(NSError *error) {
        
    }];
    
}

//MARK:----热门关键子
-(void)requestHotkeyword{
    [[HTTPRequest sharedManager]requesGetDataWithApiName:hotkeyword withParameters:nil isEnable:YES withSuccess:^(id responseObject) {
        self.hotkeywordArr = responseObject[@"data"];
        
    } withError:^(NSError *error) {
        
    }];
}
//MARK:----新人领取优惠券
-(void)requestget_coupon_user{
    [[HTTPRequest sharedManager]requesGetDataWithApiName:get_coupon_user withParameters:nil isEnable:YES withSuccess:^(id responseObject) {
        [QuHudHelper qu_showMessage:responseObject[@"msg"]];
        //优惠券
        CouPonVC *vc= [[CouPonVC alloc]initWithNibName:@"CouPonVC" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } withError:^(NSError *error) {
        
    }];
}


-(NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)classArray{
    if (_classArray == nil) {
        _classArray = [NSMutableArray array];
    }
    return _classArray;
}
- (void)requestAppVersionCheck
{
    BaseRequest *req = [BaseRequest new];
    req.type = @"2";
    
    
    [[HTTPRequest sharedManager]requestDataWithApiName:checkVersion withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        NSLog(@"CLIENT_VERSION:%@",CLIENT_VERSION);
        if ([responseObject[@"data"]integerValue] == 1) {
            UIAlertController * altController = [UIAlertController alertControllerWithTitle:@"有新的版本更新" message:@"赶快去更新哦" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [altController addAction:cancelAction];
            
            if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
                [cancelAction setValue:[UIColor grayColor] forKey:@"titleTextColor"];
            }
            UIAlertAction * yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_APP_CHECK]];
            }];
            
            [altController addAction:yesAction];
            [self presentViewController:altController animated:YES completion:nil];
            
        }
    } withError:^(NSError *error) {
        
    }];
    //
    
    
}
@end
