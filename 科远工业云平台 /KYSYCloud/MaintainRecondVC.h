//
//  MaintainRecondVC.h
//  KYSYCloud
//
//  Created by sciyonSoft on 16/3/2.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaintainRecondVC : UIViewController{


}
-(id)initWithADic:(NSDictionary *)aDic;
@property (strong, nonatomic) IBOutlet UISearchBar *mySearchBar;
- (IBAction)EWMBtnClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITableView *MyTableView;

@end
