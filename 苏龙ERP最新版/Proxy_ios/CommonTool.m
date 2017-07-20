//
//  CommonTool.m
//  KYDemo
//
//  Created by sciyonSoft on 15/11/24.
//  Copyright © 2015年 sciyonSoft. All rights reserved.
//




#import "CommonTool.h"
#import "AppDelegate.h"






#define SHOW_ALERT(msg) UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];\
[alert show]


#define USER_D [NSUserDefaults standardUserDefaults]

@implementation CommonTool


@end
