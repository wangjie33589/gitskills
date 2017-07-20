//
//  BaseDetailedViewController.m
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/12/4.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "BaseDetailedViewController.h"

@interface BaseDetailedViewController ()
{
    NSDictionary* showData;
    NSString *text;
    NSString *FPSTIME;
    NSString *FRSNNAME;
}
@end

@implementation BaseDetailedViewController
- (id)initWithShowData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        showData = [NSDictionary dictionaryWithDictionary:data];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缺陷详细";
    self.textView.userInteractionEnabled = NO;
    self.textView.font = [UIFont systemFontOfSize:13];
//    NSArray *array= [[NSArray alloc]initWithObjects:[showData objectForKey:@"FBILLID"],[showData objectForKey:@"FSTATENAME"],[showData objectForKey:@"FLENAME"],[showData objectForKey:@"FUNITNAME"],[showData objectForKey:@"FPHNAME"],[showData objectForKey:@"FDESC"],[showData objectForKey:@"FMSNAME"],[showData objectForKey:@"FTEAMNAME"],[showData objectForKey:@"FCLASSNAME"],[showData objectForKey:@"FRDNAME"],[showData objectForKey:@"FPNAME"],[showData objectForKey:@"FRSNNAME"],[showData objectForKey:@"FPSTIME"],[showData objectForKey:@"FFUNAME"],[[[showData objectForKey:@"FFDATETIME"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] stringByReplacingOccurrencesOfString:@"+08:00" withString:@""], nil];
//    
//    for (int i =0; i<array.count; i++) {
//        if (array[i]==[NSNull null]) {
//            
//            [array[i] isEqual:@""];
//            self.textView.text=[NSString stringWithFormat:@"  缺陷单号：%@\n\n  缺陷状态：%@\n\n  缺陷位置：%@\n\n  所属机组：%@\n\n  缺陷现象：%@\n\n  缺陷描述：%@\n\n  专业：%@\n\n  检修班组：%@\n\n  缺陷类别：%@\n\n  运行班组：%@\n\n  优先级：%@\n\n  处理人：%@\n\n  完成时间：%@\n\n  发现人：%@\n\n  发现时间：%@",array[0],array[1],array[2],array[3],array[4],array[5],array[6],array[7],array[8],array[9],array[10],array[11],array[12],array[13],array[14]];
//            
//            
//            
//            
//            
//        }
//         NSString *FPSTIME=//        
//    }
    if ([[showData objectForKey:@"FPSTIME"] isEqual:[NSNull null]]) {
      
        FPSTIME=[showData objectForKey:@"FPSTIME"];
        
        
    }else{
         FPSTIME= @"";
        
    
    
    }
    if ([[showData objectForKey:@"FRSNNAME"] isEqual:[NSNull null]]) {
        
        FRSNNAME=[showData objectForKey:@"FPSTIME"];
        
        
    }else{
        FRSNNAME= @"";
        
        
        
    }

   
    
    self.textView.text = [NSString stringWithFormat:@"  缺陷单号：%@\n\n  缺陷状态：%@\n\n  缺陷位置：%@\n\n  所属机组：%@\n\n  缺陷现象：%@\n\n  缺陷描述：%@\n\n  专业：%@\n\n  检修班组：%@\n\n  缺陷类别：%@\n\n  运行班组：%@\n\n  优先级：%@\n\n  处理人：%@\n\n  完成时间：%@\n\n  发现人：%@\n\n  发现时间：%@",[showData objectForKey:@"FBILLID"],[showData objectForKey:@"FSTATENAME"],[showData objectForKey:@"FLENAME"],[showData objectForKey:@"FUNITNAME"],[showData objectForKey:@"FPHNAME"],[showData objectForKey:@"FDESC"],[showData objectForKey:@"FMSNAME"],[showData objectForKey:@"FTEAMNAME"],[showData objectForKey:@"FCLASSNAME"],[showData objectForKey:@"FRDNAME"],[showData objectForKey:@"FPNAME"],FRSNNAME,FPSTIME,[showData objectForKey:@"FFUNAME"],[[[showData objectForKey:@"FFDATETIME"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] stringByReplacingOccurrencesOfString:@"+08:00" withString:@""]];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
