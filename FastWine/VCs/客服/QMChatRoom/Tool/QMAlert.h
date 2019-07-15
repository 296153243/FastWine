//
//  QMAlert.h
//  IMSDK-OC
//
//  Created by haochongfeng on 2017/5/17.
//  Copyright © 2017年 HCF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMAlert : NSObject

+ (UIWindow *)mainWindow;

+ (void)showMessage:(NSString *)message;

+ (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize;

+ (CGFloat)calcLabelHeight: (NSString *)text font: (UIFont *)font;

@end
