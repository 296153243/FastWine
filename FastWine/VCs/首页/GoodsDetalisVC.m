//
//  GoodsDetalisVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/3/28.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "GoodsDetalisVC.h"
#import "GoodsDetalisCell.h"
#import "GoodsWebCell.h"
#import "PlaceOrderVC.h"
#import "QuShareView.h"
#import <ShareSDK/ShareSDK.h>
#import "ShoppingCarVC.h"
#import "TCChooseGoodsAttributeViewController.h"
#import "UIViewController+XPSemiModal.h"
#import "WRNavigationBar.h"
#import "AllEvaluationVC.h"
#import "QMHomeViewController.h"
#define Height_Header SCREEN_WIDTH * 910 / 1200.0

#define BannerH SCREEN_WIDTH  + 120
#define MembersID 4
@interface GoodsDetalisVC ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,WKNavigationDelegate,FSSegmentTitleViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (strong, nonatomic) IBOutlet UIView *ibNavToolView;
@property(nonatomic,strong)GoodsDetalisModel *goodsDetalisModel;
@property(nonatomic,strong)GoodsDetalisRsp *goodsDetalisRsp;

@property (assign, nonatomic) CGFloat startScrollOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibTableViewTop;

@property (weak, nonatomic) IBOutlet UIButton *ibBuyBtn;
@property (weak, nonatomic) IBOutlet UIButton *ibInShoppingCarBtn;
@property (weak, nonatomic) IBOutlet UIView *ibChooseNumView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibChooseNumViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibbuyViewBottom;

@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIButton *inShoppingCarBtn;
@property (weak, nonatomic) IBOutlet UITextField *ibNumTf;
@property (weak, nonatomic) IBOutlet UILabel *ibShoppingCarNumLab;
@property (weak, nonatomic) IBOutlet UILabel *ibPicLab;
@property (weak, nonatomic) IBOutlet UILabel *ibKuCunlab;
@property (weak, nonatomic) IBOutlet UIImageView *ibGoodsImage;
@property (weak, nonatomic) IBOutlet UIButton *ibShouCangBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibBuyBtnW;
@property(nonatomic)NSInteger replyCellH;

@property(nonatomic,strong)MainGoodsModel *placeOrderModel;

@property (nonatomic) NSInteger  goodsNum;

@property(nonatomic)CGFloat webH;//web高度
@property(nonatomic)BOOL isRefresh;//是否刷新Cell

@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,strong)UIButton *rightBtn;
@property (nonatomic, strong) FSSegmentTitleView *navTitleView;
@property (strong, nonatomic) UIButton *blackBtn;
@property(nonatomic)BOOL isAddCar;//是否s加入购物车
@property(nonatomic,strong)NSDictionary *dataDic;
@property(nonatomic,strong)TCChooseGoodsAttributeViewController *chooseAttributeVc;
@property(nonatomic,strong)NSString *unique;//属性唯一值

@end

