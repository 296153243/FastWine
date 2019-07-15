//
//  BaseWKWebController.h
//  CLTravel
//
//  Created by MOOSON_ on 2018/11/28.
//  Copyright © 2018年 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseWKWebController : BasicVC
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *titleStr;
@property(nonatomic,strong)NSString *jsonStr;

@end

NS_ASSUME_NONNULL_END
