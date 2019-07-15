//
//  QuHudHelper.m
//  QuPassenger
//
//  Created by Zhuqing on 2017/9/22.
//  Copyright © 2017年 com.Qyueche. All rights reserved.
//

#import "QuHudHelper.h"

@implementation QuHudHelper

//#pragma mark mb
//+ (MBProgressHUD *)mb_loading
//{
//    return [QuHudHelper mb_loading:nil];
//}
//
//+ (MBProgressHUD *)mb_loading:(NSString *)msg
//{
//    return [QuHudHelper mb_loading:msg inView:nil];
//}
//
//+ (MBProgressHUD *)mb_loading:(NSString *)msg inView:(UIView *)view
//{
//    UIView *inView = view ? view : [UIApplication sharedApplication].keyWindow;
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:inView];
////    hud.bezelView.color = [UIColor blackColor];
////    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
////    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        NSString *string = [msg stringByReplacingOccurrencesOfString:@" " withString:@""];
//        if (string.length > 0){
//            
//            hud.mode = MBProgressHUDModeIndeterminate;
//            hud.label.text = msg;
//        }
//        [inView addSubview:hud];
//        [hud showAnimated:YES];
//        // 超时自动消失
//        // [hud hide:YES afterDelay:kRequestTimeOutTime];
//    });
//    return hud;
//}
//
//+ (MBProgressHUD *)mb_loading:(NSString *)msg inView:(UIView *)view delay:(CGFloat)seconds completion:(void (^)())completion
//{
//    UIView *inView = view ? view : [UIApplication sharedApplication].keyWindow;
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:inView];
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        NSString *string = [msg stringByReplacingOccurrencesOfString:@" " withString:@""];
//        if (string.length > 0){
//            
//            hud.mode = MBProgressHUDModeIndeterminate;
//            hud.label.text = msg;
//        }
//        [inView addSubview:hud];
//        [hud showAnimated:YES];
//        // 超时自动消失
//        [hud hideAnimated:YES afterDelay:seconds];
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if (completion){
//                completion();
//            }
//        });
//    });
//    return hud;
//}
//
//+ (void)mb_dismiss
//{
//    [QuHudHelper mb_dismiss:nil];
//}
//
//+ (void)mb_dismiss:(NSString *)msg
//{
//    [QuHudHelper mb_dismiss:msg inView:nil];
//}
//
//+ (void)mb_dismiss:(NSString *)msg inView:(UIView *)view
//{
//    UIView *inView = view ? view : [UIApplication sharedApplication].keyWindow;
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        [MBProgressHUD hideHUDForView:inView animated:YES];
//        
//        if (msg.trim.length > 0) {
//            [QuHudHelper qu_showMessage:msg];
//        }
//        
//    });
//}
//
//+ (void)mb_dismiss:(NSString *)msg inView:(UIView *)view delay:(CGFloat)seconds completion:(void (^)())completion
//{
//    UIView *inView = view ? view : [UIApplication sharedApplication].keyWindow;
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        [MBProgressHUD hideHUDForView:inView animated:YES];
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if (completion){
//                completion();
//            }
//        });
//    });
//}
//
//+ (void)mb_stopLoading:(MBProgressHUD *)hud
//{
//    [QuHudHelper mb_stopLoading:hud message:nil];
//}
//
//+ (void)mb_stopLoading:(MBProgressHUD *)hud message:(NSString *)msg
//{
//    [QuHudHelper mb_stopLoading:hud message:msg delay:0 completion:nil];
//}
//
//+ (void)mb_stopLoading:(MBProgressHUD *)hud message:(NSString *)msg delay:(CGFloat)seconds completion:(void (^)())completion
//{
//    if (hud && hud.superview){
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            NSString *string = [msg stringByReplacingOccurrencesOfString:@" " withString:@""];
//            if (string.length > 0){
//                hud.label.text = msg;
//                hud.mode = MBProgressHUDModeText;
//            }
//            
//            [hud hideAnimated:YES afterDelay:seconds];
//            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                if (completion)
//                {
//                    completion();
//                }
//            });
//        });
//    }
//
//}
//
//+ (void)mb_tipMessage:(NSString *)msg
//{
//    [QuHudHelper mb_tipMessage:msg delay:1];
//}
//
//+ (void)mb_tipMessage:(NSString *)msg delay:(CGFloat)seconds
//{
//    [QuHudHelper mb_tipMessage:msg delay:seconds completion:nil];
//}
//
//+ (void)mb_tipMessage:(NSString *)msg delay:(CGFloat)seconds completion:(void (^)())completion
//{
//    NSString *string = [msg stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if (string.length == 0){
//        
//        return;
//    }
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
//        [[UIApplication sharedApplication].keyWindow addSubview:hud];
//        hud.mode = MBProgressHUDModeText;
//        hud.label.text = msg;
//        [hud showAnimated:YES];
//        [hud hideAnimated:YES afterDelay:seconds];
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if (completion)
//            {
//                completion();
//            }
//        });
//    });
//
//}
//
//#pragma mark sv
//+ (void)sv_loading
//{
//    return [QuHudHelper sv_loading:nil];
//}
//
//+ (void)sv_loading:(NSString *)msg
//{
//    if (msg.length > 0) {
//        [SVProgressHUD showWithStatus:msg];
//    }
//    else{
//        [SVProgressHUD show];
//    }
// 
//}
//
//+ (void)sv_dismiss
//{
//    [QuHudHelper sv_dismiss:0.0f];
//}
//
//+ (void)sv_dismiss:(CGFloat)seconds
//{
//    [SVProgressHUD dismissWithDelay:seconds];
//}
//
//+ (void)sv_showErrorWithStatus:(NSString *)status
//{
//    [QuHudHelper sv_showErrorWithStatus:status deley:1.0f];
//}
//
//+ (void)sv_showErrorWithStatus:(NSString *)status deley:(CGFloat)seconds
//{
//    [SVProgressHUD showErrorWithStatus:status];
//    [SVProgressHUD dismissWithDelay:seconds];
//}

#pragma mark custom
+ (void)qu_showMessage:(NSString *)message
{
    [self qu_showMessage:message withEndBlock:nil];
}

+ (void)qu_showMessage:(NSString *)message withEndBlock:(void(^)(void))endBlock
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = .8f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.preferredMaxLayoutWidth = 200;
    [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [showview addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(showview);
    }];
    
    [showview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(window);
        
        make.width.equalTo(label.mas_width).offset(20);
        make.height.equalTo(label.mas_height).offset(20);
    }];
    
    [UIView animateWithDuration:2 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
        if (endBlock) {
            endBlock();
        }
    }];
}

@end
