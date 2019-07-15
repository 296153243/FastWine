//
//  ClassCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/5/28.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "ClassCell.h"

@implementation ClassCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setTagsFrame:(TagsFrame *)tagsFrame
{
    _tagsFrame = tagsFrame;
    
    // 解决cell重用时的bug
//    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _ibTitleLab.text = tagsFrame.sectionTitle;
    for (NSInteger i = 0; i < tagsFrame.tagsArray.count; i++) {
        UIButton *tagsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tagsBtn setTitle:tagsFrame.tagsArray[i] forState:UIControlStateNormal];
        [tagsBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        tagsBtn.titleLabel.font = TagsTitleFont;
        tagsBtn.backgroundColor = RGBACOLOR(243, 243, 243, 1);
//        tagsBtn.layer.borderWidth   = 1;
//        tagsBtn.layer.borderColor   = [UIColor lightGrayColor].CGColor;
        tagsBtn.layer.cornerRadius  = 4;
        tagsBtn.layer.masksToBounds = YES;
        tagsBtn.frame = CGRectFromString(tagsFrame.tagsFrames[i]);
        [tagsBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        tagsBtn.tag = i;
        [self.ibtagView addSubview:tagsBtn];
    }
}
-(void)btnAction:(UIButton *)sender{
    if (_classBtnClickBlock) {
        _classBtnClickBlock(sender.tag);
    }
}
@end
