//
//  GesturesViewController.m
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/15.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "GesturesViewController.h"
#import "LoginViewController.h"

@interface GesturesViewController ()

@end

@implementation GesturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手势密码";
    delPassWord.backgroundColor = [UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1];
    delPassWord.layer.masksToBounds = YES;
    delPassWord.layer.cornerRadius = 3;
    modifyPassWord.backgroundColor = [UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1];
    modifyPassWord.layer.masksToBounds = YES;
    modifyPassWord.layer.cornerRadius = 3;
    setPassWork.backgroundColor = [UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1];
    setPassWork.layer.masksToBounds = YES;
    setPassWork.layer.cornerRadius = 3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gesturesClick:(id)sender {
    UIButton* btn = (UIButton *)sender;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    AppDelegate* ad = (AppDelegate*)[UIApplication sharedApplication].delegate;
    switch (btn.tag) {
        case 0:
        {
            if ([[userDefaults objectForKey:@"passwork"] isEqualToString:@"yes"]) {
                UIAlertAction* determine = [UIAlertAction actionWithTitle:@"忘记重设" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [userDefaults removeObjectForKey:@"passwork"];
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    LoginViewController* loginVC = [story instantiateViewControllerWithIdentifier:@"LoginViewController"];
                    [App window].rootViewController = loginVC;
                }];
                UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                }];
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"小提示" message:@"您已经创建过了一个密码" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:nil];
                [alert addAction:determine];
                [alert addAction:cancel];
            }
            [userDefaults setObject:@"yes" forKey:@"passwork"];
            [ad showLLLockViewController:LLLockViewTypeCreate];
        }
            break;
        case 1:
        {
            [ad showLLLockViewController:LLLockViewTypeModify];
        }
            break;
        case 2:
        {
            [userDefaults removeObjectForKey:@"passwork"];
            [ad showLLLockViewController:LLLockViewTypeClean];
        }
            break;
            
        default:
            break;
    }
}
@end
