//
//  Area_Detil_ViewController.h
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/6/29.
//
//

#import <UIKit/UIKit.h>

@protocol SendTrendDataDelegate1

- (void)sendTrendDatas:(NSString *)datas;
@end

@interface Area_Detil_ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *myTable;
-(id)initWithDic:(NSDictionary*)aDic;
@property (retain,nonatomic) id <SendTrendDataDelegate1>sectionDeledate;//声明一个委托变量
@end
