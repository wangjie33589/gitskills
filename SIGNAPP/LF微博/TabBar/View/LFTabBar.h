//
//  LFTabBar.h
//  LF微博
//
//  Created by lf on 16/4/25.
//  Copyright © 2016年 lf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LFTabBar;

@protocol LFTabBarDelegate <NSObject>

@optional
- (void)tabBar:(LFTabBar *)tabBar didSelectedIndex:(int)index;


@end

@interface LFTabBar : UIView

@property (nonatomic, weak) id<LFTabBarDelegate> delegate;

//给外界传见按钮
- (void)addTabBarButtonWithName:(NSString *)name selName:(NSString *)selName;
@end
