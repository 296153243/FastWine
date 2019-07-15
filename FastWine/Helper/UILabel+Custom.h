//
//  UILabel+Custom.h
//  NZJob
//
//  Created by WenhuaLuo on 15/9/10.
//  Copyright (c) 2015年 WenhuaLuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Custom)

/** font */
@property (nonatomic,copy) UIFont *appearanceFont UI_APPEARANCE_SELECTOR;

+ (instancetype)labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor backGroundColor:(UIColor *)GamesBGCOLOR superView:(UIView *)superView;


@end
