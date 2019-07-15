//
//  MainViewController.m
//  FastWine
//
//  Created by MOOSON_ on 2019/3/12.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "MainViewController.h"
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
#import "MainVC.h"
#import "OwnersRightsVC.h"
#import "ClassificationVC.h"
@interface MainViewController ()<UICollectionViewDataSource, UIScrollViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,FSPageContentViewDelegate,FSSegmentTitleViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *ibSearchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *ibMainCollectionV;
@property (weak, nonatomic) IBOutlet UIView *ibToolView;
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
@property(nonatomic,strong)UIButton *messgeBtn;
@property(nonatomic,strong)UIImageView *iconImgv;
@property(nonatomic,strong)UIView *messageView;
@property(nonatomic,strong)dispatch_source_t gcdTimer;
@property(nonatomic,assign) __block NSInteger timeout;
@property(nonatomic,strong) MainFictitious *fictitiousModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibBottom;

@end

@implementation MainViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    [self requestAppVersionCheck];
    if (![Save isLogin]) {
        [self presentLoginWithComplection:^{
        }];
        return;
    }else{
        [self requestUserInfo];
     
    }
    
 
    [self performSelector:@selector(starTimer) withObject:nil afterDelay:0.1];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = NavColor;
    
    _timeout = 0;//置为0
    if (_gcdTimer) {
        dispatch_source_cancel(_gcdTimer);
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置APP引导页
    if (![[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEY]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BOOLFORKEY];
        // 静态引导页
        [self setStaticGuidePage];
        
    }
    self.ibBottom.constant = 150;
    if (kIs_iPhoneX) {
        _ibNavTop.constant = 48;
    }else{
        _ibNavTop.constant = 30;

    }
    //接收登录成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess)
                                                 name:LOGIN_SUCCESS_NOTIFICATION
                                               object:nil];
    [self configCollectionView];
    [self requestDataWithGetFlash];
    [self requestHotkeyword];
    self.pageIndex = 0;
    [self requestMainGoodsListWithIdx:self.pageIndex];
    self.ibMainCollectionV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 0;
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
   _ibTopViewH.constant = SCREEN_NAV_HEIGHT;
    _ibTopItemCenterY.constant = SCREEN_STATUSBAR_HEIGHT/2;
    //头部搜索框
    self.ibSearchBar.backgroundImage = [[UIImage alloc]init];
    UITextField *searchField=[self.ibSearchBar valueForKey:@"_searchField"];
    searchField.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    searchField.clipsToBounds =YES;
    searchField.layer.cornerRadius = 5;

 
}
-(void)loadToolView{
    
  __strong  MainVC *ctr1 =  [[MainVC alloc]init];
    NSMutableArray *childVCs = [NSMutableArray array];
    [childVCs addObject:ctr1];
 
    for (int i = 0; i<_classArray.count - 1; i++) {
        MainOneVC *ctr2 =  [[MainOneVC alloc]init];
        [childVCs addObject:ctr2];
        //接收刷新数据通知
        [[NSNotificationCenter defaultCenter] addObserver:ctr2
                                                 selector:@selector(uploadData:)
                                                     name:UPLOADMAINDATA_NOTIFICATION
                                                   object:nil];

    }
    NSMutableArray *titleStrs= [NSMutableArray array];
    [_classArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GoodsClassModel *model = obj;
        [titleStrs addObject:model.cate_name];
    }];
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 50) titles:titleStrs delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:18];
    _titleView.selectIndex = _endIdx;
    _titleView.titleNormalColor = [UIColor grayColor];
    _titleView.titleSelectColor = ThemeColor;
    _titleView.indicatorColor = ThemeColor;
    _titleView.backgroundColor = WhiteColor;
    [self.ibToolView addSubview:self.titleView];
    
 
    float top;
    if (IS_iPhoneX || IS_iPhoneXMax) {
        top = 134;
    }else{
        top = 114;
    }
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, SCREEN_HEIGHT - top) childVCs:childVCs parentVC:self delegate:self];
    self.pageContentView.contentViewCurrentIndex = 0;
    //  self.pageContentView.contentViewCanScroll = NO;//设置滑动属性
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_pageContentView];
}
-(void)loginSuccess{
    [self requestUserInfo];
    [self requestDataWithGetFlash];
    [self requestMainGoodsListWithIdx:_pageIndex];
  
}
-(void)starTimer{

    [self timerAtion];
}
-(void)showMessageView{
    UIView *messageView = [[UIView alloc]initWithFrame:CGRectMake(20, 150, 200, 30)];
    messageView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    messageView.clipsToBounds = YES;
    messageView.layer.cornerRadius = messageView.qu_size.height/2;
    
    UIImageView *iconimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, messageView.qu_size.height)];
    iconimage.clipsToBounds = YES;
    iconimage.layer.cornerRadius = messageView.qu_size.height/2;
    
    UIButton *messgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    messgeBtn.frame = CGRectMake(30, 0, messageView.qu_size.width - 50, messageView.qu_size.height);
