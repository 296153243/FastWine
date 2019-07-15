//
//  CustomButton.m
//  DingDing
//
//  Created by WenhuaLuo on 16/10/13.
//  Copyright © 2016年 Meity. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (void)drawRect:(CGRect)rect {
    
    [self setTitle:self.currentTitle forState:UIControlStateNormal];
    
    [CustomButton contentEdgeWithButton:self];
    
}

+ (instancetype)buttonWithRightImage:(NSString *)imageName title:(NSString *)title font:(UIFont *)font  titleColor:(UIColor *)color bgColor:(UIColor *) bgColor target:(id)target action:(SEL)action buttonH:(CGFloat)buttonH showView:(UIView *)showView
{
    CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
    
    button.titleLabel.font = font;
    
    [CustomButton contentEdgeWithButton:button];
    
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

+ (void)contentEdgeWithButton:(UIButton *)button
{
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = button.imageView.frame.size.width;
    //    CGFloat imageHeight = button.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = button.titleLabel.intrinsicContentSize.width;
        labelHeight = button.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = button.titleLabel.frame.size.width;
        labelHeight = button.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    CGFloat space = 5;
    
    imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
    labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
    
    button.titleEdgeInsets = labelEdgeInsets;
    button.imageEdgeInsets = imageEdgeInsets;
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
