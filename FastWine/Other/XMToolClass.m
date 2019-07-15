//
//  XMToolClass.m
//  NDBaseProject
//
//  Created by WenhuaLuo on  2017/1/18.
//  Copyright © 2017年 WenhuaLuo. All rights reserved.
//

#import "XMToolClass.h"
#import <sys/sysctl.h>
#import <CommonCrypto/CommonDigest.h>


@interface XMToolClass ()
@property (nonatomic, strong) UIView *netTipView;
@end
static XMToolClass *_instance;
@implementation XMToolClass{
    BOOL showMess;
    UIView *tipView;
}
//初始化
+ (void)initialize {
    _instance = [XMToolClass new];
}


//登录
+ (void)tipLoginFromController:(UIViewController *)showController
{
//    [showController.navigationController pushViewController:[PALoginViewController new] animated:NO];
}

#pragma mark - *******************************  拍照  *******************************
+ (void) snapImageWithDelegate:(id)delegate andParentVC:(UIViewController *)VC
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        __block UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = delegate;
        picker.allowsEditing = YES;
        [VC presentViewController:picker animated:YES completion:^{
            picker = nil;
        }];
    } else {
        NSLog(@"模拟器无法打开照相机");
    }
}

#define CommonThimeColor HEXCOLOR(0x11a0ee)
+ (void)localPhotoWithDelegate:(id)delegate andParentVC:(UIViewController *)VC
{
    __block UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = delegate;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    //修改了整个navigationbar的颜色
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarStyle:UIBarStyleBlack];
    //改样式背景
    [navBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    //隐藏导航线
    navBar.shadowImage = [[UIImage alloc]init];
    
    [picker.navigationBar setBarTintColor:[UIColor greenColor]];
    
    [picker.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIFont systemFontOfSize:15]}];
    
    //[picker.navigationBar setTintColor:[UIFont systemFontOfSize:15]];
    
    picker.navigationBar.translucent = NO;
    
    [VC presentViewController:picker animated:YES completion:^{
        picker = nil;
    }];
}


#pragma mark - md5加密
+(NSString *)md5:(NSString *)str{
    
    const char *cStr = [str UTF8String];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, (int)strlen(cStr), digest );
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
    
    
}

#define Salt @"QWEKEV224$%^@#%(()))"
+ (NSString *)formatStr:(NSString *)str withNum:(NSInteger)num withCarakter:(NSString *)carakter fromDist:(NSInteger )dist{
    NSMutableString * changeStr = [NSMutableString stringWithString:[XMToolClass formatStr:str deleteCarakter:@" " withDStr:@""]];
    NSInteger index = changeStr.length / num;
    NSInteger startInt = changeStr.length % num;
    if (startInt == 0) {
        for (int i= 0; i < index - 1; i++) {
            [changeStr insertString:carakter atIndex:num + (num + 1) * i];
        }
    }else {
        for (int i= 0; i < index; i++) {
            if (dist == 0) {
                [changeStr insertString:carakter atIndex:startInt  + (num + 1) * i];
            }else {
                [changeStr insertString:carakter atIndex:num + (num + 1) * i];
            }
        }
    }
    return changeStr.copy;
}

+ (NSString *)formatStr:(NSString *)str deleteCarakter:(NSString *)carakter withDStr:(NSString *)dStr{
    return [str stringByReplacingOccurrencesOfString:carakter  withString:dStr];
}





