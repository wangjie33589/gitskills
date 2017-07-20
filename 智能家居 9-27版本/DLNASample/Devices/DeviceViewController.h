//
//  DeviceViewController.h
//  SyncSmartHome
//
//  Created by SciyonSoft_WangJie on 16/5/3.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceViewController : UIViewController<UIScrollViewDelegate>{


    UIScrollView *_scollview;
    UISegmentedControl *_segControl;
    BOOL searchisEding;
    BOOL isfirstVC;


}

@end
