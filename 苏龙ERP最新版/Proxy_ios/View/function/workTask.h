//
//  workTask.h
//  ios版本科远APP
//
//  Created by sciyonSoft on 15/12/2.
//  Copyright © 2015年 sciyonSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface workTask : NSObject

@property(copy,nonatomic)NSString *mangeTime;
@property(copy,nonatomic)NSString *state;
@property(copy,nonatomic)NSString *mangerName;
@property(copy,nonatomic)NSString *title;
@property(copy,nonatomic)NSString *FGUID;
-(id)initWithDic:(NSDictionary *)dic;



@end
