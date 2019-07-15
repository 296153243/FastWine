//
//  SecondskillCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/6/18.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "SecondskillCell.h"
@interface SecondskillCell()
@property (weak, nonatomic) IBOutlet UIView *ibBGView;
@property (weak, nonatomic) IBOutlet UIImageView *ibgoodsImg;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodsContent;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodName;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodsPic;
@property (weak, nonatomic) IBOutlet UILabel *ibOtPicLab;

@property (weak, nonatomic) IBOutlet UILabel *ibYueShouLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibgoodsImgH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibgoodsImgW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibXiaoliangLabW;
@property (weak, nonatomic) IBOutlet UILabel *ibBaifenLab;
@property (weak, nonatomic) IBOutlet UILabel *ibYiqianggouLab;
@property (weak, nonatomic) IBOutlet UIView *ibXiaoliangBgV;

@end
@implementation SecondskillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     self.backgroundColor= [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.01];
//    self.backgroundColor = [UIColor clearColor];
//    self.backgroundView.backgroundColor = [UIColor clearColor];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (_dataArr.count == 1) {
        self.ibBGView.clipsToBounds = YES;
        self.ibBGView.layer.cornerRadius = 10;
        
    }else if (self.tag == 0 ) {
        //裁剪上半
        [self.ibBGView addViewHalfTopChange];
    }else if (self.tag == _dataArr.count - 1){
        //裁剪下半
        [self.ibBGView addViewHalfBottomChange];
    }
    
}
-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    if (_dataArr ) {
        MainGoodsModel *viewModel = _dataArr[self.tag];
        self.ibGoodName.text = viewModel.title;
         self.ibGoodsContent.text = viewModel.info;
        self.ibGoodsPic.text = [NSString stringWithFormat:@"¥ %@",viewModel.price];
        if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1) {
            self.ibGoodsPic.text = [NSString stringWithFormat:@"¥ %@",viewModel.vip_price];
        }
        //原价富文本
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:viewModel.ot_price];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, viewModel.ot_price.length)];[attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, viewModel.ot_price.length)];
        [self.ibOtPicLab setAttributedText:attri];
 
        //        NSString *sss = @"200";
        float baifen;
        float xiaoliang ;
        xiaoliang = [viewModel.ficti floatValue] +  [viewModel.sales floatValue];
        baifen = ([viewModel.ficti floatValue] +  [viewModel.sales floatValue]) /[viewModel.stock floatValue];
        self.ibBaifenLab.text = [NSString stringWithFormat:@"%.0f%%",baifen * 100];
        self.ibYiqianggouLab.text = [NSString stringWithFormat:@"  已抢购:%.0f",xiaoliang];
        //        [self changeMultiplierOfConstraint:_iblabW multiplier:baifen];
        self.ibXiaoliangLabW.constant = _ibXiaoliangBgV.qu_size.width  * baifen;
        //        NSLog(@"%.2f-----%.2f-----%.0f",[_viewModel.sales floatValue],[_viewModel.stock floatValue], baifen * 100);
        [self.ibgoodsImg sd_setImageWithURL:[NSURL URLWithString:viewModel.image]placeholderImage:[UIImage imageNamed:@"goods_noImage"]];
      
    }
}
-(void)setViewStatus:(NSInteger)viewStatus{
    _viewStatus = viewStatus;
    if (_viewStatus) {
        if (_viewStatus == 1) {
            [self.ibCellBtn setTitle:@"原价购买" forState:UIControlStateNormal];
            [self.ibCellBtn setImage:[UIImage imageNamed:@"mark_red"] forState:UIControlStateNormal];
            [self.ibCellBtn setTitleColor:HEXCOLOR(@"#E31436") forState:UIControlStateNormal];
            self.ibCellBtn.layer.borderColor = [HEXCOLOR(@"#E31436")CGColor];
        }else if (_viewStatus == 2){
            [self.ibCellBtn setTitle:@"马上抢" forState:UIControlStateNormal];
            [self.ibCellBtn setImage:[UIImage imageNamed:@"mark_red"] forState:UIControlStateNormal];
            self.ibCellBtn.layer.borderColor = [HEXCOLOR(@"#E31436")CGColor];
            [self.ibCellBtn setTitleColor:HEXCOLOR(@"#E31436") forState:UIControlStateNormal];

        }else if (_viewStatus == 3){
            [self.ibCellBtn setTitle:@"开抢提醒" forState:UIControlStateNormal];
            [self.ibCellBtn setImage:[UIImage imageNamed:@"mark_Green"] forState:UIControlStateNormal];
            [self.ibCellBtn setTitleColor:HEXCOLOR(@"#0A9F26") forState:UIControlStateNormal];
            self.ibCellBtn.layer.borderColor = [HEXCOLOR(@"#0A9F26")CGColor];
            self.ibGoodsPic.textColor = HEXCOLOR(@"#019C1E");

        }
        self.ibCellBtn.tag = _viewStatus;
        
    }
}
- (IBAction)ibMashangqiangBtnClick:(UIButton *)sender {
    if (_btnClickBlock) {
        _btnClickBlock(sender.tag);
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
