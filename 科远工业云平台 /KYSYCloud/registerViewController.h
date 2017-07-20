//
//  registerViewController.h
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/19.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface registerViewController : UIViewController
-(id)initWithADic:(NSDictionary *)aDic;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segentcontrol;
@property (strong, nonatomic) IBOutlet UITableView *mytable;
- (IBAction)segentclick:(UISegmentedControl *)sender;

@end
