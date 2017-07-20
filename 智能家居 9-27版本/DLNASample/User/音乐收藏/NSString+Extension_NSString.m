//
//  NSString+Extension_NSString.m
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/11/15.
//
//

#import "NSString+Extension_NSString.h"

@implementation NSString (Extension_NSString)
// 截取字符串方法封装
// 截取字符串方法封装
- (NSString *)subStringFrom:(NSString *)startString to:(NSString *)endString{
    
    NSRange startRange = [self rangeOfString:startString];
    NSRange endRange = [self rangeOfString:endString];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    return [self substringWithRange:range];
    
}

@end
