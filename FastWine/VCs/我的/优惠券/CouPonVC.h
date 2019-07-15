//
//  CouPonVC.h
//  CLTravel
//
//  Created by MOOSON_ on 2018/11/2.
//  Copyright © 2018年 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CouPonVC : JDBaseVC
@property(nonatomic,strong)NSString *orderId;
@property(nonatomic,copy)void(^ChooseCouponBlock)(NSString *couponId,double couponPic);

@end

NS_ASSUME_NONNULL_END
