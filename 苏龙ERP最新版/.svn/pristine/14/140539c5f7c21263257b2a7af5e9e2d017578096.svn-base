//
//  confirmVC.m
//  ios版本科远APP
//
//  Created by sciyonSoft on 15/11/30.
//  Copyright © 2015年 sciyonSoft. All rights reserved.
//

#import "confirmVC.h"


@interface confirmVC ()

@end

@implementation confirmVC{

    NSArray *showArray;
    NSDictionary *showDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self configView];
}
-(id)initWithArray:(NSDictionary *)Dic{
    self =[super init];
        if (self) {
        showDic=Dic;
    }
    
    return self;
    
    
}
-(void)configView{
    [self.taskName_field setEnabled:NO];
    [self.allocperson_field setEnabled:NO];
    [self.expectTimeTextField setEnabled:NO];
    [self.firsttextView setEditable:NO];
    [self.secondtextView setEditable:NO];
    [self.begintime setEnabled:NO];
    [self.enfTime setEnabled:NO];
    [self.taskName_field setEnabled:NO];
    [self.allocperson_field setEnabled:NO];
    [self.expectTimeTextField setEnabled:NO];
    [self.firsttextView setEditable:NO];
    [self.secondtextView setEditable:NO];
    [self.begintime setEnabled:NO];
    [self.enfTime setEnabled:NO];
    self.taskName_field.text=showDic[@"FTITLE"];
    self.allocperson_field.text=showDic[@"FRUNAME"];
    self.expectTimeTextField.text=[NSString stringWithFormat:@"%@~%@",[self replecString:showDic[@"FPSTIME"]],[self replecString:showDic[@"FPETIME"]]];
    self.firsttextView.text=showDic[@"FCONTENT"];
    self.begintime.text=[self replecString:showDic[@"FFSTIME"]];
    self.enfTime.text=[self replecString:showDic[@"FFETIME"]];
    self.secondtextView.text=showDic[@"FCEVA"];

    
}
//格式化时间
-(NSString *)replecString:(NSString *)string{
    
    NSString *newBtime =[string stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSString *nowStr =[newBtime stringByReplacingOccurrencesOfString:@"00:00:00+08:00" withString:@""];
    return nowStr;
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
