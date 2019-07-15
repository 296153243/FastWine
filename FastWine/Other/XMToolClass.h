//
//  XMToolClass.h
//  NDBaseProject
//
//  Created by WenhuaLuo on  2017/1/18.
//  Copyright © 2017年 WenhuaLuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMToolClass : NSObject
//拍照
+ (void)snapImageWithDelegate:(id)delegate andParentVC:(UIViewController *)VC;
//本地相册
+ (void)localPhotoWithDelegate:(id )delegate andParentVC:(UIViewController *)VC;
//格式化卡号
+ (NSString *)formatStr:(NSString *)str withNum:(NSInteger)num withCarakter:(NSString *)carakter fromDist:(NSInteger )dist;
+ (NSString *)formatStr:(NSString *)str deleteCarakter:(NSString *)carakter withDStr:(NSString *)dStr;
//富文本
+ (NSAttributedString *)getAttributeStr:(NSString *)oilStr andRange:(NSRange )range andColor:(UIColor*)corlor andFont:(NSInteger)fontSize;

+ (AFHTTPSessionManager *)httpRequestInit;

//登录
+ (void)tipLoginFromController:(UIViewController *)showController;


/**
 把NSDictionary解析成post格式的NSString字符串

 @param params 字典
 @return 字典
 */
+ (NSDictionary *)parseParams:(NSDictionary *)params;

/**
 md5加密

 @param str 参数
 @return 加密的字符串
 */
+(NSString *)md5:(NSString *)str;
/**
 *  @author 王猛
 *
 *  获取归档路径
 */
+ (NSString *)getKeyedAchievePath;

/**
 *  NSKeyedArchiver归档
 *
 *  @param name   归档名称
 *  @param object 归档对象
 */
+ (void)saveKeyedAchievePathName:(NSString *)name object:(id)object;

/**
 *  NSKeyedUnarchiver解档
 *
 *  @param name 解档名称
 *
 *  @return 返回解档对象
 */
+ (id)getKeyedAchievePathName:(NSString *)name;

/**
 
tip               提示内容
delegate 代理

+ (void)tokenIvalid:(NSString *)tip andDelegate:(id)delegate;
  */
/**
 *  获得当前 年、月、日、时、分、秒
 *
 *  @return NSDateComponents 年月日等相关组件
 */
+ (NSDateComponents *)getDateComponents;

/**
 *  得到现在时间戳
 *
 *  @return 现在时间戳
 */
+ (NSString *)getTimeStamp;

/**
 *  时间戳转化为格式时间
 *
 *  @param timeStamp 时间戳
 *
 *  @param isSecondDegree 精度
 *
 *  @return 格式时间
 */

+ (NSString *)getFormateTime:(NSString *)timeStamp isSecondDegree:(BOOL)isSecondDegree timeFormat:(NSInteger)timeFormat;
/**
 *  @author 王猛, 16-03-18 18:03:55
 *
 *  密码加密
 *
 *  @param NSString 密码明文
 *
 *  @return 加密后密码
 *
 *  @since 1
 */
//+ (NSString *)encryptPassword:(NSString *)originalPassword;
/**
 *  时间戳转化为格式时间-如：今天 2:00、昨天 16：00
 *
 *  @param timeStamp 时间戳
 *
 *  @return 格式时间
 */
+ (NSString *)getFormateStringTime:(NSString *)timeStamp;

/**
 *  识别设备型号
 *
 *  @return 设备型号
 */


+ (NSString *)getCurrentDeviceModel;

/**
 *  时间变换格式 *
 *  @param originTime 时间
 *
 *  @return formatterStr 格式时间
 */
+ (NSString *)formaterTime:(NSString *)originTime withFormatter:(NSString *)formatterStr;

//删除NSDocumentDirectory下文件

+(UIColor *)getColorWithHexString: (NSString *) stringToConvert;

/**
 *  可定义透明度
 *
 *  @param stringToConvert 十六进制颜色值
 *  @param alpha           颜色的透明度[0,1]
 *
 *  @return RGB颜色
 */

//从颜色获得图片
+(UIImage*) createImageWithColor:(UIColor*) color;

+(UIColor *)getColorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha;

/**
 *  渐变色
 *
 *  @param a     红色系数
 *  @param b     绿色系数
 *  @param c     蓝色色系数
 *  @param alpha 透明度
 *
 *  @return UIColor
 */
+ (UIColor *)getGradientRed:(CGFloat)a green:(CGFloat)b blue:(CGFloat)c alpha:(CGFloat)alpha;

/**
 *  随机色
 *
 *  @param alpha 透明度
 *
 *  @return UIColor
 */
