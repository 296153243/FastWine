//
//  CustomButton.h
//  DingDing
//
//  Created by WenhuaLuo on 16/10/13.
//  Copyright © 2016年 Meity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton
/**
 点击事件里面添加
[sender setNeedsDisplay];
 */
+ (instancetype)buttonWithRightImage:(NSString *)imageName title:(NSString *)title font:(UIFont *)font  titleColor:(UIColor *)color bgColor:(UIColor *) bgColor target:(id)target action:(SEL)action buttonH:(CGFloat)buttonH showView:(UIView *)showView;

@end
