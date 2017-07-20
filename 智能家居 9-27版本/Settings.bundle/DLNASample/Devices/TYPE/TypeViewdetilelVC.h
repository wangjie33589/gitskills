//
//  TypeViewdetilelVC.h
//  SyncSmartHome
//
//  Created by SciyonSoft_WangJie on 16/5/6.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeViewdetilelVC : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *typeTable;
@property (strong, nonatomic) IBOutlet UITableView *itemTable;
-(id)initWithDic:(NSDictionary*)aDic andArr:(NSArray*)array;

@end
