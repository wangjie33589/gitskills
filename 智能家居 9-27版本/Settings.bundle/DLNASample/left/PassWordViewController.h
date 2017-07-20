//
//  PassWordViewController.h
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/15.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassWordViewController : UIViewController
{
    IBOutlet UITextField *passwork1;
    IBOutlet UITextField *passwork2;
    IBOutlet UITextField *passwork3;
    IBOutlet UIButton *upPassWork;
    IBOutlet UIButton *backPassWorkButton;
}

- (IBAction)buttonClick:(id)sender;

@end
