//
//  TaskTableViewCell.h
//  Proxy_ios
//
//  Created by E-Bans on 15/11/24.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *nameTime;
@property (strong, nonatomic) IBOutlet UIImageView *rowImag;

@end
