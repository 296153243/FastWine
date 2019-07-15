//
//  QuDBManager.m
//  QuPassenger
//
//  Created by Zhuqing on 2017/9/30.
//  Copyright © 2017年 com.Qyueche. All rights reserved.
//

#import "QuDBManager.h"
#import "QuCityModel.h"

#define CITY_SELECT_DB @"area.db"

#define CITY_SELECT_TABLE @"city"
//#define PROVINCE_SELECT_TABLE @"ProvinceCodeInfo"
//#define DBVERSION_Table @"DBVersionInfo"
//#define MESSAGE_Table @"MessageInfo"

@implementation QuDBManager

+ (QuDBManager *)shareDataManger
{
    static dispatch_once_t onceToken;
    static QuDBManager *dataManger;
    
    dispatch_once(&onceToken, ^{
        dataManger = [[QuDBManager alloc] init];
        
    });
    
    return dataManger;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        [self initDataBase];
    }
    
    return self;
}

- (void)initDataBase{
    if (!_db) {
        _db = nil;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSString *fileDB = CITY_SELECT_DB;
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *pathAry = [fileDB componentsSeparatedByString:@"."];
    
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:[pathAry objectAtIndex:0] ofType:[pathAry objectAtIndex:1]];
    self.dbPath = [documentPath stringByAppendingPathComponent:fileDB];
    
//    NSString *bundleDbVersion = [self getDBVerisonFromBundleDBPath:CITY_SELECT_DB];
//    NSString *dbVersion = [self getDBVerisonFromSourceDBPath:self.dbPath];
//
//    if (![dbVersion isEqualToString:bundleDbVersion]) {
//
//
//        if (![fileManager removeItemAtPath:_dbPath error:&error]) {
//            NSLog(@"%@",[error localizedDescription])
//            ;
//            _db = [FMDatabase databaseWithPath:sourcePath];
//        }
//        else{
//            if (![fileManager copyItemAtPath:sourcePath toPath:_dbPath error:&error]) {
//                NSLog(@"%@",[error localizedDescription]);
//                _db = [FMDatabase databaseWithPath:sourcePath];
//            }
//            else{
//
//                _db = [FMDatabase databaseWithPath:_dbPath];
//
//
//            }
//            NSLog(@"database copy.....");
//
//        }
//
//    }
//    else{
//
//
//    }
//     _db = [FMDatabase databaseWithPath:_dbPath];
    _db = [FMDatabase databaseWithPath:sourcePath];

    if (!_queue) {
        _queue = [[FMDatabaseQueue alloc]initWithPath:sourcePath];
    }
 
}

#pragma 获取document数据库的版本号
//- (NSString *)getDBVerisonFromSourceDBPath:(NSString *)sourcePath{
//    @synchronized(self){
//        FMDatabase *db = [FMDatabase databaseWithPath:sourcePath];
//
//        if (![db open]){
//            NSLog(@"==<open database error!>==");
//        }
//        NSString *dbVersion= @"";
//        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ",DBVERSION_Table];
//        FMResultSet *rs = [db executeQuery:sql];
//        while ([rs next]) {
//            dbVersion = [rs stringForColumn:@"dbVersion"];//region_code
//        }
//        [rs close];
//        [db close];
//        return dbVersion;
//    }
//}
//#pragma 获取bundle数据库的版本号
//- (NSString *)getDBVerisonFromBundleDBPath:(NSString *)fileDB{
//    @synchronized(self){
//        NSArray *pathAry = [fileDB componentsSeparatedByString:@"."];
//        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:[pathAry objectAtIndex:0] ofType:[pathAry objectAtIndex:1]];
//        FMDatabase *db = [FMDatabase databaseWithPath:sourcePath];
//
//        if (![db open]){
//            NSLog(@"==<open database error!>==");
//        }
//
//        NSString *dbVersion= @"";
//        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ",DBVERSION_Table];
//
//        FMResultSet *rs = [db executeQuery:sql];
//        while ([rs next]) {
//            dbVersion = [rs stringForColumn:@"dbVersion"];//region_code
//        }
//        [rs close];
//        [db close];
//        return dbVersion;
//    }
//}

#pragma mark CITY_SELECT_TABLE
- (NSMutableArray *)getTheCityAreaCodeWithProvinceCode:(NSString *)provinceCode
{
    @synchronized(self){
        [self.db open];
        NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE lvl='2'",CITY_SELECT_TABLE];
        if (provinceCode.length > 0) {
            sql = [NSString stringWithFormat:@"SELECT * FROM %@' AND areaParent = '%@'",CITY_SELECT_TABLE,provinceCode];
        }
        
        [self.queue inDatabase:^(FMDatabase *db){
            FMResultSet *rs = [db executeQuery:sql];
            
            while ([rs next]) {
                QuCityModel *model = [[QuCityModel alloc]init];
                model.cityName   = [rs stringForColumn:@"areaName"];
                model.provinceCode = [rs stringForColumn:@"areaParent"];
                model.cityCode = [rs stringForColumn:@"areaId"];
                [dataArray addObject:model];
            }
            [rs close];
        }];
        [self.db close];

        return dataArray;
    }
}

- (NSString *)getTheProvinceCodeWithCityName:(NSString *)cityName
{
    @synchronized(self){
        [self.db open];
        __block NSString *provinceCode= @"";
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE areaName='%@'",CITY_SELECT_TABLE,cityName];
        [self.queue inDatabase:^(FMDatabase *db){
            FMResultSet *rs = [db executeQuery:sql];
            while ([rs next]) {
                provinceCode = [rs stringForColumn:@"areaParent"];//region_code
            }
            [rs close];
        }];
        [self.db close];
        return provinceCode;
    }
}

