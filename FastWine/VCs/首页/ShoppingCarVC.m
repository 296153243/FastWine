//
//  ShoppingCarVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/4/28.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "ShoppingCarVC.h"
#import "ShoppingCarCell.h"
#import "PlaceOrderVC.h"
@interface ShoppingCarVC ()<DZNEmptyDataSetSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,ShopCartCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UIButton *ibGoBuyBtn;
@property (weak, nonatomic) IBOutlet UILabel *ibAllPicLab;
@property(nonatomic,strong) UIButton *rightBarButtonItem;
@property(nonatomic,strong)CarInfoRsp *carInfoRsp;
@property(nonatomic)NSInteger pageIndex;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,assign)double allPrice;
@property(nonatomic,assign)NSInteger goodsNum;;
@property(nonatomic,strong)AddShoppingCarRsp *addshoppingRsp;
@property(nonatomic,strong)NSString *cartIds;
@property(nonatomic,strong)NSMutableArray *idsArr;

@end

@implementation ShoppingCarVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
  
    [self requestDataIndex:0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.ibTableView.rowHeight = 110;
    self.ibTableView.tableFooterView = [UIView new];
    self.ibTableView.backgroundColor = TableView_bgColor;
    //    self.ibTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    //        self.pageIndex++;
    //        [self requestOrderListWithPageIndex:self.pageIndex];
    //
    //    }];
 

//    [self  setInfo];
    self.ibTableView.tableFooterView = [UIView new];
    _ibTableView.emptyDataSetSource = self;
    _ibTableView.emptyDataSetDelegate = self;
    self.navigationItem.title = @"购物车";
    
    UIButton* rightBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [rightBtn setTitle:@"完成" forState:UIControlStateSelected];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 50, 44);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn addTarget:self action:@selector(commitClick:) forControlEvents:UIControlEventTouchUpInside];
    _rightBarButtonItem = rightBtn;
    rightBtn.contentHorizontalAlignment  =  UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightBarButtonItem];

    [_ibGoBuyBtn gradientButtonWithSize:_ibGoBuyBtn.qu_size colorArray: @[[UIColor colorWithRed:243/255.0 green:5/255.0 blue:0/255.0 alpha:1.0],[UIColor colorWithRed:255/255.0 green:73/255.0 blue:21/255.0 alpha:1.0]] percentageArray:@[@(1),@(0)] gradientType:GradientFromLeftTopToRightBottom];
}
//MARK:----编辑a
- (void)commitClick:(UIButton *)sender{

    if (!_rightBarButtonItem.selected) {
        [self.ibGoBuyBtn setTitle:@"删除" forState:UIControlStateNormal];
    }else{
        [self.ibGoBuyBtn setTitle:@"去结算" forState:UIControlStateNormal];
    }
    _rightBarButtonItem.selected = !_rightBarButtonItem.selected;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingCarCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ShoppingCarCell" owner:nil options:nil][0];
    }
