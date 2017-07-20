//
//  SetTableViewCell.m
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/14.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "SetTableViewCell.h"

@implementation SetTableViewCell

- (void)awakeFromNib {
    self.imag.layer.masksToBounds = YES;
    self.imag.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
