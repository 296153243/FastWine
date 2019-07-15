//
//  MyWalletCell.h
//  CLTravel
//
//  Created by MOOSON_ on 2018/10/29.
//  Copyright © 2018年 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyWalletCell : UITableViewCell
@property(nonatomic,strong)NSArray *data;
@property(nonatomic,strong)PromoterListModel *viewModel;
@property (weak, nonatomic) IBOutlet UILabel *ibDetaliTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibDetalisDate;
@property (weak, nonatomic) IBOutlet UILabel *ibDetalisPic;
@property (weak, nonatomic) IBOutlet UIView *ibbgView;
@property (weak, nonatomic) IBOutlet UILabel *ibPicStatus;

@property(nonatomic,strong)NSDictionary *titleDic;
@property (weak, nonatomic) IBOutlet UIImageView *ibIconImg;
@property (weak, nonatomic) IBOutlet UILabel *ibTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *ibContentLab;
@property (weak, nonatomic) IBOutlet UIButton *ibMarkBtn;

@property (weak, nonatomic) IBOutlet UIImageView *myIcon;
@property (weak, nonatomic) IBOutlet UILabel *myName;
@property (weak, nonatomic) IBOutlet UILabel *myTime;
@property (weak, nonatomic) IBOutlet UILabel *myNum;
@property (weak, nonatomic) IBOutlet UIImageView *userVipImg;
@property (weak, nonatomic) IBOutlet UIImageView *userQueenImg;

@end

NS_ASSUME_NONNULL_END
