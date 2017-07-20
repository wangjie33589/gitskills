/*
 *  CCAudioPlayer - Objective-C Audio player support remote and local files, Sitting on top of AVPlayer:
 *
 *      https://github.com/yechunjun/CCAudioPlayer
 *
 *  This code is distributed under the terms and conditions of the MIT license.
 *
 *  Author:
 *      Chun Ye <chunforios@gmail.com>
 *
 */

#import <UIKit/UIKit.h>


@interface DemoViewController : UIViewController
@property (nonatomic, retain) NSArray* renderers;
@property (nonatomic, retain)NSArray* dataSource;
@property (nonatomic, retain)NSMutableArray*ipArray;
@property (nonatomic, retain)NSMutableArray*DeviceNameArr;

+ (DemoViewController *)defaultManager;

@end
