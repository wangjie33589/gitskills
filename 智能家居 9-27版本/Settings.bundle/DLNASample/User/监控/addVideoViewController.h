//
//  addVideoViewController.h
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/8/1.
//
//

#import <UIKit/UIKit.h>

@interface addVideoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *myTable;
-(instancetype)initWithADIc:(NSDictionary*)dict;
@property(assign,nonatomic)int type;

@end
