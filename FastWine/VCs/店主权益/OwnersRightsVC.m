//
//  OwnersRightsVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/6/15.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "OwnersRightsVC.h"
#import "OwnersHeardCell.h"
#import "OwersDetalisCell.h"
#import "OwersCustomerCell.h"
#import "OwersKefuCell.h"
#import "OBDCollectionCell.h"
#import "OwnersTitleCell.h"
#import "OwnersLineCell.h"
#import "GoodsDetalisVC.h"
#import "YLImageView.h"
#import "YLGIFImage.h"
@interface OwnersRightsVC ()
@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionView;
@property (weak, nonatomic) IBOutlet YLImageView *ibAboutMe;
@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,strong)NSMutableArray * dataArr1;
@property(nonatomic,strong)NSMutableArray * dataArr2;
@property(nonatomic,strong)AccountInfo *accountinfo;
@property(nonatomic)NSInteger pageIndex;
@property(nonatomic,strong)GetWalletModel *dataRsp;
@property(nonatomic,strong)VipGoodsRsp *vipGoodsRsp;
@end

@implementation OwnersRightsVC
-(void)viewWillAppear:(BOOL)animated{
    [self requestGetWallet];
    [self requestUserInfo];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1) {
         self.navigationItem.title = @"代理权益";
    }else{
        self.navigationItem.title = @"升级代理";

    }
    [self configCollectionView];
//    [self requestGetWallet];
//    [self requestUserInfo];
    
    _ibAboutMe.image = [YLGIFImage imageNamed:@"guanyuwomen.gif"];
    _ibAboutMe.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_ibAboutMe addGestureRecognizer:tap];
  
}
-(void)tapAction:(UITapGestureRecognizer *)ges{
   //关于我们

    BaseWKWebController *vc = [[BaseWKWebController alloc]init];
//    vc.content = responseObject[@"data"][@"content"][@"content"];
//    vc.titleStr = responseObject[@"data"][@"content"][@"title"];
    vc.url = @"https://i.eqxiu.com/s/BHOzngSZ?share_level=1&from_user=2019053014e6a20b&from_id=443ba141-3&share_time=1561629426288&from=groupmessage&isappinstalled=0";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)configCollectionView{
    
    [_ibCollectionView registerNib:[UINib nibWithNibName:@"OwnersHeardCell" bundle:nil] forCellWithReuseIdentifier:OwnersHeardCellID];
    [_ibCollectionView registerNib:[UINib nibWithNibName:@"OwersDetalisCell" bundle:nil] forCellWithReuseIdentifier:OwersDetalisCellID];
    [_ibCollectionView registerNib:[UINib nibWithNibName:@"OwersCustomerCell" bundle:nil] forCellWithReuseIdentifier:OwersCustomerCellID];
    [_ibCollectionView registerNib:[UINib nibWithNibName:@"OBDCollectionCell" bundle:nil] forCellWithReuseIdentifier:OBDCollectionCellID];
    [_ibCollectionView registerNib:[UINib nibWithNibName:@"OwersKefuCell" bundle:nil] forCellWithReuseIdentifier:OwersKefuCellID];
    [_ibCollectionView registerNib:[UINib nibWithNibName:@"OwnersTitleCell" bundle:nil] forCellWithReuseIdentifier:OwnersTitleCellID];
    [_ibCollectionView registerNib:[UINib nibWithNibName:@"OwnersLineCell" bundle:nil] forCellWithReuseIdentifier:OwnersLineCellID];
//    _ibCollectionView.backgroundColor = WhiteColor;
    
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1) {
        return 9;
    }
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1) {
        if (section == 6) return self.dataRsp.promotion_product.count;
        if (section == 8) return self.dataRsp.list.count;
        return 1;
    }else{
        if (section == 2) return self.dataArr.count;
//        if (section == 4) return self.dataArr1.count;
//        if (section == 6) return self.dataArr2.count;
        return 1;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1) {
        if (indexPath.section == 0) {
            OwnersHeardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OwnersHeardCellID forIndexPath:indexPath];
            cell.accountinfo = self.accountinfo;
            if (_dataRsp) {
                cell.dataModel = self.dataRsp;
            }
            cell.controller = self;
            [cell.ibQushengjiBtn addTarget:self action:@selector(qushengjiAction) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        } else if (indexPath.section == 1) {
            OwersDetalisCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OwersDetalisCellID forIndexPath:indexPath];
            cell.controller = self;

            cell.dataRsp = self.dataRsp;
         
            return cell;
        }else if (indexPath.section == 2) {
            //
            OwersCustomerCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:OwersCustomerCellID forIndexPath:indexPath];
            cell.dataRsp = self.dataRsp;
            cell.controller = self;

            return cell;
            
        }else if (indexPath.section == 3){
            //
            OwersKefuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OwersKefuCellID forIndexPath:indexPath];
            cell.controller = self;

            return cell;
        }else if (indexPath.section == 4){
            //
            OwnersLineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OwnersLineCellID forIndexPath:indexPath];
            [cell.ibTitleLab setTitle:@"购买好货升级代理" forState:UIControlStateNormal];

            return cell;
        }else if (indexPath.section == 5){
            //
            OwnersTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OwnersTitleCellID forIndexPath:indexPath];
            cell.viewModel= self.dataRsp;
            return cell;
        }else if (indexPath.section == 6){
            //
            //商品
            OBDCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OBDCollectionCellID forIndexPath:indexPath];
            MainGoodsModel *model = _dataRsp.promotion_product[indexPath.row];
            cell.viewModel = model;
            self.ibCollectionView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
            
            return cell;
        }else if (indexPath.section == 7){
            //
            OwnersLineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OwnersLineCellID forIndexPath:indexPath];
            [cell.ibTitleLab setTitle:@"代理专属商品" forState:UIControlStateNormal];
            return cell;
        }else if (indexPath.section == 8){
            //
            //商品
            OBDCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OBDCollectionCellID forIndexPath:indexPath];
            MainGoodsModel *model = _dataRsp.list[indexPath.row];
            cell.viewModel = model;
            self.ibCollectionView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
            
            return cell;
        }else{
            return nil;
        }
    }else{
        if (indexPath.section == 0) {
            OwnersHeardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OwnersHeardCellID forIndexPath:indexPath];
            cell.accountinfo = self.accountinfo;
            cell.controller = self;
            [cell.ibQushengjiBtn addTarget:self action:@selector(qushengjiAction) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        } else if (indexPath.section == 1) {
            OwnersTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OwnersTitleCellID forIndexPath:indexPath];
           
            return cell;
        }else if (indexPath.section == 2) {
            //商品
            OBDCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OBDCollectionCellID forIndexPath:indexPath];
            MainGoodsModel *model = _dataArr[indexPath.row];
            cell.viewModel = model;
            self.ibCollectionView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
            return cell;
            
        }
