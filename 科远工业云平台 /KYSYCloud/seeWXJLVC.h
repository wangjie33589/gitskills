//
//  seeWXJLVC.h
//  KYSYCloud
//
//  Created by SciyonSoft_WangJie on 16/4/11.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface seeWXJLVC : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *myTable;
-(id)initWithDic:(NSDictionary *)aDic;
@property(nonatomic,copy)NSString *Mcode;

@end
