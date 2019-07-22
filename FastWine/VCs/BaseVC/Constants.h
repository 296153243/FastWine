//
//  Constants.h
//  GuangYiGuang_App
//
//  Created by Zhuqing on 16/7/3.
//  Copyright © 2016年 Zhuqing. All rights reserved.
//

#ifndef Constants_h
#define Constants_h
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "UIColor+HEX.h"
#import "MJExtension.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "QuRefreshHeader.h"
#import "QuLoadingHUD.h"
#import "ThirdApiManager.h"
#import "IQKeyboardManager.h"
#import "NSString+Help.h"
#import "NetWorkRequestModel.h"
#import "AccountInfo.h"
//#import "AppConfigInfo.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "PublicManager.h"
//#import "LocalDataModel.h"
//#import "CHAlertView.h"
#import "QuHudHelper.h"
#import "BaseNavigationController.h"
#import "BaseWKWebController.h"
#import "BaseInputVC.h"
#import "JDBaseVC.h"
#import "JDBaseTableVC.h"
#import "HHWZWebView.h"
#import "UIButton+NZCustom.h"
#import "UILabel+Custom.h"
#import "PopAnimator.h"
#import "HTTPRequest.h"
#import "NetWorkReqManager.h"
#import "UITextField+Help.h"
#import "UIImage+Help.h"
#import "UIView+Help.h"
#import "Save.h"
#import "ZFEmptyView.h"
#import "UIBarButtonItem+Extension.h"
#import "CommonMethod.h"

#import "UIButton+Help.h"
#import "UIButton+Gradient.h"
#import "UIScrollView+EmptyDataSet.h"

#import "XMToolClass.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import "FSScrollContentView.h"
#import "OrderpayTypeVC.h"
#import "PicListButton.h"
#import "MLEmojiLabel.h"
#import "QMDateManager.h"
#import <YBImageBrowser/YBImageBrowser.h>
//支付宝
#import <AlipaySDK/AlipaySDK.h>



//高德地图
//#import <MAMapKit/MAMapKit.h>
//#import <AMapFoundationKit/AMapFoundationKit.h>//地图
//#import <AMapSearchKit/AMapSearchKit.h>
//#import <AMapLocationKit/AMapLocationKit.h>
//#import <AMapNaviKit/AMapNaviKit.h>


#ifdef DEBUG
//#define HOSTNAME @"http://mall.jiudicar.com/"//正式
//#define HOSTNAME @"http://wine.jiudi.cn/"//本地api
//#define HOSTNAME @"http://test.jiudicar.com/"//test
#define HOSTNAME @"http://wine.jiudicar.com/"//正式



#define NSLog(...) NSLog(__VA_ARGS__)


#else

//#define HOSTNAME @"http://cust.cluochuxing.com/"//用户
//#define HOSTNAMEGENERAL @"http://sms.cluochuxing.com/"//通用
#define HOSTNAME @"http://wine.jiudicar.com/"//正式

//#define HOSTNAME @"http://jiudi.youacloud.com/index.php?"//正式

//在release版本禁止输出NSLog内容
#define NSLog(...){}

#endif


#define weakSelf(weakSelf) __weak typeof(self)weakSelf = self;

#define AfterLoggingIn @"AfterLoggingIn"

#define ScreenWidthRatio [[UIScreen mainScreen] bounds].size.width/375

#define kWindowH   [UIScreen mainScreen].bounds.size.height //应用程序的屏幕高度
#define kWindowW    [UIScreen mainScreen].bounds.size.width  //应用程序的屏幕宽度
#define HScale(v) v / 667. * kWindowH //高度比
#define WScale(w) w / 375. * kWindowW //宽度比

#define APPSCHEME @"alisdkParkingSpace"

#define kZhiFuBao @"zhifubaoPay"

#define WXPAYSUCCESS @"WeixinPaySuccess"//微信支付成功的通知
#define WXPAYFAILURE @"WeixinPayFailure"//微信支付失败的通知

#define kDelayTime 0.45  //

#define NZNotificationCenter [NSNotificationCenter defaultCenter]
#define NavRect  self.navigationController.navigationBar.frame ///导航栏的坐标
#define Nav_height  NavRect.size.height ///导航栏的高度
#define StatusRect  [[UIApplication sharedApplication] statusBarFrame] ///状态栏的坐标
#define Status_height  StatusRect.size.height ///状态栏的高度

