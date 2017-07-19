//
//  KYSign.h
//  科远签到
//
//  Created by sciyonSoft on 16/5/19.
//  Copyright © 2016年 lf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KYSign : NSObject


@property (nonatomic, copy) NSString *GUID0;

@property (nonatomic, copy) NSString *CUSTOMERINFO;

@property (nonatomic, copy) NSString *CUSTOMERINFO1;

+ (instancetype)videoWithDict:(NSDictionary *)dict;
@end
