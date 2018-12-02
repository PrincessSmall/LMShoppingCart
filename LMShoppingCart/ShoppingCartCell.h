//
//  ShoppingCartCell.h
//  LMShoppingCart
//
//  Created by Apple on 2018/11/29.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const kShoppingCartCell = @"kShoppingCartCell";
@class GoodsModel;

typedef void(^plusButtonClick)(GoodsModel *goodsModel);
typedef void(^minusButtonClick)(GoodsModel *goodsModel);

@interface ShoppingCartCell : UITableViewCell

@property (nonatomic, strong) GoodsModel *goodsModel;

@property (nonatomic, copy) plusButtonClick plusButtonBlock;
@property (nonatomic, copy) minusButtonClick minusButtonBlock;

@end

NS_ASSUME_NONNULL_END
