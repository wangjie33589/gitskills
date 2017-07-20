//
//  addDeviceSenceVC.m
//  SyncSmartHome
//
//  Created by SciyonSoft_WangJie on 16/5/12.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "addDeviceSenceVC.h"

@interface addDeviceSenceVC ()
@property(nonatomic,retain)NSDictionary *fromDic;

@end

@implementation addDeviceSenceVC
-(instancetype)initWithADic:(NSDictionary*)aDic{

    self=[super init];
    if (self) {
        self.fromDic=aDic;
        
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}




@end
