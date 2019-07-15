//
//  NSString+Help.m
//  FreshFood
//
//  Created by Zhuqing on 2017/7/17.
//  Copyright © 2017年 FreshFood. All rights reserved.
//

#import "NSString+Help.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>



@implementation NSData (base64)

+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    const char lookup[] = {
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,  99,  99,  99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,  99,  99,  99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 62,  99,  99,  99, 63,
        52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 99, 99,  99,  99,  99, 99,
        99, 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10,  11,  12,  13, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 99,  99,  99,  99, 99,
        99, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36,  37,  38,  39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 99,  99,  99,  99, 99
    };
    
    NSData *inputData = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    long long inputLength = [inputData length];
    const unsigned char *inputBytes = [inputData bytes];
    
    long long maxOutputLength = (inputLength / 4 + 1) * 3;
    NSMutableData *outputData = [NSMutableData dataWithLength:(NSUInteger)maxOutputLength];
    unsigned char *outputBytes = (unsigned char *)[outputData mutableBytes];
    
    int accumulator = 0;
    long long outputLength = 0;
    unsigned char accumulated[] = { 0, 0, 0, 0 };
    
    for (long long i = 0; i < inputLength; i++)
    {
        unsigned char decoded = (unsigned char)lookup[inputBytes[i] & 0x7F];
        
        if (decoded != 99)
        {
            accumulated[accumulator] = decoded;
            
            if (accumulator == 3)
            {
                outputBytes[outputLength++] = (unsigned char)(accumulated[0] << 2) | (accumulated[1] >> 4);
                outputBytes[outputLength++] = (unsigned char)(accumulated[1] << 4) | (accumulated[2] >> 2);
                outputBytes[outputLength++] = (unsigned char)(accumulated[2] << 6) | accumulated[3];
            }
            
            accumulator = (accumulator + 1) % 4;
        }
    }
    
    //handle left-over data
    if (accumulator > 0) outputBytes[outputLength] = (unsigned char)(accumulated[0] << 2) | (accumulated[1] >> 4);
    
    if (accumulator > 1) outputBytes[++outputLength] = (unsigned char)(accumulated[1] << 4) | (accumulated[2] >> 2);
    
    if (accumulator > 2) outputLength++;
    
    //truncate data to match actual output length
    outputData.length = (NSUInteger)outputLength;
    return outputLength ? outputData : nil;
}

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    //ensure wrapWidth is a multiple of 4
    wrapWidth = (wrapWidth / 4) * 4;
    
    const char lookup[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    long long inputLength = [self length];
    const unsigned char *inputBytes = [self bytes];
    
    long long maxOutputLength = (inputLength / 3 + 1) * 4;
    maxOutputLength += wrapWidth ? (maxOutputLength / wrapWidth) * 2 : 0;
    unsigned char *outputBytes = (unsigned char *)malloc((size_t)maxOutputLength);
    
    long long i;
    long long outputLength = 0;
    
    for (i = 0; i < inputLength - 2; i += 3)
    {
        outputBytes[outputLength++] = (unsigned char)lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = (unsigned char)lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = (unsigned char)lookup[((inputBytes[i + 1] & 0x0F) << 2) | ((inputBytes[i + 2] & 0xC0) >> 6)];
        outputBytes[outputLength++] = (unsigned char)lookup[inputBytes[i + 2] & 0x3F];
        
        //add line break
        if (wrapWidth && (outputLength + 2) % (wrapWidth + 2) == 0)
        {
            outputBytes[outputLength++] = '\r';
            outputBytes[outputLength++] = '\n';
        }
    }
    
    //handle left-over data
    if (i == inputLength - 2)
    {
        // = terminator
        outputBytes[outputLength++] = (unsigned char)lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = (unsigned char)lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = (unsigned char)lookup[(inputBytes[i + 1] & 0x0F) << 2];
        outputBytes[outputLength++] =   '=';
    }
    else if (i == inputLength - 1)
    {
        // == terminator
        outputBytes[outputLength++] = (unsigned char)lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = (unsigned char)lookup[(inputBytes[i] & 0x03) << 4];
        outputBytes[outputLength++] = '=';
        outputBytes[outputLength++] = '=';
    }
    
    if (outputLength >= 4)
    {
        //truncate data to match actual output length
        outputBytes = realloc(outputBytes, (size_t)outputLength);
        return [[NSString alloc] initWithBytesNoCopy:outputBytes
                                              length:(size_t)outputLength
                                            encoding:NSASCIIStringEncoding
                                        freeWhenDone:YES];
    }
    else if (outputBytes)
    {
        free(outputBytes);
    }
    
    return nil;
}

