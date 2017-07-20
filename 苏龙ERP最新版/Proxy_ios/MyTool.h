//
//  MyTool.h
//  Proxy_ios
//
//  Created by sciyonSoft on 15/12/21.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTool : NSObject
//rgb转换
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
//生成 uuid
+ (NSString*) stringWithUUID;
//时间转换
+(NSString *)DataFormart :(NSString*)dateString;
+(NSString *)daFormatByComment:(NSString*)dastring;
//两个时间的比较
+(BOOL)compairTimeA:(NSString*)timeA timeB:(NSString*)TimeB;


@end
