//
//  repaireConfirmViewController.h
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/19.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface repaireConfirmViewController : UIViewController
-(id)initWithADic:(NSDictionary *)aDic;
@property (strong, nonatomic) IBOutlet UITableView *myTable;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segControl;
- (IBAction)segChange:(UISegmentedControl *)sender;

@end
