//
//  UIButton+Help.h
//  CLDriver
//
//  Created by MOOSON_ on 2018/10/24.
//  Copyright © 2018年 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Help)
+ (void)addBtnShadow:(UIButton *)btn;//btn增加阴影
+ (void)addBtnMoreShadow:(UIButton *)btn;//btn增加重阴影蓝色按钮
+ (void)addBtnGradualChange:(UIButton *)sender withcornerRadius:(CGFloat )cornerRadius;//购买渐变
+ (void)addBtnGradualChangeOne:(UIButton *)sender withcornerRadius:(CGFloat )cornerRadius;//加入购物车渐变
+ (void)addBtnHalfGradualChange:(UIButton *)sender;//渐变+半边裁边 橙色
+ (void)addBtnBlueHalfGradualChange:(UIButton *)sender;//渐变+半边裁边 蓝色

+ (void)addBtnOrangeShadow:(UIButton *)btn;//橙色阴影
+ (void)addBtnMoreShadow:(UIButton *)btn withColor:(UIColor *)color withcornerRadius:(CGFloat )cornerRadius;//btn增加重阴影
@end

NS_ASSUME_NONNULL_END
