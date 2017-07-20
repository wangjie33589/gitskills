//
//  PeopleModel.h
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/12/3.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PeopleModel : NSObject

@property (nonatomic, strong) NSDictionary* data;
@property (nonatomic)BOOL isSelected;

+ (instancetype)initWithData:(NSDictionary *)aData;

@end
