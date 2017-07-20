//
//  NewtaskVC.h
//  ios版本科远APP
//
//  Created by sciyonSoft on 15/11/30.
//  Copyright © 2015年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewtaskVC : UIViewController
- (IBAction)distrbution:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextView *contentView;
- (IBAction)gobackBtn:(id)sender;
@end
