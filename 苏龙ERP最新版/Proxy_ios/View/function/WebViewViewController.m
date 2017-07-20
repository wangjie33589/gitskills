//
//  WebViewViewController.m
//  WorkPlan-IOS
//
//  Created by E-Bans on 15/10/29.
//  Copyright © 2015年 ZS. All rights reserved.
//

#import "WebViewViewController.h"

@interface WebViewViewController () <UIWebViewDelegate>
{
    UIButton* btn;
    NSString* url;
    NSString* typeStr;
}
@property(strong,nonatomic)UIDocumentInteractionController *doucumentInteractionController;
@end

@implementation WebViewViewController

- (id)initWithUrl:(NSString *)webUrl  type:(NSString *)aType;
{
    self = [super init];
    if (self) {
        url = webUrl;
        typeStr = aType;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    //[SVProgressHUD showWithStatus:@"努力加载中..."];
    [super viewWillAppear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"url===%@",url);
    NSString* encodedString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
    self.view.transform = CGAffineTransformMakeRotation(90*M_PI/180);
   // self.navigationController.navigationBar.hidden = YES;
    //[SVProgressHUD showWithStatus:@"努力加载中..."];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodedString]] ;
    NSLog(@"url=======%@",url);
    
//webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, LWidth, LHeight)];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    //self.webView.backgroundColor=[UIColor redColor];
    //[self.view addSubview:self.self.webView];
   // [self.webView loadRequest:request];
    
    if ([typeStr isEqualToString:@"txt"]) {
        NSStringEncoding * usedEncoding = nil;
        //带编码头的如 utf-8等 这里会识别
        NSString *body = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] usedEncoding:usedEncoding error:nil];
        
        
        
        NSLog(@"body=======%@",body);
        if (!body)
        {
            //如果之前不能解码，现在使用GBK解码
            NSLog(@"GBK");
            body = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:0x80000632 error:nil];
        }
        if (!body) {
            //再使用GB18030解码
            NSLog(@"GBK18030");
            body = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:0x80000631 error:nil];
        }
        if (body) {
            [self.webView loadHTMLString:body baseURL:nil];
        }
        else {
            NSLog(@"没有合适的编码");
        }
        NSData* Data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        NSLog(@"DATA=====%@",Data);
        NSString* aStr = [[NSString alloc] initWithData:Data encoding:0x80000632];
        NSString* responseStr = [NSString stringWithFormat:
                                 @"<HTML>"
                                 "<head>"
                                 "<title>Text View</title>"
                                 "</head>"
                                 "<BODY>"
                                 "<pre>"
                                 "%@"
                                 "</BODY>"
                                 "</HTML>",
                                 aStr];
        [self.webView loadHTMLString:responseStr baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    }else{
        [self.webView loadRequest:request];
    }
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(LHeight-70, 20, 50, 50);
    btn.backgroundColor = [UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:0.4];
    [btn addTarget:self action:@selector(go_back) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitle:@"关闭" forState:0];
    
    btn.layer.masksToBounds = YES;

    btn.layer.cornerRadius = 25;
    
    
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:btn];
}

-(void)request{
    NSURL *URL =[NSURL URLWithString:url];
    //if (URL) {
           self.doucumentInteractionController=[UIDocumentInteractionController interactionControllerWithURL:URL];
        [self.doucumentInteractionController setDelegate:self];
        [self.doucumentInteractionController presentPreviewAnimated:YES];
  //  }

 
    
}
#pragma mark -
#pragma mark Document Interaction Controller Delegate Methods
- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}


- (void)go_back
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:(NSString*)error];

}
- (IBAction)BtnnClick:(UIButton *)sender {
    [self request];
}
@end