- (NSString *)base64EncodedString
{
    return [self base64EncodedStringWithWrapWidth:0];
}

@end

@implementation NSString (Help)

- (NSDate *)swithStringToDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    return [formatter dateFromString:self];
}

+ (NSString *)swithDateToString:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    return [formatter stringFromDate:date];
}

+ (NSString *)swithDate:(NSDate *)date toFormatDate:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSDate *timeIntervalDate = date;
    [formatter setDateFormat:format];
    return [formatter stringFromDate:timeIntervalDate];
}

- (NSString *)timeIntervalDefaultFormatToFormatDate:(NSString *)format
{
    return  [self timeIntervalOrigalFormat:@"yyyyMMddHHmmss" toFormatDate:format];
}

- (NSString *)timeIntervalOrigalFormat:(NSString *)origalFormat toFormatDate:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:origalFormat];
    NSDate *timeIntervalDate = [formatter dateFromString:self];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:timeIntervalDate];
}

- (NSString *)timeStampToFormatDate:(NSString *)format
{
    if (self.length == 0 || self.length != 14) {
        return @"";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self longLongValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    NSString *dateStr = [formatter  stringFromDate:date];
    return dateStr;
    
}
+ (NSString *)timeFormatted:(NSString *)totalSeconds{
    NSString *stime;
    if ([totalSeconds isKindOfClass:[NSNumber class]]) {
        stime  = [NSString stringWithFormat:@"%@",totalSeconds];
    }else{
        stime = totalSeconds;
    }
    NSTimeInterval time = [[stime substringToIndex:10] doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate: detaildate];
    
}
+ (NSString *)timeFormattedWithStr:(NSString  *)totalSecondsStr{

    NSTimeInterval interval    =[totalSecondsStr doubleValue] / 1000.0;
    
    NSDate *date  = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
    
    NSString *dateString    = [formatter stringFromDate: date];
    
//    NSLog(@"时间戳对应的时间是:%@",dateString);
    
    return dateString;
    
}
+ (NSString *)returndate:(NSNumber *)num{
    
    NSString *str1=[NSString stringWithFormat:@"%@",num];
    if (num != nil) {
        int x=[[str1 substringToIndex:10] intValue];
        NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:x];NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];[dateformatter setDateFormat:@"yyyy-MM-dd hh:mm"];
//        NSLog(@"时间戳对应的时间是:%@",[dateformatter stringFromDate:date1]);
        
        return [dateformatter stringFromDate:date1];
    }
    return @"";
    
}


+ (long long)getZiFuChuan:(NSString*)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date1=[dateFormatter dateFromString:time];
    
    return [date1 timeIntervalSince1970]*1000;
    
}

- (NSString *)replace:(NSString *)target withString:(NSString *)replacement {
    return [self stringByReplacingOccurrencesOfString:target withString:replacement];
};

/*
 *@prama 价格规范化 以元为单位
 *unit YES:带¥符号 NO:不带
 */
- (NSString *)priceStringWithUnit:(BOOL)unit
{
    //    if (self.length == 0)
    //    {
    //        return @"";
    //    }
    CGFloat price = [self floatValue];
    if (unit)
    {
        return [NSString stringWithFormat:@"¥%.2f",price];
    }
    else
    {
        return [NSString stringWithFormat:@"%.2f",price];
    }
}


