//
//  LFHallViewController.m
//  LF微博
//
//  Created by lf on 16/4/26.
//  Copyright © 2016年 lf. All rights reserved.
//

#define SIM_CODE [[NSUserDefaults standardUserDefaults] objectForKey:@"Code"]
#import <CoreLocation/CoreLocation.h>
#import "LFHallViewController.h"
#import "AFNetworking.h"
#import "MyRequest.h"
#import "ASIHTTPRequest.h"
#import "SVProgressHUD.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "CommonTool.h"
#import "KYBindingViewController.h"
#import "GDataXMLNode.h"
#import "KYSign.h"
#import "KYBindingViewController.h"
#import "MBProgressHUD+MJ.h"
@interface LFHallViewController ()<CLLocationManagerDelegate,UITextFieldDelegate>
{
    UILabel *showPno;
    UILabel *showTime;
    UILabel *showPlace;
}
@property (nonatomic ,strong) CLLocationManager *mgr;
@property(nonatomic,strong)NSString *btimetext;
@property(nonatomic,strong)NSString *etimetext;
@property(nonatomic,strong)NSString *lattext;
@property(nonatomic,strong)NSString *lngtext;
@property(nonatomic,strong)NSString *phonetext;
@property(nonatomic,strong)NSString *pnotext;
@end

@implementation LFHallViewController


- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
      [self.mgr startUpdatingLocation];
    self.navigationItem.title = @"签到";
    self.navigationController.navigationBar.titleTextAttributes=@{UITextAttributeTextColor:[UIColor whiteColor]};
    
    
    
    showPno =[[UILabel alloc]initWithFrame:CGRectMake(20, 300, LWIDTH-40, 35)];
    [self.view addSubview:showPno];
    
    showTime =[[UILabel alloc]initWithFrame:CGRectMake(20, 340, LWIDTH-40, 35)];
    [self.view addSubview:showTime];
    
    showPlace =[[UILabel alloc]initWithFrame:CGRectMake(20, 380, LWIDTH-40, 35)];
    [self.view addSubview:showPlace];
    
    showPlace.lineBreakMode = UILineBreakModeCharacterWrap;
    showPlace.numberOfLines = 0;
    
    
    

    /**************NSUserDefaults传值**************/
    //NSLog(@"1111111-----%@",_phonetext);
    self.navigationItem.title = @"签到";
    // 1.创建CoreLocation管理者
    //    CLLocationManager *mgr = [[CLLocationManager alloc] init];
    // 2.成为CoreLocation管理者的代理监听获取到的位置
    self.mgr.delegate = self;
    // 判断是否是iOS8
    if([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
    {
        //        NSLog(@"是iOS8");
        // 主动要求用户对我们的程序授权, 授权状态改变就会通知代理
        [self.mgr requestAlwaysAuthorization]; // 请求前台和后台定位权限
    }else
    {
        NSLog(@"是iOS7");
        // 3.开始监听(开始获取位置)
        //       [self.mgr startUpdatingLocation];
    }
}

/**
 *  授权状态发生改变时调用
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"等待用户授权");
    }else if (status == kCLAuthorizationStatusAuthorizedAlways ||
              status == kCLAuthorizationStatusAuthorizedWhenInUse)
        
    {
        NSLog(@"授权成功");
        // 开始定位
        //         [self.mgr startUpdatingLocation];
        
    }else
    {
        NSLog(@"授权失败");
    }
}
- (IBAction)getlocation {
    [self request];
    
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态发生改变的时候调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                [self.mgr startUpdatingLocation];
                [MBProgressHUD showMessage:@"正在获取位置。。。"];
                // 模拟网络请求
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 移除遮盖
                    [MBProgressHUD hideHUD];
                });
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"自带网络");
                [self.mgr startUpdatingLocation];
                [MBProgressHUD showMessage:@"正在获取位置。。。"];
                // 模拟网络请求
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 移除遮盖
                    [MBProgressHUD hideHUD];
                });
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                [MBProgressHUD showMessage:@"没有网络。。。"];
                // 模拟网络请求
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 移除遮盖
                    [MBProgressHUD hideHUD];
                });
                break;
                
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                [MBProgressHUD showMessage:@"没有网络。。。"];
                // 模拟网络请求
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 移除遮盖
                    [MBProgressHUD hideHUD];
                });
                break;
            default:
                break;
        }
    }];
    // 开始监控
    [mgr startMonitoring];
    
   
}
#pragma mark - CLLocationManagerDelegate
/**
 *  获取到位置信息之后就会调用(调用频率非常高)
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%s", __func__);
    // 如果只需要获取一次, 可以获取到位置之后就停止
//        [self.mgr stopUpdatingLocation];
    
//     self.mgr.distanceFilter = 30;
    // 1.获取最后一次的位置
    CLLocation *location = [locations lastObject];
    //    CLLocation *location = [locations firstObject];
    NSLog(@"1  经度- %f,纬度- %f", location.coordinate.latitude , location.coordinate.longitude);
    
    
    NSString *str1 = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    NSString *str2 = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    
    [[NSUserDefaults standardUserDefaults]setValue:str1 forKey:@"lat"];
    [[NSUserDefaults standardUserDefaults]setValue:str2 forKey:@"lng"];
    
}

- (void)request{
    showTime.text = @"";
    showPno.text =@"";
    showPlace.text = @"";
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [dateFormatter stringFromDate:[NSDate date]];
    NSString *string=[NSString stringWithFormat:@"<Data><Action>CHECKIN</Action><SIM>%@</SIM><LNG>%@</LNG><LAT>%@</LAT><BDATE>%@</BDATE><EDATE>%@</EDATE><PNO>%@</PNO></Data>",_phonetext,_lngtext,_lattext,date,date,_pnotext];
    NSLog(@"%@444444",_pnotext);
    NSLog(@"%@---1234567890--%@",_lngtext,_lattext);
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SIGN_URL] withString:string];
    manger.backSuccess=^void(NSDictionary *dictt){
        if ((NSObject*)[dictt objectForKey:@"ERROR"]==[NSNull null]) {
            showPno.text= _pnotext;
            showTime.text=[NSString stringWithFormat:@"时间:%@",date];
            showPlace.text= dictt[@"CUSTOMERINFO1"];
//            [self.mgr stopUpdatingLocation];
            
            NSLog(@"%@---0000000--%@",_lngtext,_lattext);
            [CommonTool saveCooiker];
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"ERROR"]];
            NSLog(@"网络繁忙，请稍后再试！---%@",ERROR);
            return;
        }
    };
    
}

#pragma mark - 懒加载
- (CLLocationManager *)mgr
{
    if (!_mgr) {
        _mgr = [[CLLocationManager alloc] init];
    }
    return _mgr;
}

- (void)dealloc
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}


@end