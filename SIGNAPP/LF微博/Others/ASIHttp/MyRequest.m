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

-(id)initWithURL:(NSString *)urlStr withParameter:(NSDictionary *)paraDic
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
          if ([self.delegate respondsToSelector:@selector(RequestErrorViewController)]) {
              [self.delegate RequestErrorViewController];
          }
          [SVProgressHUD dismiss];
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
        NSMutableDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"json数据%@",dict);
        _backSuccess(dict);
    }];
    
    [request setFailedBlock:^{
        
    }];
    return self;
}
+(id)requestWithURL:(NSString *)urlStr withString:(NSString *)paraStr{
     return [[self alloc] initWithURL:urlStr withString:paraStr];

}
+(id)requestWithURL:(NSString *)urlStr withString:(NSString *)paraStr withPath:(NSString *)autiopath withPicArray:(NSArray *)array{
    return [[self alloc]initWithURL:urlStr withString:paraStr withPath:autiopath withPicArray:array];


}

-(id)initWithURL:(NSString *)urlStr withString:(NSString *)paraStr{
    NSLog(@"%@",paraStr);
    if (self = [super init])
    {
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:5];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
        NSLog(@"%@",[paraStr dataUsingEncoding:NSUTF8StringEncoding]);
                [request setPostValue:paraStr forKey:@""];
        NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"];
        if([cookiesdata length]) {
            NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
            NSHTTPCookie *cookie;
            for (cookie in cookies) {

                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                
                NSLog(@"cooik=====name====%@",cookie);
               
                    
                    NSLog(@"[NSMutableArray arrayWithObject:cookie]===%@",[NSMutableArray arrayWithObject:cookie]);
                [request setRequestCookies:[NSMutableArray arrayWithObject:cookie]];
                
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
            
            NSData *data = safeSelf.responseData;
            //NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            //_backFaile((NSMutableDictionary*)dict);
           
            //[SVProgressHUD showErrorWithStatus:@"服务器无响应"];
            NSLog(@"data=======%@",data);
            NSString *dataStrtwo = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"json数据:%@",dataStrtwo);

            if ([self.delegate respondsToSelector:@selector(RequestErrorViewController)]) {
                [self.delegate RequestErrorViewController];
            }
            [SVProgressHUD dismiss];
        }];
    }
    return self;
 
}
-(id)initWithURL:(NSString *)urlStr withString:(NSString *)paraStr withPath:(NSString *)autiopath withPicArray:(NSArray *)array{
    NSLog(@"%@",paraStr);
    if (self = [super init])
    {
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:5];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
        NSLog(@"%@",[paraStr dataUsingEncoding:NSUTF8StringEncoding]);
        [request setPostValue:paraStr forKey:@""];
        NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"];
        if([cookiesdata length]) {
            NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
            NSHTTPCookie *cookie;
            for (cookie in cookies) {
                
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                
                NSLog(@"cooik=====name====%@",cookie);
                
                
                NSLog(@"[NSMutableArray arrayWithObject:cookie]===%@",[NSMutableArray arrayWithObject:cookie]);
                [request setRequestCookies:[NSMutableArray arrayWithObject:cookie]];
                
            }
        }
        
              if (array.count>0) {
            
            for (int i=0; i<array.count; i++) {
                
                
                //[request setPostValue:xm_str forKey:@""];
                UIImage *image =array[i];
                
                
                NSLog(@"agsdfghhjxbgjdfg=====%@",[self compressImage:image]);
             
                   NSData* data = UIImageJPEGRepresentation([self compressImage:image], 0.1);
                
          //  NSData *data =uiimage
                NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
                NSString *dataString =[formatter stringFromDate:[NSDate date]];
                NSString *NewDataString =[dataString stringByReplacingOccurrencesOfString:@"-"
                   
                                          
                                                                               withString:@""];
//                [request setPostValue:@"" forKey:@"aguid"];
//                [request setData:data forKey:@"path"];
//                [request setPostValue:[NSString stringWithFormat:@"%@%d.jpg" ,NewDataString,i] forKey:@"fileName"];

                //[request startAsynchronous];
                
                NSString *fileName=[NSString stringWithFormat:@"%@%d.jpg" ,NewDataString,i] ;
                
                [request setData:data withFileName:fileName andContentType:@"image/jpeg/png/jpg" forKey:@"fileName"];
                
               // [request startSynchronous];
                
                
            }
            
            
        }
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString *audioStr;

        
        if ([manager fileExistsAtPath:autiopath]) {
        
            
            [request addFile:autiopath forKey:@""];
                      
                     //[request setFile:AudioPath forKey:@"path"];
          
            
            NSLog(@"录音文件存在");
        }else{
            NSLog(@"录音文件不存在");
            audioStr=@"";
        }

        [request setTimeOutSeconds:10];
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
            if ([self.delegate respondsToSelector:@selector(RequestErrorViewController)]) {
                [self.delegate RequestErrorViewController];
            }
            [SVProgressHUD dismiss];
        }];
    }
    return self;

    






}
- (UIImage *)compressImage:(UIImage *)imgSrc
{
    CGSize size = {164 , 218};
    UIGraphicsBeginImageContext(size);
    CGRect rect = {{0,0}, size};
    [imgSrc drawInRect:rect];
    UIImage *compressedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return compressedImg;
}




@end
