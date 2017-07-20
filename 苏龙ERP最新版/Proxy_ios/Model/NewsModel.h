//
//  NewsModel.h
//  Proxy_ios
//
//  Created by E-Bans on 15/11/20.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

@property (nonatomic, strong) NSString* guid;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* typeName;
@property (nonatomic, strong) NSString* time;

+ (instancetype)initWithAddData:(NSDictionary *)aData;

@end
