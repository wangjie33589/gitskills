//
//  UserInfo.m
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/14.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "UserInfo.h"

//deptGuid = 00000000000000000000000001002001;
//deptName = "\U4fe1\U606f\U7ba1\U7406\U90e8";
//iconImage = "00000000000000000000000000000001.GIF";
//positionGuid = 00000000000000000000000001003001;
//positionName = "\U7ba1\U7406\U5458\U5c97\U4f4d";
//success = 1;

//userGuid = 00000000000000000000000000000001;
//userId = ADMIN;
//userName = "\U7cfb\U7edf\U7ba1\U7406\U5458";

@implementation UserInfo

+ (void)initWithAddUserInfo:(NSDictionary *)data
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[data objectForKey:@"deptGuid"] forKey:@"deptGuid"];
    [userDefaults setObject:[data objectForKey:@"deptName"] forKey:@"deptName"];
    
    [userDefaults setObject:[data objectForKey:@"iconImage"] forKey:@"iconImage"];
    
    [userDefaults setObject:[data objectForKey:@"positionGuid"] forKey:@"positionGuid"];
    [userDefaults setObject:[data objectForKey:@"positionName"] forKey:@"positionName"];
    
    [userDefaults setObject:[data objectForKey:@"userGuid"] forKey:@"userGuid"];
    [userDefaults setObject:[data objectForKey:@"userId"] forKey:@"userId"];
    [userDefaults setObject:[data objectForKey:@"userName"] forKey:@"userName"];
    [userDefaults setObject:[data objectForKey:@"userOrgGuid"] forKey:@"userOrgGuid"];
    [userDefaults synchronize];
}

+ (void)initWithDeleteUserInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"deptGuid"];
    [userDefaults removeObjectForKey:@"deptName"];
    
    [userDefaults removeObjectForKey:@"iconImage"];
    
    [userDefaults removeObjectForKey:@"positionGuid"];
    [userDefaults removeObjectForKey:@"positionName"];
    
    [userDefaults removeObjectForKey:@"userGuid"];
    [userDefaults removeObjectForKey:@"userId"];
    [userDefaults removeObjectForKey:@"userName"];
}

@end
