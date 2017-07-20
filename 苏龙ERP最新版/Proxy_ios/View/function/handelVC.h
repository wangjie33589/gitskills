//
//  handelVC.h
//  ios版本科远APP
//
//  Created by sciyonSoft on 15/11/30.
//  Copyright © 2015年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface handelVC : UIViewController{

}


-(id)initWithArray:(NSDictionary *)Dic;
@property (strong, nonatomic) IBOutlet UIView *myView;
@property (strong, nonatomic) IBOutlet UITextField *taskName_field;
@property (strong, nonatomic) IBOutlet UITextField *allocperson_field;
@property (strong, nonatomic) IBOutlet UITextField *expectTimeTextField;
@property (strong, nonatomic) IBOutlet UITextView *firsttextView;
@property (strong, nonatomic) IBOutlet UITextView *secondtextView;
@property (strong, nonatomic) IBOutlet UITextField *begintime;
@property (strong, nonatomic) IBOutlet UITextField *enfTime;

@end
