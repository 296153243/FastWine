//
//  AccountInfo.h
//  GuangYiGuang_App
//
//  Created by Zhuqing on 16/7/21.
//  Copyright © 2016年 Zhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountInfo : NSObject

@property (strong, nonatomic) QuUserInfo *userInfo;
@property (assign, nonatomic) BOOL isLogin;
@property (strong, nonatomic) OrderNumRsp *orderStatusNum;
@property (strong, nonatomic) NSArray *coupon_num;
@property (strong, nonatomic) NSString  *userId;
@property (strong, nonatomic) NSString  *coupon_number;
@property (strong, nonatomic) NSString  *collect_number;
@property (strong, nonatomic) NSString  *remind;
@property (strong, nonatomic) NSString  *phone;
@property (strong, nonatomic) NSString  *token;
@property (strong, nonatomic) NSString  *notice;
@property (strong, nonatomic) NSString  *statu;


+ (AccountInfo *)shareRsp;

@end
