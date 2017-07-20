//
//  AppDelegate.h
//  SyncSmartHome
//
//  Created by SciyonSoft_WangJie on 16/5/3.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DDMenuController.h"
#import "LLLockViewController.h"

//enum{
//    SocketOfflineByServer,      //服务器掉线
//    SocketOfflineByUser,        //用户断开
//    SocketOfflineByWifiCut,     //wifi 断开
//};
//#import "LLLockViewController.h"
@class CGUpnpAvRenderer;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) DDMenuController* ddMenu;
@property (strong, nonatomic) UINavigationController *navigationController;

@property (nonatomic,strong) UITabBarController* tabBarCtr;
@property (nonatomic, retain)CGUpnpAvRenderer* avRenderer;

// 手势解锁相关
@property (strong, nonatomic) LLLockViewController* lockVc; // 添加解锁界面
- (void)showLLLockViewController:(LLLockViewType)type;
@end