+ (NSString *)encryptPassword:(NSString *)originalPassword{
    //1.直接MD5
    //NSString *encryptPassword = [originalPassword md5String];
    
    //2.加点盐  zhang123
    //NSString *encryptPassword = [[originalPassword stringByAppendingString:Salt] md5String];
    //NSLog(@"%@",[originalPassword md5String]);
    //3.多次MD5
    //NSString *encryptPassword = [[originalPassword md5String] md5String];
    
    //4.先MD5,再有规范的乱序
    // zhang  d0cd2693b3506677e4c55e91d6365bff
    
    // cd2693b3506677e4c55e91d6365bffd0
    NSString *md5Pwd = [originalPassword md5_32bit];
    
    NSString *headerStr = [md5Pwd substringToIndex:2];
    NSString *footerStr = [md5Pwd substringFromIndex:2];
    
    NSString *encryptPassword = [footerStr stringByAppendingString:headerStr];
    
    return encryptPassword;
}
//富文本
+ (NSAttributedString *)getAttributeStr:(NSString *)oilStr andRange:(NSRange )range andColor:(UIColor*)corlor andFont:(NSInteger)fontSize{
    NSMutableAttributedString *attributedStr1 = [[NSMutableAttributedString alloc]initWithString:oilStr];
    [attributedStr1 addAttribute:NSForegroundColorAttributeName
                           value:corlor
                           range:range];
    [attributedStr1 addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:15]
                           range:range];
    return attributedStr1;
}
//获得当前 年、月、日、时、分、秒
+ (NSDateComponents *)getDateComponents {
    /*
     时间获取  年月日时分秒
     Calendar Year: 2015
     Month: 9
     Leap month: no
     Day: 12
     Hour: 2
     Minute: 29
     Second: 12
     Weekday: 7
     **/
    NSDate *datenow = [NSDate date];//现在时间
    NSTimeZone *zone = [NSTimeZone systemTimeZone];//取到系统所在地时间差
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];//当前当地时间
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [gregorian components:unitFlags fromDate:localeDate];
    
    //    NSInteger year = [comps year];
    //    NSInteger month = [comps month];
    //    NSInteger day = [comps day];
    //    NSInteger week = [comps weekday];
    //    NSInteger hour = [comps hour];
    //    NSInteger minute = [comps minute];
    //    NSInteger second = [comps second];
    
    return comps;
}

//得到现在时间戳
+ (NSString *)getTimeStamp {
    /*
     时间date转时间戳
     
    NSDate *datenow = [NSDate date];//现在时间
    NSString *timeSp = [NSString stringWithFormat:@"%.0f", [datenow timeIntervalSince1970]];//date转时间戳
    //    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    return timeSp;
    **/
    NSDate *date = [NSDate date];
    NSTimeInterval interval = [date timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f", interval];
    return timeSp;
}


+ (AFHTTPSessionManager *)httpRequestInit
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //返回类型
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain",@"application/x-javascript",@"image/png",@"text/html",@"application/x-javascript",@"application/javascript", @"json/text", nil];
    //请求时间
    manager.requestSerializer.timeoutInterval= 30;
    
    
    AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy = securityPolicy;
    
    return manager;
}


//把NSDictionary解析成post格式的NSString字符串
+ (NSDictionary *)parseParams:(NSDictionary *)params{
    
    NSMutableDictionary *parameters= [NSMutableDictionary new];
    [parameters  setDictionary:params];
    
    [parameters setValue:[XMToolClass getTimeStamp] forKey:@"timestamp"];
    
    NSString *keyValueFormat;
    
    NSMutableString *result = [NSMutableString new];
    
    NSArray *keyArray = [parameters allKeys];
    
    //按顺序排序
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];

    for (NSString *key in sortArray) {
        
        keyValueFormat = [NSString stringWithFormat:@"%@=%@&",key,[parameters valueForKey:key]];
        [result appendString:keyValueFormat];
    }
    
    
    NSString *resultStr = [NSString stringWithFormat:@"%@nado",result];
    
    [parameters setValue:[XMToolClass  md5:resultStr] forKey:@"sig"];
    
    return parameters;
}

//NSString *sigstr = [NSString stringWithFormat:@"memberId=%@&timestamp=%@&nado", [Save memberID], [XMToolClass getTimeStamp]];
//
////传入的参数
//NSDictionary *parameters =
//@{
//  @"memberId":[Save memberID],
//  @"timestamp":[XMToolClass getTimeStamp],
//  @"sig":[XMToolClass  md5:sigstr],
//  };

//时间戳转化为格式时间
+ (NSString *)getFormateTime:(NSString *)timeStamp isSecondDegree:(BOOL)isSecondDegree timeFormat:(NSInteger)timeFormat {
    NSString *str = timeStamp;//时间戳
    NSTimeInterval time;
    NSString *timeType;
    /*
     时间戳转date
     **/
    if (timeStamp == nil) {
        str = [XMToolClass getTimeStamp];
        time = [str doubleValue];
    }else{
        if (isSecondDegree == NO) {
            time = [str doubleValue] / 1000.00;
        }else{
            time = [str doubleValue];
        }
    }
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:time];//时间戳转date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    switch (timeFormat) {
        case 0:
            timeType =@"yyyy-MM-dd HH:mm:ss";
            break;
        case 1:
            timeType =@"MM-dd-HH:mm";
            break;
        case 2:
            timeType = @"yyyy-MM-dd";
            break;
        case 3:
            timeType = @"yyyyMMddHHmmss";
            break;
        default: timeType =@"yyyy-MM-dd-HH:mm:ss";
            break;
    }
    [dateFormatter setDateFormat:timeType];
    NSString *currentDateStr = [dateFormatter stringFromDate:currentDate];
    
    return currentDateStr;
}


