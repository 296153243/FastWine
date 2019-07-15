//
//  UIView+Help.m
//  QuDriver
//
//  Created by Zhuqing on 2017/9/21.
//  Copyright © 2017年 com.Qyueche. All rights reserved.
//

#import "UIView+Help.h"

@implementation UIView (Help)

- (void)setQu_x:(CGFloat)qu_x
{
    CGRect frame = self.frame;
    frame.origin.x = qu_x;
    self.frame = frame;
}

- (CGFloat)qu_x
{
    return self.frame.origin.x;
}

- (void)setQu_y:(CGFloat)qu_y
{
    CGRect frame = self.frame;
    frame.origin.y = qu_y;
    self.frame = frame;
}

- (CGFloat)qu_y
{
    return self.frame.origin.y;
}

- (void)setQu_w:(CGFloat)qu_w
{
    CGRect frame = self.frame;
    frame.size.width = qu_w;
    self.frame = frame;
}

- (CGFloat)qu_w
{
    return self.frame.size.width;
}

- (void)setQu_h:(CGFloat)qu_h
{
    CGRect frame = self.frame;
    frame.size.height = qu_h;
    self.frame = frame;
}

- (CGFloat)qu_h
{
    return self.frame.size.height;
}

- (void)setQu_size:(CGSize)qu_size
{
    CGRect frame = self.frame;
    frame.size = qu_size;
    self.frame = frame;
}

- (CGSize)qu_size
{
    return self.frame.size;
}

- (void)setQu_origin:(CGPoint)qu_origin
{
    CGRect frame = self.frame;
    frame.origin = qu_origin;
    self.frame = frame;
}

- (CGPoint)qu_origin
{
    return self.frame.origin;
}

- (UIViewController *)qu_viewController
{
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)setCornerRadius:(CGFloat)radius AndBorder:(CGFloat)borderWidth borderColor:(UIColor *)color
{
    if (radius > 0) {
        [self.layer setCornerRadius:radius];
    }
    if (borderWidth > 0) {
        [self.layer setBorderWidth:borderWidth];
        [self.layer setBorderColor:color.CGColor];
    }
}

- (void)showShadowColor
{
    
    self.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 1.0;
    self.layer.masksToBounds = NO;
}
- (void)addViewHalfTopChange{
    
    [self layoutIfNeeded];
    CGRect bounds = self.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    [self.layer addSublayer:maskLayer];
    self.layer.mask = maskLayer;
    
    
}


- (void)addViewHalfBottomChange{
    
    [self layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(10,10)];//半边圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
}
//阴影效果 --cell
- (void)showViewShadowColor{
//    self.layer.masksToBounds = YES;
//    self.layer.masksToBounds = NO;
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,1);
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius = 4;
    self.layer.cornerRadius = 5;
    
}
//阴影效果
- (void)showViewShadowColorMasksToBounds{
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,1);
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius = 4;
    self.layer.cornerRadius = 5;
}

- (void)showShadowColorWithColor:(UIColor *)color offset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius
{
    
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
    self.layer.masksToBounds = NO;
}

- (UIImage *)screenshot{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}
+ (instancetype)viewWithBackgroundColor:(UIColor *)color superView:(UIView *)superView
{
    UIView *line = [[UIView alloc]init];
    
    line.backgroundColor = color;
    
    [superView addSubview:line];
    
    return line;
}

@end
