//
//  KYServerViewController.m
//  科远签到
//
//  Created by sciyonSoft on 16/5/30.
//  Copyright © 2016年 lf. All rights reserved.
//

#import "KYServerViewController.h"
#import "MBProgressHUD+MJ.h"
@interface KYServerViewController ()
@property (strong, nonatomic) IBOutlet UITextField *Servertext;

@end

@implementation KYServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"num"]!=nil) {
        _Servertext.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"num"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Surebtn:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults]setObject:_Servertext.text forKey:@"num"];
    [MBProgressHUD showMessage:@"保存成功"];
    // 模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 移除遮盖
        [MBProgressHUD hideHUD];
    });
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
