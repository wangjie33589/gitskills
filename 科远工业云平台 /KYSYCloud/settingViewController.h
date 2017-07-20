//
//  settingViewController.h
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/20.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface settingViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *myTable;
-(id)initWithADic:(NSDictionary *)aDic;

@end
