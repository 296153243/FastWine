//
//  VersionContentView.m
//  QuPassenger
//
//  Created by 朱青 on 2018/2/9.
//  Copyright © 2018年 com.Qyueche. All rights reserved.
//

#import "VersionContentView.h"

@implementation VersionContentView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.cancelBtn.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.cancelBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    self.cancelBtn.layer.mask = maskLayer;
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.comfirmBtn.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = self.comfirmBtn.bounds;
    maskLayer2.path = maskPath2.CGPath;
    self.comfirmBtn.layer.mask = maskLayer2;
    
    UIBezierPath *maskPath3 = [UIBezierPath bezierPathWithRoundedRect:self.btnView.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer3 = [[CAShapeLayer alloc] init];
    maskLayer3.frame = self.btnView.bounds;
    maskLayer3.path = maskPath3.CGPath;
    self.btnView.layer.mask = maskLayer3;
 
}

@end
