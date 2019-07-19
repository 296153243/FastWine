//
//  SecondskillVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/6/18.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "SecondskillVC.h"
#import "KillVC.h"

@interface SecondskillVC ()
@property (weak, nonatomic) IBOutlet UILabel *ibTitlelab;
@property (weak, nonatomic) IBOutlet UILabel *ibTimeLab;
@property(nonatomic,strong)NSMutableArray *subTitles;
@property (weak, nonatomic) IBOutlet UIView *ibTimeView;
@property (weak, nonatomic) IBOutlet UILabel *ibTimeNameLab;
@property (weak, nonatomic) IBOutlet UILabel *ibTianLab;
@property (weak, nonatomic) IBOutlet UILabel *ibShiLab;
@property (weak, nonatomic) IBOutlet UILabel *ibFenLab;
@property (weak, nonatomic) IBOutlet UILabel *ibMaioLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibTop;

@property(nonatomic,strong)dispatch_source_t gcdTimer;
@end

@implementation SecondskillVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    KillVC *vc = [KillVC new];
//    [self.navigationController pushViewController:vc animated:YES];
    

}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = NavColor;
 

//    if (_gcdTimer) {
//        // 终止定时器
//        dispatch_suspend(_gcdTimer);
//    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureContentView];

   
    
}
- (void)configureContentView {
    NSArray *titles             = @[@"周一场",@"周二场",@"周三场",@"周四场",@"周五场",@"周六场",@"周日场"];
    NSArray *titleIdxs   = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    NSMutableArray *controllers = [NSMutableArray new];
    for (int i = 0; i < titles.count; i ++) {
        KillVC *vc    = [[KillVC alloc] initWithNibName:@"KillVC" bundle:nil];
//        vc.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0f];
        [controllers addObject:vc];
     
    }
    // 设置控制器数组
    self.gf_controllers = controllers;
    // 设置标题数组
    self.gf_titles      = titles;
    //确定是哪一天
    NSString *dateStr =  [NSString getweekDayStringWithDate:[NSDate date]];
    NSLog(@"今天是:----%@", [NSString getweekDayStringWithDate:[NSDate date]]);
    self.subTitles = [NSMutableArray array];
    [titleIdxs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *subStr;
        if ([obj integerValue] == [dateStr integerValue]) {
            // 设置初始下标
            self.gf_selectIndex = (int)idx ;
            subStr = @"抢购中";
        }else{
            if ([dateStr integerValue] < [obj integerValue]) {
                 subStr = @"即将开抢";
            }else{
               subStr = @"抢购结束";
            }
           
        }
        [self.subTitles addObject:subStr];
    }];
    if (IS_iPhone678 || IS_iPhone678_Plus) {
        self.ibTop.constant = 135;
    }
    // 设置副标题数组
    self.gf_subTitles   = _subTitles;
  
    self.gf_menuY = 150;
    //   获取当前日期本周内的日期数组
    NSLog(@"weekdays:----%@", [NSString getWeekTime]);
    // 滚动结束后返回当前下标
    WS(weakSelf)
    self.gf_curPageIndexBlock = ^(int curPageIndex) {
        NSLog(@"%d",curPageIndex);
        NSString *str = titleIdxs[curPageIndex];
        [[NSNotificationCenter defaultCenter]postNotificationName:UPLOADMIAOSHADATA_NOTIFICATION object:str];
        if ([dateStr integerValue] <= [str integerValue]) {
           // @"即将开抢";
            //开启定时器
            [weakSelf timerAtion:[NSString getWeekTime][curPageIndex]];
            weakSelf.ibTitlelab.text = @"抢购即将开始";
             weakSelf.ibTimeNameLab.text = @"距本场开始:";
            if ([dateStr integerValue] == [str integerValue]) {
                weakSelf.ibTitlelab.text = @"抢购进行中";
                weakSelf.ibTimeNameLab.text = @"距本场结束:";
            }
            weakSelf.ibTimeView.hidden = NO;
            weakSelf.ibTimeLab.hidden = YES;

        }else{
            if (weakSelf.gcdTimer) {
                dispatch_source_cancel(weakSelf.gcdTimer);
            }
            weakSelf.ibTitlelab.text = @"抢购已结束";
            weakSelf.ibTimeLab.text = @"请查看其他场次抢购";
            weakSelf.ibTimeView.hidden = YES;
            weakSelf.ibTimeLab.hidden = NO;
        }
       
        
    };
    self.gf_menuBackgroundColor = [UIColor clearColor];
    self.gf_normalTitleColor = [UIColor colorWithRed:249/255.0 green:187/255.0 blue:182/255.0 alpha:1.0];
    self.gf_titleTextFont = [UIFont boldSystemFontOfSize:18];
    self.gf_subTitleTextFont = [UIFont systemFontOfSize:11];
    self.gf_selectedTitleColor = [UIColor colorWithRed:255/255.0 green:254/255.0 blue:254/255.0 alpha:1.0];
    self.gf_normalSubTitleColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.gf_normalSubTitleColor = [UIColor colorWithRed:249/255.0 green:187/255.0 blue:182/255.0 alpha:1.0];
    self.gf_maskFillColor =[UIColor clearColor];
    self.gf_subTitleTextHeight = 20;
    [self reloadView];
}
-(void)timerAtion:(NSString *)str{
    
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
         
//            NSLog(@"将字符串转换为日期对象Stardate %@",timeString);
            NSDateFormatter *formatteryear = [[NSDateFormatter alloc] init];
            [formatteryear setTimeZone:timeZone];
            [formatteryear setDateFormat:@"yyyy"];
            NSString *timeYear = [formatteryear stringFromDate:[NSDate date]];
            NSDateFormatter *formatteryue = [[NSDateFormatter alloc] init];
            [formatteryue setTimeZone:timeZone];
            [formatteryue setDateFormat:@"MM"];
            NSString *timeYue = [formatteryue stringFromDate:[NSDate date]];
            NSString *enddateStrs = [NSString stringWithFormat:@"%@-%@-%@ 23:59:59",timeYear,timeYue,str];
           
            NSLog(@"enddate %@",enddateStrs);
            [NSString dateTimeDifferenceWithStartTime:timeString endTime:enddateStrs];
        
            NSArray *arr = [[NSString dateTimeDifferenceWithStartTime:timeString endTime:enddateStrs]componentsSeparatedByString:@","];
            self.ibTianLab.text = arr[0];
            self.ibShiLab.text = arr[1];
            self.ibFenLab.text = arr[2];
            self.ibMaioLab.text = arr[3];


//             NSMutableAttributedString * testAttriString = [[NSMutableAttributedString alloc] initWithString:[NSString dateTimeDifferenceWithStartTime:timeString endTime:enddateStrs]];
//            // label的背景颜色
//            [testAttriString addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(5, testAttriString.length - 5)];
//            [self.ibTimeLab setAttributedText:testAttriString];
        

        });
        
        //        if(gcdIdx == 5) {
        //            // 终止定时器
        //            dispatch_suspend(_gcdTimer);
        //        }
    });
    // 启动任务，GCD计时器创建后需要手动启动
    dispatch_resume(_gcdTimer);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
