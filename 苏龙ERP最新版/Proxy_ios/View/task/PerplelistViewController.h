//
//  PerplelistViewController.h
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/12/2.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PerplelistViewControllerDelegate <NSObject>

-(void)backUpDataViewController:(NSArray *)array data:(NSDictionary *)dict type:(NSString *)aType;

@end

@interface PerplelistViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, unsafe_unretained) id<PerplelistViewControllerDelegate> delegate;

- (id)initWithDict:(NSDictionary *)urlDict type:(NSString *)aType;

@end
