//
//  authorVC.h
//  KYSYCloud
//
//  Created by sciyonSoft on 16/3/22.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface authorVC : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *changeBtn;

@property (strong, nonatomic) IBOutlet UITextField *pwdText;
@property (strong, nonatomic) IBOutlet UITextField *yzmTxt;
- (IBAction)autorBtnCilck:(id)sender;
- (IBAction)yzmBtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *yzmBtn;
-(id)initWithDic:(NSDictionary *)dic;
@property (strong, nonatomic) IBOutlet UIButton *dateTxt;
@end
