//
//  BaseNetWorkRequest.m
//  FreshFood
//
//  Created by Zhuqing on 2017/7/24.
//  Copyright © 2017年 FreshFood. All rights reserved.
//

#import "NetWorkReqManager.h"
#import "AppDelegate.h"
#import "XMToolClass.h"
@implementation NetWorkReqManager

- (instancetype)initWithApiName:(XQApiName)apiName params:(id)params
{
    _apiName = apiName;
    _params = params;
    return [self init];
}

- (void)postRequestWithResponse:(requestSuccess)responseBlock errorResponse:(requestFailure)errorBlock
{
    NSMutableDictionary *muParams;
    if (self.params) {
        if ([self.params isKindOfClass:[NSDictionary class]]) {
            muParams = [NSMutableDictionary dictionaryWithDictionary:self.params];
        }
        else{
            NSDictionary *dic = [self.params mj_keyValues];
            muParams = [NSMutableDictionary dictionaryWithDictionary:dic];
        }
    }
    else{
        muParams = [NSMutableDictionary new];
    }
    [NetWorkEngine addHeaderFieldsWithDictionary:[NetWorkReqManager addCustomHeaders]];
    [NetWorkEngine requestWithType:HttpRequestTypePost withUrlString:@"" withParaments:muParams withSuccessBlock:^(NSDictionary *responseObject) {
        NSLog(@"返回数据:%@",responseObject);
        BaseResponse *response = [BaseResponse mj_objectWithKeyValues:responseObject];

        if (response.code == 400004){
            //预留token过期处理
//            [QuLoadingHUD dismiss];
//            [PublicManager showAlert:response.message withDoneBlock:^{
//                
//                [NetWorkReqManager tokenInvalidActionWithApiName:apiName];
//            }];
        }
        else{
            responseBlock(responseObject);
//            errorBlock(response.message);
        }
    } withFailureBlock:errorBlock progress:nil];
}


+ (void)requestDataWithApiName:(XQApiName)apiName params:(id)params response:(requestSuccess)responseBlock errorResponse:(requestFailure)errorBlock
{
    if ([UIApplication sharedApplication].keyWindow) {
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES ];
    }
    NSMutableDictionary *muParams;
    if (params) {
        if ([params isKindOfClass:[NSDictionary class]]) {
            muParams = [NSMutableDictionary dictionaryWithDictionary:params];
        }
        else{
            NSDictionary *dic = [params mj_keyValues];
            muParams = [NSMutableDictionary dictionaryWithDictionary:dic];
        }
    }
    else{
        muParams = [NSMutableDictionary new];
    }
    NSString *urlString = @"";

    urlString = [HOSTNAME stringByAppendingString:XQApiNameEnum(apiName)];
    
    [NetWorkEngine addHeaderFieldsWithDictionary:[NetWorkReqManager addCustomHeaders]];
    NSLog(@"请求URL：%@",urlString);
    NSLog(@"请求参数：%@",[XMToolClass parseParams:muParams]);
    [NetWorkEngine requestWithType:HttpRequestTypePost withUrlString:urlString withParaments:[XMToolClass parseParams:muParams] withSuccessBlock:^(NSDictionary *responseObject) {
        NSLog(@"返回数据:%@",responseObject);
        BaseResponse *response = [BaseResponse mj_objectWithKeyValues:responseObject];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.0001 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES ];
        });
         [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES ];
        if ( response.code == 1002 ){
            //token过期处理
            [QuLoadingHUD dismiss];
            [QuHudHelper qu_showMessage:@"登录失效"];
            //            [PublicManager showAlert:response.msg withDoneBlock:^{
            //
            //                [NetWorkReqManager tokenInvalidActionWithApiName:apiName];
            //            }];
        }else if (response.code == 1001){
            [QuLoadingHUD dismiss];
            [QuHudHelper qu_showMessage:response.msg];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES ];
            });
            
        }
        else {
            responseBlock(responseObject);
            // errorBlock(response.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES ];
            });
        }
    } withFailureBlock:errorBlock progress:nil];
}
+ (void)requestNoHudDataWithApiName:(XQApiName)apiName params:(id)params response:(requestSuccess)responseBlock errorResponse:(requestFailure)errorBlock
{
    
    //    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES ];
    
    NSMutableDictionary *muParams;
    if (params) {
        if ([params isKindOfClass:[NSDictionary class]]) {
            muParams = [NSMutableDictionary dictionaryWithDictionary:params];
        }
        else{
            NSDictionary *dic = [params mj_keyValues];
            muParams = [NSMutableDictionary dictionaryWithDictionary:dic];
        }
    }
    else{
        muParams = [NSMutableDictionary new];
    }
    
    NSString *urlString = @"";
 
    urlString = [HOSTNAME stringByAppendingString:XQApiNameEnum(apiName)];

    [NetWorkEngine addHeaderFieldsWithDictionary:[NetWorkReqManager addCustomHeaders]];
    NSLog(@"请求URL：%@",urlString);
    NSLog(@"请求参数：%@",muParams);
    
    [NetWorkEngine requestWithType:HttpRequestTypePost withUrlString:urlString withParaments:muParams withSuccessBlock:^(NSDictionary *responseObject) {
        NSLog(@"返回数据:%@",responseObject);
        BaseResponse *response = [BaseResponse mj_objectWithKeyValues:responseObject];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.0001 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES ];
        });
        
        if ( response.code == 1002 ){
            //token过期处理
            [QuLoadingHUD dismiss];
            [QuHudHelper qu_showMessage:@"登录失效"];
            //            [PublicManager showAlert:response.msg withDoneBlock:^{
            //
            //                [NetWorkReqManager tokenInvalidActionWithApiName:apiName];
            //            }];
        }else if (response.code == 1001){
            [QuLoadingHUD dismiss];
            [QuHudHelper qu_showMessage:response.msg];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES ];
            });
            
        }
        else {
            responseBlock(responseObject);
            //            errorBlock(response.message);
        }
    } withFailureBlock:errorBlock progress:nil];
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
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenRect.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    [headers setObject:[NSString stringWithFormat:@"%f * %f",screenSize.width * scale,screenSize.height * scale] forKey:@"screen"];
    [headers setObject:CLIENT_VERSION forKey:@"deviceVersion"];
   //格式化时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    [headers setObject:currentDateStr forKey:@"timestamp"];
    [headers setObject:@"iOS" forKey:@"channelId"];
    [headers setObject:[self getNetworkType] forKey:@"networkType"];
    [headers setObject:@"2" forKey:@"deviceType"];
    [headers setObject:@"1" forKey:@"deviceInfo"];
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
