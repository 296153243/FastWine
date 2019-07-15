//
//  OwersCustomerCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/6/15.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * OwersCustomerCellID = @"OwersCustomerCell";

@interface OwersCustomerCell : UICollectionViewCell
@property(nonatomic,strong)GetWalletModel *dataRsp;
@property(nonatomic,strong)JDBaseVC *controller;

@property (weak, nonatomic) IBOutlet UILabel *ibWodejiamengshang;
@property (weak, nonatomic) IBOutlet UILabel *wodefensi;
@property (weak, nonatomic) IBOutlet UILabel *ibWodeyaoqingren;

@end

NS_ASSUME_NONNULL_END
