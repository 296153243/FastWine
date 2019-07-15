//
//  UIButton+NZCustom.h
//  NZJob
//
//  Created by WenhuaLuo on 15/9/9.
//  Copyright (c) 2015年 WenhuaLuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (NZCustom)

/**
 *  基础按钮：字体，字体颜色，背景色，事件
 */
+ (instancetype)buttonWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor backGroundColor:(UIColor *)bgColor buttonTag:(NSInteger)tag target:(id)target action:(SEL)action showView:(UIView *)showView;

/**
 *  基础按钮：
 */
+ (instancetype)buttonWithBackgroundImage:(NSString *)imageName target:(id)target action:(SEL)action showView:(UIView *)showView;

/**
 *  基础按钮：头像,无边框的
 */
+ (instancetype)buttonWithHeadImage:(NSString *)image target:(id)target action:(SEL)action showView:(UIView *)showView;

/**
 *  基础按钮：只显示一个图片
 */
+ (UIButton *)buttonWithImage:(NSString *)image target:(id)target action:(SEL)action showView:(UIView *)showView;

/**
 *  带有背景色//&边框颜色的按钮
 */
+ (instancetype)buttonWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor backGroundColor:(UIColor *)bgColor boardColor:(CGColorRef)boardColor target:(id)target action:(SEL)action showView:(UIView *)showView;

/**
 *  带有字体有选中&为选中颜色，带有tag&背景色的按钮
 */
+ (instancetype)buttonWithTitle:(NSString *)title font:(UIFont *)font normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor buttonTag:(NSInteger)tag backGroundColor:(UIColor *)bgColor target:(id)target action:(SEL)action showView:(UIView *)showView;

/**
 *  带有字体\背景有选中&为选中，带有tag的按钮
 */
+ (instancetype)buttonWithTitle:(NSString *)title font:(UIFont *)font normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor normalImage:(id)normalImage selectImage:(id)selectImage  buttonTag:(NSInteger)tag target:(id)target action:(SEL)action showView:(UIView *)showView;

/**
 *  左边带图标&字体颜色&背景色的按钮   系统自带的方式
 */
+ (instancetype)buttonWithLeftImage:(NSString *)imageName title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor backGroundColor:(UIColor *)bgColor target:(id)target action:(SEL)action showView:(UIView *)showView;



@end
