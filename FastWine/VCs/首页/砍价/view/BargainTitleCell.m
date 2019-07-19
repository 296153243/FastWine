//
//  BargainTitleCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/7/18.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "BargainTitleCell.h"

@implementation BargainTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.ibLinImg.transform = CGAffineTransformRotate(self.ibLinImg.transform, M_PI);//控件旋转180
}

@end
