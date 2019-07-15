//
//  ClassCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/5/28.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagsFrame.h"
NS_ASSUME_NONNULL_BEGIN

@interface ClassCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ibTitleLab;
@property (weak, nonatomic) IBOutlet UIView *ibtagView;
@property (nonatomic, strong) TagsFrame *tagsFrame;
@property(nonatomic,copy)void(^classBtnClickBlock)(NSInteger idx);
@end

NS_ASSUME_NONNULL_END
