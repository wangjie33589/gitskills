//
//  PLAYViewController.m
//  SyncSmartHome
//
//  Created by SciyonSoft_WangJie on 16/6/2.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "PLAYViewController.h"

@interface PLAYViewController ()<UIWebViewDelegate>

@end

@implementation PLAYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)initWebView {

    
    NSString *str =@"http://10.1.41.30/sciyoncloud/mobileimages/ling.mp3";
    NSURL *url =[NSURL URLWithString:str];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.MywebView loadRequest:request];

    self.MywebView.delegate=self;

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
