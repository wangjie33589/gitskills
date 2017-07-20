//
//  PositionViewController.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/19.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "PositionViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface PositionViewController ()<UIWebViewDelegate>

@end

@implementation PositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    mapView.mapType=MKMapTypeStandard;
    
    //[SVProgressHUD showWithStatus:@"努力加载中。。。"];
  self.title=@"设备定位";
   
    NSString *string =[NSString stringWithFormat:@"%@%@?user=%@&pwd=%@",HTTPIP,MAP_URL,USER_NAME,PASSWORD];
    
    NSLog(@"asfdgsdhjfghdsfg====%@",string);
    
    webView.delegate=self;
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:string]];

    
    [webView loadRequest:request];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    

}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self performSelector:@selector(dely) withObject:nil afterDelay:2];


}
-(void)dely{
    [SVProgressHUD dismiss];

}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    //[SVProgressHUD showWithStatus:@"努力加载中..."];
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
