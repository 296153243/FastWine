//
//  AccountInfo.m
//  GuangYiGuang_App
//
//  Created by Zhuqing on 16/7/21.
//  Copyright © 2016年 Zhuqing. All rights reserved.
//

#import "AccountInfo.h"

@implementation AccountInfo

+ (AccountInfo *)shareRsp
{
    static dispatch_once_t pred;
    static AccountInfo *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[self alloc]init];
        //        shared.isLogin = YES;
        
    });
    return shared;
}

- (void)setUserInfo:(QuUserInfo *)userInfo
{
    _userInfo = userInfo;
    
}
- (void)setOrderStatusNum:(OrderNumRsp *)orderStatusNum
{
    _orderStatusNum = orderStatusNum;
    
}
-(void)setUserId:(NSString *)userId{
    _userId = userId;
    if (userId) {
        [PublicManager saveUserUdToLocalWithId:userId];

    }else{
       [PublicManager removelocalUserId];
    }
}
-(void)setToken:(NSString *)token{
    _token = token;
    if (token) {
        [PublicManager saveUserUdToLocalWithToken:token];
        
    }else{
        [PublicManager removelocalToken];
    }
}
-(void)setPhone:(NSString *)phone{
    _phone = phone;
    if (phone) {
        [PublicManager saveUserUdToLocalWithPhone:phone];
    }else{
        [PublicManager removelocalPhone];
    }
}
@end
