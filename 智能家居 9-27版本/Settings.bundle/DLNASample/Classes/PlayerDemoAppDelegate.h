//
//  PlayerDemoAppDelegate.h
//  PlayerDemo
//
//  Created by apple on 11-4-2.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlayerDemoViewController;

@interface PlayerDemoAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
    PlayerDemoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PlayerDemoViewController *viewController;

@end

