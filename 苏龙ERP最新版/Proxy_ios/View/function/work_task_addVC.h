//
//  work_task_addVC.h
//  Proxy_ios
//
//  Created by sciyonSoft on 16/1/21.
//  Copyright © 2016年 keyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface work_task_addVC : UIViewController
@property (strong, nonatomic) IBOutlet UIView *myView;
@property (strong, nonatomic) IBOutlet UITextView *myTextviee;
@property (strong, nonatomic) IBOutlet UITextField *taskName;
@property (strong, nonatomic) IBOutlet UIButton *beginTime;
@property (strong, nonatomic) IBOutlet UIButton *endTime;

- (IBAction)TimeBtnclick:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITextField *expextTime;
@property (strong, nonatomic) IBOutlet UITextField *handelPerson;
- (IBAction)chosepersonBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *impontBtn;
- (IBAction)impotnClick:(id)sender;
-(id)initWithArray:(NSDictionary *)Dic;

- (IBAction)saveBtn:(UIButton *)sender;

@end
