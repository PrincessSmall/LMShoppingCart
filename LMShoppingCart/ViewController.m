//
//  ViewController.m
//  LMShoppingCart
//
//  Created by Apple on 2018/11/29.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "GoodsModel.h"
#import <JSONModel.h>
#import "ShoppingCartCell.h"
#import <Masonry.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *cartTableView;
@property (nonatomic, strong) UILabel *totalPriceLab;
@property (nonatomic, strong) UIView *bottomView;

/**购物车模型数组*/
@property (nonatomic, strong) NSArray *cartArray;
/**购买商品数组*/
@property (nonatomic, strong) NSMutableArray *buyGoodsArray;

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.cartTableView];
    [self layoutBottomView];
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma mark ===============layoutBottomView==================

- (void)layoutBottomView
{
    [self.view addSubview:self.bottomView];
    
    UILabel *totalPriceTitleLab = [[UILabel alloc]init];
    totalPriceTitleLab.text = @"总价：";
    totalPriceTitleLab.textColor = [UIColor blackColor];
    totalPriceTitleLab.font = [UIFont systemFontOfSize:14];
    [self.bottomView addSubview:totalPriceTitleLab];
    [self.bottomView addSubview:self.totalPriceLab];
    
    UIButton *buyButton = [[UIButton alloc]init];
    [buyButton setTitle:@"购买" forState:UIControlStateNormal];
    [buyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    buyButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [buyButton addTarget:self action:@selector(buyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    buyButton.enabled = self.totalPriceLab.text != 0 ? YES :NO;
    [self.bottomView addSubview:buyButton];
    
    UIButton *deleteButton = [[UIButton alloc]init];
    [deleteButton setTitle:@"清空购物车" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:deleteButton];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideBottom);
    }];
    
    [totalPriceTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomView);
        make.left.mas_equalTo(20);
    }];
    
    [self.totalPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(totalPriceTitleLab);
        make.left.mas_equalTo(totalPriceTitleLab.mas_right).offset(3);
    }];
    
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.totalPriceLab);
    }];
    
    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(deleteButton.mas_left).offset(-8);
        make.centerY.mas_equalTo(deleteButton);
    }];
    
    [self.cartTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
}


#pragma mark ===============button点击事件==================

- (void)buyButtonClick
{
    for (GoodsModel *goodsModel in self.buyGoodsArray) {
        NSLog(@"购买了%ld件%@商品",(long)goodsModel.goodsBuyNumber,goodsModel.name);
    }
}

- (void)deleteButtonClick
{
    for (GoodsModel *goodsModel in self.buyGoodsArray) {
        goodsModel.goodsBuyNumber = 0;
    }
    [self.buyGoodsArray removeAllObjects];
    //改变模型刷新数组
    [self.cartTableView reloadData];
    
    self.totalPriceLab.text = @"0";
}


#pragma mark --------UITableViewDataSource------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cartArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:kShoppingCartCell];
    cell.goodsModel = self.cartArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    __weak __typeof__(self) weakSelf = self;
    //block处理，刷新tableView，添加购买商品数组，改变总价（这里也可以使用代理来做）
    cell.plusButtonBlock = ^(GoodsModel * _Nonnull goodsModel) {
        [weakSelf.cartTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        
        if (![weakSelf.buyGoodsArray containsObject:goodsModel]) {
            [weakSelf.buyGoodsArray addObject:goodsModel];
        }
        self.totalPriceLab.text = [NSString stringWithFormat:@"%ld",(self.totalPriceLab.text.integerValue + cell.goodsModel.price.integerValue)];
    };
    //block处理，刷新tableView，移除购买商品数组
    cell.minusButtonBlock = ^(GoodsModel * _Nonnull goodsModel) {
        [weakSelf.cartTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        if (cell.goodsModel.goodsBuyNumber == 0) {
            [weakSelf.buyGoodsArray removeObject:goodsModel];
        }
        self.totalPriceLab.text = [NSString stringWithFormat:@"%ld",(self.totalPriceLab.text.integerValue - cell.goodsModel.price.integerValue)];
    };

    
    return cell;
    
    
}


#pragma mark ===============UITableViewDelegate==================

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

#pragma mark --------lazy------

- (UITableView *)cartTableView
{
    if (!_cartTableView) {
        _cartTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _cartTableView.delegate = self;
        _cartTableView.dataSource = self;
        [_cartTableView registerClass:[ShoppingCartCell class] forCellReuseIdentifier:kShoppingCartCell];
    }
    return _cartTableView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UILabel *)totalPriceLab
{
    if (!_totalPriceLab) {
        _totalPriceLab = [[UILabel alloc]init];
        _totalPriceLab.textColor = [UIColor redColor];
        _totalPriceLab.font = [UIFont systemFontOfSize:14];
        _totalPriceLab.text = [NSString stringWithFormat:@"0"];
    }
    return _totalPriceLab;
}

- (NSArray *)cartArray
{
    if (!_cartArray) {
        NSArray *tep = [[NSArray alloc]init];
        tep = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ShoppingGoods" ofType:@"plist"]];
        NSMutableArray *tempArray = [NSMutableArray array];
        NSError *error;
        for (NSDictionary *dic in tep) {
           GoodsModel *goodsModel = [[GoodsModel alloc]initWithDictionary:dic error:&error];
           [tempArray addObject:goodsModel];
        }
        _cartArray = tempArray;
        
        // KVO监听购买数量的属性
//        for (GoodsModel *model in _cartArray) {
//            [model addObserver:self forKeyPath:@"goodsBuyNumber" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];//通过kvo监听模型这个属性的改变
//            NSLog(@"%@",[model valueForKey:@"isa"]);//一个对象的isa指针指向他的真实类型，可以通过这个打印看到使用KVO监听之后，苹果默认为使用监听的这个类生成一个新的子类
//        }
    }
    return _cartArray;
}

- (NSMutableArray *)buyGoodsArray
{
    if (!_buyGoodsArray) {
        _buyGoodsArray = [NSMutableArray array];
    }
    return _buyGoodsArray;
}


#pragma mark ===============KVO==================
//模型的监听的属性改变就会调用这个方法，这里使用KVO监听模型中购买数量的属性，做到更改总价

/**
 <#Description#>

 @param keyPath 属性
 @param object 监听的对象
 @param change <#change description#>
 @param context <#context description#>
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(GoodsModel *)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
//    NSLog(@"observeValueForKeyPath:%@，%@",keyPath,object);
    NSLog(@"%@",change);//通过字典将监听的属性的新值和旧值返回回来，可以通过这个打印看看
    NSInteger new = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
    NSInteger old = [[change objectForKey:NSKeyValueChangeOldKey] integerValue];
    if (new > old) {//用户点击的是加号
        self.totalPriceLab.text = [NSString stringWithFormat:@"%ld",(self.totalPriceLab.text.integerValue + object.price.integerValue)];
    } else {//用户点击了减号
        self.totalPriceLab.text = [NSString stringWithFormat:@"%ld",(self.totalPriceLab.text.integerValue - object.price.integerValue)];
    }
    
}

- (void)dealloc
{
    for (GoodsModel *model in self.cartArray) {
        [model removeObserver:self forKeyPath:@"goodsBuyNumber"];
    }
}




@end
