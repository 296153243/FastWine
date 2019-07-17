//
//  BargainDetalisVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/7/17.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "BargainDetalisVC.h"
#import "BargainHeardCell.h"
@interface BargainDetalisVC ()
@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionView;

@end

@implementation BargainDetalisVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"砍价免费拿";
    [self configCollectionView];
}
- (void)configCollectionView{
    
    [_ibCollectionView registerNib:[UINib nibWithNibName:@"BargainHeardCell" bundle:nil] forCellWithReuseIdentifier:BargainHeardID];
  
    //    _ibCollectionView.backgroundColor = WhiteColor;
    
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BargainHeardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BargainHeardID forIndexPath:indexPath];
    return cell;
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return CGSizeMake(SCREEN_WIDTH, 740);
    return CGSizeMake(SCREEN_WIDTH, 0.1);
    
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

@end
