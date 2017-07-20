//
//  reportQuiryViewController.h
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/19.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface reportQuiryViewController : UIViewController
-(id)initWithADic:(NSDictionary *)aDic;
@property (strong, nonatomic) IBOutlet UITableView *myTable;
- (IBAction)segclick:(UISegmentedControl *)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mySeg;

@end
