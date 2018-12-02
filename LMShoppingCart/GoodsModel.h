//
//  GoodsModel.h
//  LMShoppingCart
//
//  Created by Apple on 2018/11/29.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodsModel : JSONModel
/**商品名*/
@property (nonatomic, copy) NSString *name;
/**商品价格*/
@property (nonatomic, copy) NSString *price;
/**商品购买数量*/
@property (nonatomic, assign) NSInteger goodsBuyNumber;

@end

NS_ASSUME_NONNULL_END
