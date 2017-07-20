//
//  settingViewController.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/20.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "settingViewController.h"
#import "LoginVC.h"
#import "SetTableViewCell.h"
#import "functionController.h"
#import "serverSettingVc.h"
#import "SDImageCache.h"
#import "versionVC.h"
@interface settingViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    NSDictionary *_fromDic;
    NSString *_currentVision;
    NSString *_latestVersion;
    NSDictionary *_xmlDict;
}

@end

@implementation settingViewController
-(id)initWithADic:(NSDictionary *)aDic
{
    self=[super init];
    if (self) {
        _fromDic=aDic;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.title=_fromDic[@"MNAME"];
    [self initTableview];
    
}
-(void)initTableview{
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    [self.myTable registerNib:[UINib nibWithNibName:@"SetTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.myTable.rowHeight=50;
    self.myTable.separatorColor=[UIColor blackColor];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SetTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row==0) {
        cell.title.text=@"功能简介";
        cell.imag.image=[UIImage imageNamed:@"gy"];
        
    }else if (indexPath.row==1){
        cell.title.text=@"服务器设置";
        cell.imag.image=[UIImage imageNamed:@"ss"];
    }else if (indexPath.row==2){
        cell.title.text = @"版本信息";
        cell.imag.image = [UIImage imageNamed:@"bbgx"];
    }else{
        cell.title.text = @"清除缓存";
        cell.imag.image = [UIImage imageNamed:@"content_title_icon_close"];
        }
    return cell;
 }
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            functionController *vc =[[functionController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            serverSettingVc *vc =[[serverSettingVc alloc]init];
            vc.type=0;
            [self.navigationController pushViewController:vc animated:YES];
        }break;
        case 2:{
            versionVC *vc =[[versionVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }break;
        case 3:{
            
            UIAlertController *controler =[UIAlertController alertControllerWithTitle:@"提示" message:@"该操作将会清除软件的缓存数据并且软件将重新启动，确认清除？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm =[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 [[SDImageCache sharedImageCache] clearDisk];
                [FILE_M removeItemAtPath:[CommonTool downloadPath] error:nil];
                [self.myTable reloadData];
                [USER_DEFAULTS removeObjectForKey:@"login"];
                [USER_DEFAULTS removeObjectForKey:@"Code"];
                [USER_DEFAULTS removeObjectForKey:@"YZM"];
                [USER_DEFAULTS removeObjectForKey:@"ERROR"];
                [USER_DEFAULTS removeObjectForKey:@"PASSWORD"];
                [USER_DEFAULTS removeObjectForKey:@"USER_NAME"];
                [USER_DEFAULTS removeObjectForKey:@"XML"];
                [USER_DEFAULTS removeObjectForKey:@"GUID"];
           
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                LoginVC* loginVC = [story instantiateViewControllerWithIdentifier:@"loginVC"];
                APP_WINOW.rootViewController = loginVC;
                }];
            UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
             [controler addAction:confirm];
            [controler addAction:cancel];
            [self presentViewController:controler animated:YES completion:nil];
        }break;
         default:
            break;
    }
   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
            
            
        case 1:{
            
            if ([_xmlDict[@"versionURL"] rangeOfString:FLAG].location!=NSNotFound ) {
                NSString *NEWtitle= [_xmlDict[@"versionURL"] stringByReplacingOccurrencesOfString:FLAG withString:HTTPIP];
                NSString *urlString =[NSString stringWithFormat:@"%@",NEWtitle];
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
                
                
            }
            else{
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_xmlDict[@"versionURL"]]];
                 }
          }break;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)goBack:(UIButton *)sender {
    UIAlertAction* determine = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

        [userDefaults removeObjectForKey:@"login"];
     
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
       LoginVC* loginVC = [story instantiateViewControllerWithIdentifier:@"loginVC"];
        APP_WINOW.rootViewController = loginVC;
    }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"小提示" message:@"是否确认退出当前账号" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    [alert addAction:determine];
    [alert addAction:cancel];
}


@end