//时间戳转化为格式时间-如：今天 2:00、昨天 16：00
+ (NSString *)getFormateStringTime:(NSString *)timeStamp {
    NSTimeInterval time = [timeStamp doubleValue] - 28800 ;//减8小时 == 28800 sec,上面已经[localeDate timeIntervalSince1970]了，所以要减掉
    //    NSTimeInterval time = [timeStamp doubleValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *formatterT = [[NSDateFormatter alloc] init];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    [formatter setDateFormat:@"yy-MM-dd HH:mm"];
    NSDate *confromTimespT = [NSDate dateWithTimeIntervalSince1970:time];
    [formatterT setDateFormat:@"HH:mm"];
    NSDate *startDate = confromTimesp;
    NSDate *endDate = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay | kCFCalendarUnitHour | kCFCalendarUnitMinute |kCFCalendarUnitSecond | kCFCalendarUnitWeekday | kCFCalendarUnitWeekday;
    NSDateComponents *endDateComponents = [cal components:unitFlags fromDate:endDate];
    NSDateComponents *startDateComponents = [cal components:unitFlags fromDate:startDate];
    
    NSInteger y_endDate = [endDateComponents year];
    int64_t y_startDate = [startDateComponents year];
    
    NSInteger m_endDate = [endDateComponents month];
    int64_t m_startDate = [startDateComponents month];
    
    NSInteger d_endDate = [endDateComponents day];
    int64_t d_startDate = [startDateComponents day];
    
    NSString *confromTimespStr =nil;
    if (d_endDate - d_startDate == 0 && y_endDate - y_startDate == 0 && m_endDate - m_startDate == 0)
        confromTimespStr =[NSString stringWithFormat:@"今天 %@",[formatterT stringFromDate:confromTimespT]] ;
    else if (d_endDate - d_startDate == 1 && y_endDate - y_startDate == 0 && m_endDate - m_startDate == 0)
        confromTimespStr =[NSString stringWithFormat:@"昨天 %@",[formatterT stringFromDate:confromTimespT]] ;
    else if (d_endDate - d_startDate == 2 && y_endDate - y_startDate == 0 && m_endDate - m_startDate == 0)
        confromTimespStr =[NSString stringWithFormat:@"前天 %@",[formatterT stringFromDate:confromTimespT]] ;
    else
        confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}


+ (NSString *)formaterTime:(NSString *)originTime withFormatter:(NSString *)formatterStr {
    // 格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:originTime];
    
    formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:formatterStr];
    
    return [formatter stringFromDate:date];
}

//获得设备型号
+ (NSString *)getCurrentDeviceModel {
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"Simulator";
    
    return platform;
}

