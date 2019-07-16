//
//  MainOneVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/6/13.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "MainOneVC.h"
#import "DHGuidePageHUD.h"
#import "MainBannerCollectionCell.h"
#import "MainCollectionCell.h"
#import "TitleCollectionCell.h"
#import "OBDCollectionCell.h"
#import "MainHotSaleCell.h"
#import "MainHotCakesCell.h"
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
@interface MainOneVC ()<UICollectionViewDataSource, UIScrollViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,FSPageContentViewDelegate,FSSegmentTitleViewDelegate>
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
@property (weak, nonatomic) IBOutlet UIButton *ibCityBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibTopViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibTopItemCenterY;
@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) FSSegmentTitleView *titleView;
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

@implementation MainOneVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //    [self requestAppVersionCheck];
    if (![Save isLogin]) {
        [self presentLoginWithComplection:^{
        }];
        return;
    }else{
//        [self requestUserInfo];
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = NavColor;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    if (kIs_iPhoneX) {
        _ibNavTop.constant = 48;
    }else{
        _ibNavTop.constant = 30;
        
    }
  
    
//    [self requestClassData];
//    [self requestHotkeyword];
    self.pageIndex = 0;
    [self requestMainGoodsListWithIdx:self.pageIndex];
    self.ibMainCollectionV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 0;
        [self requestClassData];
        [self requestMainGoodsListWithIdx:self.pageIndex];
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

    
    _ibTopViewH.constant = SCREEN_NAV_HEIGHT;
    _ibTopItemCenterY.constant = SCREEN_STATUSBAR_HEIGHT/2;
    //头部搜索框
    self.ibSearchBar.backgroundImage = [[UIImage alloc]init];
    UITextField *searchField=[self.ibSearchBar valueForKey:@"_searchField"];
    searchField.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    searchField.clipsToBounds =YES;
    searchField.layer.cornerRadius = 5;
    
//    //接收刷新数据通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(uploadData:)
//                                                 name:UPLOADMAINDATA_NOTIFICATION
//                                               object:nil];
// 
    
    
}
-(void)uploadData:(NSNotification *)notification{
    NSString *str = [notification object];
    _cid = str;
    [self requestClassData];
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
//    [_ibMainCollectionV registerNib:[UINib nibWithNibName:@"TitleCollectionCell" bundle:nil] forCellWithReuseIdentifier:TitleCollectionCellID];
    [_ibMainCollectionV registerNib:[UINib nibWithNibName:@"OBDCollectionCell" bundle:nil] forCellWithReuseIdentifier:OBDCollectionCellID];
//    [_ibMainCollectionV registerNib:[UINib nibWithNibName:@"MainHotSaleCell" bundle:nil] forCellWithReuseIdentifier:MainHotSaleCellID];
//    [_ibMainCollectionV registerNib:[UINib nibWithNibName:@"MainHotCakesCell" bundle:nil] forCellWithReuseIdentifier:MainHotCakesCellID];
    _ibMainCollectionV.backgroundColor = WhiteColor;
    
    _ibMainCollectionV.delegate = self;
    _ibMainCollectionV.dataSource = self;

    
    
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) return 1;
    if (section == 1) return _dataArr.count;
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MainBannerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MainBannerCollectionCellID forIndexPath:indexPath];
        NSMutableArray *arr= [NSMutableArray array];
        
        for (PSSlideModel *model in self.slideArray) {
            [arr addObject:model.image_input];
        }
        
        cell.cycleScrollView.imageURLStringsGroup = arr;
        cell.mainBannerBlock = ^(NSInteger idx){
            PSSlideModel *model = self.slideArray[idx];
            GoodsDetalisVC *vc = [[GoodsDetalisVC alloc]initWithNibName:@"GoodsDetalisVC" bundle:nil];
            vc.goodsId = model.product_id;
            [self.navigationController pushViewController:vc animated:YES];
            
        };
        return cell;
    } else{
      
        //商品
        OBDCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OBDCollectionCellID forIndexPath:indexPath];
        if (_dataArr.count > 0) {
            MainGoodsModel *model = _dataArr[indexPath.row];
            cell.viewModel = model;

        }
        return cell;
    }
    
}
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
  
    return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
  
        GoodsDetalisVC *vc = [[GoodsDetalisVC alloc]initWithNibName:@"GoodsDetalisVC" bundle:nil];
        MainGoodsModel *model = _dataArr[indexPath.row];
        vc.goodsId = model.id;
        [self.navigationController pushViewController:vc animated:YES];
    }

    
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return CGSizeMake(SCREEN_WIDTH, 200);
    
    if (indexPath.section == 1) return CGSizeMake((SCREEN_WIDTH -20)/2, ((SCREEN_WIDTH -20)/2) * 1.4);
    
    return CGSizeMake((int)((SCREEN_WIDTH-48)/2), (SCREEN_WIDTH-48)/2 *3 /5 );
}
#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 1) return 10;
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 1) return 5;
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 1) return UIEdgeInsetsMake(10, 5, 10, 5);
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark 获取轮播图数据

