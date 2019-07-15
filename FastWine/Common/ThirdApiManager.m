//
//  ThirdApiManager.m
//  QuPassenger
//
//  Created by Zhuqing on 2017/9/22.
//  Copyright © 2017年 com.Qyueche. All rights reserved.
//

#import "ThirdApiManager.h"
//#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//////微信SDK头文件
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
////#import "WeiboSDK.h"
#import <AlipaySDK/AlipaySDK.h>
//#import "RSADataSigner.h"
//#import <AlicloudMobileAnalitics/ALBBMAN.h>
#import <WechatConnector/WechatConnector.h>
#import <Bugly/Bugly.h>

@implementation ThirdApiManager

+ (ThirdApiManager *)shareManager
{
    static dispatch_once_t pred;
    static ThirdApiManager *shared = nil;
    dispatch_once(&pred, ^{
        
        shared = [[self alloc]init];
    });
    return shared;
}

- (void)registerThirdApi
{
    //amap
//    [AMapServices sharedServices].apiKey = AMapAppKey;
   //友盟 移动统计服务
//    [UMConfigure initWithAppkey:UMAppKey channel:@"App Store"];
//    [UMConfigure setEncryptEnabled:YES];//打开加密传输
//    [UMConfigure setLogEnabled:YES];//设置打开日志
  //Bugly
    [Bugly startWithAppId:BuglyAppKey];
    //获取阿里云移动统计服务
//    [[ALBBMANAnalytics getInstance] initWithAppKey:@"24804709" secretKey:@"cb01739d09d9fafdf693aee1e7d245d7"];
//    [[ALBBMANAnalytics getInstance] setAppVersion:CLIENT_VERSION];
//    [[ALBBMANAnalytics getInstance] setChannel:@"App Store"];


    //ShareSdk
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) { //微信
        [platformsRegister setupWeChatWithAppId:WXAPPID appSecret:nil];
    }];
  
    [WXApi registerApp:WXAPPID];
    
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //QQ
        [platformsRegister setupQQWithAppId:@"1107925937" appkey:@"LBKASQ85R2RfIHDx"];
        //微信
        [platformsRegister setupWeChatWithAppId:WXAPPID appSecret:nil];//100fd799f39e4ad0f46ddb46107ee164
        //新浪
//        [platformsRegister setupSinaWeiboWithAppkey:@"568898243" appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3" redirectUrl:@"http://www.sharesdk.cn"];

    }];



}

- (void)getThirdUserInfoCompletion:(void (^)(NSString *uid,NSString *nickName,NSString *headUrl,NSString *wxToken))userBlock
{
    if ([ShareSDK hasAuthorized:SSDKPlatformTypeWechat]) {
        [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
    }
    
//    [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
//
//        if (state == SSDKResponseStateSuccess){
//
//            NSLog(@"uid=%@",user.uid);
//            NSLog(@"%@",user.credential);
//            NSLog(@"token=%@",user.credential.token);
//            NSLog(@"nickname=%@",user.nickname);
//            if (userBlock) {
//                userBlock(user.uid,user.nickname,user.icon,user.credential.token);
//            }
//        }
//        else{
//            NSLog(@"%@",error);
//        }
//    }];
    
    [WeChatConnector setRequestAuthTokenOperation:^(NSString *authCode, void (^getUserinfo)(NSString *uid, NSString *token)) {
        NSLog(@"%@",authCode);
        if (userBlock) {
        userBlock(authCode,authCode,authCode,authCode);
        }
        getUserinfo(nil,nil);
        
    }];
    //先执行auth方法，我们内部会判断，如果appsecret为nil，就会判断执行setRequestAuthTokenOperation
    [ShareSDK authorize:SSDKPlatformTypeWechat settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess)
        {
            NSLog(@"%@",[user.credential rawData]);
            NSLog(@"%@",user.rawData);
        }
        else
        {
            NSLog(@"%@",error);
        }
    }];
}

- (void)sendThirdPayReqWithPayType:(QuPayType)payType payModel:(id)payModel success:(void (^)(void))paySuccessBlock fail:(void (^)(void))payFailBlock
{
    self.thirdPaySuccessBlock = paySuccessBlock;
    self.thirdPayFailBlock = payFailBlock;

    if (payType == QuPayType_WX) {
        WXPayModel *pay = payModel;
        PayReq *request = [[PayReq alloc]init];
        request.partnerId = pay.partnerid;
        request.prepayId = pay.prepayid;
        request.package = pay.package;
        request.nonceStr = pay.noncestr;
        request.timeStamp = pay.timestamp;
        request.sign = pay.sign;
        [WXApi sendReq:request];
    }
    else{

       AlipayModel *pay = (AlipayModel *)payModel;
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"JiudiZhiXuan";

        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = payModel;

        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSString *result = [resultDic objectForKey:@"resultStatus"];

            if ([@"9000" isEqualToString:result]) {

                if (paySuccessBlock) {
                    paySuccessBlock();
                }
                
            }
            else{
                if (payFailBlock) {
                    payFailBlock();
                }

            }

        }];



    }

}

- (void)sendThirdShareWithView:(UIView *)view model:(id)shareModel success:(void (^)(void))shareSuccessBlock fail:(void (^)(void))shareFailBlock
{
    QuShareModel *model = (QuShareModel *)shareModel;

    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:model.content
                                     images:model.imageUrl
                                        url:[NSURL URLWithString:model.targetUrl]
                                      title:model.title
                                       type:SSDKContentTypeAuto];

    [ShareSDK showShareActionSheet:view
                             items:model.platforms
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {

                   switch (state) {

                       case SSDKResponseStateBegin:
                       {
                           //设置UI等操作
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           if (shareSuccessBlock) {
                               shareSuccessBlock();
                           }
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           NSLog(@"%@",error);
                           if (shareFailBlock) {
                               shareFailBlock();
                           }
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {

                           break;
                       }
                       default:
                           break;
                   }
               }];

}

- (void)sendThirdShareWithPlatform:(SSDKPlatformType)platform model:(id)shareModel success:(void (^)(void))shareSuccessBlock fail:(void (^)(void))shareFailBlock
{
    QuShareModel *model = (QuShareModel *)shareModel;

    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:model.content
                                     images:model.imageUrl
                                        url:[NSURL URLWithString:model.targetUrl]
                                      title:model.title
                                       type:SSDKContentTypeAuto];
    
    //进行分享
    [ShareSDK share:platform //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {

         switch (state) {

             case SSDKResponseStateBegin:
             {
                 //设置UI等操作
                 break;
             }
             case SSDKResponseStateSuccess:
             {
                 if (shareSuccessBlock) {
                     shareSuccessBlock();
                 }
                 break;
             }
             case SSDKResponseStateFail:
             {
                 NSLog(@"%@",error);
                 if (shareFailBlock) {
                     shareFailBlock();
                 }
                 break;
             }
             case SSDKResponseStateCancel:
             {

                 break;
             }
             default:
                 break;
         }

     }];


}

@end
