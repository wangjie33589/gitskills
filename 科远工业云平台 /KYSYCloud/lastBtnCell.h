//
//  lastBtnCell.h
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/29.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lastBtnCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *firstBtn;
- (IBAction)secongBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *ThirdBtn;
- (IBAction)fourBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *texBtn;

@property (strong, nonatomic) IBOutlet UIButton *secondBtn;
@property (strong, nonatomic) IBOutlet UIButton *fourBtn;

@end
