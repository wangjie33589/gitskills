//
//  BookModel.m
//  Proxy_ios
//
//  Created by E-Bans on 15/11/19.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "BookModel.h"

@implementation BookModel

+ (instancetype)initWithAddData:(NSDictionary *)aData
{
    BookModel* model = [BookModel new];
    model.guid = [aData objectForKey:@"PERSONGUID"];
    model.userName = [aData objectForKey:@"PERSONNAME"];
    model.userId = [aData objectForKey:@"USERID"];
    model.tel = [aData objectForKey:@"OFFICETEL"];
    model.phone = [aData objectForKey:@"MOBILETEL"];
    model.dept = [aData objectForKey:@"DEPTNAME"];
    model.positionName = [aData objectForKey:@"POSITIONNAME"];
    model.email = [aData objectForKey:@"EMAIL"];
    model.msn = [aData objectForKey:@"MSN"];
    model.deptId = [aData objectForKey:@"DEPTID"];
    model.positionId = [aData objectForKey:@"DEPTID"];
    model.userImag = [aData objectForKey:@"PERSONIMAGEPATH"];
    model.pinYin = [[self firstCharactor:[aData objectForKey:@"PERSONNAME"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    return model;
}

+ (NSString *)firstCharactor:(NSString *)aString//返回拼音首字母
{
    NSMutableString *str = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSString *pinYin = [str capitalizedString];
    NSMutableArray* array = [NSMutableArray arrayWithArray:[pinYin componentsSeparatedByString:@" "]];
    NSString* pinYinStr = @"";
    for (NSInteger index = 0; index < array.count; index ++) {
        if (![[array objectAtIndex:index] isEqualToString:@""]) {
            pinYinStr = [NSString stringWithFormat:@"%@%@",pinYinStr,[[array objectAtIndex:index] substringToIndex:1]];
        }
    }
    return pinYinStr;
}

@end
