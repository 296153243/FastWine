//
//  PersonalVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/6/10.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "PersonalVC.h"
#import "PersonHearderCell.h"
#import "PersonOrderCell.h"
#import "PersonServiceCell.h"
#import "OBDCollectionCell.h"
#import "GoodsDetalisVC.h"
#import "QrCodeVC.h"
#import "UploadImgManager.h"
#import "OwnersRightsVC.h"

@interface PersonalVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionView;
@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,strong)AccountInfo *accountinfo;
@property(nonatomic)NSInteger pageIndex;
@property(nonatomic,strong)NSMutableArray *imgArr;
@property (nonatomic,strong)UIImage *selectImg;
@end

@implementation PersonalVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self requestUserInfo];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = NavColor;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configCollectionView];
    self.pageIndex = 0;
    [self requestMainGoodsListWithIdx:self.pageIndex];
    self.ibCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex  =  self.pageIndex +10;
        [self requestMainGoodsListWithIdx:self.pageIndex];
        
    }];
  
}

- (void)configCollectionView{
    
    [_ibCollectionView registerNib:[UINib nibWithNibName:@"PersonHearderCell" bundle:nil] forCellWithReuseIdentifier:PersonHearderCellID];
    [_ibCollectionView registerNib:[UINib nibWithNibName:@"PersonOrderCell" bundle:nil] forCellWithReuseIdentifier:PersonOrderCellID];
    [_ibCollectionView registerNib:[UINib nibWithNibName:@"PersonServiceCell" bundle:nil] forCellWithReuseIdentifier:PersonServiceCellID];
    [_ibCollectionView registerNib:[UINib nibWithNibName:@"OBDCollectionCell" bundle:nil] forCellWithReuseIdentifier:OBDCollectionCellID];
    
    _ibCollectionView.backgroundColor = WhiteColor;
    
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
 
    if (section == 3) return self.dataArr.count;
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PersonHearderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PersonHearderCellID forIndexPath:indexPath];
        if (_accountinfo) {
            cell.accountinfo = self.accountinfo;

        }
        cell.controller = self;
        [cell.ibKaitongAction addTarget:self action:@selector(kaitongAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.iconClickBlock = ^{
            [self takePhoto];//修改头像
        };
        return cell;
    } else if (indexPath.section == 1) {
        PersonOrderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PersonOrderCellID forIndexPath:indexPath];
        if (_accountinfo) {
            cell.accountinfo = self.accountinfo;
        }
        cell.controller = self;
        return cell;
    }else if (indexPath.section == 2) {
        //
        PersonServiceCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:PersonServiceCellID forIndexPath:indexPath];
        cell.controller = self;
        if ([ACCOUNTINFO.userInfo.is_promoter integerValue] != 1) {
           [cell.ibDianzhuqianyiBtn setTitle:@"升级代理" forState:UIControlStateNormal];
        }
        return cell;
        
    }else if (indexPath.section == 3){
       
        //商品
        OBDCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OBDCollectionCellID forIndexPath:indexPath];
        MainGoodsModel *model = _dataArr[indexPath.row];
        cell.viewModel = model;
        return cell;
    }else{
        return nil;
    }

    
}
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 3) {
        GoodsDetalisVC *vc = [[GoodsDetalisVC alloc]initWithNibName:@"GoodsDetalisVC" bundle:nil];
        MainGoodsModel *model = _dataArr[indexPath.row];
        vc.goodsId = model.id;
        [self.navigationController pushViewController:vc animated:YES];
      
    }

    
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) return CGSizeMake(SCREEN_WIDTH, 300);
    if (indexPath.section == 1)  return CGSizeMake(SCREEN_WIDTH, 150);
    if (indexPath.section == 2)  return CGSizeMake(SCREEN_WIDTH, 210);
    if (indexPath.section == 3) return CGSizeMake((SCREEN_WIDTH -20)/2, ((SCREEN_WIDTH -20)/2) * 1.4);
    
    return CGSizeMake((int)((SCREEN_WIDTH-48)/2), (SCREEN_WIDTH-48)/2 *3 /5 );
}
#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 1) return 10;
    if (section == 3) return 10;
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 3) return 5;
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 3) return UIEdgeInsetsMake(10, 5, 10, 5);
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//HeaderInSection Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    if (section == 3){
//        return CGSizeMake(SCREEN_WIDTH, 50);
//    }
    return CGSizeMake(0, 0);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(0, 0);
    
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
    [self.ibCollectionView reloadSections:idxset];
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
-(void)kaitongAction:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"立即开通"]) {
        OwnersRightsVC *vc = [[OwnersRightsVC alloc]initWithNibName:@"OwnersRightsVC" bundle:nil];
        //    vc.isMainInto = YES;
        [self.navigationController pushViewController:vc animated:YES];
       
    }else{
        //推广二维码
      
        QrCodeVC *vc = [[QrCodeVC alloc]initWithNibName:@"QrCodeVC" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//MARK:----获取个人信息
-(void)requestUserInfo{
    [[HTTPRequest sharedManager]requesGetDataWithApiName:getInformation withParameters:nil isEnable:YES withSuccess:^(id responseObject) {
        
        if ([Save isLogin]) {
            QuUserInfo *userInfo = [QuUserInfo mj_objectWithKeyValues:responseObject[@"data"][@"user_info"]];
            self.accountinfo = [AccountInfo mj_objectWithKeyValues:responseObject[@"data"]];
            
            ACCOUNTINFO.userInfo = userInfo;
            OrderNumRsp *orderNum = [OrderNumRsp mj_objectWithKeyValues:responseObject[@"data"][@"orderStatusNum"]];
            ACCOUNTINFO.orderStatusNum = orderNum;
        
        }else{
            self.accountinfo = nil;

        }
        [UIView performWithoutAnimation:^{
            [self.ibCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }];
        
    } withError:^(NSError *error) {
        
    }];
}
//可能喜欢商品
- (void)requestMainGoodsListWithIdx:(NSInteger)page
{
    
    BaseRequest *req = [BaseRequest new];
    req.first = [NSString stringWithFormat:@"%ld",page];
    req.limit = @"10";
    req.cId = @"0";
    if (_pageIndex == 0) {
        [_dataArr removeAllObjects];
        
    }
    [[HTTPRequest sharedManager]requesGetDataWithApiName:mainGoodsList withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        MainGoodsRsp *mainGoodsRsp = [MainGoodsRsp mj_objectWithKeyValues:responseObject];
        [self.dataArr addObjectsFromArray:mainGoodsRsp.data];
        [self.ibCollectionView reloadData];
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:3];
        [self.ibCollectionView reloadSections:indexSet];
        [self.ibCollectionView.mj_footer endRefreshing];
        if (mainGoodsRsp.data.count == 0) {
            [self.ibCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
    } withError:^(NSError *error) {
        
    }];
    
}
-(NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
//MARK:----------Get
-(NSMutableArray *)imgArr{
    if (_imgArr == nil) {
        _imgArr = [[NSMutableArray alloc]initWithCapacity:0];
        
    }
    return _imgArr;
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
