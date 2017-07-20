//
//  PeopleModel.m
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/12/3.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "PeopleModel.h"

@implementation PeopleModel

+ (instancetype)initWithData:(NSDictionary *)aData
{
    PeopleModel* model = [[PeopleModel alloc] init];
    model.data = aData;
    model.isSelected = NO;
    return model;
}

@end
