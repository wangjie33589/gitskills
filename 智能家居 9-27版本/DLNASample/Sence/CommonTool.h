//
//  CommonTool.h
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/7/11.
//
//

#import <Foundation/Foundation.h>

@interface CommonTool : NSObject
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;



@end
