//
//  OwersKefuCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/6/15.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "OwersKefuCell.h"
#import "QMHomeViewController.h"
#import "IhaveGoodsVC.h"
@implementation OwersKefuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)shangwulianxi:(id)sender {
    //我有好货
    IhaveGoodsVC *vc= [[IhaveGoodsVC alloc]initWithNibName:@"IhaveGoodsVC" bundle:nil];
    [self.controller.navigationController pushViewController:vc animated:YES];
    
}

@end
