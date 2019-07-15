//
//  QuDBManager.h
//  QuPassenger
//
//  Created by Zhuqing on 2017/9/30.
//  Copyright © 2017年 com.Qyueche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>
#import <FMDatabaseQueue.h>

@interface QuDBManager : NSObject

@property (strong, nonatomic) FMDatabase *db;
@property (strong, nonatomic) NSString *dbPath;
@property (strong, nonatomic) FMDatabaseQueue *queue;

+ (QuDBManager *)shareDataManger;

//获取所有城市
- (NSMutableArray *)getTheCityAreaCodeWithProvinceCode:(NSString *)provinceCode;
//根据城市名获取省code
- (NSString *)getTheProvinceCodeWithCityName:(NSString *)cityName;
//根据城市名获取城市code
- (NSString *)getTheCityCodeWithCityName:(NSString *)cityName;

//获取所有消息
- (NSMutableArray *)getMessageListWithUserId:(NSString *)userId;
//添加一条消息
- (void)insertMessageListWithModel:(MessageListModel *)model;
//获取未读消息
- (NSMutableArray *)getUnReadMessageListWithUserId:(NSString *)userId;
//更新该条消息未读状态
- (void)updateMessageReadWithModel:(MessageListModel *)model;

@end