//手机序列号 唯一标示 UUID
+ (NSString *)getUUID {
    /**
     *  随机值
     */
    //    CFUUIDRef puuid = CFUUIDCreate( nil );
    //    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    //    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    //    return result;
    /**
     *  返回没有横线的uuid
     */
    NSUUID *UUID = [[UIDevice currentDevice] identifierForVendor];
    return [[UUID UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    /**
     *  返回有横线的uuid
     */
    //    NSUUID *UUID = [[UIDevice currentDevice] identifierForVendor];
    //    return [UUID UUIDString];
}
//手机别名： 用户定义的名称
+ (NSString *)getPhoneName {
    return [[UIDevice currentDevice] name];
}
//手机系统版本
+ (NSString *)getIOSVersion {
    return [[UIDevice currentDevice] systemVersion];
}
/**
 *  @author 郑兆远, 16-03-17 18:03:03
 *
 *  判断手机号码是否有效
 *
 *  @param NSString 手机号码
 *
 *  @return 是否是正确的手机号码
 *
 *  @since 1
 */

//验证邮箱格式
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

//+ (void)tokenIvalid  {
//    //token失效之后登录状态失效
//    [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
//            NSLog(@"%zd,%@,%@",iResCode,iTags,iAlias);
//     }];
//    NSString *tip = @"您的账号已在异地登陆。如果这不是你的操作，你的账号密码已经泄露。请尽快登陆账号修改密码，或拨打客服电话400-828-9522";
//    LBMAlertView *accountAl = [[LBMAlertView alloc]initWithMessage:nil buttonTitle1:@"取消" buttonTitle2:@"重新登录"];
//    accountAl.titleLabel.attributedText = [XKToolClass getAttributeStr:tip andRange:NSMakeRange(tip.length -12, 12) andColor:FONT_COLOR_GREEN andFont:15];
//    [accountAl showWithCompletion:^(LBMAlertView *alertView, NSInteger selectIndex) {
//        if (selectIndex == 2) {
//            UIViewController *VC= [UIApplication sharedApplication].keyWindow.rootViewController;
//            LBMZCViewController *zcVC = [[LBMZCViewController alloc]init];
//            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:zcVC];
//            //设置呈透明
//            nav.navigationBar.translucent = YES;
//            [nav.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
//            nav.navigationBar.shadowImage = [[UIImage alloc]init];
//            [nav.navigationBar setBarTintColor:[UIColor whiteColor]];
//            [nav.navigationBar setBarStyle:UIBarStyleBlack];
//            [VC presentViewController:nav animated:YES completion:nil];
//        }
//    }];
//     }


//归档路径
+ (NSString *)getKeyedAchievePath {
    NSString *filepath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
    NSString *path = [filepath stringByAppendingPathComponent:@"user.data"];
    return path;
}
- (void)dealloc {
    //[super dealloc];  非ARC中需要调用此句
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//NSKeyedArchiver归档
+ (void)saveKeyedAchievePathName:(NSString *)name object:(id)object{
    NSString *filepath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
    NSString *path = [filepath stringByAppendingPathComponent:name];
    BOOL flag = [NSKeyedArchiver archiveRootObject:object toFile:path];//归档一个字符串
    if (flag == YES) {
        NSLog(@"归档成功%@",[NSKeyedUnarchiver unarchiveObjectWithFile:path]);
    }
}
//NSKeyedUnarchiver解档
+ (id)getKeyedAchievePathName:(NSString *)name {
    NSString *filepath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
    NSString *path = [filepath stringByAppendingPathComponent:name];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}
//16进制颜色(html颜色值)字符串转为UIColor
+(UIColor *)getColorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha {
    //删除字符串中的空格
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor blackColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor blackColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
    
}

//默认alpha值为1
+ (UIColor *)getColorWithHexString:(NSString *)stringToConvert {
    return [self getColorWithHexString:stringToConvert alpha:1.0f];
}
//从颜色获得图片
+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
//渐变色
+ (UIColor *)getGradientRed:(CGFloat)a green:(CGFloat)b blue:(CGFloat)c alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((10 * a) / 255.0) green:((20 * b)/255.0) blue:((30 * c)/255.0) alpha:alpha];
}

//随机色
+ (UIColor *)getRandomColorAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:arc4random() % 256 / 255.0 green: arc4random() % 256 / 255.0 blue: arc4random() % 256 / 255.0 alpha:alpha];
}

//版本号
+ (NSString *)getVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

//内部版本号
+ (NSString *)getBundleVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

//APP 名称
+ (NSString *)getAPPName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[0-9]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
//整数验证
+ (BOOL)isPureInt:(NSString*)string{
    NSString *phoneRegex = @"^\\d*$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:string];
    
}
//固定电话验证
+ (BOOL) validateTel:(NSString *)mobile
{
    NSString *phoneRegex = @"^([0-9]{3,4}-)?[0-9]{7,8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//手机号码或固定电话验证
+ (BOOL) validateMobileAndTel:(NSString *)mobile
{
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    [mobile stringByReplacingOccurrencesOfString:@"" withString:@"-"];
    NSString *phoneRegex = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    NSString *phoneRegex1 = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[0-9]|18[0-9]|14[0-9])[0-9]{8}$";
    NSPredicate *phoneTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex1];
    return ([phoneTest evaluateWithObject:mobile] || [phoneTest1 evaluateWithObject:mobile]);
}

