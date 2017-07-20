//
//  NetWorkTool.m
//  KYDemo
//
//  Created by sciyonSoft on 15/11/24.
//  Copyright © 2015年 sciyonSoft. All rights reserved.
//
#define SHOW_ALERT(msg) UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];\
[alert show]
//221.226.212.74:20159
#define SEVER_URL @"http://10.88.12.15:20159/ProxyMobile/GetServerUrl.aspx"
#define LOGIN_URL @"http://10.88.12.15:20159/ProxyMobile/MobileLogin.aspx"

#import "NetWorkTool.h"
#import "AFNetworking.h"
#import "CommonTool.h"


@implementation NetWorkTool


+(void)completionBlock:(void (^)(NSDictionary *))block{
    NSString *str =[NSString stringWithFormat:@"%@?PLANTCODE=ANDROID",SEVER_URL];
    
    
    AFHTTPRequestOperationManager *manger =[AFHTTPRequestOperationManager manager];
    //manger.requestSerializer=[AFHTTPRequestSerializer serializer ];
    // manger.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manger GET:str parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic= operation.responseObject;
        block(dic);
        
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"请求失败。");
        
    }];



}
+(void)loginWithName:(NSString *)name andPassword:(NSString *)password andisLimitorNot:(NSString *)flag completionBlock:(void (^)(NSDictionary *))block{
  

    NSString *str =[NSString stringWithFormat:@"%@?password=%@&phoneIMEI=868349022677001&isLimit=%@&userID=%@&PLANTCODE=ANDROID",LOGIN_URL,password,flag,name];
    AFHTTPSessionManager *mager =[AFHTTPSessionManager manager];
    [mager GET:str parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *dict =responseObject;
        block(dict);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error==%@",error);
        
    
    }];


}







+ (void)saveCookies{
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey: @"sessionCookies"];
    [defaults synchronize];
    
}
+(void)loadCookies{
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in cookies){
        [cookieStorage setCookie: cookie];
    }
}

+(void)workTaskcompletionBlock:(void (^)(NSDictionary *))block{
    AFHTTPRequestOperationManager *manger =[AFHTTPRequestOperationManager manager];
    NSDictionary *dict =@{@"Action":@"GETQUERYWORKTASKSQL",@"Pagesize":@"10",@"Pageindex":@"1",@"Softtype":@"DESC",@"Softfield":@"FEDITTIME",@"FTITLE":@""};
    
    
    manger.requestSerializer=[AFHTTPRequestSerializer serializer];
    manger.responseSerializer=[AFJSONResponseSerializer serializer];
    
    [manger POST:@"http://10.88.12.15:20159/OA/RSM/ProxyMobile/PaginationProxy.ashx" parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
      
        NSDictionary *dic =responseObject;
       
        block(dic);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"请求失败==%@",error);
        
    }];
    
    
    

}


+(void)workTaskSearchContain:(NSString *)contain completionBlock:(void (^)(NSDictionary *))block{
AFHTTPRequestOperationManager *manger =[AFHTTPRequestOperationManager manager];    NSDictionary *dict =@{@"Action":@"GETQUERYWORKTASKSQL",@"Pagesize":@"10",@"Pageindex":@"1",@"Softtype":@"DESC",@"Softfield":@"FEDITTIME",@"FTITLE":contain};
    
    
    manger.requestSerializer=[AFHTTPRequestSerializer serializer];
    manger.responseSerializer=[AFJSONResponseSerializer serializer];
    
    [manger POST:@"http://10.88.12.15:20159/OA/RSM/ProxyMobile/PaginationProxy.ashx" parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *dic =responseObject;
        
        block(dic);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"请求失败==%@",error);
        
    }];
    

}



+(void)request{
    AFHTTPRequestOperationManager *manger =[AFHTTPRequestOperationManager manager];
    NSDictionary *dict =@{@"Action":@"GETQUERYWORKTASKSQL",@"Pagesize":@"10",@"Pageindex":@"1",@"Softtype":@"DESC",@"Softfield":@"FEDITTIME",@"FTITLE":@"",@"FTITLE":@""};
  
   
    manger.requestSerializer=[AFHTTPRequestSerializer serializer];
    manger.responseSerializer=[AFJSONResponseSerializer serializer];
   
   [manger POST:@"http://10.88.12.15:20159/OA/RSM/ProxyMobile/PaginationProxy.ashx" parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
       
     
       
      } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
       NSLog(@"请求失败==%@",error);
       
       
   }];
    












}


+(void)searchDetilWithFGUID:(NSString *)FGUID completionBlock:(void (^)(NSDictionary *))block{
    
    AFHTTPRequestOperationManager *manger =[AFHTTPRequestOperationManager manager];
    NSDictionary *dict =@{@"Action":@"GETTASKBYGUID",@"GUID":FGUID};
    
    
    manger.requestSerializer=[AFHTTPRequestSerializer serializer];
    manger.responseSerializer=[AFJSONResponseSerializer serializer];
    
    [manger POST:@"http://10.88.12.15:20159/OA/RSM/ProxyMobile/Worktask.ashx" parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *dic =responseObject;
       
        block(dic);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"请求失败==%@",error);
        
    }];
    

}



+(void)workTaskSearchPAGE:(int)page completionBlock:(void (^)(NSDictionary * dic))block{
    AFHTTPRequestOperationManager *manger =[AFHTTPRequestOperationManager manager];    NSDictionary *dict =@{@"Action":@"GETQUERYWORKTASKSQL",@"Pagesize":[NSString stringWithFormat:@"%d",page],@"Pageindex":@"1",@"Softtype":@"DESC",@"Softfield":@"FEDITTIME",@"FTITLE":@""};
    
    
    manger.requestSerializer=[AFHTTPRequestSerializer serializer];
    manger.responseSerializer=[AFJSONResponseSerializer serializer];
    
    [manger POST:@"http://10.88.12.15:20159/OA/RSM/ProxyMobile/PaginationProxy.ashx" parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *dic =responseObject;
      
        block(dic);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"请求失败==%@",error);
        
    }];
    
    
    
    
    
    
    
    
}
+(void)workTaskWithName:(NSString *)FTITLE completionBlock:(void (^)(NSDictionary *))block{
     AFHTTPRequestOperationManager *manger =[AFHTTPRequestOperationManager manager];
    NSDictionary *dict =@{@"Action":@"GETQUERYWORKTASKSQL",@"Pagesize":@"10",@"Pageindex":@"1",@"Softtype":@"DESC",@"Softfield":@"FEDITTIME",@"FTITLE":FTITLE};
    
    
    manger.requestSerializer=[AFHTTPRequestSerializer serializer];
    manger.responseSerializer=[AFJSONResponseSerializer serializer];
    
    [manger POST:@"http://10.88.12.15:20159/OA/RSM/ProxyMobile/PaginationProxy.ashx" parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *dic =responseObject;
     
        block(dic);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"请求失败==%@",error);
        
    }];




}





@end
