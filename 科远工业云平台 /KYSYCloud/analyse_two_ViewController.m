//
//  analyse_two_ViewController.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/3/4.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "analyse_two_ViewController.h"


@interface analyse_two_ViewController ()<UIWebViewDelegate>{
    
    NSString *_titleStr;
    NSString *_urlstr;





}

@end

@implementation analyse_two_ViewController

-(id)initWithTitle:(NSString*)titleStr withUrl:(NSString*)urlStr{
    self=[super init];
    if (self) {
        _titleStr=titleStr;
        _urlstr=urlStr;
        [SVProgressHUD showWithStatus:@"努力加载中"];
    }


    return self;





}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_titleStr;
    
    [self initWebview];
}
-(void)initWebview{
    
    
    UIWebView *webview =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, LWIDTH, LHIGHT)];
    NSString *string =[NSString stringWithFormat:@"%@%@?FCODE=%@",HTTPIP,ANLISE_URL,_urlstr];
    
      webview.delegate=self;
    NSURL *url =[NSURL URLWithString:string];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webview loadRequest:request];
    [self.view addSubview:webview];
    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    
    [SVProgressHUD showErrorWithStatus:(NSString*)error];


}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];



}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD showWithStatus:@"正在加载..."];




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
