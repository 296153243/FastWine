//
//  BaseNetWorkRequest.h
//  FreshFood
//
//  Created by Zhuqing on 2017/7/24.
//  Copyright © 2017年 FreshFood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkRequestDefine.h"
#import "NetWorkEngine.h"

@interface NetWorkReqManager : NSObject

@property (assign, nonatomic) XQApiName apiName;
@property (strong, nonatomic) id params;

//实例方法请求
- (instancetype)initWithApiName:(XQApiName)apiName params:(id)params;
- (void)postRequestWithResponse:(requestSuccess)responseBlock errorResponse:(requestFailure)errorBlock;


//类方法请求
/**
 @param apiName         接口参数
 @param params          请求参数  可model 可Dictionary
 @param responseBlock   请求成功的回调
 @param errorBlock      请求失败的回调
 */
+ (void)requestDataWithApiName:(XQApiName)apiName params:(id)params response:(requestSuccess)responseBlock errorResponse:(requestFailure)errorBlock;

+ (void)requestNoHudDataWithApiName:(XQApiName)apiName params:(id)params response:(requestSuccess)responseBlock errorResponse:(requestFailure)errorBlock;

@end
