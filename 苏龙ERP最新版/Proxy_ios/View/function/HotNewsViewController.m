//
//  HotNewsViewController.m
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/30.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "HotNewsViewController.h"

@interface HotNewsViewController () <UIWebViewDelegate>
{
    NSString* url;
    NSString* title_str;
}
@end


@implementation HotNewsViewController

- (id)initWithUrl:(NSString *)aUrl title:(NSString *)titleStr
{
    self = [super init];
    if (self) {
        [SVProgressHUD showWithStatus:@"努力加载中..."];

        url = aUrl;
        title_str = titleStr;
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
   [SVProgressHUD showWithStatus:@"努力加载中..."];
//



}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.title = title_str;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;

    
}
-(void)webViewDidStartLoad:(UIWebView *)webView{

    [SVProgressHUD showWithStatus:@"努力加载中..."];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self performSelector:@selector(svpDismiss) withObject:self afterDelay:0];
    
}
- (void)svpDismiss
{
    [SVProgressHUD dismiss];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    
    [SVProgressHUD showWithStatus:@"网络超时"];
    [SVProgressHUD dismiss];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
