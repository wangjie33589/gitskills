//
//  TopView.h
//  menu
//
//  Created by E-Bans on 15/11/20.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopViewDelegate <NSObject>

-(void)pushNewsViewController:(NSInteger)page;

@end

@interface TopView : UIView
{
    UIScrollView* topScroll;
    
    NSMutableArray *centerArr;
    NSMutableArray *widthArr;
    BOOL isBtnClick;
    NSInteger FinalPage;
    NSInteger w;
    UIImageView* bgIV;
}

@property (nonatomic, unsafe_unretained) id<TopViewDelegate> delegate;
@property (nonatomic,strong) NSArray* array;

@end
