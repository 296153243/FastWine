//
//  UIBarButtonItem+Extension.h
//  黑马微博2期
//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomButton.h"
@interface UIBarButtonItem (Extension)
/**
 *  创建一个item
 *
 *  @param target    点击item后调用哪个对象的方法
 *  @param action    点击item后调用target的哪个方法
 *  @param image     图片
 *  @param highImage 高亮的图片
 *
 *  @return 创建完的item
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image;
/**
 *  创建一个带图标&文字的item
 *
 *  @param target    点击item后调用哪个对象的方法
 *  @param action    点击item后调用target的哪个方法
 *  @param leftImage     图片
 *  @param title 显示的标题
 *  @param titleColor 标题的颜色
 *  @param isRight 是否是右边的item
 *  @param titleFont 标题的字体大小
 *
 *  @return 创建完的items
 */
+ (NSArray *)itemWithTarget:(id)target action:(SEL)action leftImage:(NSString *)leftImage selectImage:(NSString *)selectImage  title:(NSString *)title titleColor:(UIColor *)titleColor isRightItem:(BOOL)isRight titleFont:(UIFont *)titleFont createdButton:(void (^ __nullable)(UIButton *button))createdButton;
+ (UIBarButtonItem *)rightItemWithTitle:(NSString *)title Target:(id)target action:(SEL)action;

@end
