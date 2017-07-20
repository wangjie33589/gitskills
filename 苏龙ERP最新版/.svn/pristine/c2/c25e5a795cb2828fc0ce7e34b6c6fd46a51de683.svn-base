//
//  PeopleViewController.h
//  Proxy_ios
//
//  Created by E-Bans on 15/11/27.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PeopleViewControllerDelegate <NSObject>

-(void)All_backUpDataViewController:(NSArray *)array data:(NSDictionary *)dict type:(NSString *)aType;

@end

@interface PeopleViewController : UIViewController
{    
    IBOutlet UISearchBar *searchBarPeople;
}

@property (nonatomic, unsafe_unretained) id<PeopleViewControllerDelegate> delegate;

- (id)initWithType:(NSString *)aType;

@end
