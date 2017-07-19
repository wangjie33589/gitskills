//
//  KYDataViewController.m
//  科远签到
//
//  Created by sciyonSoft on 16/5/12.
//  Copyright © 2016年 lf. All rights reserved.
//

#import "KYDataViewController.h"

#import "STPickerArea.h"
#import "STPickerSingle.h"
#import "STPickerDate.h"
#import "STPickerEndDate.h"

#import "MyRequest.h"
#import "ASIHTTPRequest.h"
#import "SVProgressHUD.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "CommonTool.h"
#import "MBProgressHUD+MJ.h"
#import "KYDetailTableViewController.h"
@interface KYDataViewController ()<UITextFieldDelegate,  STPickerDateDelegate,STPickerEndDateDelegate>
{
    CTTelephonyNetworkInfo *netWorkinfo;

}

@property (weak, nonatomic) IBOutlet UITextField *textDate;
@property (weak, nonatomic) IBOutlet UITextField *textEndDate;

@end

@implementation KYDataViewController

#pragma mark - --- lift cycle 生命周期 ---
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.textDate.delegate = self;
    self.textEndDate.delegate = self;
//    Bdatefield.delegate = self;
//    Edatefield.delegate = self;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}


#pragma mark - --- delegate 视图委托 ---

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.textDate) {
        [self.textDate resignFirstResponder];
        
        STPickerDate *pickerDate = [[STPickerDate alloc]init];
        [pickerDate setDelegate:self];
        [pickerDate show];
    }
    
    if (textField == self.textEndDate) {
        [self.textEndDate resignFirstResponder];
        STPickerEndDate *pickerEndDate = [[STPickerEndDate alloc]init];
        [pickerEndDate setDelegate:self];
        [pickerEndDate show];
    }
}
    
    
- (void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSString *text = [NSString stringWithFormat:@"%ld-%ld-%ld", year,month,day];
    self.textDate.text = text;
     NSLog(@"111%@",text);
    [[NSUserDefaults standardUserDefaults]setValue:text forKey:@"BeginTime"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
    
    
- (void)pickerEndDate:(STPickerEndDate *)pickerEndDate years:(NSInteger)years months:(NSInteger)months days:(NSInteger)days
{
    NSString *text = [NSString stringWithFormat:@"%ld-%ld-%ld", years, months, days];
    self.textEndDate.text = text;
    [[NSUserDefaults standardUserDefaults]setValue:text forKey:@"EndTime"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}



- (IBAction)Searchbtn:(UIBarButtonItem *)sender {
    if ([_textDate.text isEqual:@""]||[_textEndDate.text isEqual:@""]) {
        [MBProgressHUD showMessage:@"请输入开始日期和结束日期"];
        // 模拟网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 移除遮盖
            [MBProgressHUD hideHUD];
        });
        

    }else
    {
                KYDetailTableViewController *Vc = [[KYDetailTableViewController alloc]init];
                [self.navigationController pushViewController:Vc animated:YES];
    }
    
}







//    /***********NSUserDefaults传值****************/
//    [[NSUserDefaults standardUserDefaults]setValue:text forKey:@"BeginTime"];
//    [[NSUserDefaults standardUserDefaults]setValue:self.textEndDate.text forKey:@"EndTime"];
//    //将缓存中的数据强制写入磁盘
//    [[NSUserDefaults standardUserDefaults]synchronize];


@end