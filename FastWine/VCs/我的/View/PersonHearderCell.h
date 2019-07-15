//
//  PersonHearderCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/6/10.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * PersonHearderCellID = @"PersonHearderCell";

@interface PersonHearderCell : UICollectionViewCell
@property(nonatomic,strong)AccountInfo * accountinfo;
@property(nonatomic,strong)JDBaseVC *controller;
@property (weak, nonatomic) IBOutlet UIImageView *ibUserIcon;
@property (weak, nonatomic) IBOutlet UILabel *ibUserName;
@property (weak, nonatomic) IBOutlet UILabel *ibUserRole;
@property (weak, nonatomic) IBOutlet UILabel *ibYaoqingma;
@property (weak, nonatomic) IBOutlet UILabel *ibYueLab;
@property (weak, nonatomic) IBOutlet UILabel *ibYueValue;
@property (weak, nonatomic) IBOutlet UILabel *ibShoucangValue;
@property (weak, nonatomic) IBOutlet UILabel *ibZujiValue;
@property (weak, nonatomic) IBOutlet UILabel *ibYouhuiquanValue;
@property (weak, nonatomic) IBOutlet UILabel *ibHUodongLab;
@property (weak, nonatomic) IBOutlet UIButton *ibKaitongAction;
@property(nonatomic,copy)void(^iconClickBlock)();
@end

NS_ASSUME_NONNULL_END
