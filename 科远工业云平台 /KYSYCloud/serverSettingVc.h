//
//  serverSettingVc.h
//  KYSYCloud
//
//  Created by sciyonSoft on 16/3/17.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface serverSettingVc : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *textField;
- (IBAction)dropBtn:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) IBOutlet UIButton *OKBtn;
- (IBAction)OKBtnclick:(UIButton *)sender;
@property(assign,nonatomic)int type;

@end
