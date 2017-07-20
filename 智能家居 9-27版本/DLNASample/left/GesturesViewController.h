//
//  GesturesViewController.h
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/15.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GesturesViewController : UIViewController
{
    
    IBOutlet UIButton *delPassWord;
    IBOutlet UIButton *modifyPassWord;
    IBOutlet UIButton *setPassWork;
}
- (IBAction)gesturesClick:(id)sender;

@end
