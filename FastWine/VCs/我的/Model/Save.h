//
//  Save.h
//  NDBaseProject
//
//  Created by WenhuaLuo on 17/6/14.
//  Copyright © 2017年 王猛. All rights reserved.
//

#import <Foundation/Foundation.h>


@class User;
@interface Save : NSObject


+ (void)setObject:(id)value forKey:(NSString *)defaultName;

+ (id)objectForKey:(NSString *)defaultName;

/**
 *  存储帐号信息
 */
+ (void)saveUser:(User *)user;

/**
 *  获得上次存储的帐号
 *
 */
+ (User *)user;

+ (NSString *)userID;
+ (NSString *)userPhone;
+ (NSString *)userAvatar;
+ (NSString *)userName;
+ (NSString *)userToken;
+ (NSString *)obd_isbind;
+ (NSString *)odb_macid;
+ (NSString *)obd_mds;
+ (NSString *)obd_user_id;

+ (BOOL)isLogin;
@end


@interface User : NSObject
@property (nonatomic , copy) NSString  * uid;//
@property (nonatomic , copy) NSString  * phone;//用户电话号码
@property (nonatomic , copy) NSString  * account;//用户电话号码
@property (nonatomic , copy) NSString  * pwd;
@property (nonatomic , copy) NSString  * nickname;//用户昵称（微信名）
@property (nonatomic , copy) NSString  * avatar;//用户头像地址
@property (nonatomic , copy) NSString  * add_time;
@property (nonatomic , copy) NSString  * add_ip;
@property (nonatomic , copy) NSString  * last_time;
@property (nonatomic , copy) NSString  * last_ip;
@property (nonatomic , copy) NSString  * now_money;
@property (nonatomic , copy) NSString  * integral;
@property (nonatomic , copy) NSString  * status;
@property (nonatomic , copy) NSString  * level;
@property (nonatomic , copy) NSString  * spread_uid;
@property (nonatomic , copy) NSString  * agent_id;
@property (nonatomic , copy) NSString  * user_type;
@property (nonatomic , copy) NSString  * is_promoter;
@property (nonatomic , copy) NSString  * pay_count;
@property (nonatomic , copy) NSString  * direct_num;
@property (nonatomic , copy) NSString  * team_num;
@property (nonatomic , copy) NSString  * is_reward;
@property (nonatomic , copy) NSString  * allowance_number;
@end


