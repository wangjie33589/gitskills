//
//  Home_Home_ViewController.h
//  Proxy_ios
//
//  Created by E-Bans on 15/11/13.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Home_Home_ViewController : UIViewController

@property (strong, nonatomic) UITableView *home_tableView;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UITableView *home_tableView_two;

-(void)configWebView;
- (void)requestHistoryShowDataList;

@end
