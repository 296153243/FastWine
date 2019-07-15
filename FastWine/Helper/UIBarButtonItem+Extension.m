//
//  UIBarButtonItem+Extension.m
//  黑马微博2期
//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
 
    // 设置尺寸
    CGFloat height = btn.currentBackgroundImage.size.height;
    CGFloat width = btn.currentBackgroundImage.size.width;
    btn.qu_size = CGSizeMake(MAX(40, width), height);
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}



+ (NSArray *)itemWithTarget:(id)target action:(SEL)action leftImage:(NSString *)leftImage selectImage:(NSString *)selectImage title:(NSString *)title titleColor:(UIColor *)titleColor isRightItem:(BOOL)isRight titleFont:(UIFont *)titleFont  createdButton:(void (^ __nullable)(UIButton *button))createdButton
{
    
    CGFloat titleW = 0;
    if (title) {
//        titleW = [NSString sizeWithText:title font:titleFont maxSize:CGSizeMake(MAXFLOAT, 40)].width;
    }
    
    if (!leftImage) {
        UIButton *titleBtn = [UIButton buttonWithTitle:title font:titleFont titleColor:titleColor backGroundColor:ClearColor buttonTag:0 target:target action:action showView:nil];
        
        if (createdButton) {
            createdButton(titleBtn);
        }
        
        titleBtn.frame = CGRectMake(0, 0, MAX(40, titleW), 40);
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:titleBtn];
        return @[item];
        
    }
    else if (!title)
    {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        // 设置图片
        [titleBtn setImage:[UIImage imageNamed:leftImage] forState:UIControlStateNormal];
        [titleBtn setImage:[UIImage imageNamed:leftImage] forState:UIControlStateHighlighted];
        // 设置尺寸
//        CGFloat height = titleBtn.currentBackgroundImage.size.height;
        CGFloat width = titleBtn.currentBackgroundImage.size.width;
        titleBtn.qu_size = CGSizeMake(MAX(40, width), 40);
        
        if (createdButton) {
            createdButton(titleBtn);
        }
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:titleBtn];
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = 1;
        return @[item, spaceItem];
    }
    CustomButton *btn = [CustomButton buttonWithRightImage:leftImage?leftImage:@"" title:title?title:@"" font:titleFont titleColor:titleColor bgColor:[UIColor clearColor] target:target action:action buttonH:40 showView:nil];
    
    btn.contentHorizontalAlignment = isRight ? UIControlContentHorizontalAlignmentRight : UIControlContentHorizontalAlignmentLeft;
    
    btn.contentEdgeInsets = isRight ? UIEdgeInsetsMake(0, 0, 0, 0) : UIEdgeInsetsMake(0, 0, 0, 0);
    
    CGFloat width = titleW+btn.currentImage.size.width+20;
    
    btn.frame = CGRectMake(0, 0, width, 40);
    
    if (createdButton) {
        createdButton(btn);
    }
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = 0.01;
    
    return isRight ? @[spaceItem, item] : @[spaceItem, item];
}
+ (UIBarButtonItem *)rightItemWithTitle:(NSString *)title Target:(id)target action:(SEL)action{
    UIButton* leftBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:title forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 50, 44);
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    leftBtn.backgroundColor = [UIColor redColor];
    leftBtn.contentHorizontalAlignment  =  UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    return leftBtnItem;
}

@end