+ (UIColor *)getRandomColorAlpha:(CGFloat)alpha;

/**
 *  版本号
 */
+ (NSString *)getVersion;

/**
 *  内部版本号
 */
+ (NSString *)getBundleVersion;

/**
 *  APP 名称
 */
+ (NSString *)getAPPName;

/**
 *  手机UUID
 */
+ (NSString *)getUUID;

/**
 *  手机别名： 用户定义的名称
 */
+ (NSString *)getPhoneName;

/**
 *  手机别名： 用户定义的名称
 */
+ (NSString *)getIOSVersion;

/**
 *  邮箱
 */
+ (BOOL) validateEmail:(NSString *)email;
/**
 *  手机号码验证
 */
+ (BOOL) validateMobile:(NSString *)mobile;
/**
 *  邮箱验证
 */
+(BOOL)isValidateEmail:(NSString *)email;
/**
 *  固定电话验证
 */
+ (BOOL) validateTel:(NSString *)mobile;
/**
 *  手机号码或固定电话验证
 */
+ (BOOL) validateMobileAndTel:(NSString *)mobile;
/**
 *  车牌号验证
 */
+ (BOOL) validateCarNo:(NSString *)carNo;
/**
 *  车型
 */
+ (BOOL) validateCarType:(NSString *)CarType;
/**
 *  用户名
 */
+ (BOOL) validateUserName:(NSString *)name;
/**
 *  密码
 */
+ (BOOL) validatePassword:(NSString *)passWord;
/**
 *  昵称
 */
+ (BOOL) validateNickname:(NSString *)nickname;
/**
 *  身份证号
 */
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

/**
 *  拨打电话
 */
+ (void)getOpenTelphone: (NSString *)phoneNumber;
/**
 *  发短信
 */
+ (void)getOpenMSG: (NSString *)MSGphoneNumber;

/**
 *  转为UTF-8字符串
 */
+(NSString *)getUTF8String:(NSString *)string;
/**
 *  车架号
 */

+ (BOOL) validateCarJiaCard: (NSString *)identityCard;
/**
 *  发动机号验证
 */

+ (BOOL) validateCarEngiNO: (NSString *)identityCard;
/**
 *  银行卡验证
 */
+ (BOOL)checkCardNo:(NSString*)cardNo;
/**
 *  纯数字验证
 */
+ (BOOL)isPureInt:(NSString*)string;
/**
 *  每3个字符串加一个空格
 */
+ (NSString *)insertSpacesEveryFourDigitsIntoString:(NSString *)string value:(int)value;

/**
 *   存储 自定义内容
 */
+ (void)saveMessageStr:(NSString *)message StrKeyWithStr:(NSString *)key;
+ (void)saveMessagedata:(id)messagedata dataKeyWithStr:(NSString *)key;


/**
 *   存储
 */
+ (void)saveMessage:(id)message StrKeyWithStr:(NSString *)key;
+ (id)getMessage:(NSString *)key;

/**
 *   获取 自定义MessageStr
 */
+ (NSString *)getMessageStrKeyWithStr:(NSString *)key;
/**
 *   存储 自定义Messagedata
 */
+ (NSData *)getMessagedataKeyWithStr:(NSString *)key;
/**
 *  随机数 获取一个随机整数，范围在[beginNumber,endNumber），包括beginNumber，不包括endNumber
 */
+ (NSInteger)getRandomNumberBegin:(NSInteger)beginNumber end:(NSInteger)endNumber;
/**
 * 判断中英文字符串字符长度
 */
+ (int)convertToInt:(NSString*)strtemp;
/**
 * 传入银行名字返回银行类型图片名字
 */
+ (NSString *)getBnakIcon:(NSString*)bankType;
/**
 * 传入天气名称返回固定的类型名称
 */
+ (NSString *)getWeatherIcon:(NSString*)name;
/**
 *  随机取百家姓
 */
+ (NSString *)getFamilyNames;



+(NSMutableAttributedString *)checkStar:(NSString *)title;
+(NSString *)removeStar:(NSString *)title;

/**
 *  控制器上添加返回按钮样式，全局的样式应该是一样的，所以可以使用工厂类
 */
+ (instancetype)addBackItemToVC:(UIViewController *)vc;

/**
 *  视图上添加返回按钮样式
 */
+ (void)addBackItemToPVC:(UIViewController *)vc;
/**
 *  返回按钮
 */
@property (nonatomic, strong) UIButton *backBtn;
/**
 *  压缩图片上传到服务器
 */
+ (NSString *)ImageTobase64:(UIImage *)_originImage;
@end