- (NSString *)md5_32bit {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)self.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

//手机号码判断
- (BOOL)isMobileNumber{
    /**
     * 移动号段正则表达式
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     * 联通号段正则表达式
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     * 电信号段正则表达式
     */
    NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:self];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    BOOL isMatch2 = [pred2 evaluateWithObject:self];
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    BOOL isMatch3 = [pred3 evaluateWithObject:self];
    
    if (isMatch1 || isMatch2 || isMatch3) {
        return YES;
    }else{
        return NO;
    }
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)contains:(NSString *)substring {
    NSRange range = [self rangeOfString:substring];
    return range.location != NSNotFound;
}

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    return [data base64EncodedStringWithWrapWidth:wrapWidth];
}

- (NSString *)base64EncodedString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    return [data base64EncodedString];
}

- (NSString *)base64DecodedString
{
    NSData *data = [NSData dataWithBase64EncodedString:self];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSData *)base64DecodedData
{
    return [NSData dataWithBase64EncodedString:self];
}


//判断是否为整形：
- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)isPureFloat
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

//邮箱正则表达式
- (BOOL)isValidateEmail
{
    
    if((0 != [self rangeOfString:@"@"].length) &&
       (0 != [self rangeOfString:@"."].length))
    {
        
        NSCharacterSet* tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        NSMutableCharacterSet* tmpInvalidMutableCharSet = [tmpInvalidCharSet mutableCopy] ;
        [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];
        
        //使用compare option 来设定比较规则，如
        //NSCaseInsensitiveSearch是不区分大小写
        //NSLiteralSearch 进行完全比较,区分大小写
        //NSNumericSearch 只比较定符串的个数，而不比较字符串的字面值
        NSRange range1 = [self rangeOfString:@"@"
                                     options:NSCaseInsensitiveSearch];
        
        //取得用户名部分
        NSString* userNameString = [self substringToIndex:range1.location];
        NSArray* userNameArray   = [userNameString componentsSeparatedByString:@"."];
        
        for(NSString* string in userNameArray)
        {
            NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet: tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length != 0 || [string isEqualToString:@""])
                return NO;
        }
        
        NSString *domainString = [self substringFromIndex:range1.location+1];
        NSArray *domainArray   = [domainString componentsSeparatedByString:@"."];
        
        for(NSString *string in domainArray)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        
        return YES;
    }
    else // no ''@'' or ''.'' present
        return NO;
    
}
- (CGFloat)calculateTextFont:(int)font textMaxWidth:(CGFloat)width {
    CGFloat noteH = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size.height+1;
    return noteH;
}
- (NSInteger)countOccurencesOfString:(NSString*)searchString {
    NSInteger strCount = [self length] - [[self stringByReplacingOccurrencesOfString:searchString withString:@""] length];
    return strCount / [searchString length];
}
+ (NSString *)showPhoneNumberWithNumber:(NSString *)number
{
    if (number.length > 7) {
        
        NSString *showNum = [number stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return showNum;
        
    }
    
    return number;
    
    
}
+ (BOOL)judgeIsEmptyWithString:(NSString *)string
{
    if (string.length == 0 || [string isEqualToString:@""] || string == nil || string == NULL || [string isEqual:[NSNull null]])
    {
        return YES;
    }
    return NO;
}

//格式话小数 四舍五入类型
+ (NSString *)decimalWithFormat:(NSString *)format floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}
+ (NSString *)UIUtilsFomateJsonWithDictionary:(NSDictionary *)dic {
    
    NSArray *keys = [dic allKeys];
    
    NSString *string = [NSString string];
    
    
    
    for (NSString *key in keys) {
        
        NSString *value = [dic objectForKey:key];
        
        
        
        value = [NSString stringWithFormat:@"\"%@\"",value];
        
        NSString *newkey = [NSString stringWithFormat:@"\"%@\"",key];
        
        
        
        
        
        if (!string.length) {
            
            string = [NSString stringWithFormat:@"%@:%@}",newkey,value];
            
        }else {
            
            string = [NSString stringWithFormat:@"%@:%@,%@",newkey,value,string];
            
        }
        
    }
    
    string = [NSString stringWithFormat:@"{%@",string];
    
    return string;
    
}
+(NSString *)getDateStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}
+ (void)pleaseInsertStarTimeo:(NSString *)time1 andInsertEndTime:(NSString *)time2{
    // 1.将时间转换为date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date1 = [formatter dateFromString:time1];
    NSDate *date2 = [NSDate date];
    // 2.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 3.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
    // 4.输出结果
    NSLog(@"两个时间相差%ld年%ld月%ld日%ld小时%ld分钟%ld秒", cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second);
}
+ (NSInteger)pleaseInsertStarTime:(NSString *)starTime andInsertEndTime:(NSString *)endTime{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//根据自己的需求定义格式
    NSDate* startDate = [formater dateFromString:starTime];
    NSDate* endDate = [NSDate date];
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    
    NSInteger timeee= time;
    
    return timeee;
}
#pragma mark - 自定义方法，不同颜色的字
+ (NSMutableAttributedString *)multableAttributeStr:(NSString *)str stringColor:(UIColor *)color
{
    NSMutableAttributedString *mulStr = [[NSMutableAttributedString alloc]initWithString:str];
    
    NSRange range = NSMakeRange(0, [mulStr length]);
    
    [mulStr setAttributes:@{NSForegroundColorAttributeName : color} range:range];
    
    return mulStr;
    
}
+ (NSMutableAttributedString *)attributedStringWithColorTitle:(NSString *)title normalTitle:(NSString *)normalTitle frontTitle:(NSString *)frontTitle diffentColor:(UIColor *)color
{
    NSAttributedString *frontStr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",frontTitle]];
    
    //OrangeColor
    NSMutableAttributedString *goodsNameStr = [self multableAttributeStr:[NSString stringWithFormat:@"%@",title] stringColor:color];
    
    NSAttributedString *secondTipsStr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",normalTitle]];
    
    NSMutableAttributedString *finishTipMulStr = [[NSMutableAttributedString alloc]init];
    
    [finishTipMulStr appendAttributedString:frontStr];
    
    [finishTipMulStr appendAttributedString:goodsNameStr];
    
    [finishTipMulStr appendAttributedString:secondTipsStr];
    
    return finishTipMulStr;
    
}
/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    text = text?:@"";
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
#pragma mark - 上下行间隔的文字
+ (NSMutableAttributedString *)attributedStringWithLineSpacing:(CGFloat)spacing paragrapString:(NSString *)title alignment:(NSTextAlignment)alignment
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];
    paragraphStyle.alignment = alignment;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [title length])];
    
    return attributedString;
}