//    messgeBtn.backgroundColor = [UIColor grayColor];
    [messgeBtn setTitle:@"" forState:UIControlStateNormal];
    messgeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [messgeBtn addTarget:self action:@selector(messageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *mark = [UIButton buttonWithType:UIButtonTypeCustom];
    mark.frame = CGRectMake(180, 6, 11, 18);
    [mark setImage:[UIImage imageNamed:@"xiao_mark"] forState:UIControlStateNormal];

    _messgeBtn = messgeBtn;
    _iconImgv = iconimage;
    [messageView addSubview:_messgeBtn];
    [messageView addSubview:_iconImgv];
    [messageView addSubview:mark];
    _messageView = messageView;
    [[UIApplication sharedApplication].keyWindow addSubview:_messageView];
    
//    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:messageView];
    
}
-(void)messageBtnClick:(UIButton *)sender{
    
    [_messageView setHidden:YES];
    if (self.fictitiousModel.type == 2) {
       //用户购买
        GoodsDetalisVC *vc = [[GoodsDetalisVC alloc]initWithNibName:@"GoodsDetalisVC" bundle:nil];
        vc.goodsId = _fictitiousModel.id;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        OwnersRightsVC *vc = [[OwnersRightsVC alloc]initWithNibName:@"OwnersRightsVC" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
      
    }
}
-(void)timerAtion{

    _gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));

    dispatch_source_set_timer(_gcdTimer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    int r = rand() % (30-10+1) + 10;  //生成[10,30]随机数
    dispatch_source_set_event_handler(_gcdTimer, ^{
        self.timeout ++;
        
        //进入主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.timeout == r) {
                [self showMessageView];

            }
            //间隔随机数执行
            if (self.timeout% r == 0) {
                [self requesMainfictitious];
            }
            
        });
      
//        if(gcdIdx == 5) {
//            // 终止定时器
//            dispatch_suspend(_gcdTimer);
//        }
    });
    // 启动任务，GCD计时器创建后需要手动启动
    dispatch_resume(_gcdTimer);
}
#pragma mark - 设置APP静态图片引导页
- (void)setStaticGuidePage {
    NSArray *imageNameArray = @[@"guideImage1",@"guideImage2",@"guideImage3"];
    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:self.view.frame imageNameArray:imageNameArray buttonIsHidden:YES];
    guidePage.slideInto = YES;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:guidePage];
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
-(void)joinBtnAction:(UIButton *)sender{
    [_activityView removeFromSuperview];
    [_blackBtn removeFromSuperview];
    //直接去购买会员
    GoodsDetalisVC *vc = [[GoodsDetalisVC alloc]initWithNibName:@"GoodsDetalisVC" bundle:nil];
    vc.goodsId = @"4";
    vc.isBuyVip = YES;
    [self.navigationController pushViewController:vc animated:NO];
}
- (IBAction)ibSearchBtnClick:(id)sender {
    
    ClassificationVC *vc = [[ClassificationVC alloc]initWithNibName:@"ClassificationVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)ibMessageBtnAction:(id)sender {
    MessageVC *vc= [[MessageVC alloc]initWithNibName:@"MessageVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
  
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:_hotkeywordArr searchBarPlaceholder:@"搜一搜" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        
        SearchGoods *vc = [[SearchGoods alloc]initWithNibName:@"SearchGoods" bundle:nil];
        vc.searchStr = searchText;
        [searchViewController.navigationController pushViewController:vc animated:YES];
        
    }];
    searchViewController.hotSearchStyle = PYSearchHistoryStyleBorderTag;
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleNormalTag;
    [searchViewController setSearchHistoriesCount:10];
    [searchViewController setSwapHotSeachWithSearchHistory:YES];
    // 3. present
    //                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    //                [self presentViewController:nav  animated:NO completion:nil];
    [self.navigationController pushViewController:searchViewController animated:YES];
    
}
- (void)configCollectionView{
    [_ibMainCollectionV registerNib:[UINib nibWithNibName:@"MainBannerCollectionCell" bundle:nil] forCellWithReuseIdentifier:MainBannerCollectionCellID];
    [_ibMainCollectionV registerNib:[UINib nibWithNibName:@"MainCollectionCell" bundle:nil] forCellWithReuseIdentifier:MainCollectionCellID];
    [_ibMainCollectionV registerNib:[UINib nibWithNibName:@"TitleCollectionCell" bundle:nil] forCellWithReuseIdentifier:TitleCollectionCellID];
    [_ibMainCollectionV registerNib:[UINib nibWithNibName:@"OBDCollectionCell" bundle:nil] forCellWithReuseIdentifier:OBDCollectionCellID];
    [_ibMainCollectionV registerNib:[UINib nibWithNibName:@"MainHotSaleCell" bundle:nil] forCellWithReuseIdentifier:MainHotSaleCellID];
    [_ibMainCollectionV registerNib:[UINib nibWithNibName:@"MainHotCakesCell" bundle:nil] forCellWithReuseIdentifier:MainHotCakesCellID];
    _ibMainCollectionV.backgroundColor = WhiteColor;
    
    //设置headerView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionHeadersPinToVisibleBounds = YES;
    layout.sectionFootersPinToVisibleBounds = YES;
    [_ibMainCollectionV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    [_ibMainCollectionV setCollectionViewLayout:layout];
    

}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) return 1;
    if (section == 1) return _categoryArray.count;
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
        MainCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MainCollectionCellID forIndexPath:indexPath];
        MainCategoryModel *model = _categoryArray[indexPath.row];
        cell.ibTitleLab.text = model.name;
       [cell.ibIconImg sd_setImageWithURL:[NSURL URLWithString:model.pic]];
        
        return cell;
    }else if (indexPath.section == 2) {
        //热卖
        MainHotSaleCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:MainHotSaleCellID forIndexPath:indexPath];
        if (_isRefresh != YES) {
            
            if (_productArray) {
                cell.dataArr = _productArray;
                _isRefresh = YES;
            }
        }
     

        cell.itemClickBlock = ^(MainCategoryModel * _Nonnull model) {
            GoodsDetalisVC *vc = [[GoodsDetalisVC alloc]initWithNibName:@"GoodsDetalisVC" bundle:nil];
            vc.goodsId = model.product_id;
            [self.navigationController pushViewController:vc animated:YES];
         
        };
        return cell;
 
    }else if (indexPath.section == 3){
        //热销
        MainHotCakesCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:MainHotCakesCellID forIndexPath:indexPath];
     
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
        OBDCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OBDCollectionCellID forIndexPath:indexPath];
        MainGoodsModel *model = _dataArr[indexPath.row];
        cell.viewModel = model;
        return cell;
    }
    
}
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
  
