//
//  ThirdApiManager.h
//  QuPassenger
//
//  Created by Zhuqing on 2017/9/22.
//  Copyright © 2017年 com.Qyueche. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <ShareSDK/ShareSDK.h>

typedef NS_ENUM(NSUInteger, QuPayType) {
    
    QuPayType_Alipay,   //支付宝支付
    QuPayType_WX,      //微信支付
    
};

@interface ThirdApiManager : NSObject

@property (copy, nonatomic) void (^thirdPaySuccessBlock)(void);
@property (copy, nonatomic) void (^thirdPayFailBlock)(void);
@property (copy, nonatomic) void (^thirdShareSuccessBlock)(void);
@property (copy, nonatomic) void (^thirdShareFailBlock)(void);

+ (ThirdApiManager *)shareManager;

//注册第三方key
- (void)registerThirdApi;

//发送第三方支付
- (void)sendThirdPayReqWithPayType:(QuPayType)payType payModel:(id)payModel success:(void (^)(void))paySuccessBlock fail:(void (^)(void))payFailBlock;

//第三方授权登录
- (void)getThirdUserInfoCompletion:(void (^)(NSString *uid,NSString *nickName,NSString *headUrl,NSString *wxToken))userBlock;

////发送第三方分享
//- (void)sendThirdShareWithView:(UIView *)view model:(id)shareModel success:(void (^)(void))shareSuccessBlock fail:(void (^)(void))shareFailBlock;
//
////单独分享平台
//- (void)sendThirdShareWithPlatform:(SSDKPlatformType)platform model:(id)shareModel success:(void (^)(void))shareSuccessBlock fail:(void (^)(void))shareFailBlock;

@end
