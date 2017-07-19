//
//  KYSign.m
//  科远签到
//
//  Created by sciyonSoft on 16/5/19.
//  Copyright © 2016年 lf. All rights reserved.
//

#import "KYSign.h"

@implementation KYSign

+ (instancetype)videoWithDict:(NSDictionary *)dict
{
    KYSign *sign = [[self alloc] init];
    [sign setValuesForKeysWithDictionary:dict];
    return sign;
}

@end
