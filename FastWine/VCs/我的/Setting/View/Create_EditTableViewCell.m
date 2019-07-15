//
//  Create_EditTableViewCell.m
//  EricProject
//
//  Created by boosal on 17/3/20.
//  Copyright © 2017年 enzuo. All rights reserved.
//

#import "Create_EditTableViewCell.h"

@implementation Create_EditTableViewCell

-(void)drawRect:(CGRect)rect {
   // _textField.delegate = self;
}

/* 代理方法瞎搞
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [_textField resignFirstResponder];
    if ([string isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
