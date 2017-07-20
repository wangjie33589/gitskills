//
//  MyRequest.m
//  KindergartenApp
//
//  Created by apple on 14/12/26.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "MyRequest.h"
#import "AppDelegate.h"

@implementation MyRequest

#pragma mark ------------------- post请求
+ (id)requestWithURL:(NSString *)urlStr withParameter:(NSDictionary *)paraDic
{
    return [[self alloc] initWithURL:urlStr withParameter:paraDic];
}

- (id)initWithURL:(NSString *)urlStr withParameter:(NSDictionary *)paraDic
{
   if (self = [super init])
  {
      [self performSelector:@selector(dismiss) withObject:nil afterDelay:5];
      ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
      if (paraDic.count !=0)
      {
          for (int i = 0; i < paraDic.count; i ++)
          {
              [request setPostValue:paraDic.allValues[i] forKey:paraDic.allKeys[i]];
          }
      }

      NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"];
      if([cookiesdata length]) {
          NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
          NSHTTPCookie *cookie;
          for (cookie in cookies) {
              [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
              if ([cookie.name isEqualToString:@"platform_cookie"]) {
                  [request setRequestCookies:[NSMutableArray arrayWithObject:cookie]];
              }
          }
      }
    
      [request setTimeOutSeconds:5];
      [request startAsynchronous];
      
      __block ASIFormDataRequest *safeSelf = request;
      
      [request setCompletionBlock:^{
          NSData *data = safeSelf.responseData;
          NSString *dataStrtwo = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          NSLog(@"json数据:%@",dataStrtwo);
          NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
          
    
          
          
          _backSuccess((NSMutableDictionary*)dict);
      }];
      
      [request setFailedBlock:^{
          //[SVProgressHUD showErrorWithStatus:@"你的网络连接出现了异常！！！"];
          if ([self.delegate respondsToSelector:@selector(RequestErrorViewController)]) {
              [self.delegate RequestErrorViewController];
          }
          //[SVProgressHUD dismiss];
      }];
   }
    return self;
}
- (void)dismiss
{
    [SVProgressHUD dismiss];
}
#pragma mark ------------------- get请求
+ (id)requestWithURL:(NSString *)urlStr
{
    return [[self alloc] getDataUseASIForSever:urlStr];
}
- (id)getDataUseASIForSever :(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            if ([cookie.name isEqualToString:@"platform_cookie"]) {
                [request setRequestCookies:[NSMutableArray arrayWithObject:cookie]];
            }
        }
    }
    [request setTimeOutSeconds:5];
     [request startAsynchronous];
    
    __block ASIHTTPRequest *safeSelf = request;
    
    [request setCompletionBlock:^{

        NSData *data = safeSelf.responseData;
        
        NSLog(@"data=========%@",data);
        NSMutableDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"json数据%@",dict);
        _backSuccess(dict);
    }];
    
    [request setFailedBlock:^{
        // [SVProgressHUD showErrorWithStatus:@"你的网络连接出现了异常！！！"];
        
    }];
    return self;
}

@end
