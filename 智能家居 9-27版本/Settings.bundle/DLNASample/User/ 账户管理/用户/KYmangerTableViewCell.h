//
//  KYmangerTableViewCell.h
//  SmartHome
//
//  Created by sciyonSoft on 16/9/26.
//
//

#import <UIKit/UIKit.h>

@interface KYmangerTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *firstLab;
@property (strong, nonatomic) IBOutlet UILabel *secondLab;
@property (strong, nonatomic) IBOutlet UIImageView *imageview;
@property (strong, nonatomic) IBOutlet UIImageView *indicateImage;

@property (strong, nonatomic) IBOutlet UILabel *online;
@end
