//
//  HomeViewController.h
//  SyncSmartHome
//
//  Created by SciyonSoft_WangJie on 16/5/3.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

enum{
    SocketOfflineByServer,      //服务器掉线
    SocketOfflineByUser,        //用户断开
    SocketOfflineByWifiCut,     //wifi 断开
};

@interface HomeViewController : UIViewController
@property (strong,nonatomic) NSString *host;
@property (strong ,nonatomic) NSString *port;

@property (nonatomic, retain) NSTimer *heartTimer;//心跳计时器

- (void)startConnectSocket;//  socket连接
@end
