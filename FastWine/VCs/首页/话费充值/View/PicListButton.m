//
//  PicListButton.m
//  FastWine
//
//  Created by MOOSON_ on 2019/4/17.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "PicListButton.h"

@implementation PicListButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = HEXCOLOR(@"#FFEDEDF1");
        //        [aBt setTitleColor:HEXCOLOR(@"#FF323337") forState:UIControlStateNormal];
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 10;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [HEXCOLOR(@"#FF0000") CGColor];
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0,5, self.qu_w, self.qu_h/2)];
//        _titleLab.backgroundColor = [UIColor grayColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.textColor = HEXCOLOR(@"#FF0000");
        [self insertSubview:_titleLab atIndex:0];
        
        _subTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0,self.qu_h/2 -5, self.qu_w, self.qu_h/2)];
//      _subTitleLab.backgroundColor = [UIColor purpleColor];
        _subTitleLab.textAlignment = NSTextAlignmentCenter;
        _subTitleLab.font = [UIFont systemFontOfSize:10];
        _subTitleLab.textColor = HEXCOLOR(@"#FF0000");
        [self insertSubview:_subTitleLab atIndex:0];
    }
    
    return self;
}

-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    if (_titleStr) {
        _titleLab.text = _titleStr;
    }
}
-(void)setSubtitleStr:(NSString *)subtitleStr{
    _subtitleStr = subtitleStr;
    if (_subtitleStr) {
        _subTitleLab.text = _subtitleStr;
    }
}

@end
