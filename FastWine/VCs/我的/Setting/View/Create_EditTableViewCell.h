//
//  Create_EditTableViewCell.h
//  EricProject
//
//  Created by boosal on 17/3/20.
//  Copyright © 2017年 enzuo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PLUITextView.h"
//编辑地址栏使用
@interface Create_EditTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *ibTitleLab;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *ibAddressLab;
@property (weak, nonatomic) IBOutlet PLUITextView *ibAddressDtalisTV;
@property (weak, nonatomic) IBOutlet UISwitch *ibSwitch;

@end