//        else if (indexPath.section == 3) {
//            OwnersTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OwnersTitleCellID forIndexPath:indexPath];
//            cell.ibDialiTitleLab.text = @"中级代理权益：";
//            cell.ibDailiContent.text = _vipGoodsRsp.artics[@"introduce2"];
//            cell.ibSubTitleLab.text = @"购买以下任意商品即可升级成为中级代理";
//            return cell;
//        }
//        else if (indexPath.section == 4) {
//            //商品
//            OBDCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OBDCollectionCellID forIndexPath:indexPath];
//            MainGoodsModel *model = _dataArr1[indexPath.row];
//            cell.viewModel = model;
//            self.ibCollectionView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
//            return cell;
//            
//        }
//        else if (indexPath.section == 5) {
//            OwnersTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OwnersTitleCellID forIndexPath:indexPath];
//            cell.ibDialiTitleLab.text = @"高级代理权益：";
//            cell.ibDailiContent.text = _vipGoodsRsp.artics[@"introduce3"];
//            cell.ibSubTitleLab.text = @"购买以下任意商品即可升级成为高级代理";
//            return cell;
//        }
//        else if (indexPath.section == 6) {
//            //商品
//            OBDCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OBDCollectionCellID forIndexPath:indexPath];
//            MainGoodsModel *model = _dataArr2[indexPath.row];
//            cell.viewModel = model;
//            self.ibCollectionView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
//            return cell;
//            
//        }
        else{
            return nil;
        }
    }
    
    
}
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1) {
        if ( indexPath.section == 6 || indexPath.section == 8) {
            GoodsDetalisVC *vc = [[GoodsDetalisVC alloc]initWithNibName:@"GoodsDetalisVC" bundle:nil];
            MainGoodsModel *model;
            if (indexPath.section == 6) {
               model  = _dataRsp.promotion_product[indexPath.row];
            }else{
              model  = _dataRsp.list[indexPath.row];
            }
            vc.goodsId = model.id;
            [self.navigationController pushViewController:vc animated:YES];
         
        }
    }else{
        if (indexPath.section == 2 || indexPath.section == 4 || indexPath.section == 6) {
            GoodsDetalisVC *vc = [[GoodsDetalisVC alloc]initWithNibName:@"GoodsDetalisVC" bundle:nil];
            MainGoodsModel *model;
            if (indexPath.section == 2) {
               model = _dataArr[indexPath.row];
            }else if (indexPath.section == 4){
               model = _dataArr1[indexPath.row];
            }else{
               model = _dataArr2[indexPath.row];
            }
            vc.goodsId = model.id;
            [self.navigationController pushViewController:vc animated:YES];
        
        }
    }
    
    
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1) {
        if (indexPath.section == 0) return CGSizeMake(SCREEN_WIDTH, 580);
        if (indexPath.section == 1)  return CGSizeMake(SCREEN_WIDTH, 245);
        if (indexPath.section == 2)  return CGSizeMake(SCREEN_WIDTH, 150);
        if (indexPath.section == 3)  return CGSizeMake(SCREEN_WIDTH, 60);
        if (indexPath.section == 4)  return CGSizeMake(SCREEN_WIDTH, 50);
        if (indexPath.section == 5)  return CGSizeMake(SCREEN_WIDTH, 110);
        if (indexPath.section == 6) return CGSizeMake((SCREEN_WIDTH -30)/2, ((SCREEN_WIDTH -30)/2) * 1.4);
        if (indexPath.section == 7)  return CGSizeMake(SCREEN_WIDTH, 50);
        if (indexPath.section == 8) return CGSizeMake((SCREEN_WIDTH -30)/2, ((SCREEN_WIDTH -30)/2) * 1.4);
        
        return CGSizeMake((int)((SCREEN_WIDTH-48)/2), (SCREEN_WIDTH-48)/2 *3 /5 );
    }else{
        if (indexPath.section == 0) return CGSizeMake(SCREEN_WIDTH, 580);
        if (indexPath.section == 1)  return CGSizeMake(SCREEN_WIDTH, 110);
        if (indexPath.section == 2) return CGSizeMake((SCREEN_WIDTH -30)/2, ((SCREEN_WIDTH -30)/2) * 1.4);
        if (indexPath.section == 3)  return CGSizeMake(SCREEN_WIDTH, 110);
        if (indexPath.section == 4) return CGSizeMake((SCREEN_WIDTH -30)/2, ((SCREEN_WIDTH -30)/2) * 1.4);
        if (indexPath.section == 5)  return CGSizeMake(SCREEN_WIDTH, 110);
        if (indexPath.section == 6) return CGSizeMake((SCREEN_WIDTH -30)/2, ((SCREEN_WIDTH -30)/2) * 1.4);
        
        return CGSizeMake((int)((SCREEN_WIDTH-48)/2), (SCREEN_WIDTH-48)/2 *3 /5 );
    }
  
}
#pragma mark  定义每个UICollectionView的纵向间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    if (section == 1) return 10;
//    if (section == 2) return 10;
//    return 0;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    if (section == 2) return 5;
//    return 0;
//}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 2 || section == 4 || section == 6 || section == 8) return UIEdgeInsetsMake(10, 5, 10, 5);
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
-(void)qushengjiAction{
    if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:4];
        [self.ibCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:true];
    }else{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        [self.ibCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:true];
    }
  
}
//MARK:----获取个人信息
-(void)requestUserInfo{
    [[HTTPRequest sharedManager]requesGetDataWithApiName:getInformation withParameters:nil isEnable:YES withSuccess:^(id responseObject) {
        
        QuUserInfo *userInfo = [QuUserInfo mj_objectWithKeyValues:responseObject[@"data"][@"user_info"]];
        self.accountinfo = [AccountInfo mj_objectWithKeyValues:responseObject[@"data"]];
        
        ACCOUNTINFO.userInfo = userInfo;
        OrderNumRsp *orderNum = [OrderNumRsp mj_objectWithKeyValues:responseObject[@"data"][@"orderStatusNum"]];
        ACCOUNTINFO.orderStatusNum = orderNum;
        [UIView performWithoutAnimation:^{
            [self.ibCollectionView reloadData];
        }];
   
        
        
    } withError:^(NSError *error) {
        
    }];
}
//TODO:----------获取Data
- (void)requestGetWallet{
    [self.dataArr removeAllObjects];
    [self.dataArr1 removeAllObjects];
    [self.dataArr2 removeAllObjects];
    XQApiName api;
    if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1) {
        api = myUser_pro;
    }else{
        api = myguide;
    }
    [[HTTPRequest sharedManager]requestDataWithApiName:api withParameters:nil isEnable:YES withSuccess:^(id responseObject) {
    
        if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1) {
            self.dataRsp = [GetWalletModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            [UIView performWithoutAnimation:^{
                [self.ibCollectionView reloadData];
            }];
        }else{
            self.vipGoodsRsp = [VipGoodsRsp mj_objectWithKeyValues:responseObject[@"data"]];
             [self.dataArr addObjectsFromArray:self.vipGoodsRsp.list];
             [self.dataArr1 addObjectsFromArray:self.vipGoodsRsp.list2];
             [self.dataArr2 addObjectsFromArray:self.vipGoodsRsp.list3];
            
            [UIView performWithoutAnimation:^{
                [self.ibCollectionView reloadData];
            }];
            
        }
//        [self.ibCollectionView reloadData];
      
  
    } withError:^(NSError *error) {
        
    }];
}
-(NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)dataArr1{
    if (_dataArr1 == nil) {
        _dataArr1 = [NSMutableArray array];
    }
    return _dataArr1;
}
-(NSMutableArray *)dataArr2{
    if (_dataArr2 == nil) {
        _dataArr2 = [NSMutableArray array];
    }
    return _dataArr2;
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
