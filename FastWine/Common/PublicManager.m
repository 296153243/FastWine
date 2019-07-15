//
//  PublicManager.m
//  GuangYiGuang_App
//
//  Created by Zhuqing on 16/8/3.
//  Copyright © 2016年 Zhuqing. All rights reserved.
//

#import "PublicManager.h"
#import "RegexKitLite.h"
#import "PinYin4Objc.h"
#import "SAMKeychain.h"
#import <MapKit/MapKit.h>
//#import <AlicloudMobileAnalitics/ALBBMAN.h>
//#import "JZLocationConverter.h"

/**
 获取字符串value的宽度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param width 限制字符串显示区域的宽度
 @result float 返回的宽度
 */
float HeightForString(NSString *value,float fontSize,float width)
{
    NSMutableParagraphStyle *paragrap = [[NSMutableParagraphStyle alloc]init];
    paragrap.lineBreakMode = NSLineBreakByWordWrapping;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragrap.copy};
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    //    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    
    return ceil(sizeToFit.height);
}


/**
 获取指定宽度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param height 限制字符串显示区域的宽度
 @result float 返回的高度
 */
float WidthForString(NSString *value,float fontSize,float height)
{
    NSMutableParagraphStyle *paragrap = [[NSMutableParagraphStyle alloc]init];
    paragrap.lineBreakMode = NSLineBreakByWordWrapping;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragrap.copy};
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    //    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    
    return ceil(sizeToFit.width);
}

@implementation PublicManager

+ (PublicManager *)shareManager
{
    static dispatch_once_t pred;
    static PublicManager *shared = nil;
    dispatch_once(&pred, ^{
        
        shared = [[self alloc]init];
    });
    return shared;
}

- (id)init
{
    self = [super init];
    if(self){
        
        _selectCityModel = [[QuCityModel alloc]init];
        _selectCityModel.cityName = @"苏州";
        _selectCityModel.cityCode = @"320500";
        _selectCityModel.provinceCode = @"320000";
        
        
    }
    return self;
}

+ (NSString *)getDeviceId
{
    NSString *currentDeviceUUIDStr = [SAMKeychain passwordForService:BUNDLE_ID account:@"uuid"];
    if (currentDeviceUUIDStr == nil || currentDeviceUUIDStr.length == 0){
        
        currentDeviceUUIDStr = [[NSUUID UUID] UUIDString];
//        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
//        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SAMKeychain setPassword: currentDeviceUUIDStr forService:BUNDLE_ID account:@"uuid"];
    }
    return currentDeviceUUIDStr;
    

}

- (BOOL)isShowVoice
{

    NSString *showVoice = [PublicManager getShowVoiceSearchFromLocal];
    
    if ([@"0" isEqualToString:showVoice]) {
        _isShowVoice = NO;
    }
    else{
        _isShowVoice = YES;
    }
    return _isShowVoice;
}

+ (NSDictionary *)getMainDataFromLocal
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:@"MainData"];
}

+ (void)saveMainDataToLocalWithDictionary:(NSDictionary *)dictionary
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dictionary forKey:@"MainData"];
    //将数据即时写入
    [userDefaults synchronize];
    
}

+ (BOOL)getShowGuideFromLocal
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults boolForKey:@"ShowVersionGuide"];
}

+ (void)saveShowGuideToLocalWithShow:(BOOL)show
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:show forKey:@"ShowVersionGuide"];
    //将数据即时写入
    [userDefaults synchronize];
    
}

+ (NSString *)getGuideVersionFromLocal
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"GuideVersion"];
}

+ (void)saveGuideVersionToLocalWithVersion:(NSString *)version
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:version forKey:@"GuideVersion"];
    [userDefaults synchronize];
}

+ (NSArray *)getGuideImageArrayFromLocal
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"GuideImage"];
}

+ (void)saveGuideImageArrayToLocalWithVersion:(NSArray *)array
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:array forKey:@"GuideImage"];
    [userDefaults synchronize];
}

