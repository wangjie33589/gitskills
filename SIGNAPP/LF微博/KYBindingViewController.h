//
//  KYBindingViewController.h
//  科远签到
//
//  Created by sciyonSoft on 16/5/18.
//  Copyright © 2016年 lf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYBindingViewController : UIViewController
{

    IBOutlet UITextField *pnoText;
    NSMutableArray *Data;
    NSMutableArray *SaveData;
    IBOutlet UIButton *savePnoBtn;
    
}
@property (nonatomic, retain) NSMutableArray *Data;
@property (nonatomic, retain) NSMutableArray *SaveData;

@end
