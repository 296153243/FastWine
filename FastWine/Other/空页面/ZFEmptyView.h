//
//  ZFEmptyView.h
//  ZuFang
//
//  Created by 那道 on 2017/12/6.
//  Copyright © 2017年 解辉. All rights reserved.
//空页面

#import <UIKit/UIKit.h>

@interface ZFEmptyView : UIView

- (instancetype)initWithImage:(NSString *)imageName emptyTip:(NSString *)tip showHeight:(CGFloat)height topMargin:(CGFloat)topMargin;

- (void)changeTipColor:(UIColor *)tipColor;

@end
