//
//  SetViewController.h
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/14.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetViewController : UIViewController
{
    IBOutlet UITableView *set_tableview;
    IBOutlet UIButton *goBackButton;
}

- (IBAction)go_back:(id)sender;

@end
