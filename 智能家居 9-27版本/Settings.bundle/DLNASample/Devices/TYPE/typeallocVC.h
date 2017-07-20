//
//  typeallocVC.h
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/6/25.
//
//

#import <UIKit/UIKit.h>

@interface typeallocVC : UIViewController
-(id)initWithArray:(NSArray*)aArray WithADic:(NSDictionary*)dic;
@property (strong, nonatomic) IBOutlet UITableView *myTable;

@end
