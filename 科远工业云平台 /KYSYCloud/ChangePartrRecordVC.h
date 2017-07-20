//
//  ChangePartrRecordVC.h
//  KYSYCloud
//
//  Created by SciyonSoft_WangJie on 16/4/11.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePartrRecordVC : UIViewController
-(id)initWithADic:(NSDictionary *)aDic;

@property (strong, nonatomic) IBOutlet UITableView *myTable;

@end
