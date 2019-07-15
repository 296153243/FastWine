//
//  AddressTableViewCell.h
//  EricProject
//
//  Created by boosal on 17/3/17.
//  Copyright © 2017年 enzuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
#import "EPAddressModel.h"

@class EPOrderUserAddressModel;
@interface AddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImgView;
@property (weak, nonatomic) IBOutlet UILabel *ibDefLab;

@property (nonatomic, strong) AddressModel *addressModel;
@property (nonatomic, strong) EPAddressModel *epaddressModel;
@property (nonatomic, strong) EPOrderUserAddressModel *orderUserAddressModel;

@end
