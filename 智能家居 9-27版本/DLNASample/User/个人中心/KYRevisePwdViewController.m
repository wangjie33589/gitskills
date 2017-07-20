//
//  KYRevisePwdViewController.m
//  SyncSmartHome
//
//  Created by sciyonSoft on 16/6/6.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "KYRevisePwdViewController.h"
#import "Masonry.h"
#import "LoginViewController.h"
#import "MyRequest.h"
#import "MyMD5.h"
@interface KYRevisePwdViewController ()
{
    NSMutableDictionary *_myDic;
}
@end
@implementation KYRevisePwdViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=YES;
    self.navigationItem.title = @"修改密码";
    NSLog(@"密码是---%@",PWD);
    self.view.backgroundColor = [UIColor whiteColor];
    [self addview];
    
}

- (void)addview{
    UILabel *label1=[[UILabel alloc]init];
    label1.text=@"原密码:";
    
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(0);
        make.left.mas_equalTo(self.view).offset(20);
        //        make.right.mas_equalTo(self.view).offset(-10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *label2=[[UILabel alloc]init];
    label2.text=@"新密码:";
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(40);
        make.left.mas_equalTo(self.view).offset(20);
        //        make.right.mas_equalTo(self.view).offset(-10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *label3=[[UILabel alloc]init];
    label3.text=@"请确认:";
    [self.view addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(80);
        make.left.mas_equalTo(self.view).offset(20);
        //        make.right.mas_equalTo(self.view).offset(-10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];
    
    _text1 =[[UITextField alloc]init];
    _text1.placeholder= @"请输入旧密码";
    _text1.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_text1];
    [_text1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(3);
        make.left.mas_equalTo(self.view).offset(85);
        make.right.mas_equalTo(self.view).offset(-30);
        //        make.width.mas_equalTo(60);
        make.height.mas_equalTo(36);
    }];
    
    _text2 =[[UITextField alloc]init];
    _text2.placeholder= @"请输入新密码";
    _text2.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_text2];
    [_text2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(43);
        make.left.mas_equalTo(self.view).offset(85);
        make.right.mas_equalTo(self.view).offset(-30);
        //        make.width.mas_equalTo(60);
        make.height.mas_equalTo(36);
    }];
    
    _text3 =[[UITextField alloc]init];
    _text3.placeholder= @"请输入新密码";
    _text1.secureTextEntry=YES;
    _text2.secureTextEntry=YES;
    _text3.secureTextEntry=YES;
    _text3.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_text3];
    [_text3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(83);
        make.left.mas_equalTo(self.view).offset(85);
        make.right.mas_equalTo(self.view).offset(-30);
        //        make.width.mas_equalTo(60);
        make.height.mas_equalTo(36);
    }];
    
    _savebtn = [[UIButton alloc]init];
    _savebtn.backgroundColor = [UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1];
    [_savebtn setTitle:@"保  存" forState:UIControlStateNormal];
    [_savebtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    _savebtn.layer.cornerRadius = 10.0;
    [self.view addSubview:_savebtn];
    [_savebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(140 );
        make.left.mas_equalTo(self.view).offset(35);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(32);
    }];
    
    _cleanbtn = [[UIButton alloc]init];
    _cleanbtn.backgroundColor = [UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1];
    [_cleanbtn setTitle:@"清  除" forState:UIControlStateNormal];
    [_cleanbtn addTarget:self action:@selector(cleanClick) forControlEvents:UIControlEventTouchUpInside];
    _cleanbtn.layer.cornerRadius = 10.0;
    [self.view addSubview:_cleanbtn];
    [_cleanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(140);
        make.right.mas_equalTo(self.view).offset(-35);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(32);
    }];
}

- (void)saveClick{
    
    switch (_savebtn.tag) {
        case 0:
        {
            if (_text1.text == nil || [_text1.text isEqualToString:@""]) {
                [SVProgressHUD showErrorWithStatus:@"请输入旧密码"];
            }else{
                if (_text2.text == nil || [_text2.text isEqualToString:@""]) {
                    [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
                }else if (![_text2.text isEqualToString:_text3.text]) {
                    [SVProgressHUD showErrorWithStatus:@"新密码两次输入不一致"];
                }else{
                    [self request];
                }
            }
        }
            break;
        case 1:
        {
            _text1.text = nil;
            _text2.text = nil;
            _text3.text = nil;
        }
            break;
            
        default:
            break;
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_text1 isExclusiveTouch]) {
        [_text1 resignFirstResponder];
    }
    if (![_text2 isExclusiveTouch]) {
        [_text2 resignFirstResponder];
    }
    if (![_text3 isExclusiveTouch]) {
        [_text3 resignFirstResponder];
    }
}

- (void)cleanClick{
    _text1.text = @"";
    _text2.text = @"";
    _text3.text = @"";
}
//修改密码请求
- (void)request
{
    NSString *newpasds =[_text1.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *newpasds2 =[_text2.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *firstMd51=[MyMD5 md5:newpasds];
    NSString *secondMD51=[MyMD5 md5:firstMd51];
    NSString *lastMD51=[MyMD5 md5:secondMD51];
    
    if (![lastMD51 isEqualToString:PWD]) {
        [SVProgressHUD showErrorWithStatus:@"您的密码输入错误，请重新输入"];
    }else if(![_text2.text isEqualToString:_text3.text]){
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致，请重新输入"];
    }else{
        NSLog(@"%@---%@----",USER_ID,SERVERID);
        
        NSString *firstMd5=[MyMD5 md5:newpasds2];
        NSString *secondMD5=[MyMD5 md5:firstMd5];
        NSString *lastMD5=[MyMD5 md5:secondMD5];
        NSLog(@"%@--%@--%@",HTTPIP,USER_ID,lastMD5);
        NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
        NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10213\",\"userid\":\"%@\",\"newpwd\":\"%@\"}",USER_ID,lastMD5];
        NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
        NSLog(@"dict======%@",dict);
        MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
        manager.backSuccess = ^void(NSDictionary *dictt)
        {
            
            if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
                
                _myDic=dictt[@"DATA"];
                
                //      NSLog(@"dict:==%@",dictt[@"DATA"]);
                
                [[NSUserDefaults standardUserDefaults] setObject:newpasds2 forKey:@"pwd"];
                [SVProgressHUD showWithStatus:[dictt objectForKey:@"MSG"]];
                // GCD
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 移除遮盖
                    [SVProgressHUD dismiss];
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            }else{
                [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
                
                
            }
        };
        
    }
}




@end
