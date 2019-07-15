//
//  JDBaseTableVC.h
//  FastWine
//
//  Created by MOOSON_ on 2019/3/13.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDBaseTableVC : UITableViewController

- (void)presentLoginWithComplection:(void(^)(void))complectionBlock;

@end

NS_ASSUME_NONNULL_END
