//
//  LFTabBarViewController.m
//  LF微博
//
//  Created by lf on 16/4/25.
//  Copyright © 2016年 lf. All rights reserved.
//

#import "LFTabBarViewController.h"

#import "LFTabBar.h"


@interface LFTabBarViewController ()<LFTabBarDelegate>


@end

@implementation LFTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   // [self.tabBar removeFromSuperview];

    LFTabBar *tabBar = [[LFTabBar alloc]init];
    
    tabBar.delegate = self;
    tabBar.frame= self.tabBar.bounds;
    
    [self.tabBar addSubview:tabBar];
    
    NSString *imageName= nil;
    NSString *selImageName =nil;
    for (int i = 0; i <self.childViewControllers.count; i++) {
        
        imageName = [NSString stringWithFormat:@"TabBar%d",i + 1];
        selImageName = [NSString stringWithFormat:@"TabBar%dSel",i + 1];
        
        [tabBar addTabBarButtonWithName:imageName selName:selImageName];
    }
    //获取应用程序中所有的导航条
    
    UINavigationBar *bar = [UINavigationBar appearance];
    
    [bar setBackgroundImage:[UIImage imageNamed:@"NavBar65"] forBarMetrics:UIBarMetricsDefault];
}

//代理方法
- (void)tabBar:(LFTabBar *)tabBar didSelectedIndex:(int)index
{
    self.selectedIndex = index;
}


@end
