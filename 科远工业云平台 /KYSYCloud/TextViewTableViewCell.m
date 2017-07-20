//
//  TextViewTableViewCell.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/3/3.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "TextViewTableViewCell.h"

@implementation TextViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.txtView.returnKeyType=UIReturnKeyDone;
    self.txtView.delegate=self;
    
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
