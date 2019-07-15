//
//  UIButton+Help.m
//  CLDriver
//
//  Created by MOOSON_ on 2018/10/24.
//  Copyright © 2018年 MOOSON_. All rights reserved.
//

#import "UIButton+Help.h"
#define ClBtnBlueColor [UIColor colorWithRed:74/255.0 green:85/255.0 blue:120/255.0 alpha:1];
@implementation UIButton (Help)
+ (void)addBtnShadow:(UIButton *)btn{
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(264,8732.5,111,49);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:252/255.0 green:78/255.0 blue:25/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:254/255.0 green:112/255.0 blue:0/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0f)];
    [btn.layer addSublayer:gl];
}
+ (void)addBtnMoreShadow:(UIButton *)btn{
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(153,8732.5,111,49);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:154/255.0 blue:1/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:201/255.0 blue:0/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0f)];
    
    [btn.layer addSublayer:gl];
}
+ (void)addBtnGradualChange:(UIButton *)sender withcornerRadius:(CGFloat )cornerRadius{
    
    sender.clipsToBounds = YES;
    sender.layer.cornerRadius = cornerRadius;
    sender.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    sender.layer.shadowColor = [UIColor colorWithRed:31/255.0 green:36/255.0 blue:59/255.0 alpha:0.3].CGColor;
    sender.layer.shadowOffset = CGSizeMake(0,3);
    sender.layer.shadowOpacity = 0.2;
    sender.layer.shadowRadius = 10;
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = sender.bounds;
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:252/255.0 green:78/255.0 blue:25/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:254/255.0 green:112/255.0 blue:0/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0f)];
    
    [sender.layer addSublayer:gl];
    
    UIGraphicsBeginImageContextWithOptions(gl.frame.size, NO, 0);
    
    [gl renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [sender setBackgroundImage:outputImage forState:UIControlStateNormal];
    
}
+ (void)addBtnGradualChangeOne:(UIButton *)sender withcornerRadius:(CGFloat )cornerRadius{
    
    sender.clipsToBounds = YES;
    sender.layer.cornerRadius = cornerRadius;
    sender.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    sender.layer.shadowColor = [UIColor colorWithRed:31/255.0 green:36/255.0 blue:59/255.0 alpha:0.3].CGColor;
    sender.layer.shadowOffset = CGSizeMake(0,3);
    sender.layer.shadowOpacity = 0.2;
    sender.layer.shadowRadius = 10;
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = sender.bounds;
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:252/255.0 green:78/255.0 blue:25/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:254/255.0 green:112/255.0 blue:0/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0f)];
    
    [sender.layer addSublayer:gl];
    
    UIGraphicsBeginImageContextWithOptions(gl.frame.size, NO, 0);
    
    [gl renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [sender setBackgroundImage:outputImage forState:UIControlStateNormal];
    
}
+ (void)addBtnHalfGradualChange:(UIButton *)sender{
    
    sender.layer.masksToBounds = YES;
    [sender layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sender.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(5,5)];//半边圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = sender.bounds;
    maskLayer.path = maskPath.CGPath;
    sender.layer.mask = maskLayer;
    
    sender.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    sender.layer.shadowColor = [UIColor colorWithRed:31/255.0 green:36/255.0 blue:59/255.0 alpha:0.3].CGColor;
    sender.layer.shadowOffset = CGSizeMake(0,3);
    sender.layer.shadowOpacity = 1;
    sender.layer.shadowRadius = 10;
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = sender.bounds;
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 0);
    //    layer.startPoint = CGPointMake(0.5, 0);
    //    layer.endPoint = CGPointMake(0.5, 1);
    
    gl.colors = @[(__bridge id)[UIColor colorWithRed:252/255.0 green:183/255.0 blue:79/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:252/255.0 green:183/255.0 blue:79/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:240/255.0 green:97/255.0 blue:44/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:150/255.0 blue:56/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:174/255.0 blue:64/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:184/255.0 blue:77/255.0 alpha:1].CGColor];
    gl.locations = @[@(0.0),@(0.0),@(0.0),@(0.7),@(0.9),@(1.0)];
    
    UIGraphicsBeginImageContextWithOptions(gl.frame.size, NO, 0);
    
    [gl renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [sender setBackgroundImage:outputImage forState:UIControlStateNormal];
    
   
}
+ (void)addBtnBlueHalfGradualChange:(UIButton *)sender{
    sender.layer.masksToBounds = YES;
    [sender layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sender.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(5,5)];//半边圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = sender.bounds;
    maskLayer.path = maskPath.CGPath;
    sender.layer.mask = maskLayer;
    
   sender.backgroundColor = ClBtnBlueColor;
    sender.layer.shadowColor = [UIColor colorWithRed:31/255.0 green:36/255.0 blue:59/255.0 alpha:0.3].CGColor;;
    sender.layer.shadowOffset = CGSizeMake(0,3);
    sender.layer.shadowOpacity = 1;
    sender.layer.shadowRadius = 10;
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = sender.bounds;
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 0);
    //    layer.startPoint = CGPointMake(0.5, 0);
    //    layer.endPoint = CGPointMake(0.5, 1);
    
    gl.colors = @[(__bridge id)[UIColor colorWithRed:73/255.0 green:84/255.0 blue:117/255.0 alpha:0.8].CGColor,(__bridge id)[UIColor colorWithRed:70/255.0 green:78/255.0 blue:102/255.0 alpha:0.8].CGColor,(__bridge id)[UIColor colorWithRed:69/255.0 green:77/255.0 blue:101/255.0 alpha:0.8].CGColor,(__bridge id)[UIColor colorWithRed:78/255.0 green:87/255.0 blue:117/255.0 alpha:0.8].CGColor];
    gl.locations = @[@(0.0),@(0.0),@(0.0),@(0.7),@(0.9),@(1.0)];
    
    UIGraphicsBeginImageContextWithOptions(gl.frame.size, NO, 0);
    
    [gl renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [sender setBackgroundImage:outputImage forState:UIControlStateNormal];
    
}
+ (void)addBtnOrangeShadow:(UIButton *)btn{
    btn.backgroundColor = [UIColor colorWithRed:255/255.0 green:130/255.0 blue:12/255.0 alpha:1.0];
    UIView *viewShadow2 = [[UIView alloc] init];
    viewShadow2.frame = CGRectMake(147.5,325.5,80,35);
    viewShadow2.backgroundColor = [UIColor colorWithRed:255/255.0 green:130/255.0 blue:12/255.0 alpha:1.0];
    viewShadow2.layer.shadowColor = [UIColor colorWithRed:255/255.0 green:130/255.0 blue:12/255.0 alpha:0.5].CGColor;
    viewShadow2.layer.shadowOffset = CGSizeMake(0, 2);
    viewShadow2.layer.shadowOpacity = 1;
    viewShadow2.layer.shadowRadius = 4;
    
    [btn bringSubviewToFront:btn];
    btn.layer.cornerRadius = 5;
}
+ (void)addBtnMoreShadow:(UIButton *)btn withColor:(UIColor *)color withcornerRadius:(CGFloat )cornerRadius{
    btn.backgroundColor = color;
    btn.layer.shadowColor = [UIColor colorWithRed:31/255.0 green:36/255.0 blue:59/255.0 alpha:0.3].CGColor;
    btn.layer.shadowOffset = CGSizeMake(0,3);
    btn.layer.shadowOpacity = 1;
    btn.layer.shadowRadius = 10;
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(17.5,592,340,50);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:73/255.0 green:84/255.0 blue:117/255.0 alpha:0.8].CGColor,(__bridge id)[UIColor colorWithRed:70/255.0 green:78/255.0 blue:102/255.0 alpha:0.8].CGColor,(__bridge id)[UIColor colorWithRed:69/255.0 green:77/255.0 blue:101/255.0 alpha:0.8].CGColor,(__bridge id)[UIColor colorWithRed:78/255.0 green:87/255.0 blue:117/255.0 alpha:0.8].CGColor];
    gl.locations = @[@(0.0),@(0.0),@(0.5),@(1.0)];
    
    [btn.layer addSublayer:gl];
    btn.layer.cornerRadius = cornerRadius;
}
@end
