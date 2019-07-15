//
//  GoodsDetalisCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/3/28.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "GoodsDetalisCell.h"
#import "GoodsImgCollectionCell.h"
@interface GoodsDetalisCell()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)NSArray *goodsImgArr;
@property(nonatomic)NSInteger isNeedRefresh;
@property(nonatomic,strong)   UIImageView *imgv;
@property(nonatomic)CGFloat webH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibGoodsNameTop;
@property(nonatomic)BOOL isUpdate;
@end
@implementation GoodsDetalisCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
 
    [self.ibGoodsImgView setPlaceholderImage:[UIImage imageNamed:@"goods_noImage"]];
    _ibGoodsImgView.backgroundColor = TableColor;
    [self configCollectionView];
    _imgv = [UIImageView new];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setViewModel:(GoodsDetalisModel *)viewModel{
    _viewModel = viewModel;
    if (_viewModel) {
        _ibGoodsNameTop.constant = 15.0f;
        self.ibGoodsName.text = _viewModel.store_name;
        self.ibGoodsPic.text = [NSString stringWithFormat:@"¥%@",_viewModel.price];
        if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1) {
            self.ibGoodsPic.text = [NSString stringWithFormat:@"¥%@",_viewModel.vip_price];
        }
        self.ibStockLab.text = [NSString stringWithFormat:@"库存:%@",_viewModel.stock];
     

        
        float xiaoliang = [_viewModel.ficti floatValue] +  [_viewModel.sales floatValue];
        self.ibGoodsSales.text = [NSString stringWithFormat:@"销量:%.0f",xiaoliang];
        NSMutableArray *arr= [NSMutableArray array];
        for (NSString *str  in viewModel.slider_image) {
            [arr addObject:str];
        }
        
        self.ibGoodsImgView.imageURLStringsGroup = arr;
        
        _ibGoodsImgView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        self.ibimgsNumberLab.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
         self.ibimgsNumberLab.text = [NSString stringWithFormat:@"1 / %lu",(unsigned long)viewModel.slider_image.count];
        _ibGoodsImgView.itemDidScrollOperationBlock = ^(NSInteger currentIndex) {
        self.ibimgsNumberLab.text = [NSString stringWithFormat:@"%ld / %lu",(long)currentIndex + 1,(unsigned long)viewModel.slider_image.count];
         
        };
        self.ibGoodsImgView.autoScroll = NO;
        if (_viewModel.name.length == 0) {
            _ibShuxingView.hidden = YES;
            _ibImgCollectionTop.constant = 10;
        }
        self.ibXiangxingLab.text = _viewModel.name;
        self.ibShengchandizhiLab.text = _viewModel.pro_address;
        self.ibBaozhuangguigeLab.text = _viewModel.pack_nomals;
        self.ibJInghanliangLab.text = _viewModel.nw;
        self.ibCunachutiaojianLab.text = _viewModel.save_condition;
        self.ibJiujingduLab.text = _viewModel.centigrade;

        if (_viewModel.des) {
            _goodsImgArr = [self filterImage:_viewModel.des];

        }
//        [self.ibImgCollectionView reloadData];

//        viewModel.des
     
//        NSLog(@"+++++%@",_goodsImgArr);

    }
}
-(void)setKillgoodsViewModel:(GoodsDetalisModel *)killgoodsViewModel{
    _killgoodsViewModel = killgoodsViewModel;
    if (_killgoodsViewModel) {
        _ibGoodsNameTop.constant = 85.0f;
        _ibMiaoshaView.hidden = NO;
        self.ibGoodsName.text = _killgoodsViewModel.title;
        self.ibGoodsPic.text = [NSString stringWithFormat:@"¥%@",_killgoodsViewModel.price];
        self.ibPic.text = [NSString stringWithFormat:@"%@",_killgoodsViewModel.price];
        self.ibKucun.text = [NSString stringWithFormat:@" 库存:%@ ",_killgoodsViewModel.stock];
        //原价富文本
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:_killgoodsViewModel.ot_price];
        
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, _killgoodsViewModel.ot_price.length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, _killgoodsViewModel.ot_price.length)];
        [self.ibOtPicLab setAttributedText:attri];
        
        float xiaoliang = [_killgoodsViewModel.ficti floatValue] +  [_killgoodsViewModel.sales floatValue];
        self.ibXInagliang.text = [NSString stringWithFormat:@"     销量:%.0f     ",xiaoliang];
        self.ibStockLab.text = [NSString stringWithFormat:@"库存:%@",_killgoodsViewModel.stock];
        self.ibGoodsSales.text = [NSString stringWithFormat:@"销量:%.0f",xiaoliang];
        NSMutableArray *arr= [NSMutableArray array];
        for (NSString *str  in _killgoodsViewModel.images) {
            [arr addObject:str];
        }
        
        self.ibGoodsImgView.imageURLStringsGroup = arr;
        
        _ibGoodsImgView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        self.ibimgsNumberLab.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
        self.ibimgsNumberLab.text = [NSString stringWithFormat:@"1 / %lu",(unsigned long)_killgoodsViewModel.images.count];
        _ibGoodsImgView.itemDidScrollOperationBlock = ^(NSInteger currentIndex) {
            self.ibimgsNumberLab.text = [NSString stringWithFormat:@"%ld / %lu",(long)currentIndex + 1,(unsigned long)self->_killgoodsViewModel.images.count];
            
        };
        self.ibGoodsImgView.autoScroll = NO;
        
        if (_killgoodsViewModel.desc) {
            _goodsImgArr = [self filterImage:_killgoodsViewModel.desc];

        }
