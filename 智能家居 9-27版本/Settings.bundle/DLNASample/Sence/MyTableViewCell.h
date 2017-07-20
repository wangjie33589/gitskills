//
//  MyTableViewCell.h
//  SyncSmartHome
//
//  Created by SciyonSoft_WangJie on 16/5/12.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iView;
@property (strong, nonatomic) IBOutlet UILabel *firstLab;
@property (strong, nonatomic) IBOutlet UILabel *secondLab;
@property (strong, nonatomic) IBOutlet UIImageView *selectedImagView;
@property (strong, nonatomic) IBOutlet UIImageView *glowView;

@end
