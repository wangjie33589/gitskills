//
//  workTask.m
//  ios版本科远APP
//
//  Created by sciyonSoft on 15/12/2.
//  Copyright © 2015年 sciyonSoft. All rights reserved.
//

#import "workTask.h"

@implementation workTask
-(id)initWithDic:(NSDictionary *)dic{
    self =[super init];
    if (self) {
        
      
        
        self.mangeTime=[dic objectForKey:@"FSDATE"];//分配时间
        self.state=[dic objectForKey:@"FSTATENAME"];//状态
        self.mangerName=[dic objectForKey:@"FSUNAME"];//分配人
        self.title=[dic objectForKey:@"FTITLE"];//标题
        self.FGUID=[dic objectForKey:@"FGUID"];//查询明细guid
        
            }
    
    
    return self;
    
}



@end
