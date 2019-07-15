//
//  CommonMethod.h
//  Thebluebees
//
//  Created by admin on 15/7/2.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface CommonMethod : NSObject

- (void)showTip:(NSString *)title leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle showViewController:(UIViewController *)showViewController rightAction:(void (^)(void))rightAction leftAction:(void (^)(void))leftAction;

+ (instancetype)sharedManager;

+ (NSInteger )resultWithTotalNum:(NSInteger)totalNum getNum:(NSInteger)getNum;

+(int)initlabelwith:(NSString *)labelstr;

+(UIImageView *)setViewimag:(UIView *)taskview andimagename:(NSString *)imagestr;

+(UIBarButtonItem *)Setbarbtntextcolor:(UIColor *)textcolor andtitlestr:(NSString *)textstr;

+(void)altermethord:(NSString *)titlestr andmessagestr:(NSString *)messagestr andconcelstr:concelstr;

+(void)GetVerificationCode:(UIButton *)Verificationbtn finish:(void (^)(void))finish;

+(BOOL)validateCarNo:(NSString *)carNo;

////////时间相关的
+ (NSDate *)getCurrentTimeWithType:(NSString *)type;

+ (NSDate *)getDateWithString:(NSString *)dateStr type:(NSString *)type;

/////////////////////////

+ (void)tipAlertWithTitle:(id)title leftColor:(UIColor *)leftColor leftTip:(NSString *)leftTip rightTip:(NSString *)rightTip showVC:(UIViewController *)showVC leftAction:(void (^)(void))leftAction rightAction:(void (^)(void))rightAction;

@end
