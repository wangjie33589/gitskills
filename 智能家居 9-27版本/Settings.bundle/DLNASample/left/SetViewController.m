//
//  SetViewController.m
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/14.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "SetViewController.h"
#import "SetTableViewCell.h"
#import "LoginViewController.h"
#import "RelatedViewController.h"
#import "PassWordViewController.h"
#import "GesturesViewController.h"



@interface SetViewController () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    BOOL isPush;
    NSDictionary *xmlDict;
}
@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统设置";
    isPush = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1];
    
    goBackButton.layer.masksToBounds = YES;
    goBackButton.layer.cornerRadius = 3;
    
    set_tableview.delegate = self;
    set_tableview.dataSource = self;
    set_tableview.sectionHeaderHeight = 20.0f;
    set_tableview.backgroundColor = [UIColor clearColor];
    [set_tableview setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if (isPush) {
        [[App ddMenu] showLeftController:YES];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    isPush = YES;
}
- (void)go_back
{
    [[App ddMenu] showLeftController:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ------- 表代理
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    区头View
    UIView* sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    sectionView.backgroundColor = [UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1];
    return sectionView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==1?3:2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    SetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SetTableViewCell" owner:nil options:nil];
        for (id oneObject in nib)
        {
            if ([oneObject isKindOfClass:[SetTableViewCell class]])
            {
                cell = (SetTableViewCell *)oneObject;
            }
        }
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.title.text = @"修改密码";
            cell.imag.image = [UIImage imageNamed:@"xgmm"];
        }else if (indexPath.row == 1) {
            cell.title.text = @"手势";
            cell.imag.image = [UIImage imageNamed:@"ss"];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.title.text = @"版本更新";
            cell.imag.image = [UIImage imageNamed:@"bbgx"];
        }else if (indexPath.row == 2) {
            cell.title.text = @"关于";
            cell.imag.image = [UIImage imageNamed:@"gy"];
        }else if(indexPath.row==1){
            cell.title.text = @"二维码";
            cell.imag.image = [UIImage imageNamed:@"IOSNW"];

        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.rowHeight = 50;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    isPush = NO;
//    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            PassWordViewController* relatedVC = [story instantiateViewControllerWithIdentifier:@"PassWordViewController"];
//            [self.navigationController pushViewController:relatedVC animated:YES];
//        }else if (indexPath.row == 1) {
//            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            GesturesViewController* gesturesVC = [story instantiateViewControllerWithIdentifier:@"GesturesViewController"];
//            [self.navigationController pushViewController:gesturesVC animated:YES];
//        }
//    }else if (indexPath.section == 1) {
//        if (indexPath.row == 2) {
//            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            RelatedViewController* relatedVC = [story instantiateViewControllerWithIdentifier:@"RelatedViewController"];
//            [self.navigationController pushViewController:relatedVC animated:YES];
//        }else if (indexPath.row==1){
//        
//            
//        }
//        
//        else if(indexPath.row==0){
//            NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@/proxymobile/getiosversion.xml",HTTPIP,SLRD]]];
//
//            NSData *reponse =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//        xmlDict =[NSDictionary dictionaryWithXMLData:reponse];
//            NSLog(@"xumDATA=%@",xmlDict);
//            
//            NSString * latestVersion =xmlDict[@"versionCode"];
//                        NSDictionary *infoDict =[[NSBundle mainBundle]infoDictionary];
//            NSLog(@"VIESSS=%@",[infoDict objectForKey:@"CFBundleVersion"]);
//            NSString * currentVision=[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"];
//            if ([currentVision intValue]<[latestVersion intValue]) {
//                
//                UIAlertView *alert =[[UIAlertView alloc]initWithTitle:xmlDict[@"versionName"]  message:xmlDict[@"versionDescription"] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"升级", nil];
//                alert.delegate=self;
//                [alert show];
//            }
//            
//            else{
//                                UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示"  message:@"暂无新版本" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//                    [alert show];
//                }
//            
//        
//        }
//    }
//    
//}
//
//
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    switch (buttonIndex) {
//            
//            
//        case 1:{
//            
//            
//            
//            
//            
//            
//
//            if ([xmlDict[@"versionURL"] rangeOfString:FLAG].location!=NSNotFound ) {
//                NSString *NEWtitle= [xmlDict[@"versionURL"] stringByReplacingOccurrencesOfString:FLAG withString:HTTPIP];
//                
//                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:NEWtitle]];
//                
//                
//            }
//            
//                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:xmlDict[@"versionURL"]]];

//            
//        }break;
//    }

}


- (IBAction)go_back:(id)sender {
    UIAlertAction* determine = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"passwork"];
        [userDefaults removeObjectForKey:@"login"];
        //[UserInfo initWithDeleteUserInfo];
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
@end
