//
//  LoginVC.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/4.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "LoginVC.h"
#import "home_ViewController.h"
#import "serverSettingVc.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#import <CoreTelephony/CTCarrier.h>
@interface LoginVC ()<MyRequestDelegate,UITextFieldDelegate>{
    UITextField *paswwordTXT;
    UITextField *YZMtxt;
    UITextField *Userfield;
    CTTelephonyNetworkInfo *netWorkinfo;
    UIButton *YZMbtn;
    NSTimer *timer;
    int i;
    BOOL isClick;
    UIButton *remanberBtn;
    BOOL isRemanber;
    serverSettingVc *setvc;
    BOOL issuccess;
    UILabel *_lab;
    UILabel *_tobLab;

}

@end




@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
    i=60;
    isClick =YES;
    issuccess=NO;
    
    isRemanber=[[NSUserDefaults standardUserDefaults]objectForKey:@"isranmber"];

    
    netWorkinfo=[[CTTelephonyNetworkInfo alloc]init];
    netWorkinfo.subscriberCellularProviderDidUpdateNotifier=^(CTCarrier *carrier){

        [SVProgressHUD showErrorWithStatus:@"SIM卡以更换"];
    };
    CTCarrier *carrier =netWorkinfo.subscriberCellularProvider;
    
    [[NSUserDefaults standardUserDefaults]setObject:carrier.mobileNetworkCode forKey:@"Code"];
    //carrier.isoCountryCode carrierName mobileCountryCode  isoCountryCode isoCountryCode
    
    NSLog(@"SIM卡＝＝＝%@===%@===%@==%@===%@＝＝%@",SIM_CODE,carrier.isoCountryCode,carrier.carrierName,carrier.mobileCountryCode,carrier.isoCountryCode,carrier.mobileCountryCode);
    
    NSLog(@"adhsfghjsd==%@",carrier.mobileNetworkCode);
        UIView *view =[[UIView alloc]initWithFrame:CGRectMake(LWIDTH/2-130,240, 260, 35)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
_tobLab =[[UILabel alloc]initWithFrame:CGRectMake(0, 10, LWIDTH-10, 30)];
    _tobLab.backgroundColor=[UIColor clearColor];
   
    _tobLab.font=[UIFont systemFontOfSize:12];
    _tobLab.textColor=[UIColor whiteColor];

    
    _tobLab.textAlignment=NSTextAlignmentRight;
    [self.view addSubview:_tobLab];
    [self.view addSubview:_tobLab];
    
    _lab =[[UILabel alloc]initWithFrame:CGRectMake(0, 130, LWIDTH, 40)];
    _lab.backgroundColor=[UIColor clearColor];
    _lab.font=[UIFont systemFontOfSize:25];

    _lab.textColor=[UIColor whiteColor];
    _lab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_lab];
    
        
    UIImageView *iView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 35)];
    iView.image=[UIImage imageNamed:@"user"];
    [view addSubview:iView];
    Userfield =[[UITextField alloc]initWithFrame:CGRectMake(45, 0, 260-40, 35)];
   Userfield.placeholder=@"请输入用户名";
    Userfield.returnKeyType=UIReturnKeyDone;
    Userfield.delegate=self;
    [view addSubview:Userfield];
    
    UIView *passwordView  =[[UIView alloc]initWithFrame:CGRectMake(LWIDTH/2-130, 240+35+10, 260, 35)];
    UIImageView *imgview =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,40,35)];
    imgview.image=[UIImage imageNamed:@"xgmm"];
    [self.view addSubview:passwordView];
    paswwordTXT =[[UITextField alloc]initWithFrame:CGRectMake(45, 0, 260, 35)];
    paswwordTXT.delegate=self;
    paswwordTXT.secureTextEntry=YES;
    paswwordTXT.returnKeyType=UIReturnKeyDone;
    [passwordView addSubview:imgview];
    paswwordTXT.placeholder=@"请输入密码";
 
    passwordView.backgroundColor=[UIColor whiteColor];
    [passwordView addSubview:paswwordTXT];
    UIView *YZMView =[[UIView  alloc]initWithFrame:CGRectMake(LWIDTH/2-130, 240+35+35+10+10, 120, 35)];
    YZMView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:YZMView];
 YZMtxt =[[UITextField alloc]initWithFrame:CGRectMake(0, 0, 120, 35)];
    [YZMView addSubview:YZMtxt];

YZMbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    YZMtxt.placeholder=@"请输入验证码";
    YZMtxt.delegate=self;
    YZMtxt.returnKeyType=UIReturnKeyDone;
    
    
    YZMbtn.frame=CGRectMake(YZMView.frame.origin.x+130, YZMView.frame.origin.y, 260-130, 35);
    [YZMbtn setBackgroundColor:[UIColor whiteColor]];
    [YZMbtn setTitleColor:[UIColor blackColor] forState:0];
    YZMbtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [YZMbtn setTitle:@"获取验证码" forState:0];
    [YZMbtn addTarget:self action:@selector(requestToGetYZM) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:YZMbtn];
    
    
remanberBtn=[UIButton buttonWithType:UIButtonTypeCustom];

    remanberBtn.frame=CGRectMake(YZMView.frame.origin.x,YZMView.frame.origin.y+35+15, 30, 30);
    [remanberBtn addTarget:self action:@selector(remanber) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:remanberBtn];
       UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(remanberBtn.frame.origin.x +40, remanberBtn.frame.origin.y,80 , 40)];
    label.textColor=[UIColor blackColor];
    label.text=@"记住密码";
    [self.view addSubview:label];
    
    UIButton *loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame=CGRectMake(remanberBtn.frame.origin.x, remanberBtn.frame.origin.y+50, 260, 35) ;
    loginBtn.backgroundColor=[UIColor blueColor];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:0];
    [loginBtn setTitle:@"登 录" forState:0];
    [loginBtn addTarget:self action:@selector(loginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [self remanberUsernameAndPassword];
    
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self requestTitle];
    if (HTTPIP==nil) {
         [[NSUserDefaults standardUserDefaults]setObject:@"http://221.226.212.74:20085/demo" forKey:@"ip"];
    }
   
    



}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
      [textField resignFirstResponder];
    
    if (textField==paswwordTXT) {
        if ([textField.text isEqualToString:@""]) {
            
        }
        
        
        
    }
    
    return YES;



}




-(void)remanberUsernameAndPassword{
    
   NSInteger Tag =[[NSUserDefaults standardUserDefaults]integerForKey:@"isranmber"];
    
    if (Tag==0) {
        [remanberBtn setBackgroundImage:[UIImage imageNamed:@"home_write_caogao"] forState:0];
        Userfield.text=@"";
        paswwordTXT.text=@"";

        
    }else{
        [remanberBtn setBackgroundImage:[UIImage imageNamed:@"home_write_caogao_1"] forState:0];
               Userfield.text=USER_NAME;
        paswwordTXT.text=PASSWORD;
        
    }



}
-(void)remanber{
    isRemanber=!isRemanber;
    
    [[NSUserDefaults standardUserDefaults]setInteger:isRemanber forKey:@"isranmber"];
    if (isRemanber==NO) {
        [remanberBtn setBackgroundImage:[UIImage imageNamed:@"home_write_caogao"] forState:0];
        
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:paswwordTXT.text forKey:@"PASSWORD"];
        [[NSUserDefaults standardUserDefaults]setObject:Userfield.text forKey:@"USER_NAME"];

        [remanberBtn setBackgroundImage:[UIImage imageNamed:@"home_write_caogao_1"] forState:0];
        
    }
}


-(void)requestTitle{


    NSString *string =@"<Data><Action>GETTITLE</Action></Data>";
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:string];
    
    NSLog(@"ads===%@",[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL]);
    manger.backSuccess=^void(NSDictionary *dictt){
        
        if ((NSObject*)[dictt objectForKey:@"ERROR"]==[NSNull null]) {
            _lab.text=dictt[@"CUSTOMERINFO"];
            _tobLab.text=dictt[@"CUSTOMERINFO1"];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"ERROR"]];
            return;
        }
        
    };







}

