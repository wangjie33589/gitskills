//
//  LeftViewController.m
//  Proxy_ios
//
//  Created by E-Bans on 15/11/13.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "LeftViewController.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
#import "LeftTableViewCell.h"
#import "SetViewController.h"
#import "MJRefresh.h"

@interface LeftViewController () <UITableViewDataSource,UITableViewDelegate>
{
//    UIView* popView;
    NSDictionary * _myDic;
}

@end

@implementation LeftViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    userName.text = USERNAME;
    userTask.text = USERTASK;
    [self initView];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
}
//请求登录用户信息
- (void)request{
    NSLog(@"%@--%@--%@",HTTPIP,USER_ID,SERVERID);
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10214\",\"userid\":\"%@\",\"serverid\":\"%@\"}",USER_ID,SERVERID];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            if (![dictt[@"DATA"] isKindOfClass:[NSNull class]]) {
                //                  NSLog(@"用户信息为==%@",dictt[@"DATA"]);
                
                
                _myDic=dictt[@"DATA"];
                
                                if (![_myDic[@"userimg"] isKindOfClass:[NSNull class]]) {
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userimg"];
                    [[NSUserDefaults standardUserDefaults] setObject:_myDic[@"userimg"] forKey:@"userimg"];
                    [userImag sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@%@",HTTPIP,IMAGE_URL,USERIMG]] placeholderImage:[UIImage imageNamed:@"user_role_mng_bookroom_on"]];

                    
                    NSLog(@"httpo====%@",[NSString stringWithFormat:@"http://%@%@%@",HTTPIP,IMAGE_URL,USERIMG]);
                    
                    
                }
                           }
        }
    };
    
}

- (void)initView
{
    self.navigationController.navigationBar.hidden = YES;
    userImag.layer.masksToBounds = YES;
    userImag.layer.cornerRadius = userImag.frame.size.width/2;
    userImag.layer.borderColor = [[UIColor whiteColor] CGColor];
    userImag.layer.borderWidth = 1.5f;
    
//    [[SDImageCache sharedImageCache] clearDisk];
//    [[SDImageCache sharedImageCache] clearMemory];
//     [userImag sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@%@",HTTPIP,IMAGE_URL,USERIMG]] placeholderImage:[UIImage imageNamed:@"user_role_mng_bookroom_on"]];
    userName.text = USERNAME;
    userTask.text = USERTASK;
    list_tableView.delegate = self;
    list_tableView.dataSource = self;
    list_tableView.rowHeight =60;
    list_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [list_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

[list_tableView registerNib:[UINib nibWithNibName:@"LeftTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
   
    [self requestShowDataList];
    
    UIButton* setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame = CGRectMake(0, LHeight-49, ([UIScreen mainScreen].bounds.size.width-130)/2, 49);
    [setButton setTitle:@"   设置" forState:0];
    setButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [setButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] forState:0];
    [setButton addTarget:self action:@selector(setButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setButton];
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-130)/2, LHeight-49, ([UIScreen mainScreen].bounds.size.width-130)/2, 49);
    [backButton setTitle:@"   退出" forState:0];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [backButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] forState:0];
    [backButton addTarget:self action:@selector(go_back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIImageView* setImag = [[UIImageView alloc] initWithFrame:CGRectMake(IPHONE_5?10:25, 15, 20, 20)];
    setImag.image = [UIImage imageNamed:@"top_icon_set"];
    [setButton addSubview:setImag];
    
    UIImageView* backImag = [[UIImageView alloc] initWithFrame:CGRectMake(IPHONE_5?10:25, 15, 20, 20)];
    backImag.image = [UIImage imageNamed:@"end"];
    [backButton addSubview:backImag];
    [self request];
    
    
}

- (void)requestShowDataList
{
    NSLog(@"requestShowDataList");


}



- (void)go_back:(UIButton *)sender {
    UIAlertAction* determine = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"passwork"];
        [userDefaults removeObjectForKey:@"login"];

        //发送通知  sendMessage表示通知详情 array表示传输数据
        NSArray *array1 = [[NSArray alloc]initWithObjects:@"SignOut", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SignOutMessage" object:array1];
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController* loginVC = [story instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [App window].rootViewController = loginVC;
        
     
    }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"小提示" message:@"是否确认退出当前账号" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    [alert addAction:determine];
    [alert addAction:cancel];
}

- (void)setButtonClick:(UIButton *)sender {
    [[App ddMenu] showRootController:NO];
    [App tabBarCtr].selectedIndex = 0;
    if ([self.delegate respondsToSelector:@selector(pushSetViewController)]) {
        [self.delegate pushSetViewController];
    }
}
#pragma mark ------- 表代理
                                                                                                                                                                                                                                                                                

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int roleserverid= [SERVERIDSTR intValue];
    
//    NSLog(@"SERVERIDSTR --%d--%@",roleserverid,SERVERIDSTR );
    return roleserverid;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    ;
    cell.textLabel.text= @"默认网关";
    cell.imageView.image = [UIImage imageNamed:@"user_user_mng_online"];

    return cell;
}

@end
