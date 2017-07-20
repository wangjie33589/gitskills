//
//  NetWorkTool.h
//  KYDemo
//
//  Created by sciyonSoft on 15/11/24.
//  Copyright © 2015年 sciyonSoft. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NetWorkTool : NSObject
//用户登陆请求

+ (void)completionBlock:(void(^)(NSDictionary *dic))block;
+(void)loginWithName:(NSString *)name andPassword:(NSString *)password andisLimitorNot:(NSString*)flag completionBlock:(void(^)(NSDictionary *dict))block;
+ (void)saveCookies;
+(void)workTaskrequest;
// 查询明细参数请求。

+(void)workTaskcompletionBlock:(void (^)(NSDictionary * dic))block;

+(void)workTaskWithName:(NSString *)FTITLE completionBlock:(void (^)(NSDictionary * dic))block;
+(void)workTaskSearchContain:(NSString *)contain completionBlock:(void (^)(NSDictionary * dic))block;
+(void)searchDetilWithFGUID:(NSString*)FGUID completionBlock:(void(^)(NSDictionary *dic))block;
+(void)workTaskSearchPAGE:(int)page completionBlock:(void (^)(NSDictionary * dic))block;


@end
