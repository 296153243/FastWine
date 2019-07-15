//
//  QuLoadingHUD.h
//  QuPassenger
//
//  Created by Zhuqing on 2017/12/1.
//  Copyright © 2017年 com.Qyueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuLoadingHUD : UIView

+ (void)loading;

+ (void)dismiss;
+ (void)dismiss:(NSString *)msg;

@end