//车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[警京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼]{0,1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}

//车型
+ (BOOL) validateCarType:(NSString *)CarType
{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:CarType];
}

//用户名
+ (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}

//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

//昵称
+ (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//车架号
+ (BOOL) validateCarJiaCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^\\w{9}$|^\\w{17}$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//发动机号
+ (BOOL) validateCarEngiNO: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^\\w{7}$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//打电话
+ (void)getOpenTelphone: (NSString *)phoneNumber {
    // 直接拨号，拨号完成后会停留在通话记录中
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]];
    [[UIApplication sharedApplication] openURL:url];
}
//发短息
+ (void)getOpenMSG: (NSString *)MSGphoneNumber {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",MSGphoneNumber]];
    [[UIApplication sharedApplication] openURL:url];
}
//转为UTF-8字符串
+(NSString *)getUTF8String:(NSString *)string {
    NSString *utf8String = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return utf8String;
}
+ (BOOL)checkCardNo:(NSString*)cardNo{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}
+ (NSString *)insertSpacesEveryFourDigitsIntoString:(NSNumber *)num value:(int)value
{
    NSString *string = [NSString stringWithFormat:@"%@",num];
    if (string.length > 3) {
        NSMutableString *stringWithAddedSpaces = [NSMutableString new];
        for (NSUInteger i = 0; i < [string length]; i++) {
            if ((i > 0) && ((i % value) == 0)) {
                [stringWithAddedSpaces appendString:@" "];
            }
            unichar     characterToAdd = [string characterAtIndex:[string length]-1-i];
            NSString    *stringToAdd =
            [NSString stringWithCharacters:&characterToAdd length:1];
            [stringWithAddedSpaces appendString:stringToAdd];
        }
        NSMutableString * reverseString = [NSMutableString string];
        for(int i = 0 ; i < stringWithAddedSpaces.length; i ++){
            //倒序读取字符并且存到可变数组数组中
            unichar c = [stringWithAddedSpaces characterAtIndex:stringWithAddedSpaces.length- i -1];
            [reverseString appendFormat:@"%c",c];
        }
        return reverseString;
    }else{
        return string;
    }
}


