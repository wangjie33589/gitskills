//
//  PeopleTableViewCell.h
//  Proxy_ios
//
//  Created by E-Bans on 15/11/27.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeopleModel.h"

@interface PeopleTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIButton *indexBtn;
@property (strong, nonatomic) IBOutlet UIImageView *row;

@property (strong, nonatomic) PeopleModel* model;

@end
