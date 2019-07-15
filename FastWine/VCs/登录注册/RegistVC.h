//
//  RegistVC.h
//  FastWine
//
//  Created by MOOSON_ on 2019/5/29.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegistVC : UIViewController
@property(nonatomic,strong)NSString *type;//type=2 验证码登录 type=3微信登录
@property(nonatomic)BOOL isregist;//是否来注册
@property(nonatomic)NSString *phone ;
@end

NS_ASSUME_NONNULL_END
