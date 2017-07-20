//
//  Home_TableViewCell.h
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/17.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Home_TableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *indexStr;
@property (strong, nonatomic) IBOutlet UIImageView *bgImag;
@property (strong, nonatomic) IBOutlet UILabel *capacity;
@property (strong, nonatomic) IBOutlet UILabel *load;
@property (strong, nonatomic) IBOutlet UILabel *heating;
@property (strong, nonatomic) IBOutlet UILabel *loadRate;
@property (strong, nonatomic) IBOutlet UILabel *dosage;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@end
