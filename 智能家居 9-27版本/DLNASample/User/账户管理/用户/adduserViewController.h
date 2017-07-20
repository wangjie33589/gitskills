//
//  adduserViewController.h
//  SmartHome
//
//  Created by sciyonSoft on 16/6/22.
//
//

#import <UIKit/UIKit.h>

@interface adduserViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *zero;
@property (strong, nonatomic) IBOutlet UITextField *frist;
@property (strong, nonatomic) IBOutlet UILabel *second;
@property (strong, nonatomic) IBOutlet UITextField *third;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property(retain,nonatomic)NSDictionary *thisSenceDic;
-(instancetype)initWithDic:(NSDictionary*)aDic;

@end
