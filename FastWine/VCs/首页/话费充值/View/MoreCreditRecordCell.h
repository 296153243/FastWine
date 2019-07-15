//
//  MoreCreditRecordCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/4/19.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoreCreditRecordCell : UITableViewCell
@property(nonatomic,strong)PhoneOrderListModel *viewModel;
@property (weak, nonatomic) IBOutlet UILabel *ibTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *ibPhoneLab;
@property (weak, nonatomic) IBOutlet UILabel *ibTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *ibPicLab;

@end

NS_ASSUME_NONNULL_END
