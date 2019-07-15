//
//  EvaluationVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/5/9.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "EvaluationVC.h"
#import "HDragItemListView.h"
#import "UIView+Ex.h"
#import "TZImagePickerController.h"
#import "UploadImgManager.h"
@interface EvaluationVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
@property (nonatomic, strong) HDragItemListView *itemList;
@property (weak, nonatomic) IBOutlet UIView *ibImgsBgView;
@property (weak, nonatomic) IBOutlet UIView *ibStarView;
@property (weak, nonatomic) IBOutlet UIView *ibStarOneView;
@property (weak, nonatomic) IBOutlet UITextView *ibTextView;
@property(nonatomic)NSInteger starNum;//   产品评价星星个数
@property(nonatomic)NSInteger starNumber;//   商家评价星星个数
@property (weak, nonatomic) IBOutlet UILabel *ibPlaceLab;
@property (weak, nonatomic) IBOutlet UIImageView *ibGoodsImg;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodsName;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodsPic;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodsNum;
@property(nonatomic,strong) NSMutableArray *imgArr;
@property(nonatomic,strong) NSMutableArray *imgStrArr;

@end

@implementation EvaluationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self requestEvaluation];
    self.navigationItem.title = @"商品评价";
    HDragItem *item = [[HDragItem alloc] init];
    item.backgroundColor = [UIColor clearColor];
    item.image = [UIImage imageNamed:@"add_image"];
    item.isAdd = YES;
    // 创建标签列表
    HDragItemListView *itemList = [[HDragItemListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    self.itemList = itemList;
    self.itemList.maxItem = 3;
    itemList.backgroundColor = [UIColor clearColor];
    // 高度可以设置为0，会自动跟随标题计算
    // 设置排序时，缩放比例
    itemList.scaleItemInSort = 1.3;
    // 需要排序
    itemList.isSort = YES;
    itemList.isFitItemListH = YES;
    
    [itemList addItem:item];
    
    __weak typeof(self) weakSelf = self;
    
    [itemList setClickItemBlock:^(HDragItem *item) {
        if (item.isAdd) {
            NSLog(@"添加");
            [weakSelf showUIImagePickerController];
        }
    }];
    
    /**
     * 移除tag 高度变化，得重设
     */
    itemList.deleteItemBlock = ^(HDragItem *item) {
        HDragItem *lastItem = [weakSelf.itemList.itemArray lastObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!lastItem.isAdd) {
                HDragItem *item = [[HDragItem alloc] init];
                item.backgroundColor = [UIColor clearColor];
                item.image = [UIImage imageNamed:@"add_image"];
                item.isAdd = YES;
                [weakSelf.itemList addItem:item];
            }
            [weakSelf updateHeaderViewHeight];
        });
    };
    
    [self.ibImgsBgView addSubview:itemList];
    
 
    self.ibGoodsNum.text = [NSString stringWithFormat:@"× %ld",_orderModel.cart_num];
    self.ibGoodsPic.text = _orderModel.truePrice;
    //        self.ibBuyTime.text = viewModel.create_time;
    [self.ibGoodsImg sd_setImageWithURL:[NSURL URLWithString:_orderModel.productInfo.image]];
    self.ibGoodsName.text =_orderModel.productInfo.store_name;
    
    
}

//更新头部高度
- (void)updateHeaderViewHeight{
    //    self.itemList.y = _textView.height + 20;
    //    self.tableView.tableHeaderView.height = self.itemList.itemListH + self.itemList.y;
    //    [self.tableView beginUpdates]; //加上这对代码，改header的时候，会有动画，不然比较僵硬
    //    self.tableView.tableHeaderView = self.tableView.tableHeaderView;
    //    [self.tableView endUpdates];
}

- (IBAction)starBtnClick:(UIButton *)sender {
    
    for (UIView *view in self.ibStarView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btnn=(UIButton *)view;
            if (view.tag <= sender.tag) {
                btnn.selected=YES;
            }else{
                btnn.selected=NO;
            }
        }
        _starNum = sender.tag - 100;
    }
    
}
- (IBAction)starBtnAction:(UIButton *)sender {
    
    for (UIView *view in self.ibStarOneView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btnn=(UIButton *)view;
            if (view.tag <= sender.tag) {
                btnn.selected=YES;
            }else{
                btnn.selected=NO;
            }
        }
        _starNumber = sender.tag - 70;
    }
    
}
//点击评价按钮
- (IBAction)ibEvationClick:(id)sender {

    if (_imgArr.count > 0) {
    
        [_imgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UploadImgManager *manger= [UploadImgManager manager];
            [manger uploadImageWithImage:obj success:^(id  _Nonnull responseObject) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.imgStrArr addObject:responseObject[@"src"]];
                    
                    if (idx == self.imgArr.count - 1) {
                        //上传完的时候掉接口
                         [self performSelector:@selector(submitEvaluation) withObject:nil afterDelay:0.2f];
                    }
                    
                });
            } andFaile:^(NSError * _Nonnull error) {
                
            }];

        }];
        
     
        
    }else{
        [self submitEvaluation];
    }
    
}
//提交评价
-(void)submitEvaluation{
    
    [self requestEvaluationSubmit];

}
-(void)textViewDidChange:(UITextView *)textView{
    if (!self.ibTextView.text.length) {
        self.ibPlaceLab.alpha = 1;
    }else{
         self.ibPlaceLab.alpha = 0;
    }
}

#pragma mark - UIImagePickerController
- (void)showUIImagePickerController{
    //    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    //    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //    controller.delegate = self;
    //    [self presentViewController:controller animated:YES completion:nil];
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:nil];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isStop) {
        [self.imgArr addObjectsFromArray:photos];
        for (UIImage *image in photos) {
            
            HDragItem *item = [[HDragItem alloc] init];
            item.image = image;
            item.backgroundColor = [UIColor purpleColor];
            [self.itemList addItem:item];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateHeaderViewHeight];
            });
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        HDragItem *item = [[HDragItem alloc] init];
        item.image = image;
        item.backgroundColor = [UIColor purpleColor];
        [self.itemList addItem:item];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateHeaderViewHeight];
        });
    }];
}
//MARK:-----评价内容
-(void)requestEvaluation{
    EvaluationReq *req = [EvaluationReq new];
    req.unique = _orderModel.productInfo.unique;
    [[HTTPRequest sharedManager]requestDataWithApiName:evaluationInfo withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        
    } withError:^(NSError *error) {
        
    }];
}
//MARK:-----进行评价
-(void)requestEvaluationSubmit{
    EvaluationReq *req = [EvaluationReq new];
    req.unique= _orderModel.unique;
    req.comment = _ibTextView.text;
    req.product_score = [NSString stringWithFormat:@"%ld",_starNum];
    req.service_score = [NSString stringWithFormat:@"%ld",_starNumber];
    req.pics = _imgStrArr;
    
    [[HTTPRequest sharedManager]requestDataWithApiName:evaluation withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
       
    } withError:^(NSError *error) {
        
    }];
}
-(NSMutableArray *)imgArr{
    if (_imgArr == nil){
        _imgArr = [NSMutableArray array];
    }
    return _imgArr;
}
-(NSMutableArray *)imgStrArr{
    if (_imgStrArr == nil){
        _imgStrArr = [NSMutableArray array];
    }
    return _imgStrArr;
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
