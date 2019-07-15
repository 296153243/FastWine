//
//  UITableView+FooterBlank.m
//  FreshFood
//
//  Created by cssmk_jzb on 2017/7/10.
//  Copyright © 2017年 FreshFood. All rights reserved.
//

#import "UITableView+FooterBlank.h"

@implementation UITableView (FooterBlank)

- (void)setTableFooterViewBlank
{
    UIView *view = [UIView new];
    [self setTableFooterView:view];
}

-(void)setLastCellSeperatorToLeft:(UITableViewCell*)cell
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

- (void)setContentInsetAdjustmentBehaviorNever
{
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}


@end
