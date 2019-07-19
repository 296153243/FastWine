//
//  BargainingVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/7/17.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "BargainingVC.h"
#import "BargainingCell.h"
#import "BargainDetalisVC.h"
@interface BargainingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property(nonatomic,strong)CutListRsp *dataRsp;

@end

@implementation BargainingVC
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:CATVIVWEND_NOTIFICATION object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
   [self requestData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"砍价免费拿";
    self.ibTableView.rowHeight = 130;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _dataRsp.involved.count;

    }
    return   [_dataRsp.normal count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BargainingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BargainingCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"BargainingCell" owner:nil options:nil][0];
    }
    if (indexPath.section == 0) {
        CutListModel *model = _dataRsp.involved[indexPath.row];
        [cell.ibGoodsImg sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:Goods_noImage]];
        cell.ibGoodsNameLab.text = model.title;
        cell.viewModel = model;
        cell.ibKandaoLab.hidden = YES;
        [cell.ibBtn setTitle:@"继续砍价" forState:UIControlStateNormal];
        [cell.ibBtn addTarget:self action:@selector(kanjiaBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        //        self.ibYe.text = ACCOUNTINFO.userInfo.now_money;
        NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已砍%@元",model.price]];
        [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, attriStr.length - 3)];
        [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(attriStr.length - 3, 1)];
        [cell.ibyijingkanjiaLab setAttributedText:attriStr];

    }else{
        CutListModel *model = _dataRsp.normal[indexPath.row];
        [cell.ibGoodsImg sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:Goods_noImage]];
        cell.ibGoodsNameLab.text = model.title;
        cell.ibTimeView.hidden = YES;
        cell.ibKandaoLab.text = [NSString stringWithFormat:@"砍到%@元拿",model.min_price];
        [cell.ibBtn setTitle:@"点我砍价" forState:UIControlStateNormal];
        [cell.ibBtn addTarget:self action:@selector(kanjiaBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已砍%@元",model.price]];
        [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, attriStr.length - 3)];
        [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(attriStr.length - 3, 1)];
        [cell.ibyijingkanjiaLab setAttributedText:attriStr];

    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BargainDetalisVC *vc = [[BargainDetalisVC alloc]initWithNibName:@"BargainDetalisVC" bundle:nil];
    CutListModel *model;
    if (indexPath.section == 0) {
        model = _dataRsp.involved[indexPath.row];
    }else{
        model = _dataRsp.normal[indexPath.row];

    }
    vc.catId = model.id;
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = [UIColor grayColor];
    }
    return nil;
}
- (void)kanjiaBtnAction:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"点我砍价"]) {
        
    }else{
        
    }
}
-(void)requestData{
    BaseRequest *req = [BaseRequest new];
    req.limit = @"10";
    req.page = 0;
    [[HTTPRequest sharedManager]requestDataWithApiName:cut_list withParameters:req isEnable:YES withSuccess:^(id responseObject) {
       self.dataRsp  =[CutListRsp mj_objectWithKeyValues:responseObject[@"data"][@"bargain"]];
        [self.ibTableView reloadData];
    } withError:^(NSError *error) {
        
    }];
}

@end