- (CGFloat)stringHeighFontSize:(CGFloat)fontSize width:(CGFloat)width {
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.alignment = NSTextAlignmentJustified;
    CGFloat height = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:style} context:nil].size.height;
    return height;
}
//不同大小的文字
+ (NSMutableAttributedString *)attributedStringWithDifferentTitle:(NSString *)title normalTitle:(NSString *)normalTitle frontTitle:(NSString *)frontTitle diffentFont:(UIFont *)font
{
    
    NSMutableAttributedString*mulAttriStr =  [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@%@", frontTitle, title, normalTitle]];
    
    [mulAttriStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(frontTitle.length,title.length)];
    
    return mulAttriStr;
    
}
//HTML适配图片文字
+ (NSString *)adaptWebViewForHtml:(NSString *) htmlStr
{
    NSMutableString *headHtml = [[NSMutableString alloc] initWithCapacity:0];
    [headHtml appendString : @"<html>" ];
    
    [headHtml appendString : @"<head>" ];
    
    [headHtml appendString : @"<meta charset=\"utf-8\">" ];
    
    [headHtml appendString : @"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=false\" />" ];
    
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />" ];
    
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />" ];
    
    [headHtml appendString : @"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />" ];
    
    //适配图片宽度，让图片宽度等于屏幕宽度
    //[headHtml appendString : @"<style>img{width:100%;}</style>" ];
    //[headHtml appendString : @"<style>img{height:auto;}</style>" ];
    
    //适配图片宽度，让图片宽度最大等于屏幕宽度
    //    [headHtml appendString : @"<style>img{max-width:100%;width:auto;height:auto;}</style>"];
    
    
    //适配图片宽度，如果图片宽度超过手机屏幕宽度，就让图片宽度等于手机屏幕宽度，高度自适应，如果图片宽度小于屏幕宽度，就显示图片大小
    [headHtml appendString : @"<script type='text/javascript'>"
     "window.onload = function(){\n"
     "var maxwidth=document.body.clientWidth;\n" //屏幕宽度
     "for(i=0;i <document.images.length;i++){\n"
     "var myimg = document.images[i];\n"
     "if(myimg.width > maxwidth){\n"
     "myimg.style.width = '100%';\n"
     "myimg.style.height = 'auto'\n;"
     "}\n"
     "}\n"
     "}\n"
     "</script>\n"];
    
    [headHtml appendString : @"<style>table{width:100%;}</style>" ];
    [headHtml appendString : @"<title>webview</title>" ];
    NSString *bodyHtml;
    bodyHtml = [NSString stringWithString:headHtml];
    bodyHtml = [bodyHtml stringByAppendingString:htmlStr];
    return bodyHtml;
    
}
+ (BOOL) isBlankString:(NSString *)string {
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    if ([string isEqualToString:@""] || string == nil || string == NULL || [string isEqualToString :@"null" ]|| [string isEqualToString:@"<null>"]) {
        
        return YES;
        
    }
    
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        return YES;
        
    }
    
    return NO;
    
}
+ (NSDate *)zeroOfDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:date];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    // components.nanosecond = 0 not available in iOS
    NSTimeInterval ts = (double)(int)[[calendar dateFromComponents:components] timeIntervalSince1970];
    return [NSDate dateWithTimeIntervalSince1970:ts];
}
+ (NSDate *)dateWithString:(NSString *)dateStr{
    // 实例化NSDateFormatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置日期格式
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 设置为UTC时区
    // 这里如果不设置为UTC时区，会把要转换的时间字符串定为当前时区的时间（东八区）转换为UTC时区的时间
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    // 要转换的日期字符串
    
    NSDate *someDay = [formatter dateFromString:dateStr];
    return someDay;
}
+ (CGFloat)calculateRowWidth:(NSString *)string withHeight:(NSInteger)height font:(NSInteger)font {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};  //指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, height)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

