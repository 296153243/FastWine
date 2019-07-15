//
//  LoginViewController.h
//  QuDriver
//
//  Created by 朱青 on 2017/9/21.
//  Copyright © 2017年 com.Qyueche. All rights reserved.
//

#import "BaseInputVC.h"

@interface LoginViewController : JDBaseVC

@property (copy, nonatomic) void (^loginCompletionBlock) (void);

@end
