//
//  CALayer+XQXibBorderColor.m
//  QuPassenger
//
//  Created by Chenmusong on 2017/9/30.
//  Copyright © 2017年 com.Qyueche. All rights reserved.
//

#import "CALayer+XQXibBorderColor.h"
#import <UIKit/UIKit.h>

@implementation CALayer (XQXibBorderColor)
- (void)setBorderColorWithUIColor:(UIColor *)color
{
    
    self.borderColor = color.CGColor;
}

@end
