//
//  SenceViewController.h
//  SyncSmartHome
//
//  Created by SciyonSoft_WangJie on 16/5/3.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SenceViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *myTable;
@property(strong,nonatomic)UIImage *photnImage;
@property(retain,nonatomic)NSDictionary *thisSenceDic;

@end