//        [self.ibImgCollectionView reloadData];
        
        //        viewModel.des
        
        //        NSLog(@"+++++%@",_goodsImgArr);
        
    }
}
- (NSArray *)filterImage:(NSString *)html

{
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<(img|IMG)(.*?)(/>|></img>|>)" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    
    NSArray *result = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    
    for (NSTextCheckingResult *item in result) {
        
        NSString *imgHtml = [html substringWithRange:[item rangeAtIndex:0]];
        
        NSArray *tmpArray = nil;
        
        if ([imgHtml rangeOfString:@"src=\""].location != NSNotFound) {
            
            tmpArray = [imgHtml componentsSeparatedByString:@"src=\""];
            
        } else if ([imgHtml rangeOfString:@"src="].location != NSNotFound) {
            
            tmpArray = [imgHtml componentsSeparatedByString:@"src="];
            
        }
        
        
        
        if (tmpArray.count >= 2) {
            
            NSString *src = tmpArray[1];
            
            NSUInteger loc = [src rangeOfString:@"\""].location;
            
            if (loc != NSNotFound) {
                
                src = [src substringToIndex:loc];
                
                [resultArray addObject:src];
                
            }
            
        }
        
    }
 
    return resultArray;
    
}
-(void)setReplyModel:(ReplyModel *)replyModel{
    _replyModel = replyModel;
    if (_replyModel) {
        _ibNameLab.text = _replyModel.nickname;

        NSRange range = [_replyModel.avatar rangeOfString:@"http://"];
        if (range.location == NSNotFound) {
            
              [_ibIconLab sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTNAME,_replyModel.avatar]] placeholderImage:[UIImage imageNamed:@"user_icon_def"]];
            
        }else{
               [_ibIconLab sd_setImageWithURL:[NSURL URLWithString:_replyModel.avatar] placeholderImage:[UIImage imageNamed:@"user_icon_def"]];
        }
     
        _ibContentLab.text = _replyModel.comment;
        _ibTime.text = _replyModel.add_time;
        _ibNameLab.text = _replyModel.nickname;
        
        for (UIView *view in self.ibStarView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *btnn=(UIButton *)view;
                if (view.tag <= [_replyModel.star integerValue] + 100) {
                    btnn.selected=YES;
                }else{
                    btnn.selected=NO;
                }
            }
        }
   
        if (_replyModel.pics.count > 0 && _replyModel.pics.count < 4) {
            [_replyModel.pics enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIImageView *image = [self->_ibImagesView viewWithTag:idx + 71];
                [image sd_setImageWithURL:[NSURL URLWithString:obj]];
            }];
          
        }else{
            //没有图片
            _ibImagesView.hidden = YES;
        }
       
        
        
    }
}
- (IBAction)starBtnClick:(UIButton *)sender {
  
 
    
}
- (IBAction)ibLookBigImgAction:(id)sender {
    NSMutableArray *arrImgs = [NSMutableArray array];
  
    if (_replyModel.pics.count > 0) {
        [_replyModel.pics enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YBImageBrowseCellData *data0 = [YBImageBrowseCellData new];
            data0.url = obj;
            //data0.sourceObject = UIImage;
            [arrImgs addObject:data0];
        }];
    }
    
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = arrImgs;
    browser.currentIndex = 0;
    [browser show];
}

