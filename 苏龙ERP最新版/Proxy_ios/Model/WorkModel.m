//
//  WorkModel.m
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/23.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "WorkModel.h"

@implementation WorkModel

+ (instancetype)initWithAddData:(NSDictionary *)aData
{
    WorkModel* model = [[WorkModel alloc] init];
    model.dataArray = [aData objectForKey:@"data"];
    model.isGoru = YES;
    return model;
}

@end