//  安全距离
#define SafeAreaTopHeight (kWindowH >= 812.0 ? 88 : 64)
#define SafeAreaBottomHeight (kWindowH >= 812.0 ? 34 : 0)
//  状态栏高度差
#define SafeAreaStateChaHeight (kWindowH >= 812.0 ? 24 : 0)
//  状态栏高度
#define SafeAreaStateHeight (kWindowH >= 812.0 ? 44 : 20)

#define kFont(size) [UIFont systemFontOfSize:(WScale(size))]

#pragma mark - UIColor宏定义
#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define UIColorFromRGB(rgbValue) UIColorFromRGBA(rgbValue, 1.0)

#define SeparatorCOLOR [UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1]
#define APPlineColor [UIColor colorWithRed:0.8235 green:0.8235 blue:0.8235 alpha:1.0]
#define FontBlackColor [UIColor colorWithRed:0.1444 green:0.1444 blue:0.1444 alpha:1.0]

////RGB取色值
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//十六进制取色值
#define HEXCOLOR(value)  [UIColor colorWithHexString:value]

#define NavColor  RGBCOLOR(255, 255, 255);

#define navTitleColor           HEXCOLOR(@"#464646")     //导航栏文字颜色(nomal)

#define TableColor UIColorFromRGB(0xf9f9f9)

#define ThemeColor HEXCOLOR(@"#DA3B31")

#define ClearColor [UIColor clearColor]

#define WhiteColor [UIColor whiteColor]

#define BlackColor UIColorFromRGB(0x404652)

#define LineColor RGBCOLOR(223, 223, 223)



#define tableview_HeadColor RGBCOLOR(232, 234, 237)
#define TableView_bgColor UIColorFromRGB(0xeeeeee)
///字体大小适配
#define ZF_FONT(__fontsize__) [UIFont systemFontOfSize:WScale(__fontsize__)]
//防止block里引用self造成循环引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


#define AvatarDefault @"userIcon"
#define Goods_noImage @"goods_noImage"
//主题色
#define COLOR_THEME HEXCOLOR(@"00a653")
//背景色
#define COLOR_BACK  HEXCOLOR(@"f6f6f6")
//字体大小
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]

//JPush AppKey
#define JPushAppKey @"43fb6b94cf80610f5c64f836"
//WX  Appid
#define WXAPPID @"wxc14ed73e78c6a8de"
//高德地图AppKey
#define AMapAppKey @"d78102d7d86913a14da7f92c2a7929e6"
//友盟AppKey
#define UMAppKey @"5cdb6979570df366af001031"
//BuglyKey
#define BuglyAppKey @"d1243abd-5b7b-4b31-9343-e9dce423b612"
//信鸽推送
#define XGPushKey @"I6G7ASJ43P1C"
#define XGPushAppId 2200319644

//当前屏幕大小
#define SCREEN_SIZE   [[UIScreen mainScreen] bounds].size
#define SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define SCREEN_NAV_HEIGHT ([[UIScreen mainScreen] bounds].size.height == 812.0 ? 88 : 64)
#define SCREEN_STATUSBAR_HEIGHT ([[UIScreen mainScreen] bounds].size.height == 812.0 ? 44 : 20)
#define SCREEN_BOTTOM_MARGIN ([[UIScreen mainScreen] bounds].size.height == 812.0 ? 34 : 0)

#define kInputViewHeight 50

#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

#define BUNDLE_ID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#define CLIENT_VERSION [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"]

#define APP_VERCODE_LIMIT 60

#define ACCOUNTINFO [AccountInfo shareRsp]

