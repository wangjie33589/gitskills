//
//  allocModel.m
//  ios版本科远APP
//
//  Created by sciyonSoft on 15/12/2.
//  Copyright © 2015年 sciyonSoft. All rights reserved.
//

#import "allocModel.h"

@implementation allocModel

-(id)initWithDic:(NSDictionary *)dic{
    self =[super init];
    if (self) {
        
        self.manger =[dic  objectForKey:@"FRPNAME"]; //处理人
        
       
        self.state=[dic objectForKey:@"FSTATENAME"];//状态
  
        self.title=[dic objectForKey:@"FTITLE"];//标题
          self.FGUID=[dic objectForKey:@"FGUID"];//查询明细guid
        
    }
    
    
    return self;
    
}


@end
