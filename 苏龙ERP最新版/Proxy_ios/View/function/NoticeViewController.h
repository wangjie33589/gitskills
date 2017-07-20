//
//  NoticeViewController.h
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/22.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISearchBar *noticeSearchBar;
@property (strong, nonatomic) IBOutlet UITableView *noticeTableView;
@property (strong, nonatomic) NSString* title_str;

@end
