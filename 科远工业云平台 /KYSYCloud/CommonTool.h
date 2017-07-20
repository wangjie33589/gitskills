//
//  CommonTool.h
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/4.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonTool : NSObject
+(void)GoToHome;
+(NSString *)DataFormart :(NSString*)dateString;
+(NSString *)daFormatByComment:(NSString*)dastring;
+(void)saveCooiker;
	
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+(NSString *)handleEmptyString:(NSString *)string;
+ (NSString *)downloadPath;
+ (void)saveChatDic:(NSMutableDictionary *)dic;
+(NSString*)returnDpname:(NSArray *)aRR withStr:(NSString*)Str;
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
;
+(NSString *)cleanNULL:(NSString *)string;
+(UISegmentedControl*)creatSegWithArray:(NSArray *)array;

@end
