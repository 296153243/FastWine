//
//  BargainingCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/7/17.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "BargainingCell.h"

@implementation BargainingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(viewEnd) name:CATVIVWEND_NOTIFICATION object:nil];
}
-(void)viewEnd{
    if (_gcdTimer) {
        // 终止定时器
        dispatch_suspend(_gcdTimer);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setViewModel:(CutListModel *)viewModel{
    _viewModel = viewModel;
    if (_viewModel) {
        [self timerAtion:viewModel.stop_time];
//        self.ibyijingkanjiaLab.text =
    }
}
-(void)timerAtion:(NSNumber *)str{
    
    _gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    
    dispatch_source_set_timer(_gcdTimer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    
    dispatch_source_set_event_handler(_gcdTimer, ^{
        
        
        //进入主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
            [formatter setTimeZone:timeZone];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *timeString = [formatter stringFromDate:[NSDate date]];
            
            NSString *str1=[NSString stringWithFormat:@"%@",str];
            int x=[[str1 substringToIndex:10] intValue];
            NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:x];NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];[dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //        NSLog(@"时间戳对应的时间是:%@",[dateformatter stringFromDate:date1]);
    
            NSString *enddateStrs =  [dateformatter stringFromDate:date1];;
            
            [NSString dateTimeDifferenceWithStartTime:timeString endTime:enddateStrs];
            
            NSArray *arr = [[NSString dateTimeStartTime:timeString endTime:enddateStrs]componentsSeparatedByString:@","];
            self.ibTianLab.text = arr[0];
            self.ibShiLab.text = arr[1];
            self.ibFenLab.text = arr[2];
            self.ibMaioLab.text = arr[3];

            NSLog(@"%@--%@",timeString,enddateStrs);
            
        });
        
        //        if(gcdIdx == 5) {
        //            // 终止定时器
        //            dispatch_suspend(_gcdTimer);
        //        }
    });
    // 启动任务，GCD计时器创建后需要手动启动
    dispatch_resume(_gcdTimer);
}
@end
