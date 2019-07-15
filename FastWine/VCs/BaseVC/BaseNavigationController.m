//
//  BaseNavigationController.m
//  Entertainment_App
//
//  Created by Zhuqing on 2016/10/13.
//  Copyright © 2016年 Entertainment. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UINavigationBar+Awesome.h"
#import "MyWalletVC.h"
@interface BaseNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>{
    UIImageView *navBarHairlineImageView;
}

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    //偏移问题
//    self.navigationBar.translucent = NO;
//    self.extendedLayoutIncludesOpaqueBars = YES;
//    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    self.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:navTitleColor,NSFontAttributeName:[UIFont systemFontOfSize:18]};
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"tianjia_button"] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.barTintColor = NavColor;
    //TableBar  偏移问题
    [[UITabBar appearance] setTranslucent:NO];

    //tablebar 颜色
    UIImage *image = [self.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.selectedImage = image;
//    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: HEXCOLOR(@"#E373737")} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(@"#101010")} forState:UIControlStateNormal];
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(@"#E60012")} forState:UIControlStateSelected];


//    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(@"#E373737")} forState:UIControlStateNormal];
//    NSArray *titleArr = @[@"首页",@"分类",@"",@"购物车",@"我的",];
//    NSArray *iconArr = @[@"main_gray",@"fenlei_gray",@"fenxiao",@"gouwuche_gray",@"wode_gray"];
//    NSArray *selectIconArr = @[@"main_red",@"fenlei_red",@"fenxiao",@"gouwuche_red",@"wode_red",];

  
//        nav.tabBarItem = [[UITabBarItem alloc]initWithTitle:titleArr[i] image:[[UIImage imageNamed:iconArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectIconArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
  

  
}
+(void)initialize{
    //全局设置nav颜色
//    [self setupNavBar];
  
}

#pragma mark - 设置navBar style
+(void)setupNavBar{
    UINavigationBar *navBar = [UINavigationBar appearance];
  

//    3.setup title font color and size 标题的样式
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName:navTitleColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    [navBar setBackgroundImage:[UIImage imageNamed:@"tianjia_button"] forBarMetrics:UIBarMetricsDefault];

}

#pragma mark -push的时候 隐藏底部tabbar
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {

        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, 19, 44);
        [backBtn setImage:[UIImage imageNamed:@"Back_icon"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
     
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
        
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        if (@available(iOS 11.0, *)) {
            spaceItem.width = 0.001;
        }
        else
        {
            spaceItem.width = -15;
        }
        viewController.navigationItem.leftBarButtonItem = item;
//        viewController.navigationItem.leftBarButtonItems = @[spaceItem, item];
 }
    
    
 viewController.navigationController.navigationBar.translucent = NO;
    [super pushViewController:viewController animated:animated];
   
}


- (void)back
{
    
    [self popViewControllerAnimated:YES];
}
@end
