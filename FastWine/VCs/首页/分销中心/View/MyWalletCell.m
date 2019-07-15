//
//  MyWalletCell.m
//  CLTravel
//
//  Created by MOOSON_ on 2018/10/29.
//  Copyright © 2018年 MOOSON_. All rights reserved.
//

#import "MyWalletCell.h"

@implementation MyWalletCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
  
}
-(void)layoutSubviews{
    [super layoutSubviews];
 
//        if (_data.count == 1) {
//            self.ibbgView.clipsToBounds = YES;
//            self.ibbgView.layer.cornerRadius = 10;
//
//        }else if (self.tag == 0 ) {
//            //裁剪上半
//            [self.ibbgView addViewHalfTopChange];
//        }else if (self.tag == _data.count - 1){
//            //裁剪下半
//            [self.ibbgView addViewHalfBottomChange];
//        }
    
    if (self.tag == _data.count - 1) {
         //裁剪下半
         [self.ibbgView addViewHalfBottomChange];
    }
    if (self.tag == _data.count - 1) {
        self.separatorInset = UIEdgeInsetsMake(0, 1500, 0, 0);
    }
   
}
-(void)setData:(NSArray *)data{
    _data = data;
    BalanceListModel *model = _data[self.tag];
    self.ibDetaliTitle.text =  model.mark;
    self.ibDetalisDate.text = model.add_time;
    if ([model.pm integerValue] == 0) {
        self.ibDetalisPic.text = [NSString stringWithFormat:@"- %@",model.number];
    }else{
        self.ibDetalisPic.text = [NSString stringWithFormat:@"+ %@",model.number];
    }
    if (model.status == 0) {
        _ibPicStatus.text = @"未到账";
    }else{
        _ibPicStatus.text = @"已到账";

    }

   
}
-(void)setViewModel:(PromoterListModel *)viewModel{
    _viewModel =viewModel;
    if (_viewModel) {
        [self.myIcon sd_setImageWithURL:[NSURL URLWithString:_viewModel.avatar] placeholderImage:[UIImage imageNamed:AvatarDefault]];
        self.myName.text = _viewModel.nickname;
        self.myTime.text = _viewModel.add_time;
        self.myNum.text = [NSString stringWithFormat:@"%@元",_viewModel.money];
        if (_viewModel.agent_id == 0 || _viewModel.agent_id == 1) {
            _userVipImg.hidden = NO;
        }else if (_viewModel.agent_id == 3){
           _userQueenImg.hidden = NO;
           _userVipImg.hidden = NO;

        }
    }
}
-(void)setTitleDic:(NSDictionary *)titleDic{
    _titleDic = titleDic;
    if (_titleDic) {
        self.ibTitleLab.text = _titleDic[@"title"];
        self.ibIconImg.image = [UIImage imageNamed:_titleDic[@"titleImg"]];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
