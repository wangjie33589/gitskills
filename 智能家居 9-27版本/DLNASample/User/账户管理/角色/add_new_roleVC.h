//
//  add_new_roleVC.h
//  SyncSmartHome
//
//  Created by SciyonSoft_WangJie on 16/5/31.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol add_new_roleVCDelegate <NSObject>

@end
@interface add_new_roleVC : UIViewController
@property id<add_new_roleVCDelegate> userDelegate;
@end