///获取分类和banner数据
- (void)requestClassData
{
    BaseRequest *req = [BaseRequest new];
    req.cId = _cid;
    [[HTTPRequest sharedManager]requesGetDataWithApiName:getClassify withParameters:req isEnable:YES withSuccess:^(id responseObject) {
          self.slideArray = [PSSlideModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"banner"]];
        
        self.categoryArray = [MainCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"category"]];
         [self configCollectionView];
//        self.classArray = [GoodsClassModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"category"]];
//        GoodsClassModel *model = [GoodsClassModel new];
//        model.id = @"0";
//        model.cate_name = @"推荐";
//        [self.classArray  insertObject:model atIndex:0];
//        self.hotGoodsArray = [MainCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"store_hot"]];
//        self.productArray = [MainCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"store_product"]];
        
      
        [UIView performWithoutAnimation:^{
            //刷新界面
            [self.ibMainCollectionV reloadData];
//            NSIndexSet *indexSet1 = [[NSIndexSet alloc] initWithIndex:1];
//            [self.ibMainCollectionV reloadSections:indexSet1];
//            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
//            [self.ibMainCollectionV reloadSections:indexSet];
//            NSIndexSet *indexSet2 = [[NSIndexSet alloc] initWithIndex:2];
//            [self.ibMainCollectionV reloadSections:indexSet2];
            
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
        //        [self.ibMainCollectionV reloadData];
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
//MARK:----获取个人信息
-(void)requestUserInfo{
    
    [[HTTPRequest sharedManager]requesGetDataWithApiName:getInformation withParameters:nil isEnable:YES withSuccess:^(id responseObject) {
        QuUserInfo *userInfo = [QuUserInfo mj_objectWithKeyValues:responseObject[@"data"][@"user_info"]];
        
        ACCOUNTINFO.userInfo = userInfo;
        if (ACCOUNTINFO.userInfo.phone.length == 0) {
            //没有绑定电话 完善信息
            RegistVC *vc = [[RegistVC alloc]initWithNibName:@"RegistVC" bundle:nil];
            vc.type = @"3";
            BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
            
        }
        if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1) {
            self.titleArr = @[@"代理权益",@"客户管理",@"推广二维码",@"搜索"];
            self.titleIconArr = @[@"main_dianzhuquanyi",@"main_kehuguanli",@"main_erweima",@"main_sousuo"];
        }else{
            self.titleArr = @[@"升级代理",@"客户管理",@"推广二维码",@"搜索"];
            self.titleIconArr = @[@"main_dianzhuquanyi",@"main_kehuguanli",@"main_erweima",@"main_sousuo"];
            
            if(![[NSUserDefaults standardUserDefaults] boolForKey:AfterLoggingIn]){
                //   NSLog(@"第一次启动");
                [self addGuideView]; //添加广告图
                
            }
        }
        
        [UIView performWithoutAnimation:^{
            //刷新界面
            [self.ibMainCollectionV reloadData];
        }];
    
        
    } withError:^(NSError *error) {
        
    }];
}

- (IBAction)ibCityBtn:(id)sender {
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

@end
