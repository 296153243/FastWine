//
//  MyWalletVC.m
//  CLTravel
//
//  Created by MOOSON_ on 2018/10/29.
//  Copyright © 2018年 MOOSON_. All rights reserved.
//

#import "MyWalletVC.h"
#import "MyWalletCell.h"
#import "CommissionVC.h"
#import "WithdrawalVC.h"
#import "GoodsDetalisVC.h"
#import "QMHomeViewController.h"
#import "MyPromotionVC.h"
//#import "AccountDetailsVC.h"
//#import "RechargeVC.h"
//#import "WithdrawVC.h"
//#import "CouPonVC.h"
@interface MyWalletVC ()<UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UILabel *ibWalletPicLab;
@property (weak, nonatomic) IBOutlet UIImageView *ibIcon;
@property (weak, nonatomic) IBOutlet UILabel *ibName;
@property (weak, nonatomic) IBOutlet UILabel *ibDengji;
@property (weak, nonatomic) IBOutlet UILabel *ibUid;

@property(nonatomic,strong)GetWalletRsp *dataRsp;
@property(nonatomic,strong) NSArray *titleArr;
@property(nonatomic,strong) NSMutableArray *dataArr;
@property (strong, nonatomic)UIView *ibNoFenxiaozhongxinView;
@property (weak, nonatomic) IBOutlet UIView *ibTopView;
@property(nonatomic)BOOL isGobuy;//是否跳过购买页面
@end

@implementation MyWalletVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isMainInto == YES) {
        self.navigationController.navigationBarHidden = NO;
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        //    self.automaticallyAdjustsScrollViewInsets = YES;
//        self.navigationController.navigationBar.backgroundColor = NavColor;
        _isGobuy = NO;
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:animated];
       

    }
    
    if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1) {
        //是分销人
        self.navigationItem.title = @"代理权益";
        
    }else{
        self.navigationItem.title = @"升级代理";
   
    }
    self.tabBarController.delegate = self;


}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
//    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.navigationController.navigationBar.backgroundColor = NavColor;
  
    _titleArr = @[@{@"title":@"我的收益(七天后可提现)",@"titleImg":@"weidaozhang"},
                          @{@"title":@"累计获得收益",@"titleImg":@"huodeyongjin"},
                          @{@"title":@"累计已提收益",@"titleImg":@"yitiyongjin"},
                          @{@"title":@"收益明细",@"titleImg":@"yongjinmingxi"},
                         @{@"title":@"客户管理",@"titleImg":@"kehuguanli"},
                         @{@"title":@"我有好货",@"titleImg":@"woyouhaohuo"},
                          @{@"title":@"我的邀请人",@"titleImg":@"yaoqingren"},
                  
                  
                          ];
    
    if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1) {
        
        //是分销人
        [self requestGetWallet];
        [self initUI];
        
    }else{
        _ibTableView.hidden = YES;
        _ibTopView.hidden = YES;
        [self loadNofenxiaozhongxinViewWith:YES];
        
    }

   
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (self.tabBarController.selectedIndex == 2) {
        if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1) {
            //是分销人
            [self requestGetWallet];
            [self initUI];
            
        }else{
            _ibTableView.hidden = YES;
            _ibTopView.hidden = YES;
            [self loadNofenxiaozhongxinViewWith:YES];
            
        }

    }
}

