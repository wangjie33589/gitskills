//
//  contollerLogVC.h
//  KYSYCloud
//
//  Created by SciyonSoft_WangJie on 16/4/11.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface contollerLogVC : UIViewController
-(id)initWithDic:(NSDictionary *)aDic;
@property (strong, nonatomic) IBOutlet UIButton *dayBtn;
@property (strong, nonatomic) IBOutlet UIButton *mounthbtn;
@property (strong, nonatomic) IBOutlet UIButton *firstBtn;
@property (strong, nonatomic) IBOutlet UIButton *secondbtn;
@property (strong, nonatomic) IBOutlet UIButton *ThirdBtn;
@property (strong, nonatomic) IBOutlet UIButton *partBtn;
@property (strong, nonatomic) IBOutlet UITableView *myTable;

@end
