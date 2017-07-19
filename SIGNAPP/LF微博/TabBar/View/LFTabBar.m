//
//  LFTabBar.m
//  LF微博
//
//  Created by lf on 16/4/25.
//  Copyright © 2016年 lf. All rights reserved.
//

#import "LFTabBar.h"
#import "LFTabBarButton.h"


@interface LFTabBar ()

@property (nonatomic,weak)UIButton *selectedButton;

@end

@implementation LFTabBar



- (void)addTabBarButtonWithName:(NSString *)name selName:(NSString *)selName
{
    LFTabBarButton *btn = [LFTabBarButton buttonWithType:UIButtonTypeCustom];
    
    
    [btn setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selName] forState:UIControlStateSelected];
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:btn];
    

}


// 点击按钮的时候调用
- (void)btnClick:(UIButton *)button
{
    // 取消之前选择按钮
    _selectedButton.selected = NO;
    // 选中当前按钮
    button.selected = YES;
    // 记录当前选中按钮
    _selectedButton = button;
    // 切换控制器
    if ([_delegate respondsToSelector:@selector(tabBar:didSelectedIndex:)])
    {
        [_delegate tabBar:self didSelectedIndex:button.tag];
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //  设置按钮的尺寸
    
    CGFloat btnW = self.bounds.size.width / self.subviews.count;
    CGFloat btnH = self.bounds.size.height;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    
    for (int i = 0; i < self.subviews.count; i++) {
        UIButton *btn = self.subviews[i];
        btnX = i * btnW;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        if (i == 0)
        {
        [self btnClick:btn];
        }
        btn.tag = i; 
        
    }
    

}
@end
