//
//  UIView+Help.h
//  QuDriver
//
//  Created by Zhuqing on 2017/9/21.
//  Copyright © 2017年 com.Qyueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Help)

@property (assign, nonatomic) CGFloat qu_x;
@property (assign, nonatomic) CGFloat qu_y;
@property (assign, nonatomic) CGFloat qu_w;
@property (assign, nonatomic) CGFloat qu_h;
@property (assign, nonatomic) CGSize qu_size;
@property (assign, nonatomic) CGPoint qu_origin;

- (UIViewController *)qu_viewController;

//展示圆角 线 颜色
- (void)setCornerRadius:(CGFloat)radius AndBorder:(CGFloat)borderWidth borderColor:(UIColor *)color;

//展示阴影
- (void)showShadowColor;

//展示阴影_Cl
- (void)showViewShadowColor;
- (void)showViewShadowColorMasksToBounds;
- (void)showShadowColorWithColor:(UIColor *)color offset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius;
- (void)addViewHalfTopChange;//裁剪上边角
- (void)addViewHalfBottomChange;//裁剪下边角


- (UIImage *)screenshot;

//部分圆角
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;
+ (instancetype)viewWithBackgroundColor:(UIColor *)color superView:(UIView *)superView;
@end
