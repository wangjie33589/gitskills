//
//  BookTableViewCell.h
//  Proxy_ios
//
//  Created by E-Bans on 15/11/19.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *jobs;
@property (strong, nonatomic) IBOutlet UIButton *phone;

@end
