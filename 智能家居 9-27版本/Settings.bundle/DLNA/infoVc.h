//
//  infoVc.h
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/8/12.
//
//

#import <UIKit/UIKit.h>

@interface infoVc : UIViewController
-(id)initWithIp:(NSString*)ipString;
@property (strong, nonatomic) IBOutlet UITableView *myTable;

@end
