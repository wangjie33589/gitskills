//
//  work_task_first_VC.h
//  Proxy_ios
//
//  Created by sciyonSoft on 16/1/21.
//  Copyright © 2016年 keyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface work_task_first_VC : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *MySearchBar;
-(id)initWithAType:(NSString*)AType;


@end
