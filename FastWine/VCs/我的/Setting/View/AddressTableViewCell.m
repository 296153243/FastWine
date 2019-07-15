//
//  AddressTableViewCell.m
//  EricProject
//
//  Created by boosal on 17/3/17.
//  Copyright © 2017年 enzuo. All rights reserved.
//

#import "AddressTableViewCell.h"
#import "EPOrderUserAddressModel.h"

@interface AddressTableViewCell ()

@end

@implementation AddressTableViewCell

-(void)drawRect:(CGRect)rect {
    _rightImgView.contentMode = UIViewContentModeScaleToFill;
}



- (void)setEpaddressModel:(EPAddressModel *)epaddressModel
{
    _epaddressModel = epaddressModel;
    
    _nameLb.text = [NSString stringWithFormat:@"%@  %@",epaddressModel.real_name,[NSString stringWithFormat:@"%@",epaddressModel.phone]];
    _addressLb.text = [NSString stringWithFormat:@"%@%@",epaddressModel.city,epaddressModel.detail];
    if ([epaddressModel.is_default integerValue] == 1) {
        _ibDefLab.hidden = NO;
        
    }else{
        _ibDefLab.hidden = YES;

    }
}

- (void)setOrderUserAddressModel:(EPOrderUserAddressModel *)orderUserAddressModel
{
    _orderUserAddressModel = orderUserAddressModel;
    
    _nameLb.text = [NSString stringWithFormat:@"%@  %@",orderUserAddressModel.consignee,orderUserAddressModel.contact];
    
    _addressLb.text = [NSString stringWithFormat:@"%@",orderUserAddressModel.detail_address];
    
    _bottomImgView.hidden = YES;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
