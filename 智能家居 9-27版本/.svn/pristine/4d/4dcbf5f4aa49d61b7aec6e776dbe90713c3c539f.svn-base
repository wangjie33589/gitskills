//
//  ViewController.m
//  SyncSmartHome
//
//  Created by SciyonSoft_WangJie on 16/5/3.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//
#import "ViewController.h"
#import "HomeViewController.h"
#import "SenceViewController.h"
#import "DeviceViewController.h"
#import "UserViewController.h"
#import "LoginViewController.h"
#import "LeftViewController.h"
//


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
////    
if ([is_LOGIN isEqualToString:@"success"]) {
    [self successLogin];
        
   }else{
         [self gotoLogin];
    }
       //[self gotoLogin];

    NSLog(@"iscoeHear");
   
}


-(void)gotoLogin{

    
    UIStoryboard *story1 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
       LoginViewController *VC = [story1 instantiateViewControllerWithIdentifier:@"LoginViewController"];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.rootViewController =VC;




}
- (void)successLogin
{
    UIStoryboard *story1 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *homeVC = [story1 instantiateViewControllerWithIdentifier:@"HomeViewController"];
    UIStoryboard *story2 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SenceViewController *taskVC = [story2 instantiateViewControllerWithIdentifier:@"SenceViewController"];
    UIStoryboard *story3 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DeviceViewController *productionVC = [story3 instantiateViewControllerWithIdentifier:@"DeviceViewController"];
    UIStoryboard *story4 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserViewController *userVC = [story4 instantiateViewControllerWithIdentifier:@"UserViewController"];
    
    UINavigationController * Nav1 = [[UINavigationController alloc] initWithRootViewController:homeVC];
    Nav1.tabBarItem.title = @"首页";
    //    theNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);//纠正图片位置
    [Nav1.tabBarItem setTitlePositionAdjustment:UIOffsetMake(3, -3)];//纠正title位置
    Nav1.tabBarItem.image = [UIImage imageNamed:@"home"];
    Nav1.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController * Nav2 = [[UINavigationController alloc] initWithRootViewController:productionVC];
    //    Nav2.tabBarItem.title = @"场景";
    //    [Nav2.tabBarItem setTitlePositionAdjustment:UIOffsetMake(3, -3)];//纠正title位置
    //    Nav2.tabBarItem.image = [UIImage imageNamed:@"sw_1"];
    //    Nav2.tabBarItem.selectedImage = [[UIImage imageNamed:@"sw"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Nav2.tabBarItem.title = @"设备";
    [Nav2.tabBarItem setTitlePositionAdjustment:UIOffsetMake(3, -3)];//纠正title位置
    Nav2.tabBarItem.image = [UIImage imageNamed:@"device"];
    Nav2.tabBarItem.selectedImage = [[UIImage imageNamed:@"device_1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController * Nav3 = [[UINavigationController alloc] initWithRootViewController:taskVC];
    
    Nav3.tabBarItem.title = @"场景";
    [Nav3.tabBarItem setTitlePositionAdjustment:UIOffsetMake(3, -3)];//纠正title位置
    Nav3.tabBarItem.image = [UIImage imageNamed:@"sence"];
    Nav3.tabBarItem.selectedImage = [[UIImage imageNamed:@"scene_1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    
    UINavigationController * Nav4 = [[UINavigationController alloc] initWithRootViewController:userVC];
    Nav4.tabBarItem.title =@"我的";
    [Nav4.tabBarItem setTitlePositionAdjustment:UIOffsetMake(3, -3)];//纠正title位置
    Nav4.tabBarItem.image = [UIImage imageNamed:@"mine"];
    Nav4.tabBarItem.selectedImage = [[UIImage imageNamed:@"mine_1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    AppDelegate *aAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    aAppDelegate.tabBarCtr = [[UITabBarController alloc]init];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0/255.0 green:149/255.0 blue:255/255.0 alpha:1]];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    //        [[UITabBar appearance] setBackgroundImage:[ConFunc createImageWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]
    //                                                                           size:CGSizeMake(LWidth,48)]];//设置背景，修改颜色是没有用的
    
    
    aAppDelegate.tabBarCtr.viewControllers = @[Nav1,Nav2,Nav3,Nav4];
    aAppDelegate.tabBarCtr.selectedIndex = 0;
    [aAppDelegate.ddMenu showLeftController:YES];
    UIStoryboard *story5 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LeftViewController *leftVC = [story5 instantiateViewControllerWithIdentifier:@"LeftViewController"];
    leftVC.delegate = (id)homeVC;
    leftVC.delegatePush = (id)homeVC;
    leftVC.delegateFunction = (id)productionVC;
    UINavigationController * leftNav = [[UINavigationController alloc] initWithRootViewController:leftVC];
    aAppDelegate.ddMenu = [[DDMenuController alloc] initWithRootViewController:aAppDelegate.tabBarCtr];
    aAppDelegate.ddMenu.leftViewController = leftNav;
    aAppDelegate.window.rootViewController = aAppDelegate.ddMenu;
    
}



@end
