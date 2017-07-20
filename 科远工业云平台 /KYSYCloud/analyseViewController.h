//
//  analyseViewController.h
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/20.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface analyseViewController : UIViewController
-(id)initWithADic:(NSDictionary *)aDic;
@property (strong, nonatomic) IBOutlet UITableView *myTable;

@end
