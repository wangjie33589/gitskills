//
//  detilModel.h
//  ios版本科远APP
//
//  Created by sciyonSoft on 15/12/3.
//  Copyright © 2015年 sciyonSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface detilModel : NSObject
@property(copy,nonatomic)NSString *mangeTime;
@property(copy,nonatomic)NSString *state;
@property(copy,nonatomic)NSString *mangerName;
@property(copy,nonatomic)NSString *title;
@property(copy,nonatomic)NSString *FGUID;
@property(copy,nonatomic)NSString *Fcontent;
@property(copy,nonatomic)NSString *FPetime;
-(id)initWithDic:(NSDictionary *)dic;

@end
