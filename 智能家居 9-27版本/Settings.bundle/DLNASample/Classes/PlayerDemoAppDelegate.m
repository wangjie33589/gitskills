//
//  PlayerDemoAppDelegate.m
//  PlayerDemo
//
//  Created by apple on 11-4-2.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "PlayerDemoAppDelegate.h"
#import "PlayerDemoViewController.h"

@implementation PlayerDemoAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch  
    window.rootViewController = viewController;  
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
    
	    
	return YES;
}


- (void)dealloc {
//    [viewController release];
//    [window release];
//    [super dealloc];
}


@end
