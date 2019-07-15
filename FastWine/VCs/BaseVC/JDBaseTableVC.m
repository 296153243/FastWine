//
//  JDBaseTableVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/3/13.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "JDBaseTableVC.h"
#import "LoginViewController.h"
@interface JDBaseTableVC ()
@property(nonatomic,strong)UIImageView *navBarHairlineImageView;

@end

@implementation JDBaseTableVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _navBarHairlineImageView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _navBarHairlineImageView.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //去掉导航栏下横线
    _navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
}
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
#pragma mark 弹出登陆页面
- (void)presentLoginWithComplection:(void(^)(void))complectionBlock
{
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:[LoginViewController new]];
    [self presentViewController:nav animated:YES completion:nil];
    
}

@end