- (NSString *)getTheCityCodeWithCityName:(NSString *) cityName
{
    @synchronized(self){
        [self.db open];
        __block NSString *cityCode= @"";
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE areaName='%@'",CITY_SELECT_TABLE,cityName];
        [self.queue inDatabase:^(FMDatabase *db){
            FMResultSet *rs = [db executeQuery:sql];
            while ([rs next]) {
                cityCode = [rs stringForColumn:@"areaId"];//region_code
            }
            [rs close];
        }];
        [self.db close];
        return cityCode;
    }
    
}

//#pragma mark MESSAGE_Table
//- (void)insertMessageListWithModel:(MessageListModel *)model{
//
//    @synchronized(self){
//        [self.db open];
//
//        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (title,content,time,userId,msgId,isRead) VALUES ('%@','%@','%@','%@','%@','%ld')",MESSAGE_Table,model.title,model.content,model.time,model.userId,model.msgId,model.isRead];
//        [self.queue inDatabase:^(FMDatabase *db){
//            [db executeUpdate:sql];
//        }];
//
//
//        [self.db close];
//    }
//
//}
//
//- (NSMutableArray *)getMessageListWithUserId:(NSString *)userId
//{
//    @synchronized(self){
//        [self.db open];
//        NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
//        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY time DESC",MESSAGE_Table];
//        if (userId.length > 0) {
//            sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userId ='%@' ORDER BY time DESC",MESSAGE_Table,userId];
//        }
//
//        [self.queue inDatabase:^(FMDatabase *db){
//            FMResultSet *rs = [db executeQuery:sql];
//            while ([rs next]) {
//                MessageListModel *model = [[MessageListModel alloc]init];
//                model.title   = [rs stringForColumn:@"title"];
//                model.content = [rs stringForColumn:@"content"];
//                model.time = [rs stringForColumn:@"time"];
//                model.userId   = [rs stringForColumn:@"userId"];
//                model.msgId = [rs stringForColumn:@"msgId"];
//                model.isRead = [rs intForColumn:@"isRead"];
//
//                [dataArray addObject:model];
//            }
//            [rs close];
//        }];
//        [self.db close];
//
//        return dataArray;
//    }
//}
//
//- (NSMutableArray *)getUnReadMessageListWithUserId:(NSString *)userId
//{
//    @synchronized(self){
//        [self.db open];
//        NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
//        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE isRead = 0 ORDER BY time DESC",MESSAGE_Table];
//        if (userId.length > 0) {
//            sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userId ='%@' and isRead = 0 ORDER BY time DESC",MESSAGE_Table,userId];
//        }
//
//        [self.queue inDatabase:^(FMDatabase *db){
//            FMResultSet *rs = [db executeQuery:sql];
//            while ([rs next]) {
//                MessageListModel *model = [[MessageListModel alloc]init];
//                model.title   = [rs stringForColumn:@"title"];
//                model.content = [rs stringForColumn:@"content"];
//                model.time = [rs stringForColumn:@"time"];
//                model.userId   = [rs stringForColumn:@"userId"];
//                model.msgId = [rs stringForColumn:@"msgId"];
//                model.isRead = [rs intForColumn:@"isRead"];
//
//                [dataArray addObject:model];
//            }
//            [rs close];
//        }];
//        [self.db close];
//
//        return dataArray;
//    }
//}
//
////更新该条消息未读状态
//- (void)updateMessageReadWithModel:(MessageListModel *)model{
//
//    @synchronized(self){
//        [self.db open];
//
//        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET isRead = 1 WHERE msgId = '%@'",MESSAGE_Table,model.msgId];
//
//        [self.queue inDatabase:^(FMDatabase *db){
//            [db executeUpdate:sql];
//        }];
//        [self.db close];
//
//    }
//
//}
/**
 判断一张表是否已经存在
 @param tablename 表名
 */
//- (BOOL)isExistTable:(NSString *)tablename{
//    
//    @synchronized(self){
//        
//        NSString *sql = [NSString stringWithFormat:@"select count(*) as 'count' from sqlite_master where type ='table' and name = '%@'",tablename];
//        if ([self.db open]) {
//            
//            __block NSInteger count = 0;
//            [self.queue inDatabase:^(FMDatabase *db){
//                FMResultSet *rs = [db executeQuery:sql];
//                while ([rs next]) {
//                    count = [rs intForColumn:@"count"];
//                    
//                }
//                [rs close];
//            }];
//            
//            [self.db close];
//            
//            if (0 == count){
//                return NO;
//            }
//            else{
//                return YES;
//            }
//
//        }
//        
//        return NO;
//    }
//    
//}
//
///**
// 创建消息表
// */
//- (void)createMessageTable{
//    
//    NSString * paramsrecordtable = @"CREATE TABLE 'MessageInfo' (_id INTEGER PRIMARY KEY AUTOINCREMENT,msgId varchar,title varchar,content varchar,userId varchar,time varchar)";
//    
//    if (![self isExistTable:MESSAGE_Table]) {
//        if ([self.db open]) {
//    
//            [self.db executeUpdate:paramsrecordtable];
//            
//            [self.db close];
//
//        }
//    }
//
//    
//}

@end