+ (void)saveMessage:(id)message StrKeyWithStr:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:message forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (id)getMessage:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
//  存储 自定义内容
+ (void)saveMessageStr:(NSString *)message StrKeyWithStr:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:message forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//  存储 自定义内容
+ (void)saveMessagedata:(id)messagedata dataKeyWithStr:(NSString *)key {
    //不能直接存取NSObject，需要先归档转成NSData
    NSData * data  = [NSKeyedArchiver archivedDataWithRootObject:messagedata];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
// 获取 自定义MessageStr
+ (NSString *)getMessageStrKeyWithStr:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
// 获取 自定义Messagedata
+ (NSData *)getMessagedataKeyWithStr:(NSString *)key {
    NSData * data = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}
//m ~ n 随机数
+ (NSInteger)getRandomNumberBegin:(NSInteger)beginNumber end:(NSInteger)endNumber {
    //获取一个随机整数，范围在[beginNumber,endNumber），包括beginNumber，不包括endNumber
    return beginNumber + arc4random() % (endNumber - beginNumber + 1);
}
//计算中英文字符长度
+ (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}
/**
 * 传入天气名称返回固定的类型名称
 */
+ (NSString *)getWeatherIcon:(NSString*)name{
    if ([name rangeOfString:@"雨"].location != NSNotFound) {
        return @"雨";
    }
    if ([name rangeOfString:@"阴"].location != NSNotFound) {
        return @"阴";
    }
    if ([name rangeOfString:@"雪"].location != NSNotFound) {
        return @"雪";
    }
    if ([name rangeOfString:@"晴"].location != NSNotFound) {
        return @"晴";
    }
    if ([name rangeOfString:@"多云"].location != NSNotFound) {
        return @"多云";
    }
    return @"晴";
}
/**
 * 传入银行名字返回银行类型图片名字
 */
+ (NSString *)getBnakIcon:(NSString*)bankType{
    if ([bankType rangeOfString:@"建设银行"].location != NSNotFound) {
        return @"中国建设银行";
    }
    if ([bankType rangeOfString:@"苏州银行"].location != NSNotFound) {
        return @"苏州银行";
    }
    if ([bankType rangeOfString:@"邮政储蓄银行"].location != NSNotFound || [bankType rangeOfString:@"邮储银行"].location != NSNotFound) {
        return @"中国邮政银行";
    }
    if ([bankType rangeOfString:@"工商银行"].location != NSNotFound) {
        return @"中国工商银行";
    }
    if ([bankType rangeOfString:@"农业银行"].location != NSNotFound) {
        return @"中国农业银行";
    }
    if ([bankType rangeOfString:@"中国银行"].location != NSNotFound) {
        return @"中国银行";
    }
    if ([bankType rangeOfString:@"交通银行"].location != NSNotFound) {
        return @"中国交通银行";
    }
    if ([bankType rangeOfString:@"中信银行"].location != NSNotFound) {
        return @"中信银行";
    }if ([bankType rangeOfString:@"光大银行"].location != NSNotFound) {
        return @"中国光大银行";
    }if ([bankType rangeOfString:@"华夏银行"].location != NSNotFound) {
        return @"中国华夏银行";
    }
    if ([bankType rangeOfString:@"民生银行"].location != NSNotFound) {
        return @"中国民生银行";
    }
    if ([bankType rangeOfString:@"招商银行"].location != NSNotFound) {
        return @"中国招商银行";
    }
    if ([bankType rangeOfString:@"兴业银行"].location != NSNotFound) {
        return @"中国兴业银行";
    }
    if ([bankType rangeOfString:@"浦东发展银行"].location != NSNotFound) {
        return @"中国浦发银行";
    }
    if ([bankType rangeOfString:@"南京银行"].location != NSNotFound) {
        return @"南京银行";
    }
    if ([bankType rangeOfString:@"北京银行"].location != NSNotFound) {
        return @"北京银行";
    }
    if ([bankType rangeOfString:@"江苏银行"].location != NSNotFound) {
        return @"江苏银行";
    }
    else{
        return @"银联";
    }
}

+(NSMutableAttributedString *)checkStar:(NSString *)title{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:title];
    NSRange starRange = [title rangeOfString:@"*"];
    if (starRange.location != NSNotFound) {
        [attr addAttribute:NSForegroundColorAttributeName value:[XMToolClass getColorWithHexString:@"f44336"] range:starRange];
    }
    return attr;
}


+(NSString *)removeStar:(NSString *)title{
    NSString *str = title;
    NSRange starRange = [title rangeOfString:@"*"];
    if (starRange.location != NSNotFound) {
        str = [title substringFromIndex:starRange.location+1];
    }
    return str;
}


