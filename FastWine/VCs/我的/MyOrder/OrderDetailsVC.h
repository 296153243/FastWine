//
//  OrderDetailsVC.h
//  FastWine
//
//  Created by MOOSON_ on 2019/3/26.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailsVC : JDBaseVC
@property(nonatomic,strong)NSString *orderId;
@property(nonatomic,strong) OrderListModel *orderModel;
@end

NS_ASSUME_NONNULL_END
