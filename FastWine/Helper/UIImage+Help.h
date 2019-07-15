//
//  UIImage+Help.h
//  QuPassenger
//
//  Created by Zhuqing on 2017/9/22.
//  Copyright © 2017年 com.Qyueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Help)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)resizableImageName:(NSString *)imgName  WithCapInsets:(UIEdgeInsets)capInsets;

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 *
 *  @return 生成的高清的UIImage
 */
+ (UIImage *)creatNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size;

+ (UIImage *)imageWithColor:(UIColor *)color;
@end
