//
//  DropdownMenuView.h
//  PopoVerMenu
//
//  Created by chairman on 16/3/27.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropdownMenuView : UIView
/** key:title value:image */
@property (nonatomic, strong) NSDictionary *dataDic;
+ (instancetype)dropdown;
@end