@implementation GoodsDetalisVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBarHidden = YES;
//    [self.navigationController.navigationBar setTranslucent:true];
//    //把背景设为空
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
  
    [self selectBackAction:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self wr_setNavBarBackgroundAlpha:0];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftBarButtonItemAction:) image:@"back_ap"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightBarButtonItemAction:) image:@"gengduo_ap"];
    
    [self requestMainGoodsDetalis];
    if ([Save isLogin]){
        [self requestShoppingCarNum];
    }
    [self initUI];
    
    self.ibTableView.estimatedRowHeight = 0;
    
    self.ibTableView.estimatedSectionHeaderHeight = 0;
    
    self.ibTableView.estimatedSectionFooterHeight = 0;
    
}
-(void)initUI{
    self.ibTableView.tableFooterView = [UIView new];
    
    self.navTitleView = [[FSSegmentTitleView alloc]initWithFrame:_ibNavToolView.frame titles:@[@"商品",@"评价",@"详情"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.navTitleView.titleFont = [UIFont systemFontOfSize:12];
    self.navTitleView.titleSelectFont = [UIFont systemFontOfSize:13];
    _navTitleView.selectIndex = 0;
    _navTitleView.titleNormalColor = [UIColor grayColor];
    _navTitleView.titleSelectColor = ThemeColor;
    _navTitleView.indicatorColor = ThemeColor;
    
    self.navigationItem.titleView = nil;

    //    //使用自定义导航栏
    //    QuNavigationBar *bar = [QuNavigationBar showQuNavigationBarWithController:self];
    //    self.clNavBar = bar;
    //    [self.ibNavToolView addSubview:_navTitleView];
    //    self.clNavBar.titleView = _ibNavToolView;
    
    //设置导航栏透明
//    [self.navigationController.navigationBar setTranslucent:true];
    //    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    self.ibTableViewTop.constant = 0;
  

    
   
    
    [_ibInShoppingCarBtn gradientButtonWithSize:_ibInShoppingCarBtn.qu_size colorArray:@[[UIColor colorWithRed:255/255.0 green:154/255.0 blue:1/255.0 alpha:1.0],[UIColor colorWithRed:255/255.0 green:201/255.0 blue:0/255.0 alpha:1.0]] percentageArray:@[@(1),@(0)] gradientType:GradientFromLeftTopToRightBottom];
    
    [_ibBuyBtn gradientButtonWithSize:_ibInShoppingCarBtn.qu_size colorArray:@[[UIColor colorWithRed:252/255.0 green:78/255.0 blue:25/255.0 alpha:1.0],[UIColor colorWithRed:254/255.0 green:112/255.0 blue:0/255.0 alpha:1.0]] percentageArray:@[@(1),@(0)] gradientType:GradientFromLeftTopToRightBottom];
    
    [_inShoppingCarBtn gradientButtonWithSize:_inShoppingCarBtn.qu_size colorArray:@[[UIColor colorWithRed:255/255.0 green:154/255.0 blue:1/255.0 alpha:1.0],[UIColor colorWithRed:255/255.0 green:201/255.0 blue:0/255.0 alpha:1.0]] percentageArray:@[@(1),@(0)] gradientType:GradientFromLeftTopToRightBottom];
    
    [_buyBtn gradientButtonWithSize:_buyBtn.qu_size colorArray:@[[UIColor colorWithRed:252/255.0 green:78/255.0 blue:25/255.0 alpha:1.0],[UIColor colorWithRed:254/255.0 green:112/255.0 blue:0/255.0 alpha:1.0]] percentageArray:@[@(1),@(0)] gradientType:GradientFromLeftTopToRightBottom];
    
    _ibbuyViewBottom.constant = SafeAreaBottomHeight;
    UIButton *blackbg = [UIButton buttonWithType:UIButtonTypeCustom];
    [blackbg setFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - _ibChooseNumView.qu_h)];
    blackbg.alpha = 0.0f;
    [blackbg addTarget:self action:@selector(selectBackAction:) forControlEvents:UIControlEventTouchUpInside];
    blackbg.backgroundColor = [UIColor blackColor];
    _blackBtn = blackbg;
    //    [[UIApplication sharedApplication].keyWindow insertSubview:blackbg belowSubview:self.ibDateChooseView];
    [[[UIApplication sharedApplication] keyWindow]addSubview:blackbg];
    _goodsNum = 1;
}
-(void)leftBarButtonItemAction:(UIButton *)sender{
  
    if (_isBuyVip == YES) {
        [self.navigationController popToRootViewControllerAnimated:YES];
       
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    
    }
}
-(void)rightBarButtonItemAction:(UIButton *)sender{
  
    [self shareBtnClick];
}
- (void)shareBtnClick{
    QuShareModel *model = [QuShareModel new];
    model.title = _goodsDetalisModel.store_name;
    model.imageUrl = _goodsDetalisModel.image;
    model.targetUrl = _goodsDetalisRsp.urlShare;
    [self loadAppShareWithModel:model];
}
-(IBAction)selectBackAction:(UIButton *)sender{
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.blackBtn.alpha = 0.0f;
                         self.ibChooseNumViewBottom.constant = -300;
                         [self.view layoutIfNeeded];
                     }
     
                     completion:^(BOOL finished) {
                     }];
}
//MARK:------客服
- (IBAction)ibKefuBtnClick:(id)sender {
    if (![Save isLogin]) {
        [self presentLoginWithComplection:^{
        }];
        return;
    }
    QMHomeViewController *vc= [QMHomeViewController new];
    [self.navigationController pushViewController:vc animated:YES];

}
- (IBAction)ibGoCarVC:(id)sender {
    if (![Save isLogin]) {
        [self presentLoginWithComplection:^{
        }];
        return;
    }
  
    ShoppingCarVC *vc = [[ShoppingCarVC alloc]initWithNibName:@"ShoppingCarVC" bundle:nil];
//    vc.goodsModel = _goodsDetalisModel;
    [self selectBackAction:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:------收藏
- (IBAction)ibShouCangBtnClick:(UIButton *)sender {
    if (![Save isLogin]) {
        [self presentLoginWithComplection:^{
        }];
        return;
    }
  
//    PlaceOrderVC *vc = [[PlaceOrderVC alloc]initWithNibName:@"PlaceOrderVC" bundle:nil];
//    vc.goodsModel = _goodsDetalisModel;
//    [self.navigationController pushViewController:vc animated:YES];
    if (sender.selected) {
        [self requestCancelCollectGoods];
    }else{
        [self requestCollectGoods];
    }
//    sender.selected = !sender.selected;
    
}
//MARK:------选择商品属性
- (IBAction)ibShoppingCarBtnCLick:(UIButton *)sender {
    if (![Save isLogin]) {
        [self presentLoginWithComplection:^{
        }];
        return;
    }
    //区分购买还是加入购物车
    if (_placeOrderModel.unique) {
        _unique = _placeOrderModel.unique;

    }else{
        //默认传0
        _unique = @"0";

    }
    
    if (sender.tag == 66) {
        _isAddCar = YES;
    }else{
        _isAddCar = NO;

    }
    if (_goodsDetalisRsp.productAttr.count > 0) {
        [self goodsAttributeChooseIsFromBuyNowBtn:NO];
        return ;
    }
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{

                         self.blackBtn.alpha = 0.3f;
                         self.ibChooseNumViewBottom.constant = 0;
                         self.ibPicLab.text = [NSString stringWithFormat:@"¥ %@",self.goodsDetalisRsp.storeInfo.vip_price];
                         if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1) {
                             self.ibPicLab.text = [NSString stringWithFormat:@"¥ %@",self.goodsDetalisRsp.storeInfo.vip_price];
                         }
                         self.ibKuCunlab.text = [NSString stringWithFormat:@"库存:%@",self.goodsDetalisRsp.storeInfo.stock];
                         [self.ibGoodsImage sd_setImageWithURL:[NSURL URLWithString:self.goodsDetalisRsp.storeInfo.image] placeholderImage:[UIImage imageNamed:@"goods_noImage"]];
                         [self.view layoutIfNeeded];
                         //                             [self loadDatePicker];
                     }

                     completion:^(BOOL finished) {

                     }];
}
//MARK:--------选择商品属性
- (void)goodsAttributeChooseIsFromBuyNowBtn:(BOOL)isFromBuyNow {
    //    if (!User_ID) {
    //        [self presentLoginVC];
    //        return;
    //    }
   TCChooseGoodsAttributeViewController *chooseGoodsAttributeVC = [TCChooseGoodsAttributeViewController new];
    chooseGoodsAttributeVC.goBuyBlok = ^(UIViewController *vc,NSString *unqi, NSInteger goodsNum) {
        self.goodsNum = goodsNum;
        self.unique = unqi;
        [self goBuyBtnClick:nil];
        self.chooseAttributeVc = (TCChooseGoodsAttributeViewController *)vc;
        [self.chooseAttributeVc dismissViewBtnClick];
    };
    chooseGoodsAttributeVC.isFromBuyCart = NO;
    chooseGoodsAttributeVC.fromBuyNowBtn = isFromBuyNow;
    chooseGoodsAttributeVC.fatherVC = self;
    //    chooseGoodsAttributeVC.goods_id = s_Integer(_goodsModel.goodsInfo.goods_id);
    chooseGoodsAttributeVC.goods_id = _goodsDetalisModel.id;
 
    chooseGoodsAttributeVC.store_id = 4;
    chooseGoodsAttributeVC.dataDic = _dataDic;
    XPSemiModalConfiguration *config = [XPSemiModalConfiguration defaultConfiguration];
    [self presentSemiModalViewController:chooseGoodsAttributeVC contentHeight:SCREEN_HEIGHT - 200 configuration:config completion:nil];
}
- (IBAction)goBuyBtnClick:(UIButton *)sender {

    if (!_isAddCar) {
        if ([_placeOrderModel.id integerValue] == MembersID) {
            if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1){
                [QuHudHelper qu_showMessage:@"该产品只能购买一次"];
                return ;
            }
        }
     

        [self requestconPlaceOrder];
    }else{
        [self requestconAddShoppingCar];
    }
   
}
- (IBAction)inToCarBtnClick:(UIButton *)sender {
}
- (IBAction)jianJian:(id)sender {
    if (_goodsNum > 1 ) {
        _goodsNum -- ;
        [_ibNumTf setText:[NSString stringWithFormat:@"%ld",_goodsNum]];


    }else{
        [QuHudHelper qu_showMessage:@"最少添加一件"];
    }

}
- (IBAction)jiaJia:(id)sender {
    if (_goodsNum > 0 ) {
        _goodsNum ++;
        [_ibNumTf setText:[NSString stringWithFormat:@"%ld",_goodsNum]];

    }
}


