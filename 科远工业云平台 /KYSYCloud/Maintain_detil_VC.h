//
//  Maintain_detil_VC.h
//  KYSYCloud
//
//  Created by sciyonSoft on 16/3/9.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Maintain_detil_VC : UIViewController
-(id)initWithDic:(NSDictionary*)aDic;
@property (strong, nonatomic) IBOutlet UITableView *myTable;
- (IBAction)btnClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mySeg;
- (IBAction)segControl:(UISegmentedControl *)sender;
@property(nonatomic,copy)NSString *Mcode;

@end
