//
//  UIButton+NZCustom.m
//  NZJob
//
//  Created by WenhuaLuo on 15/9/9.
//  Copyright (c) 2015年 WenhuaLuo. All rights reserved.
//

#import "UIButton+NZCustom.h"

@implementation UIButton (NZCustom)

+ (instancetype)buttonWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor backGroundColor:(UIColor *)bgColor buttonTag:(NSInteger)tag target:(id)target action:(SEL)action showView:(UIView *)showView
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.titleLabel.font = font;
    
    btn.tag = tag;
    
    btn.backgroundColor = bgColor;
    
    btn.titleLabel.numberOfLines = 0;
    
    btn.clipsToBounds = YES;
    
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [showView addSubview:btn];
    
    return btn;
}

+ (instancetype)buttonWithTitle:(NSString *)title font:(UIFont *)font normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor normalImage:(id)normalImage selectImage:(id)selectImage buttonTag:(NSInteger)tag target:(id)target action:(SEL)action showView:(UIView *)showView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:selectedColor forState:UIControlStateSelected];
    
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    
    if ([normalImage isKindOfClass:[UIImage class]]) {
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    }
    else
        [button setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    
    if ([selectImage isKindOfClass:[UIImage class]]) {
        [button setBackgroundImage:selectImage forState:UIControlStateNormal];
    }
    else
        [button setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
    
    button.titleLabel.font = font;
    
    button.tag = tag;
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [showView addSubview:button];
    
    return button;
}
+ (instancetype)buttonWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor backGroundColor:(UIColor *)bgColor boardColor:(CGColorRef)boardColor target:(id)target action:(SEL)action showView:(UIView *)showView
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.titleLabel.font = font;
    
    btn.backgroundColor = bgColor;
    
    btn.layer.borderColor = boardColor;
    
    btn.layer.borderWidth = 0.5;
    
    btn.clipsToBounds = YES;
    
    btn.titleLabel.numberOfLines = 0;
    
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [showView addSubview:btn];
    
    return btn;
}


+ (instancetype)buttonWithTitle:(NSString *)title font:(UIFont *)font normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor buttonTag:(NSInteger)tag backGroundColor:(UIColor *)bgColor  target:(id)target action:(SEL)action showView:(UIView *)showView
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    btn.titleLabel.font = font;
    
    btn.backgroundColor = bgColor;
    
    [btn setTitleColor:selectedColor forState:UIControlStateSelected];
    
    [btn setTitleColor:normalColor forState:UIControlStateNormal];
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    btn.tag = tag;
    
    [showView addSubview:btn];
    
    return btn;

}

+ (instancetype)shareButtonSetEdgeInsetWithTarget:(id)target action:(SEL)action showView:(UIView *)showView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:@"分享" forState:UIControlStateNormal];
    
    [button setImage:[UIImage imageNamed:@"public_share"] forState:UIControlStateNormal];
    
    [button setImage:[UIImage imageNamed:@"public_share"] forState:UIControlStateHighlighted];
    
//    button.titleLabel.font = kFont4;
    
    button.frame = CGRectMake(0, 0, 80, 44);
    
//    button.imageEdgeInsets = UIEdgeInsetsMake(0, kLeftMargin, 0, 0);
    
//    button.titleEdgeInsets = UIEdgeInsetsMake(0, 2 * kLeftMargin, 0, 0);

    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [showView addSubview:button];
    
    return button;
}


/*
+ (instancetype)buttonWithRightImage:(NSString *)imageName title:(NSString *)title font:(UIFont *)font  titleColor:(UIColor *)color bgColor:(UIColor *) bgColor target:(id)target action:(SEL)action buttonH:(CGFloat)buttonH showView:(UIView *)showView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.titleLabel.font = font;
    
    CGSize buttonSize = [self sizeWithText:title font:font maxSize:CGSizeMake(MAXFLOAT, buttonH)];
    
    CGFloat imageW = button.imageView.bounds.size.width;
    
    button.imageEdgeInsets = UIEdgeInsetsMake(0, buttonSize.width + 10, 0, -buttonSize.width);
    
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageW, 0, imageW);
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    button.titleLabel.numberOfLines = 0;
    
    [button setTitleColor:color forState:UIControlStateNormal];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    button.backgroundColor = bgColor;
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [showView addSubview:button];
    
    return button;
}
*/

+ (instancetype)buttonWithLeftImage:(NSString *)imageName title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor backGroundColor:(UIColor *)bgColor target:(id)target action:(SEL)action showView:(UIView *)showView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10 / 2, 0, 0);
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    button.titleLabel.font = font;
    
    button.backgroundColor = bgColor;
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [showView addSubview:button];
    
    return button;
}

+ (instancetype)buttonWithBackgroundImage:(NSString *)imageName target:(id)target action:(SEL)action showView:(UIView *)showView
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    button.clipsToBounds = YES;
    
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [showView addSubview:button];
    
    return button;
}

+ (UIButton *)buttonWithImage:(NSString *)image target:(id)target action:(SEL)action showView:(UIView *)showView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.clipsToBounds = YES;
    
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [showView addSubview:button];
    
    return button;
}

+ (instancetype)buttonWithHeadImage:(NSString *)image target:(id)target action:(SEL)action showView:(UIView *)showView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.clipsToBounds = YES;
    
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [showView addSubview:button];
    
    return button;
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
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
