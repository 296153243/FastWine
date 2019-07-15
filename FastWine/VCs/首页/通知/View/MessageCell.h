//
//  MessageCell.h
//  CLTravel
//
//  Created by MOOSON_ on 2018/11/5.
//  Copyright © 2018年 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ibTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *ibContentLab;
@property (weak, nonatomic) IBOutlet UILabel *ibTimeLab;

@end

NS_ASSUME_NONNULL_END
