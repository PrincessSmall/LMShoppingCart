//
//  ShoppingCartCell.m
//  LMShoppingCart
//
//  Created by Apple on 2018/11/29.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ShoppingCartCell.h"
#import <Masonry.h>
#import "GoodsModel.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ShoppingCartCell ()

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *minusButton;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIButton *plusButton;

@end

@implementation ShoppingCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUIFrames];
    }
    return self;
}


#pragma mark --------setUPUI------
- (void)setGoodsModel:(GoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    self.titleLabel.text = goodsModel.name;
    self.priceLabel.text = goodsModel.price;
    self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)goodsModel.goodsBuyNumber];
    self.minusButton.enabled = goodsModel.goodsBuyNumber == 0 ? NO : YES;
}


#pragma mark ===============按钮点击事件==================

- (void)clickPlusButton
{
    self.goodsModel.goodsBuyNumber ++;
    // block传递cell的plusButton按钮的点击事件
    self.plusButtonBlock(self.goodsModel);
}

- (void)clickMimusButton
{
    self.goodsModel.goodsBuyNumber --;
    // block传递cell的minusButton按钮的点击事件
    self.minusButtonBlock(self.goodsModel);
}


#pragma mark --------layoutUIFrames------

- (void)layoutUIFrames
{
    [self.contentView addSubview:self.goodsImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.minusButton];
    [self.contentView addSubview:self.numLabel];
    [self.contentView addSubview:self.plusButton];
    
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(35);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsImageView);
        make.left.mas_equalTo(self.goodsImageView.mas_right).offset(5);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
    
    [self.plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(25);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(self.plusButton.mas_left).offset(-15);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.minusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(self.numLabel.mas_left).offset(-15);
        make.width.height.mas_equalTo(25);
    }];
}


#pragma mark --------lazy------

- (UIImageView *)goodsImageView
{
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc]init];
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _goodsImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.font = [UIFont systemFontOfSize:12];
        _priceLabel.textColor = [UIColor orangeColor];
    }
    return _priceLabel;
}

- (UIButton *)minusButton
{
    if (!_minusButton) {
        _minusButton = [[UIButton alloc]init];
        [_minusButton setTitle:@"➖" forState:UIControlStateNormal];
        [_minusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _minusButton.layer.cornerRadius = 12.5;//设置圆角半径
        _minusButton.layer.masksToBounds = YES;
        _minusButton.layer.borderWidth = 1.0;//设置边框宽度
        _minusButton.layer.borderColor = [UIColor orangeColor].CGColor;//设置边框颜色
        [_minusButton addTarget:self action:@selector(clickMimusButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _minusButton;
}

- (UILabel *)numLabel
{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc]init];
        _numLabel.textColor = [UIColor blackColor];
        _numLabel.font = [UIFont systemFontOfSize:14];
        _numLabel.backgroundColor = [UIColor greenColor];
        _numLabel.text = @"0";
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}

- (UIButton *)plusButton
{
    if (!_plusButton) {
        _plusButton = [[UIButton alloc]init];
        [_plusButton setTitle:@"➕" forState:UIControlStateNormal];
        [_plusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _plusButton.layer.cornerRadius = 12.5;
        _plusButton.layer.masksToBounds = YES;
        _plusButton.layer.borderWidth = 1.0;//设置边框宽度
        _plusButton.layer.borderColor = [UIColor orangeColor].CGColor;//设置边框颜色
        [_plusButton addTarget:self action:@selector(clickPlusButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _plusButton;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
