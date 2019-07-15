//
//  PersonOrderCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/6/10.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllAddressVC.h"
NS_ASSUME_NONNULL_BEGIN
static NSString * PersonOrderCellID = @"PersonOrderCell";

@interface PersonOrderCell : UICollectionViewCell
@property(nonatomic,strong)AccountInfo * accountinfo;
@property(nonatomic,strong)JDBaseVC *controller;

@property (weak, nonatomic) IBOutlet UILabel *ibDaifuNumLab;
@property (weak, nonatomic) IBOutlet UILabel *ibDaifaNumLab;
@property (weak, nonatomic) IBOutlet UILabel *ibDaishouNumLab;
@property (weak, nonatomic) IBOutlet UILabel *ibDaipingLab;
@end

NS_ASSUME_NONNULL_END
