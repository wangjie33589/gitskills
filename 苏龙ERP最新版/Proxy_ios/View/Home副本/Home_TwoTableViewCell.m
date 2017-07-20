//
//  Home_TwoTableViewCell.m
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/17.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "Home_TwoTableViewCell.h"

@implementation Home_TwoTableViewCell

- (void)awakeFromNib {
    int wigth  = [[NSString stringWithFormat:@"%.0f",LWidth/5]intValue];
    self.bgImag.frame=CGRectMake(5, 0, LWidth-10, 20);
    if (IPHONE_5) {
        self.mg.frame=CGRectMake(0, 0, wigth+wigth, 20);
        self.nper1.frame=CGRectMake(wigth+wigth-15, 0, wigth, 20);
        
    }
    
   }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
