//
//  HHWEPickerViewController.m
//  Honghai
//
//  Created by 班文政 on 2017/3/21.
//  Copyright © 2017年 Nado. All rights reserved.
//

#import "HHWEPickerViewController.h"
#import "UIImageView+WebCache.h"
#import <Photos/Photos.h> // iOS9开始推荐
#import "MBProgressHUD+MJ.h"


#define SCREEN_WIDETH [UIScreen mainScreen].bounds.size.width
//屏幕的高
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface HHWEPickerViewController ()


@property(nonatomic,strong)UIPageControl *page;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIScrollView *imageBgView;
@property(nonatomic,strong)NSMutableArray *images;
@property(nonatomic,strong)UIScrollView *scrView;

@end

@implementation HHWEPickerViewController


static NSString *WEAssetCollectionTitle = @"首面";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.scrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDETH, SCREEN_HEIGHT)];
    self.scrView.pagingEnabled = YES;
    self.scrView.contentSize = CGSizeMake(SCREEN_WIDETH * self.imagesArr.count, SCREEN_HEIGHT);
    self.scrView.delegate = self;
    self.images = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < self.imagesArr.count; i++) {
        self.imageBgView = [[UIScrollView alloc] init];
        self.imageBgView.tag = i;
        self.imageBgView.delegate = self;
        self.imageBgView.maximumZoomScale = 2;
        self.imageBgView.minimumZoomScale = 1;
        self.imageBgView.scrollEnabled = NO;
        self.imageBgView.showsHorizontalScrollIndicator = NO;
        self.imageBgView.showsVerticalScrollIndicator = NO;
        self.imageBgView.backgroundColor = [UIColor clearColor];
        self.imageBgView.frame = CGRectMake(i*SCREEN_WIDETH, 0, SCREEN_WIDETH, SCREEN_HEIGHT);
        [self.scrView addSubview:self.imageBgView];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDETH, SCREEN_HEIGHT)];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imagesArr[i]]];
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.imageBgView addSubview:self.imageView];
        
        [self.images addObject:self.imageView];
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
        //设置长按时间
        longPressGesture.view.tag = i;
        longPressGesture.minimumPressDuration = 0.5;
        [self.imageBgView addGestureRecognizer:longPressGesture];
    }
    
    [self.scrView setContentOffset:CGPointMake(SCREEN_WIDETH * [self.index intValue], 0)];
    
    self.page = [[UIPageControl alloc]initWithFrame:CGRectMake(SCREEN_WIDETH/2 - 50, SCREEN_HEIGHT - 50, 100, 20)];
    
    self.page.numberOfPages = self.imagesArr.count;//总的图片页数
    
    self.page.currentPage = [self.index intValue]; //当前页
    
    self.page.backgroundColor = [UIColor clearColor];
    
    if (self.imagesArr.count != 1) {
        
        [self.view addSubview:self.page];
    }
    
    [self.view addSubview:self.scrView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTapsRequired = 1; //点击次数
    tapGesture.numberOfTouchesRequired = 1; //点击手指数
    [self.view addGestureRecognizer:tapGesture]; //轻击手势触发
}

//长按手势触发方法
-(void)longPressGesture:(UILongPressGestureRecognizer *)sender
{
    UILongPressGestureRecognizer *longPress = sender;
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认保存?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self saveImage];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"保存成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    
    UIAlertController *alertController1 = [UIAlertController alertControllerWithTitle:@"保存失败" message:@"请允许程序访问你的相机" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController1 addAction:okAction1];
    
    
    if (!error) {
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [self presentViewController:alertController1 animated:YES completion:nil];
    }
}




- (void)saveImage
{
    // PHAsset : 一个资源, 比如一张图片\一段视频
    // PHAssetCollection : 一个相簿
    
    // PHAsset的标识, 利用这个标识可以找到对应的PHAsset对象(图片对象)
    __block NSString *assetLocalIdentifier = nil;
    
    // 如果想对"相册"进行修改(增删改), 那么修改代码必须放在[PHPhotoLibrary sharedPhotoLibrary]的performChanges方法的block中
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 1.保存图片A到"相机胶卷"中
        // 创建图片的请求
        
        UIImageView *imageView = self.images[[self.index intValue]];
        
        assetLocalIdentifier = [PHAssetCreationRequest creationRequestForAssetFromImage:imageView.image].placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (success == NO) {
            
            [self showError:@"保存图片失败!"];
            return;
        }
        
        // 2.获得相簿
        PHAssetCollection *createdAssetCollection = [self createdAssetCollection];
        
        if (createdAssetCollection == nil) {
            
            [self showError:@"创建相簿失败!"];
            return;
        }
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            // 3.添加"相机胶卷"中的图片A到"相簿"D中
            
            // 获得图片
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetLocalIdentifier] options:nil].lastObject;
            
            // 添加图片到相簿中的请求
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdAssetCollection];
            
            // 添加图片到相簿
            [request addAssets:@[asset]];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success == NO) {
                [self showError:@"保存图片失败!"];;
            } else {
                [self showSuccess:@"保存图片成功!"];;
            }
        }];
    }];
}

/**
 *  获得相簿
 */
- (PHAssetCollection *)createdAssetCollection
{
    // 从已存在相簿中查找这个应用对应的相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *assetCollection in assetCollections) {
        if ([assetCollection.localizedTitle isEqualToString:WEAssetCollectionTitle]) {
            return assetCollection;
        }
    }
    
    // 没有找到对应的相簿, 得创建新的相簿
    
    // 错误信息
    NSError *error = nil;
    
    // PHAssetCollection的标识, 利用这个标识可以找到对应的PHAssetCollection对象(相簿对象)
    __block NSString *assetCollectionLocalIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        // 创建相簿的请求
        assetCollectionLocalIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:WEAssetCollectionTitle].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    // 如果有错误信息
    if (error) return nil;
    
    // 获得刚才创建的相簿
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionLocalIdentifier] options:nil].lastObject;
}

- (void)showSuccess:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [MBProgressHUD showSuccess:text];
        
    });
}

- (void)showError:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [MBProgressHUD showError:text];
        
    });
}






//轻击手势触发方法
-(void)tapGesture:(UITapGestureRecognizer *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//监听事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [self.page setCurrentPage:offset.x / bounds.size.width];
    
    self.index = [NSString stringWithFormat:@"%ld",(long)self.page.currentPage];
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return scrollView.subviews[0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
