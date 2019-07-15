//
//  VersionContentView.h
//  QuPassenger
//
//  Created by 朱青 on 2018/2/9.
//  Copyright © 2018年 com.Qyueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VersionContentView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UIView *btnView;

@end
