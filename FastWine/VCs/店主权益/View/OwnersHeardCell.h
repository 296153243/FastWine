//
//  OwnersHeardCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/6/15.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * OwnersHeardCellID = @"OwnersHeardCell";

@interface OwnersHeardCell : UICollectionViewCell
@property(nonatomic,strong)AccountInfo * accountinfo;
@property(nonatomic,strong)JDBaseVC *controller;
@property(nonatomic,strong)GetWalletModel *dataModel;

@property (weak, nonatomic) IBOutlet UIImageView *ibUserIcon;
@property (weak, nonatomic) IBOutlet UILabel *ibUserName;
@property (weak, nonatomic) IBOutlet UILabel *ibYaoqingma;
@property (weak, nonatomic) IBOutlet UILabel *ibshenfen;
@property (weak, nonatomic) IBOutlet UILabel *ibYe;
@property (weak, nonatomic) IBOutlet UIView *ibMoneyView;
@property (weak, nonatomic) IBOutlet UILabel *ibLeijihuode;
@property (weak, nonatomic) IBOutlet UILabel *ibYujihuodeLab;
@property (weak, nonatomic) IBOutlet UIButton *ibQushengjiBtn;

@property (weak, nonatomic) IBOutlet UIButton *ibCodeBtn;

@end

NS_ASSUME_NONNULL_END
