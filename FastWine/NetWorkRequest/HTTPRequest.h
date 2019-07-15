//
//  HTTPRequest.h
//  NIMLiveDemo
//
//  Created by 那道 on 2017/9/20.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NetWorkRequestDefine.h"

@interface City :NSObject
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * name;

@end

@interface Province :NSObject
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSArray<City *>              * city;
@property (nonatomic , copy) NSString              * name;

@end

@interface PCAInfo :NSObject
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSArray<Province *>              * province;

@end

@interface HTTPRequest : NSObject


+ (instancetype)sharedManager;

- (void)requestDataWithParameters:(NSDictionary *)parameters urlString:(id)urlString isEnable:(BOOL)enable  withSuccess:(void (^)(id responseObject))success
                        withError:(void (^)(NSError* error))failed;
- (void)requestDataWithApiName:(XQApiName)apiName withParameters:(id)parameters isEnable:(BOOL)enable  withSuccess:(void (^)(id responseObject))success
                     withError:(void (^)(NSError* error))failed;

- (void)requesGetDataWithApiName:(XQApiName)apiName withParameters:(id)parameters isEnable:(BOOL)enable  withSuccess:(void (^)(id responseObject))success
                     withError:(void (^)(NSError* error))failed;



@end

