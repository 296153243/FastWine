//
//  UILabel+Custom.m
//  NZJob
//
//  Created by WenhuaLuo on 15/9/10.
//  Copyright (c) 2015年 WenhuaLuo. All rights reserved.
//

#import "UILabel+Custom.h"
@implementation UILabel (Custom)



+ (instancetype)labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor backGroundColor:(UIColor *)bgColor superView:(UIView *)superView
{
    UILabel *label = [[UILabel alloc]init];
    
    label.textAlignment = NSTextAlignmentLeft;
    
    label.textColor = textColor;
    
    label.backgroundColor = bgColor;
    
    label.numberOfLines = 0;
    
    label.font = font;
    
    label.text = text;
    
    [superView addSubview:label];
    
    return label;
}



- (void)setAppearanceFont:(UIFont *)appearanceFont
{
    if(appearanceFont)
    {
        [self setFont:appearanceFont];
    }
}

- (UIFont *)appearanceFont
{
    return self.font;
}


@end
