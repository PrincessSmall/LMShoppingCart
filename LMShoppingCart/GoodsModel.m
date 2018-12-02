//
//  GoodsModel.m
//  LMShoppingCart
//
//  Created by Apple on 2018/11/29.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"goodsBuyNumber"])
        return YES;
    
    return NO;
}

@end