//MARK:-----FSSegmentTitleViewDelegate
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    /* 滚动指定段的指定row  到 指定位置*/
    if (endIndex == 2) {
        [self.ibTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else{
        [self.ibTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:endIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}
//MARK:-----UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return BannerH;
    }else if (indexPath.section == 1){
        return 45;
    }else if (indexPath.section == 2){
        if (_goodsDetalisRsp.reply.count > 0) {
            _replyCellH = 0;
            ReplyModel *model = [ReplyModel mj_objectWithKeyValues:_goodsDetalisRsp.reply[indexPath.row]];
            if (model.pics.count > 0) {
                //
             _replyCellH =  _replyCellH + 180;
                return 180;

            }else{
                _replyCellH =  _replyCellH + [model.comment stringHeighFontSize:14 width:SCREEN_WIDTH - 20] + 70;
                return [model.comment stringHeighFontSize:14 width:SCREEN_WIDTH - 20] + 70;
            }
        }
        return 0.1;
    }else if (indexPath.section == 3){
        
        return _webH + 200;
    }else{
        return 100;
    }
    
}
//MARK:-----UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        //评论
        return self.goodsDetalisRsp.reply.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsDetalisCell *cell =[tableView dequeueReusableCellWithIdentifier:@"GoodsDetalisCell"];
    
    if (indexPath.section == 0) {
        //
        cell = [[NSBundle mainBundle]loadNibNamed:@"GoodsDetalisCell" owner:nil options:nil][0];
        cell.viewModel =_goodsDetalisModel;
    }else if (indexPath.section == 1){
        
         cell = [[NSBundle mainBundle]loadNibNamed:@"GoodsDetalisCell" owner:nil options:nil][1];
         cell.ibReplyNumLab.text  = [NSString stringWithFormat:@"共 %@ 条",_goodsDetalisRsp.replyCount];
//        cell.ibHaopingLab.text = [NSString stringWithFormat:@"好评:%@%",@""];
    }else if (indexPath.section == 2){
        //评论
          cell = [[NSBundle mainBundle]loadNibNamed:@"GoodsDetalisCell" owner:nil options:nil][2];
        if (_goodsDetalisRsp.reply.count > 0) {
            ReplyModel *model = [ReplyModel mj_objectWithKeyValues:_goodsDetalisRsp.reply[indexPath.row]];
            cell.replyModel = model;
        }
       
    }else if (indexPath.section == 3){
        //详情
        GoodsDetalisCell * cell = [[NSBundle mainBundle]loadNibNamed:@"GoodsDetalisCell" owner:nil options:nil][3];
        if (_goodsDetalisModel.des) {
            cell.viewModel = _goodsDetalisModel;

    
        }
      

        cell.collectionViewLoadFinish = ^(CGFloat webH) {
         
            if (self.webH == webH) {
                self.isRefresh = YES;
            }
            self.webH =  webH;
          
            if (self.isRefresh != YES) {
                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:3];
                [self.ibTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
//                [self.ibTableView reloadData];
//                self.isRefresh = YES;
            }
        
        };
//        self.webH =  cell.ibImgCollectionView.collectionViewLayout.collectionViewContentSize.height;
        NSLog(@"ibImgCollectionView.collectionViewLayout.collectionViewContentSize.height:%f",cell.ibImgCollectionView.collectionViewLayout.collectionViewContentSize.height);
      
        return cell;
    }else{
        //推荐
    }

    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        AllEvaluationVC *vc = [[AllEvaluationVC alloc]initWithNibName:@"AllEvaluationVC" bundle:nil];
        vc.goodsDetalisRsp = _goodsDetalisRsp;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//#pragma mark UIScrollViewDelegate
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    if (scrollView == self.ibTableView) {
//
//        self.startScrollOffset = scrollView.contentOffset.y;
//    }
//
//}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView == _ibTableView) {
//        CGPoint offset = scrollView.contentOffset;
//        if (offset.y < BannerH) {
//            [self.navigationController.navigationBar setTranslucent:true];
//             self.ibTableViewTop.constant = 0;
////            NSLog(@"++++%f",1.f - offset.y / BannerH);
//
//            if (1.f - offset.y / BannerH == 1) {
////                [self.navigationController.navigationBar setTranslucent:true];
//////                 self.navigationController.navigationBar.alpha = 0.1;
////               self.navigationController.navigationBar.backgroundColor = [UIColor colorWithWhite:1 alpha:0.0001];
//            }else{
//               self.navigationController.navigationBar.alpha = 1.f - offset.y / BannerH;
//            }
//
//            self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftBarButtonItemAction:) image:@"back_ap" highImage:nil];
//            self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightBarButtonItemAction:) image:@"gengduo_ap" highImage:nil];
//            self.navigationItem.titleView = nil;
////            self.navigationController.navigationBar.backgroundColor = [UIColor colorWithWhite:1 alpha:1.f - offset.y / BannerH];
//
//        } else {
////             NSLog(@"---%f",MIN(1.f, (offset.y - BannerH) / BannerH));
//            if (MIN(1.f, (offset.y - BannerH) / BannerH) == 0) {
//
//                self.navigationController.navigationBar.alpha = 0.0001;
//            }else{
//                self.navigationController.navigationBar.alpha = MIN(1.f, (offset.y - BannerH) / BannerH);
//
//            }
//            [self.navigationController.navigationBar setTranslucent:false];
//            [UIView animateWithDuration:0.2 animations:^{
////                self.ibTableViewTop.constant = SafeAreaTopHeight;
//
//            }];
//            self.navigationController.navigationBar.alpha = 1;
//            self.navigationItem.titleView = _navTitleView;
//            self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftBarButtonItemAction:) image:@"bank_X" highImage:nil];
//            self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightBarButtonItemAction:) image:@"share_dian" highImage:nil];
//    //            self.navigationController.navigationBar.backgroundColor = [UIColor colorWithWhite:1 alpha:MIN(1.f, (offset.y - BannerH) / BannerH)];
//    }
////        NSLog(@"offset.y:%f",offset.y);
//        if (offset.y  >= ScreenWidthRatio * 400  + 45 ) {
//            self.navTitleView.selectIndex = 1;
//        }
//        if (offset.y >= ScreenWidthRatio * 400  + 45 + 480 ) {
//            self.navTitleView.selectIndex = 2;
//
//        }
//    }
//
//}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _ibTableView){
        CGFloat offset = scrollView.contentOffset.y;
        BOOL hiddenNavBar;
        if (scrollView == self.ibTableView) {
            hiddenNavBar = YES;
        } else {
            hiddenNavBar = NO;
            
        }
        [self changeNavBarAlpha:offset hiddenNavBar:hiddenNavBar];
        
        if (offset  >= BannerH  + 45 ) {
            self.navTitleView.selectIndex = 1;
        }
        if (offset >= BannerH  + 45 + _goodsDetalisRsp.reply.count * 180 ) {
            self.navTitleView.selectIndex = 2;
//            NSLog(@"-----%ld", _replyCellH);
        }

    }
    
   
}
#pragma mark - TCBabyDeailtyViewControllerDelegate
- (void)TCBabyDeailtyViewControllerOffsetY:(float)offsetY hiddenNavBar:(BOOL)hiddenNavBar {
    [self changeNavBarAlpha:offsetY hiddenNavBar:hiddenNavBar];
}
#pragma mark -滑动导航渐变
- (void)changeNavBarAlpha:(CGFloat)yOffset hiddenNavBar:(BOOL)hiddenNavBar {
    if (!hiddenNavBar) {
//        self.titleView.alpha = 1;
//        self.segmentVC.segmentBar.alpha = 1;
        [self wr_setNavBarBackgroundAlpha:1];
    } else {
        CGFloat currentAlpha = (yOffset - (-0))/(Height_Header/2.0 - (-0));
        currentAlpha = currentAlpha <= 0.0 ? 0.0 : (currentAlpha >= 1.0 ? 1.0 : currentAlpha);
//        self.titleView.alpha = currentAlpha;
//        self.segmentVC.segmentBar.alpha = currentAlpha;
        [self wr_setNavBarBackgroundAlpha:currentAlpha];
        if (currentAlpha >0.3) {
            [self.navigationController.navigationItem.leftBarButtonItem setImage:IMAGE(@"back_ap")];
         
        }
        //    NSLog(@"当前的滑动距离是%f透明度是%f",yOffset,currentAlpha);
        if (yOffset > Height_Header/2.0) {
            [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
            self.navigationItem.titleView = _navTitleView;
            self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftBarButtonItemAction:) image:@"bank_X"];
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightBarButtonItemAction:) image:@"share_dian"];
        } else {

            [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
            self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftBarButtonItemAction:) image:@"back_ap"];
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightBarButtonItemAction:) image:@"gengduo_ap"];
            self.navigationItem.titleView = nil;
        }
    }
    
}
//MARK:request首页商品详情
- (void)requestMainGoodsDetalis
{
    BaseRequest *req = [BaseRequest new];
    req.id =_goodsId;
    
    [[HTTPRequest sharedManager]requesGetDataWithApiName:mainGoodsDetalis withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        self->_goodsDetalisModel = [GoodsDetalisModel mj_objectWithKeyValues:responseObject[@"data"][@"storeInfo"]];
        self.goodsDetalisRsp = [GoodsDetalisRsp mj_objectWithKeyValues:responseObject[@"data"]];
        self.dataDic = responseObject;
        if (self.goodsDetalisRsp.storeInfo.is_special == 1 || self.goodsDetalisRsp.storeInfo.is_integral == 1 || self.goodsDetalisRsp.storeInfo.is_agent == 1) {
            //会员商品 只展示立即购买
            self.ibInShoppingCarBtn.hidden = YES;
//            self.ibBuyBtnW.multiplier = 1.0;
            [self changeMultiplierOfConstraint:self.ibBuyBtnW multiplier:1.0];
            self.inShoppingCarBtn.hidden = YES;
            
            
        }else{
//            [self placeOrderGoodsModel];

        }
        if ([self.goodsDetalisRsp.storeInfo.userCollect isEqualToString:@"0"]) {
            self.ibShouCangBtn.selected = NO;
        }else{
            self.ibShouCangBtn.selected = YES;

        }
        self.webH = 300;

        [self.ibTableView reloadData];
    } withError:^(NSError *error) {
        
    }];
    
}


