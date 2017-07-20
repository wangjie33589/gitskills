//
//  RealWatchController.h
//  KYSYCloud
//
//  Created by sciyonSoft on 16/3/1.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RealWatchController : UIViewController{


    IBOutlet UISegmentedControl *segent;


}
-(id)initWithDic:(NSDictionary*)aDic;
@property (strong, nonatomic) IBOutlet UITableView *myTable;

@end
