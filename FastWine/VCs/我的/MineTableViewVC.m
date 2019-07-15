//
//  MineTableViewVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/3/13.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "MineTableViewVC.h"
#import "MyOrderVC.h"
#import "SettingVC.h"
#import "UploadImgManager.h"
#import "MessageVC.h"
#import "MyWalletVC.h"
#import "QrCodeVC.h"
#import "MyPromotionVC.h"
#import "CommissionVC.h"
#import "CouPonVC.h"
#import "MycollectionVC.h"
#import "EvaluationVC.h"
#import "MyBalanceVC.h"
#import "QMHomeViewController.h"
@interface MineTableViewVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *ibHeardImg;
@property (weak, nonatomic) IBOutlet UILabel *ibNameLab;
@property (weak, nonatomic) IBOutlet UILabel *ibVipStatusLab;

@property (strong, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UILabel *ibDaifuNumLab;
@property (weak, nonatomic) IBOutlet UILabel *ibDaifaNumLab;
@property (weak, nonatomic) IBOutlet UILabel *ibDaishouNumLab;
@property (weak, nonatomic) IBOutlet UILabel *ibDaipingLab;
@property (weak, nonatomic) IBOutlet UILabel *ibbanlanceLab;//余额
@property (weak, nonatomic) IBOutlet UILabel *ibCouponsLab;//优惠券数量
@property (weak, nonatomic) IBOutlet UILabel *ibAddTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *ibDianzhuqunyiLab;

@property(nonatomic,strong)NSMutableArray *imgArr;
@property (nonatomic,strong)UIImage *selectImg;
@property (weak, nonatomic) IBOutlet UILabel *ibDianzhu;

@end

@implementation MineTableViewVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
  
    if ([Save isLogin]) {
        [self requestUserInfo];
        
    }
    else {
        self.ibHeardImg.image = [UIImage imageNamed:AvatarDefault];
        self.ibAddTimeLab.text = @"";
        self.ibNameLab.text = @"请登录";
        self.ibbanlanceLab.text = @"0.00";
        self.ibCouponsLab.text = @"0";
        self.ibDaishouNumLab.hidden = YES;
        self.ibDaifaNumLab.hidden = YES;
        self.ibDaifuNumLab.hidden = YES;
        self.ibDaipingLab.hidden = YES;
        
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";
    _ibTableView.tableFooterView = [UIView new];
    _ibTableView.backgroundColor = HEXCOLOR(@"#F9F9F9");
    _ibTableView.frame = CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT - SafeAreaTopHeight);
    //偏移问题
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets = YES;
//    self.navigationController.navigationBar.backgroundColor = NavColor;

//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(fefuBtnClick) image:@"kefu-1" highImage:nil];
//    UIImage *img = [UIImage imageNamed:@""];
//    [self.navigationController.navigationBar setBackgroundImage:img  forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}
- (void)fefuBtnClick{
    EvaluationVC *vc= [[EvaluationVC alloc]initWithNibName:@"EvaluationVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:-----余额
- (IBAction)ibbanlanceBtnClick:(id)sender {
    if (![Save isLogin]) {
        [self presentLoginWithComplection:^{
        }];
        return;
    }
    MyWalletVC *vc = [[MyWalletVC alloc]initWithNibName:@"MyWalletVC" bundle:nil];
    vc.isMainInto = YES;
    [self.navigationController pushViewController:vc animated:YES];
  
}
//MARK:-----优惠券数量
- (IBAction)ibCouponNumClick:(id)sender {
    if (![Save isLogin]) {
        [self presentLoginWithComplection:^{
        }];
        return;
    }
   
    CouPonVC *vc = [[CouPonVC alloc]initWithNibName:@"CouPonVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:-----消息
- (IBAction)ibMessageBtnClick:(id)sender {
    //通知
    if (![Save isLogin]) {
        [self presentLoginWithComplection:^{
        }];
        return;
    }
    MessageVC *vc = [[MessageVC alloc]initWithNibName:@"MessageVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)ibOrderBtnClick:(UIButton *)sender {
    if (![Save isLogin]) {
        [self presentLoginWithComplection:^{
        }];
        return;
    }
    MyOrderVC *vc = [[MyOrderVC alloc]initWithNibName:@"MyOrderVC" bundle:nil];
    vc.selectOrderIdx = sender.tag;
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:---------UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![Save isLogin]) {
        [self presentLoginWithComplection:^{
        }];
        return;
    }
    if (indexPath.section == 0) {
     
        [self takePhoto];//
        
    }else if (indexPath.section == 1){
        //订单
        MyOrderVC *vc = [[MyOrderVC alloc]initWithNibName:@"MyOrderVC" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
       
    }else if (indexPath.section == 2) {
//        if (indexPath.row == 0) {
//            //爱车
//            [self.navigationController pushViewController:[PSMyCarViewController new] animated:YES];
//        }else{
//            //停车记录
//            [self.navigationController pushViewController:[PSParkRecordViewController new] animated:YES];
//        }

        switch (indexPath.row) {
            case 0:{
               //收藏
              
               MycollectionVC *vc = [[MycollectionVC alloc]initWithNibName:@"MycollectionVC" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }
                
                break;
            case 1:{
                //代理权益
                MyWalletVC *vc = [[MyWalletVC alloc]initWithNibName:@"MyWalletVC" bundle:nil];
                vc.isMainInto = YES;
                [self.navigationController pushViewController:vc animated:YES];
              
            }
                
                break;
            case 2:{
                
              //客服
                if (![Save isLogin]) {
                    [self presentLoginWithComplection:^{
                    }];
                    return;
                }
                QMHomeViewController *vc= [QMHomeViewController new];
                [self.navigationController pushViewController:vc animated:NO];
            }
                
                break;
            case 3:{
             
                //推广二维码
              
                QrCodeVC *vc = [[QrCodeVC alloc]initWithNibName:@"QrCodeVC" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
           
            }
                
                break;
            case 4:{
                //设置
             
                SettingVC *vc = [[SettingVC alloc]initWithNibName:@"SettingVC" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
          
            }
                
                break;
          
            
                
                break;
                
            default:
                break;
        }
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  
    return 0.01;
}
#pragma mark - take photo
- (void)takePhoto {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self openPhoto];
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self takeCamera];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alert addAction:photoAction];
    [alert addAction:cameraAction];
    [alert addAction:cancleAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)openPhoto {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    //    更改titieview的字体颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = HEXCOLOR(@"777777");
    [imagePicker.navigationBar setTitleTextAttributes:attrs];
    imagePicker.navigationBar.tintColor = HEXCOLOR(@"777777");
    imagePicker.navigationBar.translucent = NO;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)takeCamera {
    BOOL isAvailable = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isAvailable) {
        NSLog(@"没有摄像头");
        return ;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    
    attrs[NSForegroundColorAttributeName] = [UIColor redColor];
    
    [imagePicker.navigationBar setTitleTextAttributes:attrs];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *photoImg = [info objectForKey:UIImagePickerControllerEditedImage];
    self.selectImg = photoImg;
    [self.imgArr removeAllObjects];
    [self.imgArr addObject:_selectImg];
    NSIndexSet *idxset = [NSIndexSet indexSetWithIndex:0];
    [self.ibTableView reloadSections:idxset withRowAnimation:UITableViewRowAnimationNone];
    self.ibHeardImg.image = _selectImg;
    [_imgArr addObject:_selectImg];
    
    if (_imgArr.count > 0) {
        UploadImgManager *manger= [UploadImgManager manager];
        [manger uploadImageWithImageArr:self.imgArr success:^(id  _Nonnull responseObject) {
        
            dispatch_sync(dispatch_get_main_queue(), ^{
             //修改头像
            [self requestCustomerupdateInformation:responseObject[@"src"]];
                
                
            });
            
        } andFaile:^(NSError * _Nonnull error) {
            
        }];
    }else{
       
        
    }

}
-(void)requestCustomerupdateInformation:(NSString *)imgstr{
    UserInfoUploadImgReq *req = [UserInfoUploadImgReq new];
    req.type = @"1";
    req.avatar = imgstr;
    
    [[HTTPRequest sharedManager]requestDataWithApiName:customerupdateInformation withParameters:req isEnable:YES withSuccess:^(id responseObject) {
  
        [self requestUserInfo];
    } withError:^(NSError *error) {
        
    }];
}
//MARK:----获取个人信息
-(void)requestUserInfo{
    [[HTTPRequest sharedManager]requesGetDataWithApiName:getInformation withParameters:nil isEnable:YES withSuccess:^(id responseObject) {
     
        QuUserInfo *userInfo = [QuUserInfo mj_objectWithKeyValues:responseObject[@"data"][@"user_info"]];
        AccountInfo *accountinfo = [AccountInfo mj_objectWithKeyValues:responseObject[@"data"]];
        
        ACCOUNTINFO.userInfo = userInfo;
       
        OrderNumRsp *orderNum = [OrderNumRsp mj_objectWithKeyValues:responseObject[@"data"][@"orderStatusNum"]];
        ACCOUNTINFO.orderStatusNum = orderNum;
        
        if ([Save isLogin]) {
            self.ibAddTimeLab.text = [NSString stringWithFormat:@"邀请码:%@",ACCOUNTINFO.userInfo.uid];
            [self.ibHeardImg sd_setImageWithURL:[NSURL URLWithString:ACCOUNTINFO.userInfo.avatar] placeholderImage:[UIImage imageNamed:AvatarDefault]];
            self.ibNameLab.text = ACCOUNTINFO.userInfo.nickname;
            if (ACCOUNTINFO.userInfo.agent_id == 0) {
                self.ibVipStatusLab.text = @"普通用户";
                self.ibAddTimeLab.hidden = YES;
                self.ibDianzhuqunyiLab.text = @"代理权益";
                self.ibbanlanceLab.text = @"加入即享";
                self.ibDianzhu.text = @"升级代理";
            }else if (ACCOUNTINFO.userInfo.agent_id == 1){
                self.ibVipStatusLab.text = @"普通代理";
                 self.ibbanlanceLab.text = ACCOUNTINFO.userInfo.now_money;
                self.ibDianzhu.text = @"代理权益";
                self.ibDianzhuqunyiLab.text = @"代理权益";
            }else if (ACCOUNTINFO.userInfo.agent_id == 2){
                self.ibVipStatusLab.text = @"钻石代理";
                 self.ibbanlanceLab.text = ACCOUNTINFO.userInfo.now_money;
                self.ibDianzhu.text = @"代理权益";
                self.ibDianzhuqunyiLab.text = @"代理权益";
            }
          
            if ([ACCOUNTINFO.orderStatusNum.noBuy integerValue] > 0) {
             
                self.ibDaifuNumLab.hidden = NO;
                self.ibDaifuNumLab.text = ACCOUNTINFO.orderStatusNum.noBuy;
                
            }
            if ([ACCOUNTINFO.orderStatusNum.noPostage integerValue] > 0) {
                self.ibDaifaNumLab.hidden = NO;
                self.ibDaifaNumLab.text = ACCOUNTINFO.orderStatusNum.noPostage;
             
            }
            if ([ACCOUNTINFO.orderStatusNum.noTake integerValue] > 0) {
                self.ibDaishouNumLab.hidden = NO;
                self.ibDaishouNumLab.text = ACCOUNTINFO.orderStatusNum.noTake;
            
            }
            if ([ACCOUNTINFO.orderStatusNum.noReply integerValue] > 0) {
                self.ibDaipingLab.hidden = NO;
                self.ibDaipingLab.text = ACCOUNTINFO.orderStatusNum.noReply;
                
            }
           
            self.ibCouponsLab.text = [NSString stringWithFormat:@"%ld",accountinfo.coupon_num.count];
        }
     
    } withError:^(NSError *error) {
        
    }];
}
//MARK:----------Get
-(NSMutableArray *)imgArr{
    if (_imgArr == nil) {
        _imgArr = [[NSMutableArray alloc]initWithCapacity:0];
        
    }
    return _imgArr;
}
@end