//MARK:---操作的商品----暂时废弃
-(void)placeOrderGoodsModel{
    NSString *attr_values;
    if (_goodsDetalisRsp.productAttr.count > 0) {
        if (_goodsDetalisRsp.productAttr.count ==  1) {
            //一个属性
            attr_values = @"";
            attr_values = [attr_values stringByAppendingString:[NSString stringWithFormat:@"%@",_goodsDetalisRsp.productAttr[0][@"attr_values"][0]]];
            NSLog(@"attr_values:%@",attr_values);
        }else if (_goodsDetalisRsp.productAttr.count ==  2){
            attr_values = _goodsDetalisRsp.productAttr[1][@"attr_values"][0];
            attr_values = [attr_values stringByAppendingString:[NSString stringWithFormat:@",%@",_goodsDetalisRsp.productAttr[0][@"attr_values"][0]]];
            NSLog(@"attr_values:%@",attr_values);
        }
     
        
    }
    NSArray *arrKeys = [_goodsDetalisRsp.productValue allKeys];
    
    [arrKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isEqualToString:attr_values]) {
            NSDictionary *value = [self.goodsDetalisRsp.productValue valueForKey:obj];
            NSLog(@"productValue:%@",value);
            self.placeOrderModel = [MainGoodsModel mj_objectWithKeyValues:value];
            
        }
    }];
    
}
//MARK:---收藏商品
- (void)requestCollectGoods
{
    AddCarReq *req= [AddCarReq new];
    req.productId = _goodsId;
    [[HTTPRequest sharedManager]requesGetDataWithApiName:collect_product withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        [QuHudHelper qu_showMessage:@"收藏成功"];
        self.ibShouCangBtn.selected = YES;
        
    } withError:^(NSError *error) {
        
    }];
    
}
//MARK:---取消收藏商品
- (void)requestCancelCollectGoods
{
    AddCarReq *req= [AddCarReq new];
    req.productId = _goodsId;
    [[HTTPRequest sharedManager]requesGetDataWithApiName:cancel_product withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        [QuHudHelper qu_showMessage:@"取消收藏"];
        self.ibShouCangBtn.selected = NO;

    } withError:^(NSError *error) {
        
    }];
    
}
//MARK:---购物车数量
- (void)requestShoppingCarNum
{
    
    [[HTTPRequest sharedManager]requesGetDataWithApiName:shoppingCarNum withParameters:nil isEnable:YES withSuccess:^(id responseObject) {
        
        if ([responseObject[@"data"] integerValue] > 0) {
            self.ibShoppingCarNumLab.hidden = NO;
            self.ibShoppingCarNumLab.text = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
            
        }else{
            self.ibShoppingCarNumLab.hidden = YES;
        }
    } withError:^(NSError *error) {
        
    }];
    
}
//MARK:---获取购物车key
- (void)requestconfirm_order
{
    
    [[HTTPRequest sharedManager]requesGetDataWithApiName:confirm_order withParameters:nil isEnable:YES withSuccess:^(id responseObject) {
     
    } withError:^(NSError *error) {
        
    }];
    
}
//MARK:---加入购物车
- (void)requestconAddShoppingCar
{
    AddCarReq *req = [AddCarReq new];
    req.productId = _goodsDetalisRsp.storeInfo.id;
    req.uniqueId = _unique?_unique:@"0";
    req.cartNum = [NSString stringWithFormat:@"%ld",self.goodsNum];
    
    [[HTTPRequest sharedManager]requesGetDataWithApiName:addshopingCar withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        [QuHudHelper qu_showMessage:@"加入成功"];
        [self requestShoppingCarNum];
        [self selectBackAction:nil];
    } withError:^(NSError *error) {
        
    }];
    
}
//MARK:---下单
- (void)requestconPlaceOrder
{
    
    AddCarReq *req = [AddCarReq new];
    req.productId = _goodsDetalisRsp.storeInfo.id;
    req.cartNum = [NSString stringWithFormat:@"%ld",self.goodsNum];
    req.uniqueId = _unique?_unique:@"0";
  
    
    [[HTTPRequest sharedManager]requesGetDataWithApiName:mainGoodsPalceOrder withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        
        PlaceOrderVC *vc = [[PlaceOrderVC alloc]initWithNibName:@"PlaceOrderVC" bundle:nil];
        vc.cartId = responseObject[@"data"][@"cartId"];
        [self.navigationController pushViewController:vc animated:YES];

    } withError:^(NSError *error) {
        
    }];
    
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
//MARK:-----修改multiplier
- (void)changeMultiplierOfConstraint:(NSLayoutConstraint *)constraint multiplier:(CGFloat)multiplier{
    [NSLayoutConstraint deactivateConstraints:@[constraint]];
    NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:constraint.firstItem attribute:constraint.firstAttribute relatedBy:constraint.relation toItem:constraint.secondItem attribute:constraint.secondAttribute multiplier:multiplier constant:constraint.constant];
    newConstraint.priority = constraint.priority;
    newConstraint.shouldBeArchived = constraint.shouldBeArchived;
    newConstraint.identifier = constraint.identifier;
    [NSLayoutConstraint activateConstraints:@[newConstraint]];
    
}

@end
