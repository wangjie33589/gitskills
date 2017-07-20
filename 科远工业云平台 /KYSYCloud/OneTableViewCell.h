//
//  OneTableViewCell.h
//  KYSYCloud
//
//  Created by sciyonSoft on 16/3/3.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UITextField *textfield;
@property (strong, nonatomic) IBOutlet UIButton *EWMBtn;

@end
