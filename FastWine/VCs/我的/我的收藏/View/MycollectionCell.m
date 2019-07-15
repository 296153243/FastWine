//
//  MycollectionCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/5/5.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "MycollectionCell.h"

@implementation MycollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setViewModel:(CollectListModel *)viewModel{
    _viewModel = viewModel;
    if (_viewModel) {
        self.ibName.text = _viewModel.store_name;
        self.ibPic.text = [NSString stringWithFormat:@"¥%@",_viewModel.price];
        self.ibNum.text = [NSString stringWithFormat:@"销量:%@",_viewModel.sales];;
        [self.ibIcon sd_setImageWithURL:[NSURL URLWithString:_viewModel.image] placeholderImage:[UIImage imageNamed:AvatarDefault]];

    }
}
- (IBAction)ibDelectClick:(id)sender {
    if (_clickDelectBlock) {
        _clickDelectBlock(_viewModel);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