-(void)requestToGetYZM{
    
    
    if ([Userfield.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"用户名不能为空"];
        
        return;
        
    }
    if ([paswwordTXT.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
            timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(second_1) userInfo:nil repeats:YES];
        YZMbtn.userInteractionEnabled=NO;
        YZMbtn.alpha=0.5;
    
         NSString *string =[NSString stringWithFormat:@"<Data><Action>GETVTCODE</Action><USERID>%@</USERID><PWD>%@</PWD><SIM>%@</SIM></Data>",Userfield.text,paswwordTXT.text,SIM_CODE];

       MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:string];
       manger.backSuccess=^void(NSDictionary *dictt){
                  if ((NSObject*)[dictt objectForKey:@"ERROR"]==[NSNull null]) {
           [[NSUserDefaults standardUserDefaults]setObject:dictt[@"CUSTOMERINFO"] forKey:@"YZM"];
           
       }else{
           NSLog(@"11111%@",[dictt objectForKey:@"CUSTOMERINFO"]);
           [timer invalidate];
           timer=nil;
           
             YZMbtn.userInteractionEnabled=YES;
             YZMbtn.alpha=1;
            [YZMbtn setTitle:@"获取验证码" forState:0];
        [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"ERROR"]];
          }
       
    };


}
-(void)second_1{
    i=i-1;
        [YZMbtn setTitle:[NSString stringWithFormat:@"%d秒后重新获取",i] forState:0];
    if (i==0) {
     [timer invalidate];
        timer=nil;
        i =60;
        
               YZMbtn.userInteractionEnabled=YES;
        YZMbtn.alpha=1;
      
        [YZMbtn setTitle:@"获取验证码" forState:0];
    }
    



}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loginBtn:(UIButton *)sender {
    
    
    if ([Userfield.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"用户名不能为空"];
        
        return;
        
    }
    if ([paswwordTXT.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
      //[SVProgressHUD showWithStatus:@"正在登录。。。"];
    
    NSString *string =[NSString stringWithFormat:@"<Data><Action>LOGIN</Action><USERID>%@</USERID><PWD>%@</PWD><TIME>%d</TIME><SIM>%@</SIM><VTCODE>%@</VTCODE></Data>",Userfield.text,paswwordTXT.text,i,SIM_CODE,YZMtxt.text];
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:string];
    
    NSLog(@"ads===%@",[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL]);
    manger.backSuccess=^void(NSDictionary *dictt){
        
        if ((NSObject*)[dictt objectForKey:@"ERROR"]==[NSNull null]) {
             [[NSUserDefaults standardUserDefaults] setObject:@"SUCCESS" forKey:@"login"];
            
            [[NSUserDefaults standardUserDefaults]setObject:paswwordTXT.text forKey:@"PASSWORD"];
            [[NSUserDefaults standardUserDefaults]setObject:Userfield.text forKey:@"USER_NAME"];
            [[NSUserDefaults standardUserDefaults]setObject:dictt[@"XML"] forKey:@"XML"];
            [[NSUserDefaults standardUserDefaults]setObject:dictt[@"GUID"] forKey:@"GUID"];
            issuccess=YES;
            [CommonTool saveCooiker];
            
            [CommonTool GoToHome];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"ERROR"]];
            return;
        }
  
    };
//    if (issuccess==NO) {
//        [SVProgressHUD showErrorWithStatus:@"登陆失败，请修改登陆地址重试。。。"] ;
//
//    }
    
}

    
    

-(void)requestToLogin :(NSString*)string{
    
    
        NSString *  xmlString=[NSString stringWithFormat:@"<Data><Action>LOGIN</Action><USERID>%@</USERID><PWD>%@</PWD><SIM>%@</SIM><TIME>%d</TIME><VTCODE>%@</VTCODE></Data>",Userfield.text,paswwordTXT.text,SIM_CODE,i,YZM];
        

  
        MyRequest * mamger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlString];
    
    mamger.delegate=self;
    mamger.backSuccess=^void(NSDictionary *dictt){
        if ([[dictt objectForKey:@"ERROR"] rangeOfString:@"null"].location!=NSNotFound ) {
            
            if ([string isEqualToString:@"不需要"]) {
                
        
                [CommonTool GoToHome];
            }else{
                
                if ([[dictt objectForKey:@"CUSTOMERINFO"] isEqualToString:YZM]) {
                    [CommonTool GoToHome];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"验证码有误。。。"];
                    
                }
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"ERROR"]];
        }
        
        
        
        
        
        
        
    };
    




}


- (IBAction)changeServerBtn:(UIButton *)sender {
    serverSettingVc *vc =[[serverSettingVc alloc]init];
    vc.type=1;
    [self presentViewController:vc animated:YES completion:nil];
    
    
}
@end
