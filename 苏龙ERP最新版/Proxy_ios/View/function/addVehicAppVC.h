//
//  addVehicAppVC.h
//  Proxy_ios
//
//  Created by SciyonSoft_WangJie on 17/7/6.
//  Copyright © 2017年 keyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VehicAppVC;
@protocol VehicAppVCDelegte <NSObject>

-(void)pushVehicAppVC;

@end

@interface addVehicAppVC : UIViewController
@property (nonatomic, unsafe_unretained) id<VehicAppVCDelegte> delegate;


@property (strong, nonatomic) IBOutlet UITextField *applyOrg;
@property (strong, nonatomic) IBOutlet UITextField *applyPerson;

@property(copy,nonatomic)NSString * type;
@property(copy,nonatomic)NSString *FLOWGUID;

@property (strong, nonatomic) IBOutlet UITextField *applyDateTexxtField;
@property (strong, nonatomic) IBOutlet UITextField *applypersonCountfield;
@property (strong, nonatomic) IBOutlet UITextField *indeedCityField;
- (IBAction)begintime:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *beginTimeBtn;
@property (strong, nonatomic) IBOutlet UIButton *endTime;
- (IBAction)endTimeBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *uesrCreRensonTview;
@property (strong, nonatomic) IBOutlet UITextView *remarkTview;
@property (strong, nonatomic) IBOutlet UIView *myview;

@property (strong, nonatomic) IBOutlet UIButton *bigSave;
@property (strong, nonatomic) IBOutlet UIButton *smallSave;
@property (strong, nonatomic) IBOutlet UIButton *smallDel;

- (id)initWithAdic:(NSDictionary*)aDic;

@end