-(void)loadNofenxiaozhongxinViewWith:(BOOL)isBuyVip{
  
    //不是代理直接去购买会员
    GoodsDetalisVC *vc = [[GoodsDetalisVC alloc]initWithNibName:@"GoodsDetalisVC" bundle:nil];
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
    vc.goodsId = @"4";
    vc.isBuyVip = YES;
    [self.navigationController pushViewController:vc animated:NO];
 
}
- (void)ibGoumaiHuiYuan:(id)sender {
    GoodsDetalisVC *vc = [[GoodsDetalisVC alloc]initWithNibName:@"GoodsDetalisVC" bundle:nil];
    vc.goodsId = @"4";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)initUI{
    [_ibTableView showViewShadowColor];
    _ibTableView.tableFooterView = [UIView new];

}
//账户明细
- (void)rightBarButtonItemAction:(UIButton *)sender{
//    AccountDetailsVC *vc = [[AccountDetailsVC alloc]initWithNibName:@"AccountDetailsVC" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
        return 50;
   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyWalletCell"];
  
   cell = [[NSBundle mainBundle]loadNibNamed:@"MyWalletCell" owner:nil options:nil][1];
     
    cell.titleDic = _titleArr[indexPath.row];
    if (indexPath.row == _titleArr.count - 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, 1500, 0, 0);
    }
    if (indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5) {
        cell.ibMarkBtn.hidden = NO;
        cell.ibContentLab.hidden = YES;
    } if (indexPath.row == 5) {
        cell.ibMarkBtn.hidden = NO;
        cell.ibContentLab.hidden = NO;
        cell.ibContentLab.text = _dataArr[indexPath.row];
        cell.ibContentLab.textColor = [UIColor lightGrayColor];
    }else if (indexPath.row == 6) {
        cell.ibContentLab.text = [NSString stringWithFormat:@"%@",_dataArr[indexPath.row]];
      
    }else {
        cell.ibContentLab.text = [NSString stringWithFormat:@"%@元",_dataArr[indexPath.row]];
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 3) {
        //佣金明细
        CommissionVC *vc = [[CommissionVC alloc]initWithNibName:@"CommissionVC" bundle:nil];
        vc.walletRsp = self.dataRsp;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 4) {
     
        if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1){
            MyPromotionVC *vc = [[MyPromotionVC alloc]initWithNibName:@"MyPromotionVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            MyWalletVC *vc = [[MyWalletVC alloc]initWithNibName:@"MyWalletVC" bundle:nil];
            vc.isMainInto = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.row == 5) {
        //我有好货跳转客服
        QMHomeViewController *vc= [QMHomeViewController new];
        [self.navigationController pushViewController:vc animated:NO];
    }
    
}
- (IBAction)ibTixianBtnClick:(id)sender {
    WithdrawalVC *vc =[[WithdrawalVC alloc]initWithNibName:@"WithdrawalVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)goRechargeBtnClick:(id)sender {
//    if ([APPCONFIGININFO.appCanfigModel.chargeEnabled integerValue]== 2){
//        [QuHudHelper qu_showMessage:@"暂时还未开放哦"];
//        return ;
//    }
//    //去充值
//    RechargeVC *vc = [[RechargeVC alloc]initWithNibName:@"RechargeVC" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
}
//TODO:----------获取钱包余额
- (void)requestGetWallet{
    
    [[HTTPRequest sharedManager]requestDataWithApiName:myUser_pro withParameters:nil isEnable:YES withSuccess:^(id responseObject) {
        self.dataRsp = [GetWalletRsp mj_objectWithKeyValues:responseObject];
        NSString *picStr= [NSString stringWithFormat:@"%@元",self.dataRsp.data.userInfo.now_money];
        self.ibWalletPicLab.text = picStr;
        self.ibName.text = self.dataRsp.data.userInfo.nickname;
        self.ibDengji.text = self.dataRsp.data.agent.name;
        [self.ibIcon sd_setImageWithURL:[NSURL URLWithString:self.dataRsp.data.userInfo.avatar] placeholderImage:[UIImage imageNamed:AvatarDefault]];
        self.ibUid.text = [NSString stringWithFormat:@"邀请码:%@",self.dataRsp.data.userInfo.uid];
        
        [self.dataArr addObject:self.dataRsp.data.number?self.dataRsp.data.number:@""];
        
        [self.dataArr addObject:self.dataRsp.data.allnumber?self.dataRsp.data.allnumber:@""];
        [self.dataArr addObject:self.dataRsp.data.extractNumber?self.dataRsp.data.extractNumber:@""];
        [self.dataArr addObject:self.dataRsp.data.agent.direct?self.dataRsp.data.agent.direct:@""];
        [self.dataArr addObject:self.dataRsp.data.userInfo.direct_num?self.dataRsp.data.userInfo.direct_num:@"0"];
        [self.dataArr addObject:@"商务联系     "];
        [self.dataArr addObject:self.dataRsp.data.userInfo.spread_name?self.dataRsp.data.userInfo.spread_name:@"无"];
    
      
        [self.ibTableView reloadData];
    } withError:^(NSError *error) {
        
    }];
//    [ requestDataWithApiName:getWallet params:req response:^(NSDictionary *responseObject) {
//        BaseResponse *rsp = [BaseResponse mj_objectWithKeyValues:responseObject];
//        if (rsp.code == 0) {
//            self.dataRsp = [GetWalletRsp mj_objectWithKeyValues:responseObject];
//            NSString *picStr= [NSString stringWithFormat:@"%@元",self.dataRsp.data.allMoney];
//            [self.ibWalletPicLab setAttributedText: [UILabel setupAttributeString:picStr rangeText:@"元" textFont:16]];
//
//        }else{
//            [QuHudHelper qu_showMessage:rsp.msg];
//        }
//    } errorResponse:^(NSString *error) {
//
//    }];
//
}
-(NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
