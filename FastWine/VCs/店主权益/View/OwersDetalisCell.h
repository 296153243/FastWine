//
//  OwersDetalisCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/6/15.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * OwersDetalisCellID = @"OwersDetalisCell";

@interface OwersDetalisCell : UICollectionViewCell
@property(nonatomic,strong)GetWalletModel *dataRsp;
@property(nonatomic,strong)JDBaseVC *controller;

@property (weak, nonatomic) IBOutlet UILabel *ibleijishouyi;
@property (weak, nonatomic) IBOutlet UILabel *ibJInrishouyi;
@property (weak, nonatomic) IBOutlet UILabel *ibYitixian;
@property (weak, nonatomic) IBOutlet UILabel *jinriyitixian;
@property (weak, nonatomic) IBOutlet UILabel *ibWeidaozhang;
@property (weak, nonatomic) IBOutlet UILabel *ibJinriweidaozhang;
@property (weak, nonatomic) IBOutlet UILabel *ibYueLab;
@property (weak, nonatomic) IBOutlet UILabel *ibKetixianyueLab;

@end

NS_ASSUME_NONNULL_END
