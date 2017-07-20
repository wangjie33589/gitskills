
//
//  ChangeVC.h
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/6/28.
//
//

#import <UIKit/UIKit.h>

@interface ChangeVC : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)btnClick:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *myTextField;
-(instancetype)initWithDic:(NSDictionary*)aDic;

@end
