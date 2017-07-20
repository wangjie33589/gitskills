//
//  URLSingleton.h
//  weweima
//
//  Created by SciyonSoft_WangJie on 16/4/6.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLSingleton : NSObject
@property (nonatomic, strong) NSString *urlString;
+ (URLSingleton *)mainURLSingleton;

@end
