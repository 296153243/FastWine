//
//  BargainingCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/7/17.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BargainingCell : UITableViewCell
@property(nonatomic,strong)CutListModel *viewModel;
@property (weak, nonatomic) IBOutlet UIImageView *ibGoodsImg;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodsNameLab;
@property (weak, nonatomic) IBOutlet UILabel *ibyijingkanjiaLab;
@property (weak, nonatomic) IBOutlet UIView *ibTimeView;
@property (weak, nonatomic) IBOutlet UILabel *ibKandaoLab;

@property (weak, nonatomic) IBOutlet UILabel *ibTianLab;
@property (weak, nonatomic) IBOutlet UILabel *ibShiLab;
@property (weak, nonatomic) IBOutlet UILabel *ibFenLab;
@property (weak, nonatomic) IBOutlet UILabel *ibMaioLab;
@property (weak, nonatomic) IBOutlet UIButton *ibBtn;

@property(nonatomic,strong)dispatch_source_t gcdTimer;

@end

NS_ASSUME_NONNULL_END