//MARK:--------UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

//MARK:------configCollectionView
- (void)configCollectionView{
    
    [_ibImgCollectionView registerNib:[UINib nibWithNibName:@"GoodsImgCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"GoodsImgCollectionCell"];
    
    _ibImgCollectionView.backgroundColor = WhiteColor;

}


#pragma mark - UICollectionViewDataSource
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
 
    if([indexPath row] == ((NSIndexPath*)[[collectionView indexPathsForVisibleItems] lastObject]).row){
        //end of loading
        dispatch_async(dispatch_get_main_queue(),^{
            //for example [activityIndicator stopAnimating];
        
        });
    }

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   

    return _goodsImgArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //OBD 商品
    GoodsImgCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsImgCollectionCell" forIndexPath:indexPath];

    cell.imageUrl = _goodsImgArr[indexPath.row];
 
 
    return cell;
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    
    return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
  
    
}
 CGFloat imageScale;
static NSInteger isddd;
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    [self.imgv sd_setImageWithURL:[NSURL URLWithString:_goodsImgArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"goods_noImage"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!error && image.size.width >0) {
            imageScale = image.size.height/image.size.width;
            CGFloat newImageWidth = image.size.width;
            CGFloat newImageHeight = imageScale * newImageWidth;
        NSLog(@"newImageWidth:%f----newImageHeight:%f---imageScale:%f+++++%ld",newImageWidth,newImageHeight,imageScale,indexPath.row);
         
//             self.webH = self.webH +newImageHeight;
         
            if (indexPath.row == self.goodsImgArr.count - 1) {
                [self performSelector:@selector(uploadedddd) withObject:nil afterDelay:0.5];
            }

//            NSLog(@"webH:++++%f------%f",self.ibImgCollectionView.collectionViewLayout.collectionViewContentSize.height,self.webH);
//            if (self.webH != self.ibImgCollectionView.collectionViewLayout.collectionViewContentSize.height) {
//                
//                if (self.collectionViewLoadFinish) {
//                    self.collectionViewLoadFinish(self.ibImgCollectionView.collectionViewLayout.collectionViewContentSize.height);
//                }
//            }
//            self.webH = self.ibImgCollectionView.collectionViewLayout.collectionViewContentSize.height;
         
//            [self.ibImgCollectionView reloadData];
//            self.ibgoodsImgW.constant = newImageWidth;
//            self.ibgoodsImgH.constant = newImageHeight;
      
        }
    }];


//    NSLog(@"SCREEN_WIDTH *imageScale:--------%f",SCREEN_WIDTH *imageScale);
//    if (SCREEN_WIDTH *imageScale > 0) {
//    }else{
//        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH *0.78);
//    }
    return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH *imageScale);


}
-(void)uploadedddd{
  
 
  __block  BOOL reloadFinished = NO;
//    [_ibImgCollectionView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        reloadFinished = YES;
    
    
    });
   NSLog(@"webH:++++%f------%f",self.ibImgCollectionView.collectionViewLayout.collectionViewContentSize.height,self.webH);
        
        if (self.webH != self.ibImgCollectionView.collectionViewLayout.collectionViewContentSize.height) {
            if (self.collectionViewLoadFinish) {
                self.collectionViewLoadFinish(self.ibImgCollectionView.collectionViewLayout.collectionViewContentSize.height);
            }
         
        }
        
        
    
}
#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.001;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.001;
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.1, 0.1, 0.1, 0.1);
}

@end