//==================支付宝支付===================
#define ALI_PARTNER                                  @"2016082401793923"
#define ALI_SELLTER                                  @"2018082861176594"
#define ALI_PRIVATE_KEY                           @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMVw0C9WBb6XLvlKuXn4qc60xMTAQscKG0itl8kLD7VjClTAA7XXhoB5tp8zw1uI8Lwki7YGAz/VF3vjmrShlwT+aL01rX+mEQd/5R2wyZPCJhcRa+IdJZ1DA8kbS2ZYw5aHtfJzKIbQ4k/a/ULYK/XGLlv2lO3ifEvqeUXHLT2RAgMBAAECgYB0U+yFB0TpL0Ag5xLytzytKjqIxdJSXTUIFCdK73Z443qRxnQpLmvzxEKB+EiQ5NUZtNqQC2jcshtdBhP/evlzkKr4jsfDY5c/pJKhqspWO0ZR6vyfswbwBqOlIevBeBdokmNg9sqXhP1J7x/AaZiump0Drviq6JeUfVYRfjh7xQJBAPcO4lelL3T2A2pziRyG+DAyX+dFWe24EUKRTRJZI64LmH2DlTSvgYeNZALqemPWGTnhrvoFdMxCEOmzYh7/2uMCQQDMljLfx9fS4/rL5X7uBABhVNQwMzQqvjSuqArTZ3DwGfHQzwhp14BM3C9QTvxKj1CYgER/478QSKnITXH3NKv7AkApG+/rt4/K/XiaCPmCpq67jlZI7FBHbv5oPjc921lFh6ZrFC8Koj2CabN/jLaq0CBIclYkQi4qIsAfsvqbv+UTAkBetlovB1F/LFP6+O/eOLQEW0UwW0QXVZ8GDH2WiRjbzucICBCZD08yRe0RfL+HtPlW4GrV2hWl8D3JoTDVhOjpAkEAoWK7c2CcU6PMUPanXng51KaFe2cOMYbv9r56VCSbt0gNlBRVDQy/pkW+V7qKNPZ0nmr+BzlaaK6kE7NfxJ7t+g=="

#define ALI_CALLBACK_URL                             @"http://121.40.216.91:8080/notify_url.jsp"
//==============================================

//判断是否大于ios几
#define IOS(a) ([[[UIDevice currentDevice] systemVersion] floatValue] >= a)
//屏幕尺寸
#define IS_iPhoneX        ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//iPhoneXMax
#define IS_iPhoneXMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
// 6P、6sP、7P、8P
#define IS_iPhone678_Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
// 6、6s、7、8
#define IS_iPhone678      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
// 5、5s
#define IS_iPhone5        ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
// 3g、4、4s
#define IS_iPhone34       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define LOGIN_SUCCESS_NOTIFICATION  @"LOGIN_SUCCESS_NOTIFICATION"
#define UPLOADMAINDATA_NOTIFICATION  @"UPLOADMAINDATA_NOTIFICATION"
#define UPLOADMIAOSHADATA_NOTIFICATION  @"UPLOADMIAOSHADATA_NOTIFICATION"
#define CATVIVWEND_NOTIFICATION  @"CATVIVWEND_NOTIFICATION"
#define CATDETALISEND_NOTIFICATION  @"CATDETALISEND_NOTIFICATION"

#define TOKEN_INVAILD_NOTIFICATION  @"TOKEN_INVAILD_NOTIFICATION"
#define SHOW_VOICE_NOTIFICATION  @"SHOW_VOICE_NOTIFICATION"

#define URL_WALLET_RULE @"http://app-files.qyueche.com/public/wallet_rule.html"
#define URL_PROTOCOL_RULE @"http://app-files.qyueche.com/public/service_protocol_rule.html"
#define URL_COUPON_RULE @"http://app-files.qyueche.com/public/coupon_rule.html"
#define URL_TICKET_RULE @"http://app-files.qyueche.com/public/buy_refund_rule.html"
#define URL_SERVICE_RULE @"https://kefu.qyueche.com"

#define URL_APP_CHECK @"https://itunes.apple.com/cn/app/%E4%B9%9D%E5%BC%9F%E6%99%BA%E9%80%89-%E5%BC%80%E5%90%AF%E6%99%BA%E6%85%A7%E7%94%9F%E6%B4%BB/id1463527939?mt=8"


#define TipPhone @"请输入正确的11位手机号"
#define Tip @"正在加载中"

#define TipFailure @"请再试一遍"
#define TipFailureDetail @"网络开小差了～"

#define TipFinish @"请输入完整信息"

#define APPDELEGATE ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#endif /* Constants_h */
