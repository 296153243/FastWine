//
//  OwnersTitleCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/6/15.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * OwnersTitleCellID = @"OwnersTitleCell";

@interface OwnersTitleCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *ibDialiTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *ibDailiContent;
@property (weak, nonatomic) IBOutlet UILabel *ibSubTitleLab;
@property(nonatomic,strong)GetWalletModel *viewModel;
@end

NS_ASSUME_NONNULL_END