+ (NSString *)encodeBase:(NSString *)string
{
    //先将string转换成data
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    
    NSString *baseString = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    
    return baseString;
}
+ (NSString *) getweekDayStringWithDate:(NSDate *) date{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 指定日历的算法
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:date];
    // 1 是周日，2是周一 3.以此类推
    NSNumber * weekNumber = @([comps weekday]);NSInteger weekInt = [weekNumber integerValue];NSString *weekDayString = @"1";switch (weekInt) {case 1:{weekDayString = @"7";}break;case 2:{weekDayString = @"1";}break;case 3:{weekDayString = @"2";}break;case 4:{weekDayString = @"3";}break;case 5:{weekDayString = @"4";}break;case 6:{weekDayString = @"5";}break;case 7:{weekDayString = @"6";}break;default:break;}return weekDayString;
    
}
// 获取当前周的周一和周日的时间
+ (NSArray *)getWeekTime
{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:nowDate];
    // 获取今天是周几
    NSInteger weekDay = [comp weekday];
    // 获取几天是几号
    NSInteger day = [comp day];
    // 计算当前日期和本周的星期一和星期天相差天数
    long firstDiff,lastDiff;
    // weekDay = 1;
    if (weekDay == 1)
    {
        firstDiff = -6;
        lastDiff = 1;
    }
    else
    {
        firstDiff = [calendar firstWeekday] - weekDay + 1;
        lastDiff = 8 - weekDay;
    }
    // NSLog(@"firstDiff: %ld lastDiff: %ld",firstDiff,lastDiff);
    // 在当前日期(去掉时分秒)基础上加上差的天
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:nowDate];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek = [calendar dateFromComponents:firstDayComp];
    NSDateComponents *lastDayComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:nowDate];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek = [calendar dateFromComponents:lastDayComp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    NSString *firstDay = [formatter stringFromDate:firstDayOfWeek];
    NSString *lastDay = [formatter stringFromDate:lastDayOfWeek];
    NSLog(@"%@=======%@",firstDay,lastDay);
    int firstValue = firstDay.intValue;
    int lastValue = lastDay.intValue;
    
    NSMutableArray *dateArr = [[NSMutableArray alloc]init];
    if (firstValue < lastValue) {
        
        for (int j = 0; j<7; j++) {
            NSString *obj = [NSString stringWithFormat:@"%d",firstValue+j];
            [dateArr addObject:obj];
        }
    }
    else if (firstValue > lastValue)
    {
        for (int j = 0; j < 7-lastValue; j++) {
            NSString *obj = [NSString stringWithFormat:@"%d",firstValue+j];
            [dateArr addObject:obj];
        }
        for (int z = 0; z<lastValue; z++) {
            
            NSString *obj = [NSString stringWithFormat:@"%d",z+1];
            [dateArr addObject:obj];
        }
    }
    
    return dateArr;
}
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime
{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startDate =[date dateFromString:startTime];
    NSDate *endDdate = [date dateFromString:endTime];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponents = [cal components:unitFlags fromDate:startDate toDate:endDdate options:0];
    
    // 天
    NSInteger day = [dateComponents day];
    // 小时
    NSInteger house = [dateComponents hour];
    // 分
    NSInteger minute = [dateComponents minute];
    // 秒
    NSInteger second = [dateComponents second];
    
    NSString *timeStr;
    NSString *longStr;
    if (day != 0) {
        timeStr = [NSString stringWithFormat:@"%zd天%zd小时%zd分%zd秒",day,house,minute,second];
    }
    else if (day==0 && house !=0) {
        timeStr = [NSString stringWithFormat:@"%zd小时%zd分%zd秒",house,minute,second];
    }
    else if (day==0 && house==0 && minute!=0) {
        timeStr = [NSString stringWithFormat:@"%zd分%zd秒",minute,second];
    }
    else{
        timeStr = [NSString stringWithFormat:@"%zd秒",second];
    }
    longStr = [NSString stringWithFormat:@"%zd,%zd,%zd,%zd,",day,house,minute,second];
    return longStr;
}

