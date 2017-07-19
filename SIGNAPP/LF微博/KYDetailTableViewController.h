//
//  KYDetailTableViewController.h
//  科远签到
//
//  Created by sciyonSoft on 16/5/24.
//  Copyright © 2016年 lf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYDetailTableViewController : UITableViewController
//-(id)initWithADic:(NSDictionary *)aDic;
@property(nonatomic,strong)NSString *btime;
@property(nonatomic,strong)NSString *etime;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSString *lat;
@property(nonatomic,strong)NSString *lng;
@property(nonatomic,strong)NSString *pno;
@end
