//
//  BasicVC.h
//  GuangYiGuang_App
//
//  Created by Zhuqing on 16/7/1.
//  Copyright © 2016年 Zhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuNavigationBar.h"
#import "BaseNavigationController.h"
@interface BasicVC : UIViewController

@property (strong, nonatomic) QuNavigationBar *clNavBar;

+ (BaseNavigationController *)navigationControllerContainSelf;
- (void)presentLoginWithComplection:(void(^)(void))complectionBlock;

- (void)setLeftBarItemWithButton:(UIButton *)btn;
- (void)setRightBarItemWithButton:(UIButton *)btn;

- (void)jumpWithParams:(NSString *)params;

- (void)monitorNetworkingWithWWANBlock:(void(^)(void))wwanBlock wifiBlock:(void(^)(void))wifiBlock;

@end
