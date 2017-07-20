//
//  URLSingleton.m
//  weweima
//
//  Created by SciyonSoft_WangJie on 16/4/6.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "URLSingleton.h"

@implementation URLSingleton
+ (URLSingleton *)mainURLSingleton {
    static URLSingleton *singleton = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //内部代码只会执行一次
        singleton = [[URLSingleton alloc] init];
        
    });
    return singleton;
}


@end
