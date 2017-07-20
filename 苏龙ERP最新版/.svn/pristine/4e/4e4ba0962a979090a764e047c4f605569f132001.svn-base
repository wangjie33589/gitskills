//
//  NewsModel.m
//  Proxy_ios
//
//  Created by E-Bans on 15/11/20.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

+ (instancetype)initWithAddData:(NSDictionary *)aData
{
    NewsModel* model = [NewsModel new];
    model.guid = [aData objectForKey:@"GUID"];
    model.type = [aData objectForKey:@"TYPEVALUE"];
    model.typeName = [aData objectForKey:@"TYPENAME"];
    model.time = [aData objectForKey:@"EDITTIME"];
    return model;
}

@end
