//
//  CommonTool.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/4.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "CommonTool.h"
#define DEFAULT_VOID_COLOR [UIColor whiteColor]


@implementation CommonTool
//+(void)GoToHome{
//    UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UINavigationController *nav =[sb instantiateViewControllerWithIdentifier:@"home_ViewController"];
//    APP_WINOW.rootViewController=nav;
//    [UIView animateWithDuration:.7 animations:^{
//        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:APP_WINOW cache:YES];
//    }];
//
//
//
//
//}
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
+(void)saveCooiker{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kUserDefaultsCookie"];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:
    [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL]]];
    
    NSLog(@"cooiker===%@",cookies);
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"kUserDefaultsCookie"];
}


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
+(NSString*)handleEmptyString:(NSString *)string{
    
        if (string ==nil) {
        
        return @"";
        
        
    }else{
        return  string;
        
        
    }



}

+ (NSString *)downloadPath{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/TmpFile"];
}

+ (void)saveChatDic:(NSMutableDictionary *)dic{
    
    //用户数据最好不要直接放在Documents中，而是放在二级文件夹。
    NSString *dirPath =[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/chatInfo"];
    if (![FILE_M fileExistsAtPath:dirPath]) {
        [FILE_M createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //为了支持多用户使用，每个用户的聊天记录都用一个独立的文件存储。
  
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/chatInfo/server.plist"];
    [dic writeToFile:path atomically:YES];
}

+(NSString*)returnDpname:(NSArray *)aRR  withStr:(NSString *)Str{
    
    //NSMutableArray *array =[NSMutableArray array];
    NSMutableDictionary  *dict =[NSMutableDictionary dictionary];
    
    for (int i =0; i<aRR.count; i++) {
        NSString *string =aRR[i][@"DPGUID"];
        NSString *obj =aRR[i][@"DPNAME"];
        
        [dict setObject:obj forKey:string];
    
    }
    
    NSString *dpname =[dict objectForKey:[NSString stringWithFormat:@"%@",Str]];
    return dpname;




}

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


+(NSString *)cleanNULL:(NSString *)string{
    
    NSLog(@"string======%@",string);
    if (string ==nil) {
        
        return @"";
        
        
    }else{
        return  string;
        
        
    }
    
    
    
    
    
    
}
+(UISegmentedControl*)creatSegWithArray:(NSArray *)array{

    UISegmentedControl *seg =[[UISegmentedControl alloc ]initWithItems:array];
    return seg;




}


@end
