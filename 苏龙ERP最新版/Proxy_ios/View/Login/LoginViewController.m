//
//  LoginViewController.m
//  Proxy_ios
//
//  Created by E-Bans on 15/11/13.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "LoginViewController.h"
#import "Home_Function_ViewController.h"
#import "Home_Home_ViewController.h"
#import "Home_task_ViewController.h"
#import "Home_User_ViewController.h"
#import "ConFunc.h"
#import "DDMenuController.h"
#import "LeftViewController.h"
#import "UserInfo.h"
#import "CommonFunctionVC.h"

#import "SimplePingHelper.h"//ping

@interface LoginViewController () <MyRequestDelegate,UITextFieldDelegate>
{
    UIView* popView;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    loginButton.layer.cornerRadius = 5;
    loginButton.layer.masksToBounds = YES;
    UIImageView* userImagView = [[UIImageView alloc] init];
    userImagView.frame = CGRectMake(LWidth/2-40, 160, 80, 80);
       userImagView.image = [UIImage imageNamed:@"imagUserIndex"];
    [self.view addSubview:userImagView];
    UIView* userNameView = [[UIView alloc] initWithFrame:CGRectMake(30, 300, LWidth-60, 35)];
    if (IPHONE_5) {
        userNameView.frame=CGRectMake(30, 260, LWidth-60, 35);
    }
    userNameView.backgroundColor = [UIColor whiteColor];
    userNameView.layer.masksToBounds = YES;
    userNameView.layer.cornerRadius = 5;
    [self.view addSubview:userNameView];
    UIImageView* imagN = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7.5, 20, 20)];
    imagN.image = [UIImage imageNamed:@"user_add"];
    [userNameView addSubview:imagN];
    userName = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, userNameView.bounds.size.width-40, 35)];
    userName.font = [UIFont systemFontOfSize:14];
    userName.returnKeyType=UIReturnKeyDone;
    userName.placeholder = @"请输入用户名";
    userName.delegate=self;
    [userNameView addSubview:userName];
    UIView* userPassWordView = [[UIView alloc] initWithFrame:CGRectMake(30, 350, LWidth-60, 35)];
    if (IPHONE_5) {
        userPassWordView.frame=CGRectMake(30, 310, LWidth-60, 35);
    }
    userPassWordView.backgroundColor = [UIColor whiteColor];
    userPassWordView.layer.masksToBounds = YES;
    userPassWordView.layer.cornerRadius = 5;
    [self.view addSubview:userPassWordView];
    UIImageView* imagP = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7.5, 20, 20)];
    imagP.image = [UIImage imageNamed:@"lock"];
    [userPassWordView addSubview:imagP];
    passWork = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, userPassWordView.bounds.size.width-40, 35)];
    passWork.font = [UIFont systemFontOfSize:14];
    passWork.placeholder = @"请输入密码";
    passWork.delegate=self;
    passWork.returnKeyType= UIReturnKeyDone;
      passWork.secureTextEntry=YES;
    [userPassWordView addSubview:passWork];
    
    UIButton* loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 5;
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.frame = CGRectMake(60, 450, LWidth-120, 35);
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [loginBtn setTitle:@"登录" forState:0];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:0];
    loginBtn.backgroundColor = [UIColor colorWithRed:0.16 green:0.59 blue:1 alpha:1];
    [self.view addSubview:loginBtn];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;

}
- (void)login:(id)sender {
    [SimplePingHelper ping:HTTPWIFI target:self sel:@selector(pingResult:)];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)pingResult:(NSNumber*)success {
    if (success.boolValue) {
        NSLog(@"内网链接成功");
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"http"];
        [[NSUserDefaults standardUserDefaults] setObject:HTTPWIFI forKey:@"http"];
        [self requestShowDataList1];
    } else {
        NSLog(@"内网链接失败");
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"http"];
        [[NSUserDefaults standardUserDefaults] setObject:HTTPSIM forKey:@"http"];
        [self requestShowDataList1];
        //[self requestShowDataList2:@""];

    }
}
- (void)requestShowDataList1
{
    [self.view endEditing:YES];
    
    
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/ProxyMobile/GetServerUrl.aspx?PLANTCODE=SLRD",HTTPIP,SLRD]];
    
    NSLog(@"hsdgfhgfhfgh====%@",[NSString stringWithFormat:@"http://%@%@/ProxyMobile/GetServerUrl.aspx?PLANTCODE=SLRD",HTTPIP,SLRD]);
    manager.delegate = self;
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            [self requestShowDataList2:[dictt objectForKey:@"serverUrl"]];
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}
- (void)requestShowDataList2:(NSString *)url
{
    NSString *pass =passWork.text;
    
    NSString *newpasds =[pass stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *user=userName.text;
    NSString *newUsers =[user  stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/ProxyMobile/MobileLogin.aspx?password=%@&userID=%@&phoneIMEI=%@&isLimit=N",HTTPIP,SLRD, newpasds,newUsers,@"1234567890111"]];
    
    
    manager.delegate = self;
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [self successLogin];
            [UserInfo initWithDeleteUserInfo];
            [UserInfo initWithAddUserInfo:dictt];
            [[NSUserDefaults standardUserDefaults] setObject:@"success" forKey:@"login"];
            
            
            NSString *pass =passWork.text;
            
            NSString *newpasds =[pass stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *user=userName.text;
            NSString *newUsers =[user  stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            

            
            //存储cookie
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kUserDefaultsCookie"];
            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@/ProxyMobile/MobileLogin.aspx?password=%@&userID=%@&phoneIMEI=%@&isLimit=N",HTTPIP,SLRD,newpasds,newUsers,@"1234567890111"]]];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"kUserDefaultsCookie"];
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}
#pragma mark ------------------------- 网络环境不可用时的页面
- (void)RequestErrorViewController
{
    [SVProgressHUD dismiss];
    popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LWidth, LHeight-48)];
    popView.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    UIImageView* imag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 160)];
    imag.center = popView.center;
    imag.image = [UIImage imageNamed:@"02e9868d724dae529e06525edbaf024e.png"];
    [popView addSubview:imag];
    [self.view addSubview:popView];
    UITapGestureRecognizer* regiontapGestureT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestShowDataList1)];
    [popView addGestureRecognizer:regiontapGestureT];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)successLogin
{
    UIStoryboard *story1 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Home_Home_ViewController *homeVC = [story1 instantiateViewControllerWithIdentifier:@"Home_Home_ViewController"];
    UIStoryboard *story2 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Home_task_ViewController *taskVC = [story2 instantiateViewControllerWithIdentifier:@"Home_task_ViewController"];
    UIStoryboard *story3 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    Home_Function_ViewController *productionVC = [story3 instantiateViewControllerWithIdentifier:@"Home_Function_ViewController"];
    CommonFunctionVC *productionVC = [story3 instantiateViewControllerWithIdentifier:@"CommonFunctionVC"];
    UIStoryboard *story4 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Home_User_ViewController *userVC = [story4 instantiateViewControllerWithIdentifier:@"Home_User_ViewController"];
    
    UINavigationController * Nav1 = [[UINavigationController alloc] initWithRootViewController:homeVC];
    Nav1.tabBarItem.title = @"首页";
    //    theNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);//纠正图片位置
    [Nav1.tabBarItem setTitlePositionAdjustment:UIOffsetMake(3, -3)];//纠正title位置
    Nav1.tabBarItem.image = [UIImage imageNamed:@"sy_1"];
    Nav1.tabBarItem.selectedImage = [[UIImage imageNamed:@"sy"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController * Nav2 = [[UINavigationController alloc] initWithRootViewController:taskVC];
    Nav2.tabBarItem.title = @"我的事务";
    [Nav2.tabBarItem setTitlePositionAdjustment:UIOffsetMake(3, -3)];//纠正title位置
    Nav2.tabBarItem.image = [UIImage imageNamed:@"sw_1"];
    Nav2.tabBarItem.selectedImage = [[UIImage imageNamed:@"sw"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController * Nav3 = [[UINavigationController alloc] initWithRootViewController:productionVC];
    Nav3.tabBarItem.title = @"常用功能";
    [Nav3.tabBarItem setTitlePositionAdjustment:UIOffsetMake(3, -3)];//纠正title位置
    Nav3.tabBarItem.image = [UIImage imageNamed:@"gl_1"];
    Nav3.tabBarItem.selectedImage = [[UIImage imageNamed:@"gl"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController * Nav4 = [[UINavigationController alloc] initWithRootViewController:userVC];
    Nav4.tabBarItem.title = @"个人中心";
    [Nav4.tabBarItem setTitlePositionAdjustment:UIOffsetMake(3, -3)];//纠正title位置
    Nav4.tabBarItem.image = [UIImage imageNamed:@"gr_1"];
    Nav4.tabBarItem.selectedImage = [[UIImage imageNamed:@"gr"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    AppDelegate *aAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    aAppDelegate.tabBarCtr = [[UITabBarController alloc]init];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0/255.0 green:149/255.0 blue:255/255.0 alpha:1]];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    //        [[UITabBar appearance] setBackgroundImage:[ConFunc createImageWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]
    //                                                                           size:CGSizeMake(LWidth,48)]];//背景，修改颜色是没有用的
    
    
    
    
    aAppDelegate.tabBarCtr.viewControllers = @[Nav1,Nav2,Nav3,Nav4];
    aAppDelegate.tabBarCtr.selectedIndex = 0;
    
    [aAppDelegate.ddMenu showLeftController:YES];
    UIStoryboard *story5 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LeftViewController *leftVC = [story5 instantiateViewControllerWithIdentifier:@"LeftViewController"];
        leftVC.delegate = (id)homeVC;
    leftVC.delegatePush =(id) homeVC;
    leftVC.delegateFunction = (id)productionVC;
    UINavigationController * leftNav = [[UINavigationController alloc] initWithRootViewController:leftVC];
    aAppDelegate.ddMenu = [[DDMenuController alloc] initWithRootViewController:aAppDelegate.tabBarCtr];
    aAppDelegate.ddMenu.leftViewController = leftNav;
    aAppDelegate.window.rootViewController = aAppDelegate.ddMenu;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}

@end
