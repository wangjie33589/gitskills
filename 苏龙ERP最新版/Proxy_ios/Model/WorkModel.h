//
//  WorkModel.h
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/23.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkModel : NSObject

@property (nonatomic, strong) NSArray* dataArray;
@property (nonatomic) BOOL isGoru;

+ (instancetype)initWithAddData:(NSDictionary *)aData;

@end
