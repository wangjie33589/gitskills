//
//  CollectionViewCell.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/4.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.AlertLab.layer.cornerRadius=15;
    self.AlertLab.layer.masksToBounds=YES;
    
    
    
}

@end
