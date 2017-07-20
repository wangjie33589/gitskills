//
//  TimerCell.h
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/7/11.
//
//

#import <UIKit/UIKit.h>

@interface TimerCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIImageView *sunDayImg;
@property (strong, nonatomic) IBOutlet UIImageView *MonDayImg;
@property (strong, nonatomic) IBOutlet UIImageView *TuesDayImg;
@property (strong, nonatomic) IBOutlet UIImageView *wedDayImg;
@property (strong, nonatomic) IBOutlet UIImageView *thurDayImg;
@property (strong, nonatomic) IBOutlet UIImageView *friDayImg;
@property (strong, nonatomic) IBOutlet UIImageView *satDayImg;

@end
