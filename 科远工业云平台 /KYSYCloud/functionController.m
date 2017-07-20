//
//  functionController.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/3/17.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "functionController.h"

@interface functionController ()<UIScrollViewDelegate>

@end

@implementation functionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"功能简介";
    [self initScrollow];
}

-(void)initScrollow{

    UIScrollView *scrollow =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, LWIDTH, LHIGHT)];
    scrollow.pagingEnabled=YES;
    scrollow.contentOffset=CGPointMake(0, 0);
    scrollow.contentSize=CGSizeMake(LWIDTH*2, 0);
    scrollow.delegate=self;
    
    NSArray *array =[[NSArray alloc]initWithObjects:@"iosewm.png",@"sciyoncloud.png", nil];
 
   
    for (int i=0; i<2; i++) {
        
        
        UIImageView *imageview =[[UIImageView alloc]initWithFrame:CGRectMake(i*LWIDTH, 100, LWIDTH-40, LHIGHT-200)];
        imageview.image=[UIImage imageNamed:array[i]];
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(i*LWIDTH, 60, LWIDTH, 40)];
        label.text=[NSString stringWithFormat:@"%@",i==0?@"SYCloud科远智慧云手机客户端iOS版本":@"SYCloud科远智慧云手机客户端安卓版本"];
        
        label.textAlignment=NSTextAlignmentCenter;
        [scrollow addSubview:label];
            [scrollow addSubview:imageview];
    }
    
        [self.view addSubview:scrollow];



}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