//随机取百家姓
+ (NSString *)getFamilyNames {
    NSArray *arr = @[@"赵",@"钱",@"孙",@"李",@"周",@"吴",@"郑",@"王",@"冯",@"陈",@"褚",@"卫",@"蒋",@"沈",@"韩",@"杨",@"朱",@"秦",@"尤",@"许",@"何",@"吕",@"施",@"张",@"孔",@"曹",@"严",@"华",@"金",@"魏",@"陶",@"姜",@"戚",@"谢",@"邹",@"喻",@"柏",@"水",@"窦",@"章",@"云",@"苏",@"潘",@"葛",@"奚",@"范",@"彭",@"郎",@"鲁",@"韦",@"昌",@"马",@"苗",@"凤",@"花",@"方",@"俞",@"任",@"袁",@"柳",@"酆",@"鲍",@"史",@"唐",@"费",@"廉",@"岑",@"薛",@"雷",@"贺",@"倪",@"汤",@"滕",@"殷",@"罗",@"毕",@"郝",@"邬",@"安",@"常",@"乐",@"于",@"时",@"傅",@"皮",@"卞",@"齐",@"康",@"伍",@"余",@"元",@"卜",@"顾",@"孟",@"平",@"黄",@"和",@"穆",@"萧",@"尹",@"姚",@"邵",@"湛",@"汪",@"祁",@"毛",@"禹",@"狄",@"米",@"贝",@"明",@"臧",@"计",@"伏",@"成",@"戴",@"谈",@"宋",@"茅",@"庞",@"熊",@"纪",@"舒",@"屈",@"项",@"祝",@"董",@"梁",@"杜",@"阮",@"蓝",@"闵",@"席",@"季",@"麻",@"强",@"贾",@"路",@"娄",@"危",@"江",@"童",@"颜",@"郭",@"梅",@"盛",@"林",@"刁",@"钟",@"徐",@"邱",@"骆",@"高",@"夏",@"蔡",@"田",@"樊",@"胡",@"凌",@"霍",@"虞",@"万",@"支",@"柯",@"昝",@"管",@"卢",@"莫",@"经",@"房",@"裘",@"缪",@"干",@"解",@"应",@"宗",@"丁",@"宣",@"贲",@"邓",@"郁",@"单",@"杭",@"洪",@"包",@"诸",@"左",@"石",@"崔",@"吉",@"钮",@"龚",@"程",@"嵇",@"邢",@"滑",@"裴",@"陆",@"荣",@"翁",@"荀",@"羊",@"于",@"惠",@"甄",@"曲",@"家",@"封",@"芮",@"羿",@"储",@"靳",@"汲",@"邴",@"糜",@"松",@"井",@"段",@"富",@"巫",@"乌",@"焦",@"巴",@"弓",@"牧",@"隗",@"山",@"谷",@"车",@"侯",@"宓",@"蓬",@"全",@"郗",@"班",@"仰",@"秋",@"仲",@"伊",@"宫",@"宁",@"仇",@"栾",@"暴",@"甘",@"钭",@"厉",@"戎",@"祖",@"武",@"符",@"刘",@"景",@"詹",@"束",@"龙",@"叶",@"幸",@"司",@"韶",@"郜",@"黎",@"蓟",@"溥",@"印",@"宿",@"白",@"怀",@"蒲",@"邰",@"从",@"鄂",@"索",@"咸",@"籍",@"赖",@"卓",@"蔺",@"屠",@"蒙",@"池",@"乔",@"阴",@"郁",@"胥",@"能",@"苍",@"双",@"闻",@"莘",@"党",@"翟",@"谭",@"贡",@"劳",@"逄",@"姬",@"申",@"扶",@"堵",@"冉",@"宰",@"郦",@"雍",@"却",@"璩",@"桑",@"桂",@"濮",@"牛",@"寿",@"通",@"边",@"扈",@"燕",@"冀",@"浦",@"尚",@"农",@"温",@"别",@"庄",@"晏",@"柴",@"瞿",@"阎",@"充",@"慕",@"连",@"茹",@"习",@"宦",@"艾",@"鱼",@"容",@"向",@"古",@"易",@"慎",@"戈",@"廖",@"庾",@"终",@"暨",@"居",@"衡",@"步",@"都",@"耿",@"满",@"弘",@"匡",@"国",@"文",@"寇",@"广",@"禄",@"阙",@"东",@"欧",@"殳",@"沃",@"利",@"蔚",@"越",@"夔",@"隆",@"师",@"巩",@"厍",@"聂",@"晁",@"勾",@"敖",@"融",@"冷",@"訾",@"辛",@"阚",@"那",@"简",@"饶",@"空",@"曾",@"毋",@"沙",@"乜",@"养",@"鞠",@"须",@"丰",@"巢",@"关",@"蒯",@"相",@"查",@"后",@"荆",@"红",@"游",@"郏",@"竺",@"权",@"逯",@"盖",@"益",@"桓",@"公",@"仉",@"督",@"岳",@"帅",@"缑",@"亢",@"况",@"郈",@"有",@"琴",@"归",@"海",@"晋",@"楚",@"闫",@"法",@"汝",@"鄢",@"涂",@"钦",@"商",@"牟",@"佘",@"佴",@"伯",@"赏",@"墨",@"哈",@"谯",@"篁",@"年",@"爱",@"阳",@"佟",@"言",@"福",@"南",@"火",@"铁",@"迟",@"漆",@"官",@"冼",@"真",@"展",@"繁",@"檀",@"祭",@"密",@"敬",@"揭",@"舜",@"楼",@"疏",@"冒",@"浑",@"挚",@"胶",@"随",@"高",@"皋",@"原",@"种",@"练",@"弥",@"仓",@"眭",@"蹇",@"覃",@"阿",@"门",@"恽",@"来",@"綦",@"召",@"仪",@"风",@"介",@"巨",@"木",@"京",@"狐",@"郇",@"虎",@"枚",@"抗",@"达",@"杞",@"苌",@"折",@"麦",@"庆",@"过",@"竹",@"端",@"鲜",@"皇",@"亓",@"老",@"是",@"秘",@"畅",@"邝",@"还",@"宾",@"闾",@"辜",@"纵",@"侴",@"万俟",@"司马",@"上官",@"欧阳",@"夏侯",@"诸葛",@"闻人",@"东方",@"赫连",@"皇甫",@"羊舌",@"尉迟",@"公羊",@"澹台",@"公冶",@"宗正",@"濮阳",@"淳于",@"单于",@"太叔",@"申屠",@"公孙",@"仲孙",@"轩辕",@"令狐",@"钟离",@"宇文",@"长孙",@"慕容",@"鲜于",@"闾丘",@"司徒",@"司空",@"兀官",@"司寇",@"南门",@"呼延",@"子车",@"颛孙",@"端木",@"巫马",@"公西",@"漆雕",@"车正",@"壤驷",@"公良",@"拓跋",@"夹谷",@"宰父",@"谷梁",@"段干",@"百里",@"东郭",@"微生",@"梁丘",@"左丘",@"东门",@"西门",@"南宫",@"第五",@"公仪",@"公乘",@"太史",@"仲长",@"叔孙",@"屈突",@"尔朱",@"东乡",@"相里",@"胡母",@"司城",@"张廖",@"雍门",@"毋丘",@"贺兰",@"綦毋",@"屋庐",@"独孤",@"南郭",@"北宫",@"王孙"];
    return arr[[XMToolClass getRandomNumberBegin:0 end:arr.count - 1]];
}
/*
 * 上传图片到服务器
 */