+ (NSString *)dateTimeStartTime:(NSString *)startTime endTime:(NSString *)endTime
{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startDate =[date dateFromString:startTime];
    NSDate *endDdate = [date dateFromString:endTime];
    
    NSTimeInterval startInterval = [startDate timeIntervalSince1970]*1;
    NSTimeInterval endInterval = [endDdate timeIntervalSince1970]*1;
    NSTimeInterval value = endInterval - startInterval;
    
    // 天
    int day = (int)value / (24 *3600);
    // 小时
    int house = (int)value / (24 *3600)%3600;
    // 分
    int minute = (int)value /60%60;
    // 秒
    int second = (int)value %60;
    
    NSString *timeStr;
    
    if (day != 0) {
        timeStr = [NSString stringWithFormat:@"距结束%d小时%d分%d秒",house,minute,second];
    }
    else if (day==0 && house !=0) {
        timeStr = [NSString stringWithFormat:@"距结束%d小时%d分%d秒",house,minute,second];
    }
    else if (day==0 && house==0 && minute!=0) {
        timeStr = [NSString stringWithFormat:@"距结束%d分%d秒",minute,second];
    }
    else{
        timeStr = [NSString stringWithFormat:@"距结束%d秒",second];
    }
    
    return timeStr;
}


@end

