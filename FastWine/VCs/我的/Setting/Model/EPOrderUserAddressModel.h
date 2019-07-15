//
//  EPOrderUserAddressModel.h
//  EricProject
//
//  Created by boosal on 17/6/6.
//  Copyright © 2017年 enzuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPOrderUserAddressModel : NSObject

@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *ad_code;
@property (nonatomic, copy) NSString *detail_address;
@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *consignee;

@end
