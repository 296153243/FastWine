//
//  MyOrderVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/3/15.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "MyOrderVC.h"
#import "AllOrderVC.h"
#import "NoPaymentVC.h"
#import "WaitSendGoodsVC.h"
#import "WaitReceivingVC.h"
#import "FinishedVC.h"
#import "GoodsDetalisVC.h"
@interface MyOrderVC ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate>
@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) FSSegmentTitleView *titleView;
@end

@implementation MyOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的订单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    AllOrderVC *ctr1 =  [[AllOrderVC alloc]init];
    NoPaymentVC *ctr2 =  [[NoPaymentVC alloc]init];
    WaitSendGoodsVC *ctr3 =  [[WaitSendGoodsVC alloc]init];
    WaitReceivingVC *ctr4 =  [[WaitReceivingVC alloc]init];
    FinishedVC*ctr5 =  [[FinishedVC alloc]init];

    NSArray *childVCs = @[ctr1,ctr2,ctr3,ctr4,ctr5];

    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 84, SCREEN_WIDTH, 50) titles:@[@"全部",@"待支付",@"待发货",@"待收货",@"待评价"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:18];
    _titleView.selectIndex = _selectOrderIdx;
    _titleView.titleNormalColor = [UIColor grayColor];
    _titleView.titleSelectColor = ThemeColor;
    _titleView.indicatorColor = ThemeColor;
    [self.view addSubview:self.titleView];
//    self.titleView.backgroundColor = [UIColor redColor];
    
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 134, SCREEN_WIDTH, SCREEN_HEIGHT - 114) childVCs:childVCs parentVC:self delegate:self];
    self.pageContentView.contentViewCurrentIndex = _selectOrderIdx;
    //  self.pageContentView.contentViewCanScroll = NO;//设置滑动属性
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:_pageContentView];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backAction) image:@"Back_icon"];
}
-(void)backAction{
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[GoodsDetalisVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return ;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.pageContentView.contentViewCurrentIndex = endIndex;
    self.title = @[@"全部",@"待支付",@"待发货",@"待收货",@"待评价"][endIndex];
    
}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
    self.title = @[@"全部",@"待支付",@"待发货",@"待收货",@"待评价"][endIndex];
}
@end
