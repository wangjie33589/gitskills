//
//  Sinaleton.m
//  weweima
//
//  Created by SciyonSoft_WangJie on 16/4/6.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "Sinaleton.h"

@implementation Sinaleton
+ (Sinaleton *)defaultSinaleton {
    static Sinaleton *singleton = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //内部代码只会执行一次
        singleton = [[Sinaleton alloc] init];
        
    });
    return singleton;
}



@end
