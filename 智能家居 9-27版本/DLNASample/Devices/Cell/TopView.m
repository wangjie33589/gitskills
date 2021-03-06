//
//  TopView.m
//  menu
//
//  Created by E-Bans on 15/11/20.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "TopView.h"

#define TopScHeight 40
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define ButtonFont 14

//按钮之间的间隔
#define GapOfButton 20.0

@implementation TopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/

- (void)drawRect:(CGRect)rect {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchClick:) name:@"tongzhi" object:nil];
    centerArr = [NSMutableArray array];
    widthArr = [NSMutableArray array];
    
    topScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, TopScHeight)];
    topScroll.showsHorizontalScrollIndicator = NO;
    topScroll.backgroundColor = [UIColor whiteColor] ;
    
    bgIV = [[UIImageView alloc] init];
    bgIV.backgroundColor = [UIColor colorWithRed:0.16 green:0.59 blue:1 alpha:1];
    bgIV.frame = CGRectMake(0, 38, 72, 2);
    [topScroll addSubview:bgIV];
    
    float contenX = GapOfButton;
    for (int i =0 ; i < _array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:_array[i] forState:UIControlStateNormal];
        button.titleLabel.font  = [UIFont systemFontOfSize:ButtonFont];
    CGSize size = [button.currentTitle sizeWithFont:[UIFont systemFontOfSize:ButtonFont] constrainedToSize:CGSizeMake(1000, 40)];
        if (_array.count<4) {
            if (_array.count==1) {
                button.frame = CGRectMake(0, 1, LWidth, TopScHeight - 4);
                bgIV.frame = CGRectMake(10, 38, LWidth-20, 2);
            }else if (_array.count==2) {
                button.frame = CGRectMake(i*(LWidth/2), 1, LWidth/2, TopScHeight - 4);
                bgIV.frame = CGRectMake(0, 38, LWidth/2, 2);
            }else if (_array.count==3) {
                button.frame = CGRectMake(i*(LWidth/3), 1, LWidth/3, TopScHeight - 4);
                bgIV.frame = CGRectMake(0, 38, LWidth/3, 2);
            }
        }else{
            button.frame = CGRectMake(contenX, 1, size.width, TopScHeight - 4);
        }
        button.backgroundColor = [UIColor clearColor];
        contenX = button.frame.origin.x + size.width + GapOfButton;
        button.tag = 200 + i;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topScroll addSubview:button];
        NSNumber *num = [NSNumber numberWithFloat:button.center.x];
        [centerArr addObject:num];
        NSNumber *num2 = [NSNumber numberWithFloat:button.frame.size.width];
        [widthArr addObject:num2];
        [button setTitleColor:i==0?[UIColor colorWithRed:0.16 green:0.59 blue:1 alpha:1]:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1] forState:UIControlStateNormal];
        if (i == _array.count-1) {
            w = button.frame.size.width;
        }
    }
    topScroll.contentSize = CGSizeMake(contenX, TopScHeight);
    [self addSubview:topScroll];
}

- (void)btnClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(pushNewsViewController:)]) {
        [self.delegate pushNewsViewController:button.tag-200];
    }
    isBtnClick = YES;
    FinalPage = button.tag - 200;
    [UIView animateWithDuration:0.3 animations:^{
        if (_array.count>3) {
            if (button.frame.origin.x+w > LWidth) {
                if (button.frame.origin.x>ScreenWidth/2.0&&button.frame.origin.x<topScroll.contentSize.width - ScreenWidth/2.0) {
                    topScroll.contentOffset = CGPointMake(button.frame.origin.x-ScreenWidth/2.0, 0);
                }
                else if (button.frame.origin.x>=topScroll.contentSize.width - ScreenWidth/2.0) {
                    topScroll.contentOffset = CGPointMake(topScroll.contentSize.width - ScreenWidth, 0);
                }
                else{
                    topScroll.contentOffset = CGPointMake(0, 0);
                }
            }
        }
    }];
    for (id view in [topScroll subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* btn = (UIButton *)view;
            if (btn.tag == button.tag) {
                [btn setTitleColor:[UIColor colorWithRed:0.16 green:0.59 blue:1 alpha:1] forState:0];
            }else{
                [btn setTitleColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1] forState:0];
            }
        }
    }
    [UIView animateWithDuration:0.15 animations:^{
        bgIV.frame = CGRectMake(button.frame.origin.x-20, 38, button.frame.size.width+40, 2);
    }];
}
- (void)switchClick:(NSNotification *)text{
    isBtnClick = YES;
    FinalPage = [text.userInfo[@"indexpage"] integerValue];
    for (id view in [topScroll subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* btn = (UIButton *)view;
            if (btn.tag == [text.userInfo[@"indexpage"] integerValue]+200) {
                
                
                [UIView animateWithDuration:0.3 animations:^{
                    if (_array.count>3) {
                        if (btn.frame.origin.x+w > LWidth) {
                            if (btn.frame.origin.x>ScreenWidth/2.0&&btn.frame.origin.x<topScroll.contentSize.width - ScreenWidth/2.0) {
                                topScroll.contentOffset = CGPointMake(btn.frame.origin.x-ScreenWidth/2.0, 0);
                            }
                            else if (btn.frame.origin.x>=topScroll.contentSize.width - ScreenWidth/2.0) {
                                topScroll.contentOffset = CGPointMake(topScroll.contentSize.width - ScreenWidth, 0);
                            }
                            else{
                                topScroll.contentOffset = CGPointMake(0, 0);
                            }
                        }
                    }
                }];
                
                [btn setTitleColor:[UIColor colorWithRed:0.16 green:0.59 blue:1 alpha:1] forState:0];
                [UIView animateWithDuration:0.15 animations:^{
                    bgIV.frame = CGRectMake(btn.frame.origin.x-20, 38, btn.frame.size.width+40, 2);
                }];
            }else{
                [btn setTitleColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1] forState:0];
            }
        }
    }
}

@end