+ (NSString *)getVersionAlertDateFromLocal
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"VersionAlertDate"];
}

+ (void)saveVersionAlertDateToLocalWithDateString:(NSString *)dateString
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dateString forKey:@"VersionAlertDate"];
    [userDefaults synchronize];
}

+ (void)removeVersionAlertDate
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"VersionAlertDate"];
    //将数据即时写入
    [userDefaults synchronize];
    
}


+ (NSString *)getLocalUserId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:@"userId"];
}

+ (void)saveUserUdToLocalWithId:(NSString *)userId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userId forKey:@"userId"];
    //将数据即时写入
    [userDefaults synchronize];
    
}

+ (void)removelocalUserId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"userId"];
    //将数据即时写入
    [userDefaults synchronize];
    
}

+ (NSString *)getLocalPhone
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:@"phone"];
}

+ (void)saveUserUdToLocalWithPhone:(NSString *)phone
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:phone forKey:@"phone"];
    //将数据即时写入
    [userDefaults synchronize];
    
}

+ (void)removelocalPhone
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"phone"];
    //将数据即时写入
    [userDefaults synchronize];
    
}

+ (NSString *)getLocalToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:@"token"];
}

+ (void)saveUserUdToLocalWithToken:(NSString *)token
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:token forKey:@"token"];
    //将数据即时写入
    [userDefaults synchronize];
    
}

+ (void)removelocalToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"token"];
    //将数据即时写入
    [userDefaults synchronize];
    
}
+ (NSString *)getShowVoiceSearchFromLocal
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:@"ShowVoiceSearch"];
}

+ (void)saveVoiceSearchToLocalWithShow:(NSString *)show
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:show forKey:@"ShowVoiceSearch"];
    //将数据即时写入
    [userDefaults synchronize];
}

+ (BOOL)evenNumberWithNumber:(NSInteger)number
{
    if (number % 2==0) {
        return YES;
    }
    return NO;
}



+(void)showAlert:(NSString *)message
{
    [PublicManager showAlert:message withDoneBlock:nil];
}

+(void)showAlert:(NSString *)message withDoneBlock:(void(^)(void))doneBlock
{
//    [CHAlertView showCHAlertViewWithTitle:@"提示" message:message cancleButtonTitle:@"确定" okButtonTitle:nil okClickHandle:nil cancelClickHandle:^{
//        if (doneBlock) {
//            doneBlock();
//        };
//    }];
}

/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
   
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

+ (void)callPhoneWithNumber:(NSString *)number
{
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",number];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    });
    
}

+ (NSString *)base64ImageDataString:(UIImage *)photoImg
{
    CGFloat width = photoImg.size.width;
    CGFloat height = photoImg.size.height;
    if (width > 200 || height > 200) {
        if (width > height) {
            height = height * (200/width);
            width = 200;
        }
        else{
            width = width * (200/height);
            height = 200;
        }
        photoImg = [PublicManager OriginImage:photoImg scaleToSize:CGSizeMake(width, height)];
    }
    NSData *data = UIImageJPEGRepresentation(photoImg, 0.5f);
    NSString *base64DataString = [data base64EncodedString];
    return base64DataString;
}

+ (UIImage *) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

