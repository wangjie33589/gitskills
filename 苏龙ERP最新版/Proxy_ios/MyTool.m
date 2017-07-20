//
//  MyTool.m
//  Proxy_ios
//
//  Created by sciyonSoft on 15/12/21.
//  Copyright © 2015年 keyuan. All rights reserved.
//
#define DEFAULT_VOID_COLOR [UIColor whiteColor]

#import "MyTool.h"

@implementation MyTool
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (NSString*) stringWithUUID {
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    NSString *newstring=[uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""];
 
    return newstring;
}

+(NSString *)DataFormart :(NSString*)dateString{
    
    if (dateString==nil) {
        return @"";
    }else{
        NSString *newString= [dateString  stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        
        return [newString stringByReplacingOccurrencesOfString:@"+08:00" withString:@""];
        
        
        
    }
    
}
+(NSString *)daFormatByComment:(NSString*)dastring{
    if (dastring==nil) {
        return @"";
    }else{
        NSArray *arr=[dastring componentsSeparatedByString:@"T"];
        return arr[0];
        
        
    }
    
}
+(BOOL)compairTimeA:(NSString *)timeA timeB:(NSString *)TimeB{
    NSString *newtimeA =[timeA stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *newtimeA1 =[newtimeA stringByReplacingOccurrencesOfString:@":" withString:@""];
   long long  int  endtimeA =[[newtimeA1 stringByReplacingOccurrencesOfString:@" " withString:@""]integerValue];
      NSString *newtimeB =[TimeB stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *newtimeB1 =[newtimeB stringByReplacingOccurrencesOfString:@":" withString:@""];
    long long int  endtimeB =[[newtimeB1 stringByReplacingOccurrencesOfString:@" " withString:@""]integerValue];
        if (endtimeA<endtimeB) {
        return YES;
    }else{
        return NO;
    }
}

@end
