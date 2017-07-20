//
//  SenceChoice_erea_device_pancel_VC.h
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/7/18.
//
//

#import <UIKit/UIKit.h>

@interface SenceChoice_erea_device_pancel_VC : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *first_table;
@property (strong, nonatomic) IBOutlet UITableView *second_table;
@property (strong, nonatomic) IBOutlet UITableView *Third_table;
-(instancetype)initWithADic:(NSDictionary*)aDic AndTitle:(NSString*)title;



@end
