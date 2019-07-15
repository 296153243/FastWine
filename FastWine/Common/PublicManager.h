//
//  PublicManager.h
//  GuangYiGuang_App
//
//  Created by Zhuqing on 16/8/3.
//  Copyright © 2016年 Zhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuCityModel.h"

float HeightForString(NSString *value,float fontSize,float width);
float WidthForString(NSString *value,float fontSize,float height);

@interface PublicManager : NSObject

@property (strong, nonatomic) QuCityModel *selectCityModel;
@property (assign, nonatomic) BOOL isShowVoice;

+ (PublicManager *)shareManager;

//保存首页数据
+ (NSDictionary *)getMainDataFromLocal;
+ (void)saveMainDataToLocalWithDictionary:(NSDictionary *)dictionary;

//保存本地userId
+ (NSString *)getLocalUserId;
+ (void)saveUserUdToLocalWithId:(NSString *)userId;
+ (void)removelocalUserId;

//保存本地phone
+ (NSString *)getLocalPhone;
+ (void)saveUserUdToLocalWithPhone:(NSString *)phone;
+ (void)removelocalPhone;

//保存本地Token
+ (NSString *)getLocalToken;
+ (void)saveUserUdToLocalWithToken:(NSString *)token;
+ (void)removelocalToken;

//保存引导图version
+ (NSString *)getGuideVersionFromLocal;
+ (void)saveGuideVersionToLocalWithVersion:(NSString *)version;

//保存是否展示引导图
+ (BOOL)getShowGuideFromLocal;
+ (void)saveShowGuideToLocalWithShow:(BOOL)show;

//保存引导图链接
+ (NSArray *)getGuideImageArrayFromLocal;
+ (void)saveGuideImageArrayToLocalWithVersion:(NSArray *)array;

//保存版本升级提示日期
+ (NSString *)getVersionAlertDateFromLocal;
+ (void)saveVersionAlertDateToLocalWithDateString:(NSString *)dateString;
+ (void)removeVersionAlertDate;

//保存是否展示语音搜索
+ (NSString *)getShowVoiceSearchFromLocal;
+ (void)saveVoiceSearchToLocalWithShow:(NSString *)show;

//获取设备号
+ (NSString *)getDeviceId;

//判断是否是偶数
+ (BOOL)evenNumberWithNumber:(NSInteger)number;


/**
 *  警告提示框
 *
 *  @param message msg
 */
+(void)showAlert:(NSString *)message;
+(void)showAlert:(NSString *)message withDoneBlock:(void(^)(void))doneBlock;

//画虚线
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

//拨打电话
+ (void)callPhoneWithNumber:(NSString *)number;

//base64图片处理
+ (NSString *)base64ImageDataString:(UIImage *)photoImg;

+ (NSString *)getFullPinyinString:(NSString *)str;
+ (NSString *)getFirsrPingyinString:(NSString *)str;

+ (UIImage *)getMapArrowImage;

//条形码生成
+ (UIImage *)generateBarCode:(NSString *)code size:(CGSize)size color:(UIColor *)color backGroundColor:(UIColor *)backGroundColor;

+ (NSAttributedString *)getAttributedWithString:(NSString *)string WithLineSpace:(CGFloat)lineSpace kern:(CGFloat)kern font:(UIFont *)font;

+ (void)showMapNavSheetWithEndLat:(NSString *)lat lon:(NSString *)lon name:(NSString *)endName;

+ (void)makePhoneCallWithPhoneNumber:(NSString *)number;

//阿里云统计
+ (void)trackALCustomHitBuildWithEventLabel:(NSString *)label controller:(UIViewController *)controller;

@end
