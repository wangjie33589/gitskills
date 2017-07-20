//
//  LeftViewController.h
//  Proxy_ios
//
//  Created by E-Bans on 15/11/13.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftViewControllerDelegate <NSObject>

-(void)pushSetViewController;

@end

@protocol LeftViewControllerRefreshDelegate <NSObject>

-(void)refreshDataViewController;

@end

@protocol LeftViewControllerPushDelegate <NSObject>

-(void)pushMenuViewController:(NSString *)title titleUp:(NSString *)titleStr;

@end

@interface LeftViewController : UIViewController
{
    IBOutlet UIImageView *userImag;
    IBOutlet UILabel *userName;
    IBOutlet UILabel *userTask;
    IBOutlet UITableView *list_tableView;
}

@property (nonatomic, unsafe_unretained) id<LeftViewControllerDelegate> delegate;
@property (nonatomic, unsafe_unretained) id<LeftViewControllerPushDelegate> delegatePush;
@property (nonatomic, unsafe_unretained) id<LeftViewControllerRefreshDelegate> delegateFunction;

- (void)go_back:(UIButton *)sender;
- (void)setButtonClick:(UIButton *)sender;

@end
