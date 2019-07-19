//
//  BargainHeardCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/7/17.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "BargainHeardCell.h"
#import "RPLoopQueueView.h"
#import "KanListTableCell.h"
#define degreesToRadians(x) (M_PI * x / 180.0)
@implementation BargainHeardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.ibLineImg.transform = CGAffineTransformRotate(self.ibLineImg.transform, M_PI);//控件旋转180
    
//    NSMutableDictionary * dic0 = [NSMutableDictionary dictionary];
//    dic0[@"img"] = @"rpImg_00.jpg";
//    dic0[@"content"] = @"===>>>>>>我是第0个<<<<<<===";
//
//    NSMutableDictionary * dic1 = [NSMutableDictionary dictionary];
//    dic1[@"img"] = @"rpImg_01.jpg";
//    dic1[@"content"] = @"===>>>>>>我是第1个<<<<<<===";
//
//    NSMutableDictionary * dic2 = [NSMutableDictionary dictionary];
//    dic2[@"img"] = @"rpImg_02.jpg";
//    dic2[@"content"] = @"===>>>>>>我是第2个<<<<<<===";
//
//    NSMutableArray * infoArr = [NSMutableArray array];
//    [infoArr addObject:dic0];
//    [infoArr addObject:dic1];
//    [infoArr addObject:dic2];
//
//    RPLoopQueueView * loopView = [[RPLoopQueueView alloc]initWithFrame:CGRectMake(0, 0, self.ibLunboView.qu_w, 50)];
//    loopView.keepSecond = 2;
//    loopView.infoArr = infoArr;
//    [self.ibLunboView addSubview:loopView];
    self.ibKanListTableView.rowHeight = 60;
    self.ibKanListTableView.tableFooterView = [UIView new];

      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(viewEndd) name:CATDETALISEND_NOTIFICATION object:nil];
}
-(void)viewEndd{
    if (_gcdTimer) {
        // 终止定时器
        _timeout == 0;
        dispatch_suspend(_gcdTimer);
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _viewModel.userHelpLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KanListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KanListTableCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"KanListTableCell" owner:nil options:nil][0];
    }
    UserHelpListModel *model = _viewModel.userHelpLists[indexPath.row];
    [cell.ibUserImg sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:Goods_noImage]];
    cell.ibUserName.text = [NSString stringWithFormat:@"%@，帮你砍一刀",model.nickname];
    cell.ibPicLab.text = [NSString stringWithFormat:@"砍了%@元",model.price];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
}
- (IBAction)ibCutBtn:(id)sender {
}
-(void)setViewModel:(CutDetailsRsp *)viewModel{
    _viewModel  = viewModel;
    if (_viewModel) {
        [self.ibGoodsImg sd_setImageWithURL:[NSURL URLWithString:_viewModel.bargain.image] placeholderImage:[UIImage imageNamed:Goods_noImage]];
        self.ibGoodsName.text = _viewModel.bargain.title;
        
        NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价%@元",_viewModel.bargain.price]];
        [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, attriStr.length - 3)];
        [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(attriStr.length - 3, 1)];
        [self.ibYuanjialab setAttributedText:attriStr];
        self.ibYijingKanjiaLab.text = [NSString stringWithFormat:@"砍到%@元拿",_viewModel.bargain.min_price];
        
        NSMutableAttributedString * infoAttriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已砍%@元，还差%@元",_viewModel.selfCutPrice,_viewModel.price]];
        [infoAttriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, viewModel.selfCutPrice.length)];
        [infoAttriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(infoAttriStr.length - (_viewModel.price.length + 1) ,  _viewModel.price.length)];
        [self.ibCutInfoLab setAttributedText:infoAttriStr];
        self.ibYiqiangW.constant = _ibJinduView.qu_size.width  * (_viewModel.pricePercent * 0.01);
        
        [self timerAtion:_viewModel.bargain.stop_time];
        
        if (self.viewModel.pricePercent == 100) {
            //砍价完成
            [self.ibCutbtn setTitle:@"立即购买" forState:UIControlStateNormal];
        }
        [self.ibKanListTableView reloadData];
    }
}
-(void)timerAtion:(NSNumber *)str{
    
    _gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    
    dispatch_source_set_timer(_gcdTimer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    weakSelf(weakSelf);
    dispatch_source_set_event_handler(_gcdTimer, ^{
        
         weakSelf.timeout ++;
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
            self.ibShiLab.text = arr[1];
            self.ibFenLab.text = arr[2];
            self.ibMiaoLab.text = arr[3];
            
            NSLog(@"%@--%@",timeString,enddateStrs);
            
        });
        //间隔5秒执行一下
        if (weakSelf.timeout%5 == 0) {
            [self requestCat];
        }
        
        //        if(gcdIdx == 5) {
        //            // 终止定时器
        //            dispatch_suspend(_gcdTimer);
        //        }
    });
    // 启动任务，GCD计时器创建后需要手动启动
    dispatch_resume(_gcdTimer);
}

-(void)requestCat{
    CutReq *req = [CutReq new];
    req.id = _viewModel.bargain.id;
    req.bargainUid = @"0";
    [[HTTPRequest sharedManager]requestDataWithApiName:cut_con withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        self.viewModel = [CutDetailsRsp mj_objectWithKeyValues:responseObject[@"data"]];
        [self.ibKanListTableView reloadData];
        
        if (self.viewModel.pricePercent == 100) {
            //砍价完成
            [self.ibCutbtn setTitle:@"立即购买" forState:UIControlStateNormal];
        }
    } withError:^(NSError *error) {
        
    }];
}
@end
