//
//  EWMController.m
//  Proxy_ios
//
//  Created by sciyonSoft on 16/1/12.
//  Copyright © 2016年 keyuan. All rights reserved.
//

#import "EWMController.h"

@interface EWMController ()

@end

@implementation EWMController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

-(void)initView{
    UIScrollView *scroll =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, LWidth, LHeight)];
    scroll.backgroundColor=[UIColor clearColor];
    scroll.contentSize=CGSizeMake(4*LWidth, LHeight);
    scroll.pagingEnabled=YES;
    scroll.contentOffset=CGPointMake(0, 0);
    
    //scroll.userInteractionEnabled=NO;
    [self.view addSubview:scroll];
    //NSArray *arr =[[NSArray alloc]initWithObjects:@"IOSNW", @"IOSWW",@"AZNW",@"AZWW",nil];
    NSArray *arr =[[NSArray alloc]initWithObjects:@"IOSNW", @"IOSWW",@"AZNW",@"AZWW",nil];
    NSArray *otherARR =[[NSArray alloc]initWithObjects:@"iOS版内网二维码",@"iOS版外网二维码",@"Android版内网二维码",@"Android版外网二维码", nil];
    for (int i=0; i<4; i++) {
        
        
        UIImageView *imgView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        imgView.center=CGPointMake(LWidth/2+LWidth*i , self.view.center.y-50);
        imgView.image=[UIImage imageNamed:arr[i]];
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(LWidth*i, imgView.center.y+120,LWidth, 30)];
        label.numberOfLines=0;
        //label.backgroundColor=[UIColor redColor];
        
        
        [scroll addSubview:label];
        label.textAlignment=NSTextAlignmentCenter;
        label.text=otherARR[i];
        label.font=[UIFont systemFontOfSize:18];
        label.textColor=[UIColor blackColor];
        
        
        
        [scroll addSubview:imgView];
        UILabel *topLAb =[[UILabel alloc]initWithFrame:CGRectMake(LWidth*i, 0, LWidth, imgView.center.y-100)];
        topLAb.numberOfLines=0;
        topLAb.textAlignment=NSTextAlignmentCenter;
        topLAb.font=[UIFont systemFontOfSize:18];
        
        topLAb.text=@"    扫一扫下面的二维码即可下载安装本软件\n注意：当前二维码暂时不支持微信扫一扫，请用浏览器扫一扫功能进行下载安装";
        [scroll addSubview:topLAb];
        
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"BrandProductPopup关闭"] forState:UIControlStateNormal];
        button.frame=CGRectMake(LWidth-100+LWidth*i, 0,100, 100);
        [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        
        
        
    }
}
-(void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
    
    
    
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
