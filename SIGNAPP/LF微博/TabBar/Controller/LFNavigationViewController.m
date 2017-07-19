//
//  LFNavigationViewController.m
//  LF微博
//
//  Created by lf on 16/4/26.
//  Copyright © 2016年 lf. All rights reserved.
//

#import "LFNavigationViewController.h"

@interface LFNavigationViewController ()

@end

@implementation LFNavigationViewController


+ (void)initialize
{
    if (self == [LFNavigationViewController class]) {
        NSLog(@"---");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    viewController.hidesBottomBarWhenPushed = YES;
    return [super pushViewController:viewController animated:YES];
    
}



@end
