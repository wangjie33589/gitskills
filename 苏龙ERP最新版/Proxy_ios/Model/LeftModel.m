//
//  LeftModel.m
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/15.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "LeftModel.h"

@implementation LeftModel

+ (instancetype)initWithAddData:(NSMutableArray *)aData
{
    LeftModel* model = [LeftModel new];
    model.dataArray = [NSMutableArray arrayWithArray:aData];
    model.anRow = NO;
    return model;
}

@end
