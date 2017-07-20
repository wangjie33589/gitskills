//
//  reworkVC.m
//  ios版本科远APP
//
//  Created by sciyonSoft on 15/11/30.
//  Copyright © 2015年 sciyonSoft. All rights reserved.
//

#import "reworkVC.h"


@interface reworkVC (){
    NSArray *showArray;
    NSDictionary *showDic;

}

@end

@implementation reworkVC

- (void)viewDidLoad {
    [super viewDidLoad];
  

    [self configView];
}
-(void)configView{
    [self.task_name setEnabled:NO];
    [self.handelPerson setEnabled:NO];
    [self.experctTime setEnabled:NO];
    [self.firstTextField setEditable:NO];
    [self.secondTextField setEditable:NO];
    [self.reworkTime setEnabled:NO];
    self.task_name.text=showDic[@"FTITLE"];
    self.handelPerson.text=showDic[@"FRUNAME"];
    self.experctTime.text=[NSString stringWithFormat:@"%@~%@",[self replecString:showDic[@"FPSTIME"]],[self replecString:showDic[@"FPETIME"]]];
    self.firstTextField.text=showDic[@"FCONTENT"];
   self.secondTextField.text=showDic[@"FRREASON"];

    
    
}
//格式化时间
-(NSString *)replecString:(NSString *)string{
    
    NSString *newBtime =[string stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSString *nowStr =[newBtime stringByReplacingOccurrencesOfString:@"00:00:00+08:00" withString:@""];
    return nowStr;
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

-(id)initWithArray:(NSDictionary *)Dic{
    self =[super init];
    
    
    
    if (self) {
        showDic =Dic;
    }
    
    return self;
    
    
}
@end
