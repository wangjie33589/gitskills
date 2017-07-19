//
//  KYBindingViewController.m
//  科远签到
//
//  Created by sciyonSoft on 16/5/18.
//  Copyright © 2016年 lf. All rights reserved.
//

#define LAT [[NSUserDefaults standardUserDefaults] objectForKey:@"LAT"]
#define LNG [[NSUserDefaults standardUserDefaults] objectForKey:@"LNG"]
#import "KYBindingViewController.h"
#import <UIKit/UIKit.h>
#import "MyRequest.h"
#import "ASIHTTPRequest.h"
#import "SVProgressHUD.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "CommonTool.h"
#import "UIImageView+WebCache.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface KYBindingViewController ()<UITextFieldDelegate>
{
    CTTelephonyNetworkInfo *netWorkinfo;
    NSDictionary * _chatInfoDic;
}
@property(nonatomic,strong)NSString *btimetext;
@property(nonatomic,strong)NSString *etimetext;
@property(nonatomic,strong)NSString *lattext;
@property(nonatomic,strong)NSString *lngtext;
@property(nonatomic,strong)NSString *pnotext;

//@property (strong, nonatomic) IBOutlet UILabel *phonetext;
@end

@implementation KYBindingViewController

@synthesize Data,SaveData;
- (IBAction)savePnoBtn:(UIButton *)sender {
    
//    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"number"]==nil) {
//        [[NSUserDefaults standardUserDefaults]setObject:pnoText.text forKey:@"number"];
//        
//    }
//    [self request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    pnoText.delegate = self;
//    pnoText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//    pnoText.returnKeyType =UIReturnKeyDone;
//    
//    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"number"]!=nil) {
//        pnoText.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"number"];
//    }

 }

- (void)request
{
    //    NSDate *date =[NSDate date];
    
    NSString *string=[NSString stringWithFormat:@"<Data><Action>BIND</Action><SIM>%@</SIM><LNG>%@</LNG><LAT>%@</LAT><BDATE>%@</BDATE><EDATE>%@</EDATE><PNO>%@</PNO></Data>",_phonetext,_lngtext,_lattext,_btimetext,_etimetext,[[NSUserDefaults standardUserDefaults]objectForKey:@"number"]];
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SIGN_URL] withString:string];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD showErrorWithStatus:@"绑定成功！"];
        if ((NSObject*)[dictt objectForKey:@"ERROR"]==[NSNull null]) {
            [[NSUserDefaults standardUserDefaults]setObject:@"ok" forKey:@"ok"];
            [[NSUserDefaults standardUserDefaults]setObject:pnoText.text forKey:@"number"];
            [CommonTool saveCooiker];
        }else{
            
            
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"ERROR"]];
            
            return;
        }
        
    };
}

@end