//    if (indexPath.section == 4) {
//        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
//        NSMutableArray *titleStrs= [NSMutableArray array];
////        [_classArray removeAllObjects];
//
//        [_classArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            GoodsClassModel *model = obj;
//            [titleStrs addObject:model.cate_name];
//        }];
//
//        self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 50) titles:titleStrs delegate:self indicatorType:FSIndicatorTypeEqualTitle];
//        self.titleView.titleSelectFont = [UIFont systemFontOfSize:18];
//        _titleView.selectIndex = _endIdx;
//        _titleView.titleNormalColor = [UIColor grayColor];
//        _titleView.titleSelectColor = ThemeColor;
//        _titleView.indicatorColor = ThemeColor;
//        _titleView.backgroundColor = WhiteColor;
//        [headerView addSubview:self.titleView];
//        return headerView;
//    }
    return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        SearchGoods *vc = [[SearchGoods alloc]initWithNibName:@"SearchGoods" bundle:nil];
        MainCategoryModel *model = _categoryArray[indexPath.row];
        vc.cid = model.cid;
        [self.navigationController pushViewController:vc animated:YES];
      
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
    if (indexPath.section == 1) return CGSizeMake((SCREEN_WIDTH - 140)/5, 80);
    if (indexPath.section == 2) return CGSizeMake(SCREEN_WIDTH, 500);
    
    if (indexPath.section == 3)  return CGSizeMake(SCREEN_WIDTH, 200);
 
    if (indexPath.section == 4) return CGSizeMake((SCREEN_WIDTH -20)/2, ((SCREEN_WIDTH -20)/2) * 1.4);
 
    return CGSizeMake((int)((SCREEN_WIDTH-48)/2), (SCREEN_WIDTH-48)/2 *3 /5 );
}
#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 1) return 10;
    if (section == 4) return 10;
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 1) return 20;
    if (section == 4) return 5;
    
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 1) return UIEdgeInsetsMake(5, 20, 5, 20);
    if (section == 4) return UIEdgeInsetsMake(10, 5, 10, 5);
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//HeaderInSection Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    if (section == 4){
//      return CGSizeMake(SCREEN_WIDTH, 50);
//    }
    return CGSizeMake(0, 0);

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(0, 0);
    
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
        //加载分类页签
        [self loadToolView];
       
        [UIView performWithoutAnimation:^{
            //刷新界面
            [self.ibMainCollectionV reloadData];
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
            [self.ibMainCollectionV reloadSections:indexSet];
            NSIndexSet *indexSet1 = [[NSIndexSet alloc] initWithIndex:2];
            [self.ibMainCollectionV reloadSections:indexSet1];
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
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:4];
        [self.ibMainCollectionV reloadSections:indexSet];
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
//                [self addGuideView]; //添加广告图
                
            }
        }
       
        [UIView performWithoutAnimation:^{
            //刷新界面
            [self.ibMainCollectionV reloadData];
        }];
        for (int i=0; i<self.tabBarController.viewControllers.count; i++) {
            
            BaseNavigationController *nav= (BaseNavigationController *)self.tabBarController.viewControllers[i];
            
            if (i == 2) {
                //分配TableBar图标
                [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(181, 31, 34)} forState:UIControlStateSelected];
                if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1) {
                    
                    nav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"代理权益" image:[[UIImage imageNamed:@"Jiubei_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"Jiubei_red"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                    nav.tabBarItem.imageInsets = UIEdgeInsetsMake(-30, 0, 0, 0);
                    
                    
                }else{
                    nav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"升级代理" image:[[UIImage imageNamed:@"Jiubei_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"Jiubei_red"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                    nav.tabBarItem.imageInsets = UIEdgeInsetsMake(-30, 0, 0, 0);
                    
                    
                }
                
            }
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
//MARK:----虚拟物品购买
-(void)requesMainfictitious{
    
    [_messageView setHidden:NO];
    [[HTTPRequest sharedManager]requesGetDataWithApiName:mainfictitious withParameters:nil isEnable:YES withSuccess:^(id responseObject) {
        self.fictitiousModel = [MainFictitious mj_objectWithKeyValues:responseObject[@"data"]];

        if (self.fictitiousModel.type == 2) {
            [self.messgeBtn setTitle:[NSString stringWithFormat:@"来自%@的%@购买了%@",self.fictitiousModel.city,self.fictitiousModel.nickname,self.fictitiousModel.store_name] forState:UIControlStateNormal];
        }else{
            [self.messgeBtn setTitle:[NSString stringWithFormat:@"来自%@的%@成为了会员",self.fictitiousModel.city,self.fictitiousModel.nickname] forState:UIControlStateNormal];
        }
        [self->_iconImgv sd_setImageWithURL:[NSURL URLWithString:self.fictitiousModel.avatar] placeholderImage:[UIImage imageNamed:AvatarDefault]];
        [self performSelector:@selector(hideMessage) withObject:nil afterDelay:5];
        
    } withError:^(NSError *error) {
        
    }];
}
-(void)hideMessage{
    [_messageView setHidden:YES];

}
- (IBAction)ibCityBtn:(id)sender {
}
#pragma mark --FSSegmentTitleView
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    _endIdx = endIndex;
    self.pageContentView.contentViewCurrentIndex = endIndex;
    GoodsClassModel *model = _classArray[endIndex];
    _cid = model.id;
    [self requestMainGoodsListWithIdx:0];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:UPLOADMAINDATA_NOTIFICATION object:_cid];
//    self.title = @[@"全部",@"待支付",@"待发货",@"待收货",@"待评价"][endIndex];
    
}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
//    self.title = @[@"全部",@"待支付",@"待发货",@"待收货",@"待评价"][endIndex];
    if (endIndex < _classArray.count) {
     
    }
    GoodsClassModel *model = _classArray[endIndex];
    _cid = model.id;
    [[NSNotificationCenter defaultCenter]postNotificationName:UPLOADMAINDATA_NOTIFICATION object:_cid];
    
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
}
@end
