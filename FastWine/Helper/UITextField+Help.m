//
//  UITextField+Help.m
//  FreshFood
//
//  Created by Zhuqing on 2017/8/31.
//  Copyright © 2017年 FreshFood. All rights reserved.
//

#import "UITextField+Help.h"

@implementation UITextField (Help)

- (void)setLeftContentMarginWithMargin:(NSInteger)margin
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, margin, 5)];
    self.leftView = view;
    self.leftViewMode = UITextFieldViewModeAlways;

}

@end
