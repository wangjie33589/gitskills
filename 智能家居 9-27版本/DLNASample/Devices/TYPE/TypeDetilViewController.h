//
//  TypeDetilViewController.h
//  SyncSmartHome
//
//  Created by SciyonSoft_WangJie on 16/5/10.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeDetilViewController : UIViewController
-(id)initWithDic:(NSDictionary*)aDic;

@property (strong, nonatomic) IBOutlet UITableView *myTable;

@end
