//
//  KillVC.h
//  FastWine
//
//  Created by MOOSON_ on 2019/6/18.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KillVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
-(void)uploadMiaoshaData:(NSNotification *)notification;
@end

NS_ASSUME_NONNULL_END
