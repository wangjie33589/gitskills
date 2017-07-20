//
//  ViewController.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/4.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//


#import "ViewController.h"
#import "LoginVC.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([IS_LOGIN isEqualToString:@"SUCCESS"]) {
        [CommonTool GoToHome];
    }else{
        UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginVC *login =[sb instantiateViewControllerWithIdentifier:@"loginVC"];
        APP_WINOW.rootViewController=login;
        [UIView animateWithDuration:0.7 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:APP_WINOW cache:YES];
        }] ;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

@end
