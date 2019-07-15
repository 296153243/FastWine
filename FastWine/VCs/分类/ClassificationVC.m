//
//  ClassificationVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/5/28.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "ClassificationVC.h"
#import "ClassCell.h"
#import "TagsFrame.h"
#import "SearchGoods.h"
#import <PYSearch.h>
@interface ClassificationVC ()
@property (weak, nonatomic) IBOutlet UISearchBar *ibSearchBar;

@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property(nonatomic,strong)NSArray *hotkeywordArr;

@property(nonatomic,strong)NSArray *classArr;
@property (nonatomic, strong) NSArray *tagsArray;

@property (nonatomic, strong) NSMutableArray *tagsFrames;

@property(nonatomic,strong)GoodsClassRsp *dataRsp;
@end

@implementation ClassificationVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.ibTableView.tableFooterView = [UIView new];
    [self requestClassData];
    [self requestHotkeyword];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = NavColor;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self requestClassData];
    //头部搜索框
    self.ibSearchBar.backgroundImage = [[UIImage alloc]init];
    UITextField *searchField=[self.ibSearchBar valueForKey:@"_searchField"];
    searchField.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    searchField.clipsToBounds =YES;
    searchField.layer.cornerRadius = 5;
    
}
- (IBAction)ibbackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
  
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:_hotkeywordArr searchBarPlaceholder:@"搜一搜" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        
        SearchGoods *vc = [[SearchGoods alloc]initWithNibName:@"SearchGoods" bundle:nil];
        vc.searchStr = searchText;
        [searchViewController.navigationController pushViewController:vc animated:YES];
        
    }];
    searchViewController.hotSearchStyle = PYSearchHistoryStyleBorderTag;
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleNormalTag;
    [searchViewController setSearchHistoriesCount:10];
    [searchViewController setSwapHotSeachWithSearchHistory:YES];
    // 3. present
    //                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    //                [self presentViewController:nav  animated:NO completion:nil];
    [self.navigationController pushViewController:searchViewController animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [_tagsFrames[indexPath.row] tagsHeight];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _tagsFrames.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassCell"];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ClassCell" owner:nil options:nil][0];
    }
    if (self.tagsFrames) {
     cell.tagsFrame = _tagsFrames[indexPath.row];
        
    }
    if (indexPath.row == _tagsFrames.count - 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, 1500, 0, 0);
    }
    cell.classBtnClickBlock = ^(NSInteger  idx) {
        SearchGoods *vc = [[SearchGoods alloc]initWithNibName:@"SearchGoods" bundle:nil];
         GoodsClassModel *model = self.dataRsp.data[indexPath.row];
        NSDictionary *dic = model.child[idx];
        vc.cid = dic[@"id"];
        
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SearchGoods *vc = [[SearchGoods alloc]initWithNibName:@"SearchGoods" bundle:nil];
    GoodsClassModel *model = _dataRsp.data[indexPath.row];
    vc.cid = model.id;
    [self.navigationController pushViewController:vc animated:YES];
}

//MARK:----商品分类
-(void)requestClassData{
    [[HTTPRequest sharedManager]requesGetDataWithApiName:goodsCategory withParameters:nil isEnable:YES withSuccess:^(id responseObject) {
        self.dataRsp = [GoodsClassRsp mj_objectWithKeyValues:responseObject];
        self.tagsFrames = [NSMutableArray array];
    
        [self.dataRsp.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GoodsClassModel *model = obj;
            TagsFrame *frame = [[TagsFrame alloc] init];
            
            frame.tagsMinPadding  = 5;
            frame.tagsMargin      = 20;
            frame.tagsLineSpacing = 10;
            frame.sectionTitle = model.cate_name;
            NSMutableArray *arr = [NSMutableArray array];
            [model.child enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *name = obj[@"cate_name"];
                [arr addObject:name];
            }];
            frame.tagsArray = arr;
            [self.tagsFrames addObject:frame];

        }];
        [self.ibTableView reloadData];
    } withError:^(NSError *error) {
        
    }];
}
//MARK:----热门关键子
-(void)requestHotkeyword{
    [[HTTPRequest sharedManager]requesGetDataWithApiName:hotkeyword withParameters:nil isEnable:YES withSuccess:^(id responseObject) {
        self.hotkeywordArr = responseObject[@"data"];
        
    } withError:^(NSError *error) {
        
    }];
}
@end
