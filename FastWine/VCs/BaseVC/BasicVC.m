//
//  BasicVC.m
//  GuangYiGuang_App
//
//  Created by Zhuqing on 16/7/1.
//  Copyright © 2016年 Zhuqing. All rights reserved.
//

#import "BasicVC.h"
//#import "LoginViewController.h"
#import "MainViewController.h"
//#import "RegistPhoneVC.h"
@interface BasicVC ()<UIGestureRecognizerDelegate>

@end

@implementation BasicVC

+ (BaseNavigationController *)navigationControllerContainSelf
{
    id vc = [[[self class] alloc]init];
    
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
    return nav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[IQKeyboardManager sharedManager]setEnable:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar=NO;
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @" ";
    UIImage *image = [UIImage imageNamed:@"Back_icon"];
    [backItem setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-400.f, 0) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = backItem;
    
//    [self.view setBackgroundColor:COLOR_BACK];

    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer ){
        if (self.navigationController.viewControllers.count < 2 || self.navigationController.visibleViewController == [self.navigationController.viewControllers firstObject]){
            return NO;
        }
    }
    
    return YES;
}

- (void)setLeftBarItemWithButton:(UIButton *)btn
{
    
    [btn addTarget:self action:@selector(leftBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:item];

    
}

- (void)setRightBarItemWithButton:(UIButton *)btn
{
    
    [btn addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setRightBarButtonItem:item];
    
    
}

- (void)leftBarButtonItemAction:(id)sender{}

- (void)rightBarButtonItemAction:(id)sender{}

#pragma mark 弹出登陆页面
- (void)presentLoginWithComplection:(void(^)(void))complectionBlock
{
//    BaseNavigationController *nav = [RegistPhoneVC navigationControllerContainSelf];
//    RegistPhoneVC *controller = nav.viewControllers[0];
//
//    [self presentViewController:nav animated:YES completion:nil];
    
}

#pragma mark 根据eventId和params跳转
- (void)jumpWithParams:(NSString *)params
{
    if ([params hasPrefix:@"http"] || [params hasPrefix:@"https"]) {
        //H5页面
        //webView
        BaseWKWebController *vc = [[BaseWKWebController alloc]init];
        vc.url = params;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        
        if ([params hasPrefix:@"qyueche://"]) {
            NSArray *aArray = [params componentsSeparatedByString:@"//"];
            
            if (aArray.count > 1) {
                
                NSString *aString = [aArray lastObject];
                
                NSArray *bArray = [aString componentsSeparatedByString:@"_"];
                
                if (bArray.count > 1) {
                    
                    NSString *cString = [bArray firstObject];
                    NSString *dString = [bArray lastObject];
                    
                    switch ([cString integerValue]) {
                            
                        case 0:{
                            
                            //不带任何操作
                        }
                            break;
                            
                        case 1:{
                            
                            //活动分享领券
//                            ActivityShareVC *vc = [[ActivityShareVC alloc]initWithNibName:@"ActivityShareVC" bundle:nil];
//                            vc.couponId = dString;
//                            [self.navigationController pushViewController:vc animated:YES];
                            
                        }
                            break;
                            
                        case 2:{
                            
                            //路线详情

                        }
                            break;
                            
                        case 3:{
                            //登录
//                            [self presentLoginWithComplection:nil];
                        }
                            break;
                            
                        default:
//                            [QuHudHelper qu_showMessage:@"抱歉，暂不支持此功能"];
                            break;
                    }
                }
                
            }
        }
    }

}

#pragma mark 监测网络状态
- (void)monitorNetworkingWithWWANBlock:(void(^)(void))wwanBlock wifiBlock:(void(^)(void))wifiBlock
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
                NSLog(@"未知网络");
                break;
            case 0:
                NSLog(@"网络不可达");
                break;
            case 1:
            {
                NSLog(@"GPRS网络");
                //发通知，带头搞事
                if (wwanBlock) {
                    wwanBlock();
                }
            }
                break;
            case 2:
            {
                NSLog(@"wifi网络");
                //发通知，搞事情
                if (wifiBlock) {
                    wifiBlock();
                }
            }
                break;
            default:
                break;
        }
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            NSLog(@"有网");
        }
        else{
            NSLog(@"没网");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"Release---- %@",NSStringFromClass([self class]));
}

@end