+ (NSString *)getFullPinyinString:(NSString *)str {
    
    NSString *sTmp = nil;

    if ([str isMatchedByRegex:@"[\u4e00-\u9fa5]"]){
        
        HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
        [outputFormat setToneType:ToneTypeWithoutTone];
        [outputFormat setVCharType:VCharTypeWithV];
        [outputFormat setCaseType:CaseTypeUppercase];
        
        sTmp = [PinyinHelper toHanyuPinyinStringWithNSString:str withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
        
    }
    else
        sTmp = str;
    
    if ([str isEqualToString:@"长沙"]) {
        sTmp = @"CS";
    }
    else if ([str isEqualToString:@"长治"]) {
        sTmp = @"CZ";
    }
    else if ([str isEqualToString:@"重庆"]) {
        sTmp = @"CQ";
    }
    else if ([str isEqualToString:@"长春"]) {
        sTmp = @"CQ";
    }
    else if ([str isEqualToString:@"厦门"]) {
        sTmp = @"XM";
    }
    return sTmp;
}

+ (NSString*)getFirsrPingyinString:(NSString *)str
{
    NSString *sTmp = @"";
    
    NSString *textStr = nil ;
    
    for (NSInteger i =0 ; i<[str length]; i++) {
        
        NSString *tempStr = [NSString stringWithFormat:@"%C",[str characterAtIndex:i]];
        
        if ([tempStr isMatchedByRegex:@"[\u4e00-\u9fa5]"])
        {

            HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
            [outputFormat setToneType:ToneTypeWithoutTone];
            [outputFormat setVCharType:VCharTypeWithV];
            [outputFormat setCaseType:CaseTypeUppercase];
            
            sTmp = [PinyinHelper toHanyuPinyinStringWithNSString:tempStr withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
            
            if (sTmp.length > 0) {
                sTmp = [sTmp substringToIndex:1];
            }
            
        }
        else
        {
            sTmp = [NSString stringWithFormat:@"%c",[str characterAtIndex:i]];
        }
        if (textStr == nil) {
            textStr = sTmp;
        }
        else
            textStr = [textStr stringByAppendingString:sTmp];
        
    }
    
    if ([str isEqualToString:@"长沙"]) {
        return @"CS";
    }
    else if ([str isEqualToString:@"长治"]) {
        return @"CZ";
    }
    else if ([str isEqualToString:@"重庆"]) {
        return @"CQ";
    }
    else if ([str isEqualToString:@"长春"]) {
        return @"CQ";
    }
    else if ([str isEqualToString:@"厦门"]) {
        return @"XM";
    }
    return textStr;
}

+ (UIImage *)getMapArrowImage
{
    NSInteger width = 32;
    NSInteger height = 32;
    NSInteger h = height, w = width;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    void *data = NULL;//calloc(height * width, 4);
    CGContextRef bmpContext = CGBitmapContextCreate(data, width, height, 8, width*4, colorSpace, (CGBitmapInfo)(kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big));
    
    CGContextTranslateCTM(bmpContext, 0.0, height);
    CGContextScaleCTM(bmpContext, 1.0, -1.0);
    
    CGContextSetRGBFillColor(bmpContext, 251/255.0, 255/255.0f, 250/255.0, 1.0f);
    CGContextSetRGBStrokeColor(bmpContext, 1/255.0, 255/255.0f, 2/255.0, 1.0f);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint spnts[] = {CGPointMake(0.8*w, 0.5*h),
        CGPointMake(0.4*w, 0.1*h), CGPointMake(0.3*w, 0.1*h),
        CGPointMake(0.6*w, 0.5*h),
        CGPointMake(0.3*w, 0.9*h), CGPointMake(0.4*w, 0.9*h)};
    CGPathAddLines(path, NULL, spnts, sizeof(spnts)/sizeof(spnts[0]));
    CGPathCloseSubpath(path);
    
    CGContextAddPath(bmpContext, path);
    CGContextDrawPath(bmpContext, kCGPathFillStroke);
    
    CGPathRelease(path);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(bmpContext);
    
    UIImage *arrow = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(bmpContext);
    
    return arrow;
}

//条形码生成
+ (UIImage *)generateBarCode:(NSString *)code size:(CGSize)size color:(UIColor *)color backGroundColor:(UIColor *)backGroundColor{
    // 生成条形码图片
    CIImage *barcodeImage;
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    //设置条形码颜色和背景颜色
    CIFilter * colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
    [colorFilter setValue:filter.outputImage forKey:@"inputImage"];
    //条形码颜色
    if (color == nil) {
        color = [UIColor blackColor];
    }
    if (backGroundColor == nil) {
        backGroundColor = [UIColor whiteColor];
    }
    [colorFilter setValue:[CIColor colorWithCGColor:color.CGColor] forKey:@"inputColor0"];
    //背景颜色
    [colorFilter setValue:[CIColor colorWithCGColor:backGroundColor.CGColor] forKey:@"inputColor1"];
    
    barcodeImage = [colorFilter outputImage];
    
    // 消除模糊
    CGFloat scaleX = size.width / barcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = size.height / barcodeImage.extent.size.height;
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}

/*
 *  设置行间距和字间距
 *
 *  @param string    字符串
 *  @param lineSpace 行间距
 *  @param kern      字间距
 *  @param font      字体大小
 *
 *  @return 富文本
 */
+ (NSAttributedString *)getAttributedWithString:(NSString *)string WithLineSpace:(CGFloat)lineSpace kern:(CGFloat)kern font:(UIFont *)font{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    //调整行间距
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attriDict = @{NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@(kern),
                                NSFontAttributeName:font};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string attributes:attriDict];
    return attributedString;
}

//打开导航地图actionsheet
+ (void)showMapNavSheetWithEndLat:(NSString *)lat lon:(NSString *)lon name:(NSString *)endName
{
//    HDAlertView *alertView = [HDAlertView showActionSheetWithTitle:@""];
//    [alertView setDefaultButtonTitleColor:HEXCOLOR(@"404040")];
//    [alertView setCancelButtonTitleColor:HEXCOLOR(@"777777")];
//
//    // 打开地图的优先级顺序：苹果地图->高德地图->百度地图->腾讯地图
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com"]]){
//        // 苹果地图
//        // 起点为“我的位置”，终点为后台返回的address
//        [alertView addButtonWithTitle:@"苹果地图" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
//
//            //当前的位置
//            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
//
//            //目的地的位置
//            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]) addressDictionary:nil]];
//            toLocation.name = endName;
//            NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
//            NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@NO}; //打开苹果自身地图应用，并呈现特定的item
//            [MKMapItem openMapsWithItems:items launchOptions:options];
//
//        }];
//
//    }
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
//        // 高德地图
//        // 起点为“我的位置”，终点为后台返回的address
//        [alertView addButtonWithTitle:@"高德地图" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
//
//            NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&sname=%@&did=BGVIS2&dlat=%@&dlon=%@&dname=%@&dev=0&t=2",@"我的位置",lat,lon,endName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
//
//        }];
//
//    }
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
//        // 百度地图
//        // 起点为“我的位置”，终点为后台返回的坐标
//        CLLocationCoordinate2D ret = [JZLocationConverter gcj02ToBd09:CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue])];
//
//        [alertView addButtonWithTitle:@"百度地图" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
//
//            NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=%f,%f|name:%@&mode=walking&src=C罗出行",ret.latitude,ret.longitude,endName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            NSURL *url = [NSURL URLWithString:urlString];
//            [[UIApplication sharedApplication] openURL:url];
//
//        }];
//
//    }
//
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
//        // 腾讯地图
//        // 起点为“我的位置”，终点为后台返回的坐标
//        [alertView addButtonWithTitle:@"腾讯地图" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
//
//            NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?type=walk&from=我的位置&tocoord=%@,%@&to=%@&referer=C罗出行",lat,lon,endName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            NSURL *url = [NSURL URLWithString:urlString];
//            [[UIApplication sharedApplication] openURL:url];
//
//        }];
//
//    }
//
//    [alertView addButtonWithTitle:@"取消" type:HDAlertViewButtonTypeCancel handler:^(HDAlertView *alertView) {
//
//    }];
//
//    [alertView show];
  
}

//拨打系统电话
+ (void)makePhoneCallWithPhoneNumber:(NSString *)number
{
    if (number.trim.length > 0) {
        
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", number];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        }
        else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
    }

}



@end
