//
//  OrderpayTypeVC.h
//  FastWine
//
//  Created by MOOSON_ on 2019/4/1.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderpayTypeVC : UIViewController
@property(nonatomic,strong)NSString *pic;
@property(nonatomic,strong)NSString *orderId;
@property(nonatomic)BOOL isTopUp;//是否是充值页面
@property(nonatomic)XQApiName apiName;
@property(nonatomic)XQApiName updateOrderApiName;
@end

NS_ASSUME_NONNULL_END
