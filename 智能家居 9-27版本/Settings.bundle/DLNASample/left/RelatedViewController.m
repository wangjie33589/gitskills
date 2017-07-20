//
//  RelatedViewController.m
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/14.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "RelatedViewController.h"

@interface RelatedViewController ()

@end

@implementation RelatedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.time.text = [NSString stringWithFormat:@"更新时间 %@",CHANGE_TIME];
    self.company.text = [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey]];
    self.version.text = [NSString stringWithFormat:@"版本号  %@ For IOS",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
