//
//  SYQRCodeViewController.h
//  weweima
//
//  Created by SciyonSoft_WangJie on 16/4/6.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYQRCodeViewController : UIViewController
@property (nonatomic, copy) void (^SYQRCodeCancleBlock) (SYQRCodeViewController *);//扫描取消
@property (nonatomic, copy) void (^SYQRCodeSuncessBlock) (SYQRCodeViewController *,NSString *);//扫描结果
@property (nonatomic, copy) void (^SYQRCodeFailBlock) (SYQRCodeViewController *);//扫描失败


@end
