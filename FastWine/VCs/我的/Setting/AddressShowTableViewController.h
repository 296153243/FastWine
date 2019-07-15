//
//  AddressShowTableViewController.h
//  EricProject
//
//  Created by boosal on 17/3/20.
//  Copyright © 2017年 enzuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
@class EPAddressModel;

typedef enum {
    Address_Edit,
    Address_Create,
}page_Type;

@interface AddressShowTableViewController : UITableViewController

/**
 要编辑的地址
 */
@property (nonatomic, strong) AddressModel *addressModel;

@property (nonatomic, strong) EPAddressModel *epaddressModel;

-(instancetype)initWithPageType:(page_Type)pageType;

@end
