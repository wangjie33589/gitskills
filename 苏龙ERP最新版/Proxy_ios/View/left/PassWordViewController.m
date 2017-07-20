//
//  PassWordViewController.m
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/15.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "PassWordViewController.h"
#import "LoginViewController.h"

@interface PassWordViewController () <MyRequestDelegate>
{
}
@end

@implementation PassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    passwork1.secureTextEntry = YES;
    passwork2.secureTextEntry = YES;
    passwork3.secureTextEntry = YES;
    upPassWork.backgroundColor = [UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1];
    upPassWork.layer.masksToBounds = YES;
    upPassWork.layer.cornerRadius = 3;
    backPassWorkButton.layer.masksToBounds = YES;
    backPassWorkButton.layer.cornerRadius = 3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)buttonClick:(id)sender {
    UIButton* btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:
        {
            if (passwork1.text == nil || [passwork1.text isEqualToString:@""]) {
                [SVProgressHUD showErrorWithStatus:@"请输入旧密码"];
            }else{
                if (passwork2.text == nil || [passwork2.text isEqualToString:@""]) {
                    [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
                }else if (![passwork2.text isEqualToString:passwork3.text]) {
                    [SVProgressHUD showErrorWithStatus:@"新密码两次输入不一致"];
                }else{
                    [self upPasswork];
                }
            }
        }
            break;
        case 1:
        {
            passwork1.text = nil;
            passwork2.text = nil;
            passwork3.text = nil;
        }
            break;
            
        default:
            break;
    }
}
- (void)upPasswork
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"UPDPWD",@"Action",passwork2.text,@"NEW",passwork1.text,@"OLD", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/ProxyMobile/MobileFrame.ashx",HTTPIP,SLRD] withParameter:dict];
    manager.delegate = self;
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"passwork"];
            [userDefaults removeObjectForKey:@"login"];
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController* loginVC = [story instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [App window].rootViewController = loginVC;
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}
#pragma mark ------------------------- 网络环境不可用时的页面
- (void)RequestErrorViewController
{
    UIAlertAction* determine = [UIAlertAction actionWithTitle:@"重新提交" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self upPasswork];
    }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"小提示" message:@"网络好像不通畅" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    [alert addAction:determine];
    [alert addAction:cancel];
}
@end
