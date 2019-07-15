//
//  KillVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/6/18.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "KillVC.h"
#import "SecondskillCell.h"
#import "GoodsDetalisVC.h"
#import "EventCalendar.h"
#import "KillGoodsDetalisVC.h"
@interface KillVC ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property(nonatomic,strong)MainGoodsRsp *goodsRsp;
@property(nonatomic)NSInteger viewStatus;//1:结束 2进行中  3位开始
@property(nonatomic)NSInteger idx;
@end

@implementation KillVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //接收刷新数据通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(uploadMiaoshaData:)
                                                 name:UPLOADMIAOSHADATA_NOTIFICATION
                                               object:nil];
    self.ibTableView.tableFooterView = [UIView new];
    _ibTableView.emptyDataSetSource = self;
    _ibTableView.emptyDataSetDelegate = self;
  
}
-(void)uploadMiaoshaData:(NSNotification *)notification{
    NSString *str = [notification object];
    NSLog(@"notification:%@",str);
    _idx = [str integerValue];
    NSString *dateStr =  [NSString getweekDayStringWithDate:[NSDate date]];
    if ([dateStr integerValue] <= [str integerValue]) {
        // 抢购即将开始
        _viewStatus = 3;
        if ([dateStr integerValue] == [str integerValue]) {
          //  抢购进行中";
            _viewStatus = 2;
        }
        
    }else{
        //"抢购已结束";
        _viewStatus = 1;

    }
    [self requestClassDataWithWeek:str];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 140;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.goodsRsp.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SecondskillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SecondskillCell"];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"SecondskillCell" owner:nil options:nil][0];
    }
    if (_goodsRsp.data) {
        cell.tag = indexPath.row;
        cell.dataArr = _goodsRsp.data;
    }
    cell.viewStatus = _viewStatus;
    cell.btnClickBlock = ^(NSInteger btnTag) {
//        1:结束 2进行中  3位开始
        if (btnTag == 1) {
            //
            GoodsDetalisVC *vc = [[GoodsDetalisVC alloc]initWithNibName:@"GoodsDetalisVC" bundle:nil];
            MainGoodsModel *model = self.goodsRsp.data[indexPath.row];
            vc.goodsId = model.product_id;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (btnTag == 2){
            KillGoodsDetalisVC *vc = [[KillGoodsDetalisVC alloc]initWithNibName:@"KillGoodsDetalisVC" bundle:nil];
            MainGoodsModel *model = self.goodsRsp.data[indexPath.row];
            vc.goodsId = model.id;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (btnTag == 3){
            //开抢提醒
            EventCalendar *calendar = [EventCalendar sharedEventCalendar];
            
            NSCalendar *calend = [NSCalendar currentCalendar];
            NSDate *now = [NSDate date];
            NSDateComponents *components = [calend components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
            NSDate *startDate = [calend dateFromComponents:components];
            NSDate *endDate = [calend dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
            
            NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
            //            NSLog(@"将字符串转换为日期对象Stardate %@",timeString);
            NSDateFormatter *formatteryear = [[NSDateFormatter alloc] init];
            [formatteryear setTimeZone:timeZone];
            [formatteryear setDateFormat:@"yyyy"];
            NSString *timeYear = [formatteryear stringFromDate:[NSDate date]];
            NSDateFormatter *formatteryue = [[NSDateFormatter alloc] init];
            [formatteryue setTimeZone:timeZone];
            [formatteryue setDateFormat:@"MM"];
            NSString *timeYue = [formatteryue stringFromDate:[NSDate date]];
            NSString *enddateStrs = [NSString stringWithFormat:@"%@-%@-%@ 00:00:00",timeYear,timeYue,[NSString getWeekTime][self.idx - 1]];
           
           NSDate *someDay = [NSString dateWithString:enddateStrs];
//            NSLog(@"将字符串转换为日期对象Stardate %@",someDay);

           MainGoodsModel *model = self.goodsRsp.data[indexPath.row];
            [calendar createEventCalendarTitle:@"秒杀活动开抢提醒" location:[NSString stringWithFormat:@"《%@》的活动已经开始,赶快去九弟智选抢购吧",model.title] startDate:someDay endDate:someDay allDay:YES alarmArray:@[@"-3000"]];
        }
    };
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //      1:结束 2进行中  3位开始
    if (_viewStatus == 1) {
        //
        GoodsDetalisVC *vc = [[GoodsDetalisVC alloc]initWithNibName:@"GoodsDetalisVC" bundle:nil];
        MainGoodsModel *model = self.goodsRsp.data[indexPath.row];
        vc.goodsId = model.product_id;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (_viewStatus == 2){
        KillGoodsDetalisVC *vc = [[KillGoodsDetalisVC alloc]initWithNibName:@"KillGoodsDetalisVC" bundle:nil];
        MainGoodsModel *model = self.goodsRsp.data[indexPath.row];
        vc.goodsId = model.id;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (_viewStatus == 3){
        [QuHudHelper qu_showMessage:@"此商品暂未开抢"];
        GoodsDetalisVC *vc = [[GoodsDetalisVC alloc]initWithNibName:@"GoodsDetalisVC" bundle:nil];
        MainGoodsModel *model = self.goodsRsp.data[indexPath.row];
        vc.goodsId = model.product_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
#pragma mark - EmptyDataSet

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *titleStr;
    NSAttributedString *attributrStr;
    NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#b3b3b3"],
                          NSFontAttributeName : [UIFont systemFontOfSize:13]};
    titleStr = @"暂无商品";
    attributrStr = [[NSAttributedString alloc] initWithString:titleStr attributes:dic];
    return attributrStr;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"NoneData_Icon"];
}
//MARK:----商品分类
-(void)requestClassDataWithWeek:(NSString * )week{
    KillReq *req = [KillReq new];
//    req.start_time = [NSString stringWithFormat:@"%.0f",[starTime timeIntervalSince1970]];
//    req.end_time = [NSString stringWithFormat:@"%.0f",[endTime timeIntervalSince1970]];
    req.week = week;
    [[HTTPRequest sharedManager]requestDataWithApiName:seckill_index withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        self.goodsRsp = [MainGoodsRsp mj_objectWithKeyValues:responseObject];

        [self.ibTableView reloadData];
    } withError:^(NSError *error) {
        
    }];
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
