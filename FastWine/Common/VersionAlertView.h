//
//  VersionAlertView.h
//  QuPassenger
//
//  Created by 朱青 on 2018/2/9.
//  Copyright © 2018年 com.Qyueche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VersionContentView.h"

typedef void (^VersionAlertBlockHandler)(void);

@interface VersionAlertView : NSObject
{
    UIView *backgroundView;
    
    NSMutableArray *alertViewQueue;
}
@property (strong, nonatomic) VersionContentView *showView;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *mesage;
@property (copy, nonatomic) VersionAlertBlockHandler dismissBlock;
@property (copy, nonatomic) VersionAlertBlockHandler selectBlock;

- (id)initWithAlertTitle:(NSString *)title message:(NSString *)message cancelHandler:(VersionAlertBlockHandler)cancelHandler confirmHandler:(VersionAlertBlockHandler)confirmHandler;

- (void)show;

@end