//    [cell.ibselectBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
 
    cell.delegate = self;
    if (_dataArr.count > 0) {
//        MainGoodsModel *model = _dataArr[indexPath.row];
        AddShoppingCarModel *addmodel  = _dataArr[indexPath.row];
        
        [cell addTheValue:addmodel];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark -- 实现加减按钮点击代理事件
/**
 *  实现加减按钮点击代理事件
 *
 *  @param cell 当前单元格
 *  @param flag 按钮标识，11 为减按钮，12为加按钮
 */
-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag{
    NSIndexPath *index = [self.ibTableView indexPathForCell:cell];
    switch (flag) {
        case 11:
        {
            
            //做减法
            //先获取到当期行数据源内容，改变数据源内容，刷新表格
            AddShoppingCarModel *model = self.dataArr[index.row];
            if (model.cart_num > 1)
            {
                model.cart_num --;
                model.trueStock++;
              
            }
            // [self.goodsTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
        case 12:
        {
            //做加法
            AddShoppingCarModel *model = self.dataArr[index.row];
            if (model.trueStock>0) {
                model.trueStock --;
                model.cart_num++;
                
            }
        
            //[self.goodsTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
        case 13:
        {    //先获取到当期行数据源内容，改变数据源内容，刷新表格
            AddShoppingCarModel *model = self.dataArr[index.row];
            if (model.selectState)            {
                model.selectState = NO;
            }else {
                model.selectState = YES;
                
            }
            //刷新当前行
            //[self.goodsTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        default:
            break;
    }
    //刷新表格
    [self.ibTableView reloadData];
    //先获取到当期行数据源内容，修改购物车数量
    AddShoppingCarModel *model = self.dataArr[index.row];
    [self requestShoppingCarEditorWithModel:model];
    
    //计算总价
    [self totalPrice];
    
}
#pragma mark -- 计算价格
-(void)totalPrice
{
    _cartIds = @"";
    [self.idsArr removeAllObjects];

    //遍历整个数据源，然后判断如果是选中的商品，就计算价格（单价 * 商品数量）
    for ( int i =0; i<self.dataArr.count; i++)    {
        AddShoppingCarModel *model = [self.dataArr objectAtIndex:i];
        if (model.selectState)
        {
            self.allPrice +=  model.cart_num  * [model.truePrice doubleValue];
            self.goodsNum += model.cart_num;
            
            _cartIds = [_cartIds stringByAppendingFormat:@",%@",model.id];
            
            if (![self.idsArr containsObject: model.id]) {
                [self.idsArr addObject:model.id];

            }
            
          
            NSLog(@"allPrice:%.2f----%@",self.allPrice,_cartIds);

        }
    }
    //给总价文本赋值
    self.ibAllPicLab.text = [NSString stringWithFormat:@"%.2f 元",self.allPrice];
//    self.settlementView.goodsNumLab.text=[NSString stringWithFormat:@"共计：%ld　件商品 ",(long)self.goodsNum];
    //每次算完要重置为0，因为每次的都是全部循环算一遍
    self.allPrice = 0;
    self.goodsNum = 0;

}
//MARK:----去结算
- (IBAction)ibGoBuyBtn:(UIButton *)sender {
    double total=[self.ibAllPicLab.text doubleValue];

    if ([sender.titleLabel.text isEqualToString:@"去结算"]) {
        if (total > 0) {
            //去下单页面 带过去cartId
            PlaceOrderVC *vc = [[PlaceOrderVC alloc]initWithNibName:@"PlaceOrderVC" bundle:nil];
            vc.cartId = [self.cartIds substringFromIndex:1];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            [QuHudHelper qu_showMessage:@"请选择结算商品"];
        }
    }else{
        //删除商品
        if (total > 0) {
            //
            [self requestDeleteShoppingCarGoods:nil];
            
        }else{
            [QuHudHelper qu_showMessage:@"请选择删除的商品"];
        }
    }
   
}

//MARK:----全选
- (IBAction)ibAllChooseBtnClick:(UIButton *)sender {
    //判断是否选中
    sender.tag = !sender.tag;
    if (sender.tag)    {
//        [sender setImage:[UIImage imageNamed:@"5.png"] forState:UIControlStateNormal];
        sender.selected = YES;
        
    }else{
//        [sender setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
        sender.selected = NO;
    }
    //改变单元格选中状态
    for (int i=0; i<self.dataArr.count; i++)
    {
        MainGoodsModel *model = [self.dataArr objectAtIndex:i];
        model.selectState = sender.tag;
    }
    //计算价格
    [self totalPrice];
    //刷新表格
    [self.ibTableView reloadData];
    
   
}

-(void)setInfo{
    self.allPrice=0;
    self.goodsNum = 0;
//    self.dataArr = [[NSMutableArray alloc]init];
    /**
     
     *  初始化一个数组，数组里面放字典。字典里面放的是单元格需要展示的数据
     
     */
    
    for (int i = 0; i<7; i++)
        
    {
        
        NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]init];
        
        [infoDict setValue:@"4.png" forKey:@"imageName"];
        
        [infoDict setValue:@"这是商品标题" forKey:@"goodsTitle"];
        
        [infoDict setValue:@"10" forKey:@"goodsPrice"];
        
        [infoDict setValue:[NSNumber numberWithBool:NO] forKey:@"selectState"];
        
        [infoDict setValue:[NSNumber numberWithInt:1] forKey:@"goodsNum"];
        /*
         @property(assign,nonatomic)int allNum;
         
         @property(assign,nonatomic)int remainedNum;
         */
        [infoDict setValue:[NSNumber numberWithInt:1000] forKey:@"allNum"];
        [infoDict setValue:[NSNumber numberWithInt:999] forKey:@"remainedNum"];
        
        //封装数据模型
        MainGoodsModel *goodsModel = [MainGoodsModel mj_objectWithKeyValues:infoDict];
        
        //将数据模型放入数组中
        
        [self.dataArr addObject:goodsModel];
        
    }
}
//MARK:---加入购物车
- (void)requestconAddShoppingCar
{
    
    
}
//TODO:----------获取data
- (void)requestDataIndex:(NSInteger )pageIdx{

    if (pageIdx == 0) {
        [_dataArr removeAllObjects];
    }
    weakSelf(weakSelf);
    [[HTTPRequest sharedManager]requesGetDataWithApiName:shoppingCarGoodsList withParameters:nil isEnable:YES withSuccess:^(id responseObject) {
        BaseResponse *rsp = [BaseResponse mj_objectWithKeyValues:responseObject];
        if (rsp.code == 200) {
            self.addshoppingRsp = [AddShoppingCarRsp mj_objectWithKeyValues:responseObject[@"data"]];
            [weakSelf.dataArr addObjectsFromArray:self.addshoppingRsp.valid];
            [self.ibTableView reloadData];
            
            
        }else{
            [QuHudHelper qu_showMessage:rsp.msg];
        }
        [self.ibTableView.mj_header endRefreshing];
        [self.ibTableView.mj_footer endRefreshing];
        if (self.addshoppingRsp.valid.count == 0) {
            [self.ibTableView.mj_footer endRefreshingWithNoMoreData];
        }
    } withError:^(NSError *error) {
        
    }];
  
    
}
//TODO:----------编辑购物车
- (void)requestShoppingCarEditorWithModel:(AddShoppingCarModel *)model{
    
    AddShoppingReq *req = [AddShoppingReq new];
    req.cartId = model.id;
    req.cartNum = [NSString stringWithFormat:@"%ld",model.cart_num];
    [[HTTPRequest sharedManager]requesGetDataWithApiName:shoppingCarEditor withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        BaseResponse *rsp = [BaseResponse mj_objectWithKeyValues:responseObject];
        if (rsp.code == 200) {
           
//               [QuHudHelper qu_showMessage:rsp.msg];
            
        }else{
            [QuHudHelper qu_showMessage:rsp.msg];
        }
   
    } withError:^(NSError *error) {
        
    }];
    
}
//TODO:----------删除购物车
- (void)requestDeleteShoppingCarGoods:(AddShoppingCarModel *)model{
    
    AddShoppingReq *req = [AddShoppingReq new];
    req.ids =_idsArr;
    
    [[HTTPRequest sharedManager]requestDataWithApiName:shoppingCarDelete withParameters:req isEnable:YES withSuccess:^(id responseObject) {
      [QuHudHelper qu_showMessage:responseObject[@"data"]];
      [self requestDataIndex:0];
    } withError:^(NSError *error) {
        
    }];
    
}
#pragma mark - EmptyDataSet

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *titleStr;
    NSAttributedString *attributrStr;
    NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#b3b3b3"],
                          NSFontAttributeName : [UIFont systemFontOfSize:13]};
    titleStr = @"暂无数据";
    attributrStr = [[NSAttributedString alloc] initWithString:titleStr attributes:dic];
    return attributrStr;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"NoneData_Icon"];
}
//MARK:----------Get
- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}

-(NSMutableArray *)idsArr{
    if (_idsArr == nil) {
        _idsArr = [NSMutableArray array];
    }
    return _idsArr;
}
@end