+ (NSString *)ImageTobase64:(UIImage *)_originImage {
    NSData *_data = UIImageJPEGRepresentation(_originImage, 1.0f);
    NSString *_encodedImageStr = [_data base64EncodedStringWithOptions:0];
    
    //    NSData *_data2 = UIImageJPEGRepresentation(_originImage, 1.0f);
    //    NSData *_data2  = UIImagePNGRepresentation(_originImage);
    //    NSString *pic2str = [_data2 base64EncodedStringWithOptions:0];
    
    //    return pic2str;
    return _encodedImageStr;
}

static UIViewController *ws;
/*
 * 返回按钮的添加
 */

- (void)clickBack
{
    if ([[ws.navigationController.childViewControllers firstObject] isEqual:ws] ) {
        [ws.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [ws.navigationController popViewControllerAnimated:YES];
    }
}

+ (instancetype)addBackItemToVC:(UIViewController *)vc{
    XMToolClass *factool = [self new];
    factool.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [factool.backBtn setTitle:@"" forState:0];
    [factool.backBtn setImage:[UIImage imageNamed:@"back_all"] forState:UIControlStateNormal];
    [factool.backBtn setImage:[UIImage imageNamed:@"back_all"] forState:UIControlStateSelected];
    factool.backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    factool.backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    factool.backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    ws = vc;
    [factool.backBtn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:factool.backBtn];
    return factool;
}

- (void)clickBackDis
{
    [ws dismissViewControllerAnimated:NO completion:nil];
}

+ (void)addBackItemToPVC:(UIViewController *)vc{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [button setTitle:@"返回" forState:0];
    [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"返回-点击"] forState:UIControlStateSelected];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    ws = vc;
    [button addTarget:self action:@selector(clickBackDis) forControlEvents:UIControlEventTouchUpInside];
  
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

#pragma mark - *******************************  懒加载  *******************************
- (UIView *)netTipView {
    if (!_netTipView) {
        _netTipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 64)];
        _netTipView.backgroundColor = [UIColor greenColor];
        UIImageView *tip = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"alert"]];
        [_netTipView addSubview:tip];
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(32);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        UILabel *tipLB = [UILabel new];
        [_netTipView addSubview:tipLB];
        [tipLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tip.mas_right).offset(8);
            make.centerY.equalTo(tip.mas_centerY);
        }];
        tipLB.font = [UIFont boldSystemFontOfSize:15];
        tipLB.textColor = [UIColor greenColor];
        tipLB.text = @"当前网络不可用，请检查你的网络设置！";
    }
    return _netTipView;
}



@end
