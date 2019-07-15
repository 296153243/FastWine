//
//  AddressModel.h
//  EricProject
//
//  Created by boosal on 17/3/18.
//  Copyright © 2017年 enzuo. All rights reserved.
//


@interface AddressModel : NSObject <NSCopying>

/**
 收货人姓名
 */
@property (nonatomic, copy) NSString *receiverName;

/**
 收货人手机
 */
@property (nonatomic, copy) NSString *receiverPhone;

/**
 收货人地址 (地址全称)
 */
@property (nonatomic, copy) NSString *reveiverAddress;
/**
 省、市、区 地址
 */
@property (nonatomic, copy) NSString *province_cityString;
/**
 详细地址
 */
@property (nonatomic, copy) NSString *districtString;

/**
 改地址是否为默认地址
 */
@property (nonatomic, assign) NSNumber *isDefaultAddress;

@end
