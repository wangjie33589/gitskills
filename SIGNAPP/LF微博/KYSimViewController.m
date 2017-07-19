//
//  KYSimViewController.m
//  科远签到
//
//  Created by sciyonSoft on 16/5/20.
//  Copyright © 2016年 lf. All rights reserved.
//
#define LAT [[NSUserDefaults standardUserDefaults] objectForKey:@"LAT"]
#define LNG [[NSUserDefaults standardUserDefaults] objectForKey:@"LNG"]
#import "KYSimViewController.h"
#import "KYBindingViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
@interface KYSimViewController ()<UITextFieldDelegate>

@end

@implementation KYSimViewController
@synthesize Data,SaveData;



- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    showPswd = [[UILabel alloc] initWithFrame:CGRectMake(15, 400,300, 30)];
    showPswd.font = [UIFont fontWithName:@"Arial" size:13.0f];
    //        showPswd.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:showPswd];
      m_server.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"gonghao"];
    
    
    float originX=15;
    //        float offsetY=120;
    float tfHeight=35;
    
    UILabel * email=[[UILabel alloc] initWithFrame:CGRectMake(originX,80, 200,25)];
    email.text=@"工号";
    [self.view addSubview:email];
    
    m_tfemail=[[UITextField alloc] initWithFrame:CGRectMake(originX, 110, 285, tfHeight)];
    [m_tfemail setBorderStyle:UITextBorderStyleRoundedRect];
    m_tfemail.font = [UIFont fontWithName:@"Arial" size:13.0f];
    m_tfemail.delegate=self;
        m_tfemail.returnKeyType=UIReturnKeyDone;
  
    [self.view addSubview:m_tfemail];
    [m_tfemail becomeFirstResponder];
    
    UILabel * ser=[[UILabel alloc] initWithFrame:CGRectMake(originX,150, 200,25)];
    ser.text=@"再次输入工号";
    [self.view addSubview:ser];
    
    m_server=[[UITextField alloc] initWithFrame:CGRectMake(originX, 180, 285, tfHeight)];
    m_server.returnKeyType=UIReturnKeyDone;
      m_server.delegate=self;
    [m_server setBorderStyle:UITextBorderStyleRoundedRect];
    m_server.font = [UIFont fontWithName:@"Arial" size:13.0f];
    [self.view addSubview:m_server];
    
    UILabel * pw=[[UILabel alloc] initWithFrame:CGRectMake(originX,220, 200,25)];
    pw.text=@"手机序列号";
    [self.view addSubview:pw];
    
    m_tfPw=[[UITextField alloc] initWithFrame:CGRectMake(originX, 250, 285, tfHeight)];
    [m_tfPw setEnabled:NO];
    [m_tfPw setBorderStyle:UITextBorderStyleRoundedRect];
    m_tfPw.font = [UIFont fontWithName:@"Arial" size:13.0f];
    [self.view addSubview:m_tfPw];
    
    UIButton * signIn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [signIn setFrame:CGRectMake(originX,290,50, 50)];
    [signIn setTitle:@"保存" forState:UIControlStateNormal];
    [signIn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signIn];
    
    
    UIButton * signIn1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [signIn1 setFrame:CGRectMake(originX + 100,290,50, 50)];
    [signIn1 setTitle:@"显示" forState:UIControlStateNormal];
    [signIn1 addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signIn1];
    
    UIButton * signIn2=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [signIn2 setFrame:CGRectMake(originX + 200,290,50, 50)];
    [signIn2 setTitle:@"确定" forState:UIControlStateNormal];
    [signIn2 addTarget:self action:@selector(show1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signIn2];

    
    
    NSString* identifierNumber = [[UIDevice currentDevice].identifierForVendor UUIDString] ;
    NSLog(@"手机序列号: %@",identifierNumber);
    NSString *str1= [identifierNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"-------11111------%@",str1);
    m_tfPw.text = [NSString stringWithFormat:@"%@",str1];
    
//    m_tfemail.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"number"];
 
        m_tfemail.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"gonghao"];
 
    NSLog(@"%@----222",[[NSUserDefaults standardUserDefaults]objectForKey:@"gonghao"]);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    //主要是[receiver resignFir2572esponder]在哪调用就能把receiver对应的键盘往下收
    
    
    return YES;
}

- (void)show:(id)sender
{
    NSString * name = [m_tfemail text];
    NSString * server = [m_server text];
    
    NSString * psw = [SFHFKeychainUtils getPasswordForUsername:name andServiceName:server error:nil];
    [showPswd performSelectorOnMainThread:@selector(setText:) withObject:psw waitUntilDone:NO];
    
    if (m_tfPw.text !=nil) {
        m_tfPw.text =@"";
    }

}

- (void)save:(id)sender
{
    NSString * name = [m_tfemail text];
    NSString * pswd = [m_tfPw text];
    NSString * server = [m_server text];
    
    BOOL s = [SFHFKeychainUtils storeUsername:name andPassword:pswd forServiceName:server updateExisting:NO error:nil];
    if (s == YES) {
        NSLog(@"save success");
    }else {
        NSLog(@"save faild");
    }
 
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"pnonumber"]==nil) {
        [[NSUserDefaults standardUserDefaults]setObject:m_tfemail.text forKey:@"pnonumber"];
        
    }
    NSLog(@"asdsdf===%@",m_server.text);

    
   
        NSString *str1 = [NSString stringWithFormat:@"%@",m_tfemail.text];
        NSLog(@"%@---",str1);
        [[NSUserDefaults standardUserDefaults]setObject:str1 forKey:@"gonghao"];

    
    
   
}

- (void)show1:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setValue:showPswd.text forKey:@"phoneudid"];
    

    [self request];
}




- (void)request
{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [dateFormatter stringFromDate:[NSDate date]];
    NSString *string=[NSString stringWithFormat:@"<Data><Action>BIND</Action><SIM>%@</SIM><LNG>%@</LNG><LAT>%@</LAT><BDATE>%@</BDATE><EDATE>%@</EDATE><PNO>%@</PNO></Data>",_phonetext,@" ",@" ",date,date,[[NSUserDefaults standardUserDefaults]objectForKey:@"gonghao"]];
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SIGN_URL] withString:string];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD showErrorWithStatus:@"绑定成功！"];
        if ((NSObject*)[dictt objectForKey:@"ERROR"]==[NSNull null]) {
//            [[NSUserDefaults standardUserDefaults]setObject:@"ok" forKey:@"ok"];
//            [[NSUserDefaults standardUserDefaults]setObject:pnoText.text forKey:@"number"];
            
        }else{
            
            
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"ERROR"]];
            
            return;
        }
        
    };
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
