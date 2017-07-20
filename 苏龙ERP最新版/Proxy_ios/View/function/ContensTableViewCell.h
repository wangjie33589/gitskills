//
//  ContensTableViewCell.h
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/23.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContensTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imag;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *contens;

@end
