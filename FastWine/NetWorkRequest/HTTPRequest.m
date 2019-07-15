//
//  HTTPRequest.m
//  NIMLiveDemo
//
//  Created by 那道 on 2017/9/20.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "HTTPRequest.h"
#import "XMToolClass.h"


@implementation City

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             };
}


@end

@implementation Province
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             };
}

+ (NSDictionary*)mj_objectClassInArray{
    return @{
             @"city":[City class]
             };
}

@end

@implementation PCAInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             };
}

+ (NSDictionary*)mj_objectClassInArray{
    return @{
             @"province":[Province class]
             };
}

@end



@implementation HTTPRequest


+ (instancetype)sharedManager
{
    static HTTPRequest *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HTTPRequest alloc] init];
    });
    return instance;
}


- (void)requestDataWithParameters:(NSDictionary *)parameters urlString:(id)urlString isEnable:(BOOL)enable  withSuccess:(void (^)(id responseObject))success
                        withError:(void (^)(NSError* error))failed
{
    APPDELEGATE.window.userInteractionEnabled = enable;
    if (!enable) {
        [SVProgressHUD showWithStatus:Tip];
    }
    AFHTTPSessionManager *manager = [XMToolClass httpRequestInit];
    
    NSString *url = [[NSString stringWithFormat:@"%@%@%@", HOSTNAME,@"g=app&m=appv1&a=", urlString]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"请求URL----：%@",url);
    NSLog(@"请求参数----：%@",[XMToolClass parseParams:parameters]);
    [manager POST:url parameters:[XMToolClass parseParams:parameters] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"返回数据---:%@",responseObject);
        [SVProgressHUD dismiss];
        APPDELEGATE.window.userInteractionEnabled = YES;
        
        if ([responseObject[@"code"] integerValue] == 0 ) {
            if (success) {
                success(responseObject);
            }
        }
        else
        {
            //没有车辆
            if ([urlString isEqualToString:@"GetWZAll"]) {
                if (success) {
                    success(responseObject);
                }
            }
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            
            if ([urlString containsString:@"Login"] && [responseObject[@"code"] integerValue]==3) {
                [SVProgressHUD dismissWithDelay:kDelayTime*4];
            }
            else
            {
                [SVProgressHUD dismissWithDelay:kDelayTime];
            }
            
            if (failed) {
                failed(nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failed) {
            failed(error);
        }
        [SVProgressHUD dismiss];
        APPDELEGATE.window.userInteractionEnabled = YES;
        
    }];
}
- (void)requestDataWithApiName:(XQApiName)apiName withParameters:(id)parameters isEnable:(BOOL)enable  withSuccess:(void (^)(id responseObject))success
                     withError:(void (^)(NSError* error))failed{
//    APPDELEGATE.window.userInteractionEnabled = enable;
//    if (!enable) {
//        [SVProgressHUD showWithStatus:Tip];
//    }
    AFHTTPSessionManager *manager = [XMToolClass httpRequestInit];
    
    NSMutableDictionary *muParams;
    if (parameters) {
        if ([parameters isKindOfClass:[NSDictionary class]]) {
            muParams = [NSMutableDictionary dictionaryWithDictionary:parameters];
        }
        else{
            NSDictionary *dic = [parameters mj_keyValues];
            muParams = [NSMutableDictionary dictionaryWithDictionary:dic];
        }
    }
    else{
        muParams = [NSMutableDictionary new];
    }
    NSString *urlString = @"";
    
    urlString = [HOSTNAME stringByAppendingString:XQApiNameEnum(apiName)];
    //添加请求头
    [NetWorkEngine addHeaderFieldsWithDictionary:[HTTPRequest addCustomHeaders]];
    
    NSLog(@"请求URL----：%@",urlString);
    NSLog(@"请求参数----：%@",[XMToolClass parseParams:muParams]);
    //添加请求头
    [NetWorkEngine addHeaderFieldsWithDictionary:[HTTPRequest addCustomHeaders]];
    [NetWorkEngine requestWithType:HttpRequestTypePost withUrlString:urlString withParaments:[XMToolClass parseParams:muParams] withSuccessBlock:^(NSDictionary *responseObject) {
        NSLog(@"POST返回数据---:%@",responseObject);
        BaseResponse *rsp =[BaseResponse mj_objectWithKeyValues:responseObject];
        if (rsp.code == 200) {
            if (responseObject != nil) {
                if (success) {
                    success(responseObject);
                }
            }
        }else{
            if (rsp.msg) {
               [QuHudHelper qu_showMessage:rsp.msg];

            }
            //登录接口把msg 返回
            if (apiName == login) {
                if (failed) {
                    failed((NSError *)rsp.msg);
                }
            }
        

//             [QuHudHelper qu_showMessage:responseObject[@"data"]];
        }
        
    } withFailureBlock:^(NSString *error) {
        if (failed) {
            failed((NSError *)error);
        }
        
        [SVProgressHUD dismiss];
        APPDELEGATE.window.userInteractionEnabled = YES;
    } progress:^(float progress) {
        
    }];
//    [manager POST:urlString parameters:[XMToolClass parseParams:muParams] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"返回数据---:%@",responseObject);
//        [SVProgressHUD dismiss];
//        APPDELEGATE.window.userInteractionEnabled = YES;
//
//        if ([responseObject[@"code"] integerValue] == 200) {
//            if (success) {
//                success(responseObject);
//            }
//
//        }
//        else
//        {
//            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
//            if ([responseObject[@"code"] integerValue]==3) {
//                [SVProgressHUD dismissWithDelay:kDelayTime*4];
//            }else if ([responseObject[@"code"] integerValue]==2) {
//                [SVProgressHUD dismissWithDelay:kDelayTime*2];
//            }
//            else
//            {
//                [SVProgressHUD dismissWithDelay:kDelayTime];
//            }
//
//            if (failed) {
//                failed(nil);
//            }
//        }
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (failed) {
//            failed(error);
//        }
//        [SVProgressHUD dismiss];
//        APPDELEGATE.window.userInteractionEnabled = YES;
//
//    }];
}
- (void)requesGetDataWithApiName:(XQApiName)apiName withParameters:(id)parameters isEnable:(BOOL)enable  withSuccess:(void (^)(id responseObject))success
                       withError:(void (^)(NSError* error))failed{
    
   BaseRequest *reqModel = parameters;
    
   NSString *urlStr = [self URLRequestStringWithURL:[HOSTNAME stringByAppendingString:XQApiNameEnum(apiName)] dic:[reqModel properties_aps]];
//    NSLog(@"properties_aps:%@",[reqModel properties_aps]);
    NSLog(@"请求URL----:%@",urlStr);
//    NSString * urlString = [NSString stringWithFormat:@"%@mapType=%@&method=%@&macid=%@&user_id=%@&mds=%@&option=cn",XQApiNameEnum(apiName),reqModel.mapType,reqModel.method,reqModel.macid,reqModel.user_id,reqModel.mds];
//    NSLog(@"请求URL：%@",urlString);
    //添加请求头
    [NetWorkEngine addHeaderFieldsWithDictionary:[HTTPRequest addCustomHeaders]];
    
    [NetWorkEngine requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        NSLog(@"Get返回数据---:%@",responseObject);
        BaseResponse *rsp =[BaseResponse mj_objectWithKeyValues:responseObject];
        if (rsp.code == 200) {
            if (responseObject != nil) {
                if (success) {
                    success(responseObject);
                }
            }
        }else{
            [QuHudHelper qu_showMessage:rsp.msg];
        }
        
    } withFailureBlock:^(NSString *error) {
        if (failed) {
            failed((NSError *)error);
        }
//        [SVProgressHUD dismiss];
        APPDELEGATE.window.userInteractionEnabled = YES;
    } progress:^(float progress) {
        
    }];
}
//Get请求参数封装
- (NSString *)URLRequestStringWithURL:(NSString *)urlstr dic:(NSDictionary *)dic{
    
    NSMutableString *URL = [NSMutableString stringWithFormat:@"%@",urlstr];
    //获取字典的所有keys
    NSArray * keys = [dic allKeys];
    
    //拼接字符串
    for (int j = 0; j < keys.count; j ++){
        NSString *string;
        
        if (dic[keys[j]] == nil) {
            break;
        }
        if (j == 0){
            //拼接时加？
            string = [NSString stringWithFormat:@"?%@=%@", keys[j], dic[keys[j]]];
            
        }else{
            //拼接时加&
            string = [NSString stringWithFormat:@"&%@=%@", keys[j], dic[keys[j]]];
        }
        //拼接字符串
        [URL appendString:string];
        
    }
    return URL;
}
//设置请求头
+ (NSDictionary *)addCustomHeaders
{
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    //    [headers setObject:@"" forKey:@"clientInfo"];
    //    [headers setObject:@"2" forKey:@"platform"];
    //    [headers setObject:@"sysVersion" forKey:HDDevice.systemVersion];
    //    [headers setObject:HDDeviceModel forKey:@"deviceModal"];
    //    [headers setObject:[PublicManager getDeviceId] forKey:@"deviceUUID"];
    //    得到当前屏幕的尺寸
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGSize screenSize = screenRect.size;
//    CGFloat scale = [UIScreen mainScreen].scale;
//    [headers setObject:[NSString stringWithFormat:@"%f * %f",screenSize.width * scale,screenSize.height * scale] forKey:@"screen"];
//    [headers setObject:CLIENT_VERSION forKey:@"deviceVersion"];
//    //格式化时间
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
//    [headers setObject:currentDateStr forKey:@"timestamp"];
//    [headers setObject:@"iOS" forKey:@"channelId"];
//    [headers setObject:[self getNetworkType] forKey:@"networkType"];
//    [headers setObject:@"2" forKey:@"deviceType"];
//    [headers setObject:@"1" forKey:@"deviceInfo"];
    NSString *authorization = [PublicManager getLocalToken]?[PublicManager getLocalToken]:@"";
    [headers setObject:authorization forKey:@"Authorization"];
//    NSLog(@"Authorization:-------%@",authorization);
    //    deviceType：设备类型，1：android，2：iOS
    //    deviceInfo：1：app,2：小程序
    //    if([PublicManager getLocalToken] != nil){
    //        [headers setObject:[PublicManager getLocalToken] forKey:@"token"];
    //    }
    //    else{
    //        [headers setObject:@"" forKey:@"token"];
    //    }
    //    if([PublicManager getLocalUserId] != nil){
    //        [headers setObject:[NSString stringWithFormat:@"%@",[PublicManager getLocalUserId]] forKey:@"userid"];
    //    }
    //    else{
    //        [headers setObject:@"" forKey:@"userid"];
    //    }
    //
    //    if([PublicManager getLocalPhone] != nil){
    //        [headers setObject:[NSString stringWithFormat:@"%@",[PublicManager getLocalPhone]] forKey:@"phone"];
    //    }
    //    else{
    //        [headers setObject:@"" forKey:@"phone"];
    //    }
    //    NSLog(@"%@---%@---%@",[NSString stringWithFormat:@"%@",[PublicManager getLocalUserId]],[PublicManager getLocalPhone],[PublicManager getLocalToken]);
    return headers;
}
+ (NSString *)getNetworkType
{
    __block  NSString *network = @"";
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                network = @"Unknown";
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                NSLog(@"没有网络(断网)");
                network = @"NotReachable";
                
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
                network = @"WWAN";
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                NSLog(@"WIFI");
                network = @"WIFI";
                break;
        }
    }];
    
    return network;
}
//token过期处理
+ (void)tokenInvalidActionWithApiName:(XQApiName)apiName
{
    //    ACCOUNTINFO.userInfo = nil;
    //    ACCOUNTINFO.userId = nil;
    //    ACCOUNTINFO.isLogin = NO;
    //   //停止推送
    //    [[XGPush defaultManager]stopXGNotification];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BaseNavigationController *nav = (BaseNavigationController *)delegate.window.rootViewController;
    [nav popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:TOKEN_INVAILD_NOTIFICATION object:nil];
}

@end

