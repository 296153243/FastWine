//
//  BargainHeardCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/7/17.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * BargainHeardID = @"BargainHeardCell";
@interface BargainHeardCell : UICollectionViewCell
@property(nonatomic,strong)CutDetailsRsp *viewModel;
@property (weak, nonatomic) IBOutlet UITableView *ibKanListTableView;
@property (weak, nonatomic) IBOutlet UIImageView *ibLineImg;
@property (weak, nonatomic) IBOutlet UIView *ibLunboView;

@property (weak, nonatomic) IBOutlet UIImageView *ibGoodsImg;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodsName;
@property (weak, nonatomic) IBOutlet UILabel *ibYuanjialab;
@property (weak, nonatomic) IBOutlet UILabel *ibYijingKanjiaLab;
@property (weak, nonatomic) IBOutlet UILabel *ibShiLab;
@property (weak, nonatomic) IBOutlet UILabel *ibFenLab;
@property (weak, nonatomic) IBOutlet UILabel *ibMiaoLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibYiqiangW;
@property (weak, nonatomic) IBOutlet UIButton *ibCutbtn;

@property (weak, nonatomic) IBOutlet UILabel *ibCutInfoLab;
@property(nonatomic,strong)dispatch_source_t gcdTimer;
@property (weak, nonatomic) IBOutlet UIView *ibJinduView;
@property(nonatomic,assign) __block NSInteger timeout;

@end

NS_ASSUME_NONNULL_END
