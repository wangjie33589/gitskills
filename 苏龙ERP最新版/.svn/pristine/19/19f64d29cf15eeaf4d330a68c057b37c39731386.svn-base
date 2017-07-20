//
//  Home_TableViewCell.m
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/17.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "Home_TableViewCell.h"

@implementation Home_TableViewCell

- (void)awakeFromNib {

   // int wigth  = [[NSString stringWithFormat:@"%.0f",LWidth/7]intValue];
// 
//        self.firstLab.frame =CGRectMake(0, 0, wigth-10, 20);
//        self.Secondlab.frame =CGRectMake(wigth-20, 0, 50, 20);
//        self.Thirdlab.frame =CGRectMake(wigth*100, 0, 50, 20);
//        self.fourlab.frame =CGRectMake(wigth*3, 0, 50, 20);
//        self.fivelab.frame =CGRectMake(wigth*4, 0, 50, 20);
//        self.sixLab.frame =CGRectMake(wigth*5, 0,50, 20);
//        self.lastLabel.frame =CGRectMake(wigth*6, 0, 50, 20);
//
    int wigth  = [[NSString stringWithFormat:@"%.0f",LWidth/7]intValue];
    self.bgImag.frame=CGRectMake(5, 0, LWidth-10, 20);
    self.bgImag.layer.cornerRadius=20;
    self.bgImag.layer.masksToBounds=YES;
    self.backImage.frame=CGRectMake(5, 0, LWidth-10, 1);

    if (IPHONE_5) {
        self.firstLab.frame =CGRectMake(0, 0, wigth-10, 20);
        self.Secondlab.frame =CGRectMake(wigth*1-10, 0, wigth, 20);
        self.Thirdlab.frame =CGRectMake(wigth*2-10, 0, wigth, 20);
        self.fourlab.frame =CGRectMake(wigth*3-15, 0, wigth+10, 20);
        self.fivelab.frame =CGRectMake(wigth*4-15, 0, wigth, 20);
        self.sixLab.frame =CGRectMake(wigth*5-30, 0,wigth+10, 20);
        self.lastLabel.frame =CGRectMake(wigth*6-27, 0, wigth+10, 20);
        
    }else if(IPHONE_6){
        self.firstLab.frame =CGRectMake(0, 0, wigth, 20);
        self.Secondlab.frame =CGRectMake(wigth*1-15, 0, wigth, 20);
        self.Thirdlab.frame =CGRectMake(wigth*2-15, 0, wigth, 20);
        self.fourlab.frame =CGRectMake(wigth*3-20, 0, wigth+10, 20);
        self.fivelab.frame =CGRectMake(wigth*4-20, 0, wigth, 20);
        self.sixLab.frame =CGRectMake(wigth*5-30, 0,wigth+5, 20);
        self.lastLabel.frame =CGRectMake(wigth*6-30, 0, wigth, 20);
        
        
        
    }else{
        self.firstLab.frame =CGRectMake(0, 0, wigth, 20);
        self.Secondlab.frame =CGRectMake(wigth*1-10, 0, wigth, 20);
        self.Thirdlab.frame =CGRectMake(wigth*2-10, 0, wigth, 20);
        self.fourlab.frame =CGRectMake(wigth*3-10, 0, wigth+10, 20);
        self.fivelab.frame =CGRectMake(wigth*4-5, 0, wigth, 20);
        self.sixLab.frame =CGRectMake(wigth*5-15, 0,wigth+5, 20);
        self.lastLabel.frame =CGRectMake(wigth*6-20, 0, wigth, 20);

    
    
    
    
    }
    

    

    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
