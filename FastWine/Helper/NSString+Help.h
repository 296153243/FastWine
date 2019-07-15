//
//  NSString+Help.h
//  FreshFood
//
//  Created by Zhuqing on 2017/7/17.
//  Copyright © 2017年 FreshFood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (base64)

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;

- (NSString *)base64EncodedString;

@end

@interface NSString (Help)

- (NSDate *)swithStringToDate;
+ (NSString *)swithDateToString:(NSDate *)date;

+ (NSString *)swithDate:(NSDate *)date toFormatDate:(NSString *)format;
/**
 默认时间格式转化 原始格式 yyyy-MM-dd HH:mm:ss

 @param format 需转化的时间格式 如:yyyy年MM月dd日 HH:mm:ss
 @return string
 */
- (NSString *)timeIntervalDefaultFormatToFormatDate:(NSString *)format;

/**
 时间格式转化

 @param origalFormat 原始格式:  如yyyyMMddHHmmss
 @param format 需转化的时间格式 如:yyyy-MM-dd HH:mm:ss
 @return string
 */
- (NSString *)timeIntervalOrigalFormat:(NSString *)origalFormat toFormatDate:(NSString *)format;


/**
 时间戳转化    原始格式:时间戳

 @param format 需转化的时间格式 如:yyyy-MM-dd HH:mm:ss
 @return string
 */
- (NSString *)timeStampToFormatDate:(NSString *)format;

//转换成当前时刻
+ (NSString *)timeFormatted:(NSString  *)totalSeconds;
+ (NSString *)timeFormattedWithStr:(NSString  *)totalSecondsStr;
+ (long long)getZiFuChuan:(NSString*)time;



- (NSString *)replace:(NSString *)target withString:(NSString *)replacement;

/**
 md5加密
 */
- (NSString *)md5_32bit;

/**
 手机号码判断
 */
-(BOOL)isMobileNumber;

- (NSString *)priceStringWithUnit:(BOOL)unit;

- (NSString *)trim;
- (BOOL)contains:(NSString *)substring;

- (NSString *)base64EncodedString;
- (NSString *)base64DecodedString;

//判断是否为整形：
- (BOOL)isPureInt;
//判断是否为浮点形：
- (BOOL)isPureFloat;

- (BOOL)isValidateEmail;
//
- (CGFloat)calculateTextFont:(int)font textMaxWidth:(CGFloat)width;
- (NSInteger)countOccurencesOfString:(NSString*)searchString;
+ (NSString *)showPhoneNumberWithNumber:(NSString *)number;
+ (BOOL)judgeIsEmptyWithString:(NSString *)string;//判断字符串是否为空 NUll
+ (NSString *)decimalWithFormat:(NSString *)format floatV:(float)floatV;
//转Json字符串
+ (NSString *)UIUtilsFomateJsonWithDictionary:(NSDictionary *)dic;
//当前时间
+ (NSString *)getDateStr;
+ (void)pleaseInsertStarTimeo:(NSString *)time1 andInsertEndTime:(NSString *)time2;
+ (NSInteger)pleaseInsertStarTime:(NSString *)starTime andInsertEndTime:(NSString *)endTime;
+ (NSMutableAttributedString *)attributedStringWithColorTitle:(NSString *)title normalTitle:(NSString *)normalTitle frontTitle:(NSString *)frontTitle diffentColor:(UIColor *)color;
#pragma mark - 上下行间隔的文字
+ (NSMutableAttributedString *)attributedStringWithLineSpacing:(CGFloat)spacing paragrapString:(NSString *)title alignment:(NSTextAlignment)alignment;
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 计算高度
 
 @param fontSize 文字大小
 @param width 文字展示宽度
 @return 返回文字高度
 */
- (CGFloat)stringHeighFontSize:(CGFloat)fontSize width:(CGFloat)width;
//不同大小的文字
+ (NSMutableAttributedString *)attributedStringWithDifferentTitle:(NSString *)title normalTitle:(NSString *)normalTitle frontTitle:(NSString *)frontTitle diffentFont:(UIFont *)font;
//HTML适配图片文字
+ (NSString *)adaptWebViewForHtml:(NSString *) htmlStr;
//判断是否为空
+ (BOOL) isBlankString:(NSString *)string;//
//去掉转义字符\"
+ (NSString *)deletezhuanyiZifu:(NSString *)str;
//获取当日零点
+ (NSDate *)zeroOfDate:(NSDate *)date;
//字符串转为Date
+ (NSDate *)dateWithString:(NSString *)dateStr;

+ (CGFloat)calculateRowWidth:(NSString *)string withHeight:(NSInteger)height font:(NSInteger)font;
+ (NSString *)returndate:(NSNumber *)num;
+ (NSString *)encodeBase:(NSString *)string;///base64编码
+ (NSString *) getweekDayStringWithDate:(NSDate *) date;//获取今天周几
+ (NSArray *)getWeekTime;
/**
 两个时间相差多少天多少小时多少分多少秒
 
 @param startTime 开始时间
 @param endTime 结束时间
 @return 相差时间
 */
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;
+ (NSString *)dateTimeStartTime:(NSString *)startTime endTime:(NSString *)endTime;
@end
