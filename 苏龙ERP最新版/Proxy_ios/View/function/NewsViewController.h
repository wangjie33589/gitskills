//
//  NewsViewController.h
//  Proxy_ios
//
//  Created by E-Bans on 15/11/24.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController
{
    IBOutlet UILabel *nsTitle;
    IBOutlet UILabel *time;
    IBOutlet UILabel *name;
    IBOutlet UILabel *contens;
}

- (id)initWithUrl:(NSString *)aUrl;

@end
