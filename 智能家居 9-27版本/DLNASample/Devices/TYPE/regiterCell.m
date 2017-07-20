//
//  regiterCell.m
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/8/15.
//
//

#import "regiterCell.h"

@implementation regiterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textfield.delegate=self;
    self.textfield.returnKeyType=UIReturnKeyDone;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField  resignFirstResponder];
    
    
    return YES;



}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
