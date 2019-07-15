//
//  UITableView+FooterBlank.h
//  FreshFood
//
//  Created by cssmk_jzb on 2017/7/10.
//  Copyright © 2017年 FreshFood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (FooterBlank)

- (void)setTableFooterViewBlank;

-(void)setLastCellSeperatorToLeft:(UITableViewCell*)cell;

- (void)setContentInsetAdjustmentBehaviorNever;

@end
