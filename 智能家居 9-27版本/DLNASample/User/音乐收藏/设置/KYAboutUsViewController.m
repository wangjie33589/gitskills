//
//  KYAboutUsViewController.m
//  SmartHome
//
//  Created by sciyonSoft on 16/7/6.
//
//

#import "KYAboutUsViewController.h"
#import "SVProgressHUD.h"

@interface KYAboutUsViewController ()

@end

@implementation KYAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=YES;
    self.navigationItem.title = @"关于我们";

}
- (IBAction)btn1:(id)sender
{
    
   // 1.显示蒙板
//    [SVProgressHUD showSuccessWithStatus:@"检查新版本..."];
    
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            // 2.隐藏蒙板
//                [SVProgressHUD dismiss];
    //
    //            // 3.提示用户
               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"当前已是最新版本" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //            // 显示UIAlertView
               [alert show];
                
           }    );
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
