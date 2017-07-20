//
//  OneTableViewCell.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/3/3.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "OneTableViewCell.h"

@implementation OneTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.textfield.delegate=self;
    self.textfield.returnKeyType=UIReturnKeyDone;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textfield resignFirstResponder];
    return YES;
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
