//
//  CheckController.h
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/19.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckController : UIViewController
@property (strong, nonatomic) IBOutlet UISearchBar *mySearchbar;
@property (strong, nonatomic) IBOutlet UITableView *MyTabkeView;

-(id)initWithADic:(NSDictionary*)aDic;

@end
