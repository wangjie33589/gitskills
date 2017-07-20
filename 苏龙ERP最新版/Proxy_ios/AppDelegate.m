//
//  AppDelegate.m
//  Proxy_ios
//
//  Created by E-Bans on 15/11/13.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "AppDelegate.h"
#import "SimplePingHelper.h"//ping

@interface AppDelegate ()<UIAlertViewDelegate>{
 NSString *_currentVision;
    
  NSString *_latestVersion;
    NSDictionary *_xmlDict;
    
 
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
   
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
    NSDictionary *textAttributes = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"a_company-wideblue"] forBarMetrics:UIBarMetricsDefault];
    self.window.backgroundColor = [UIColor whiteColor];
    
    return YES;
}


-(void)APPUpdata{
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@/proxymobile/getiosversion.xml",HTTPIP,SLRD]]];
    NSData *reponse =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
  _xmlDict =[NSDictionary dictionaryWithXMLData:reponse];
        NSLog(@"xumDATA=%@",_xmlDict);
    _latestVersion =_xmlDict[@"versionCode"];
    NSDictionary *infoDict =[[NSBundle mainBundle]infoDictionary];
    NSLog(@"VIESSS=%@",[infoDict objectForKey:@"CFBundleVersion"]);
    _currentVision=[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"];
    if ([_currentVision intValue]<[_latestVersion intValue]) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:_xmlDict[@"versionName"]  message:_xmlDict[@"versionDescription"] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"升级", nil];
        alert.delegate=self;
        [alert show];
        
}
    
    
 //   [ConFunc changeAPPUpdata];
  




}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
      
        case 1:{
                       
            if ([_xmlDict[@"versionURL"] rangeOfString:FLAG].location!=NSNotFound ) {
                NSString *NEWtitle= [_xmlDict[@"versionURL"] stringByReplacingOccurrencesOfString:FLAG withString:HTTPIP];
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:NEWtitle]];
                NSLog(@"asdsdf====%@",NEWtitle);
    
                
            }
            else{
             [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_xmlDict[@"versionURL"]]];
            
            
            
            }

          
            
            
        }break;
    }
  
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // 手势解锁相关
    [SimplePingHelper ping:HTTPWIFI target:self sel:@selector(pingResult:)];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    if ([[userDefaults objectForKey:@"passwork"] isEqualToString:@"yes"]) {
        NSString* pswd = [LLLockPassword loadLockPassword];
        if (pswd) {
            [self showLLLockViewController:LLLockViewTypeCheck];
        } else {
            [self showLLLockViewController:LLLockViewTypeCreate];
        }
    }
}
#pragma mark - 弹出手势解锁密码输入框
- (void)showLLLockViewController:(LLLockViewType)type
{
    if(self.window.rootViewController.presentingViewController == nil){
        
        LLLog(@"root = %@", self.window.rootViewController.class);
        LLLog(@"lockVc isBeingPresented = %d", [self.lockVc isBeingPresented]);
        
        self.lockVc = [[LLLockViewController alloc] init];
        self.lockVc.nLockViewType = type;
        
        self.lockVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self.window.rootViewController presentViewController:self.lockVc animated:NO completion:^{
        }];
        LLLog(@"创建了一个pop=%@", self.lockVc);
    }
}

- (void)pingResult:(NSNumber*)success {
    if (success.boolValue) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"http"];
        [[NSUserDefaults standardUserDefaults] setObject:HTTPWIFI forKey:@"http"];
         [self APPUpdata];
        
        NSLog(@"shdfjh==%@",HTTPIP);
        
    } else {
       
        
      
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"http"];
        [[NSUserDefaults standardUserDefaults] setObject:HTTPSIM forKey:@"http"];
        
        NSLog(@"shdfjh==%@",HTTPIP);
         [self APPUpdata];
     
    }
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
