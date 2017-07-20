//
//  authorVC.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/3/22.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "authorVC.h"

@interface authorVC ()<UITextFieldDelegate>{

    int i;
    NSTimer *timer;
    NSDictionary *_fromDic;
   NSDictionary *  _XMLDic;
    NSArray *_showArray;
    int type;
    UIView  *pView;
    UIDatePicker *datePicker;
}
@end

@implementation authorVC
-(id)initWithDic:(NSDictionary *)dic{
    self=[super init];
    if (self) {
        _fromDic=dic;
        
        NSLog(@"_dromdic=======%@",_fromDic);
        
    }
    
    
    return self;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    i=60;
    self.title=@"在线授权";
    type=0;
    self.pwdText.delegate=self;
    self.yzmTxt.delegate=self;
  
    self.pwdText.returnKeyType= UIReturnKeyDone;
    
    NSDateFormatter *formarter =[[NSDateFormatter alloc]init];
    [formarter setDateFormat:@"yyyy-MM-dd"];
 

    [self.dateTxt setTitle: [formarter stringFromDate:[NSDate date]] forState:0];
    
    
       [self initDataPicker];
   
    self.yzmTxt.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    self.yzmTxt.returnKeyType=UIReturnKeyDone;
    self.pwdText.secureTextEntry=YES;
}
- (IBAction)dataBtnClick:(UIButton *)sender {
    [UIView animateWithDuration:0.25 animations:^{
        pView.frame = CGRectMake(0, LHIGHT-255, LWIDTH, 190);
    }];

}


-(void)initDataPicker{
    pView = [[UIView alloc] initWithFrame:CGRectMake(0, LHIGHT, LWIDTH, 190)];
    pView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pView];
    

    //    取消按钮
    UIButton* returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(10, 0, 50, 30);
    returnBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [returnBtn setTitle:@"取消" forState:0];
    [returnBtn setTitleColor:[UIColor colorWithRed:0.000 green:0.800 blue:0.600 alpha:1] forState:0];
    [returnBtn addTarget:self action:@selector(returnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [pView addSubview:returnBtn];
    
    //    确定按钮
    UIButton* endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    endBtn.frame = CGRectMake(LWIDTH-60, 0, 50, 30);
    endBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [endBtn setTitle:@"完成" forState:0];
    [endBtn setTitleColor:[UIColor colorWithRed:0.000 green:0.800 blue:0.600 alpha:1] forState:0];
    [endBtn addTarget:self action:@selector(endBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [pView addSubview:endBtn];
    
    //    横线
    UIImageView* bgimagViewA = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
    bgimagViewA.frame = CGRectMake(0, 0, LWIDTH, 2);
    [pView addSubview:bgimagViewA];
    UIImageView* bgimagViewB = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
    bgimagViewB.frame = CGRectMake(0, 28, LWIDTH, 2);
    [pView addSubview:bgimagViewB];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, LWIDTH, 160)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    datePicker.minuteInterval = 5;
    datePicker.backgroundColor = [UIColor whiteColor];
    [pView addSubview:datePicker];



}
- (void)returnBtnClick:(UIButton *)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        pView.frame = CGRectMake(0,LHIGHT,LWIDTH, 190);
    }];
}
- (void)endBtnClick:(UIButton *)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        pView.frame = CGRectMake(0, LHIGHT, LWIDTH, 190);
    }];
    NSDate *select = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
    [self.dateTxt  setTitle:dateAndTime forState:0];
 
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
[textField resignFirstResponder];
return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}


- (IBAction)changeLeftOrRight:(UIButton *)sender {
    UIAlertController *controler =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action =[UIAlertAction actionWithTitle:@"左笼" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.changeBtn setTitle:@"左笼" forState:0];
        type=0;
        
    }];
    UIAlertAction *rightAction =[UIAlertAction actionWithTitle:@"右笼" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
               [self.changeBtn setTitle:@"右笼" forState:0];
        type=1;
        
    }];
    [controler addAction:action];
    [controler addAction:rightAction];
    [self presentViewController:controler animated:YES completion:nil];
    
    
}

- (IBAction)autorBtnCilck:(id)sender {
   
    [self requestControlData];
    
    
    
}
-(void)second_1{
    i=i-1;

    [self.yzmBtn setTitle:[NSString stringWithFormat:@"(%d)秒后重新获取",i] forState:0];
    if (i==0) {
        [timer invalidate];
        timer=nil;
    
       self.yzmBtn.userInteractionEnabled=YES;
        self.yzmBtn.alpha=1;
        //isClick=!isClick;
        i=60;
        [self.yzmBtn setTitle:@"获取验证码" forState:0];
    }

}

- (IBAction)yzmBtnClick:(id)sender {
    
       [self requestYzm];
}





-(void)requestYzm{
    
      if ([self.pwdText.text  isEqual:@""]) {
        [SVProgressHUD showErrorWithStatus:@"登陆密码不能为空"];
        return;
    }

    self.yzmBtn.userInteractionEnabled=NO;
    self.yzmBtn.alpha=0.5;
    
    timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(second_1) userInfo:nil repeats:YES];
   self.yzmBtn.userInteractionEnabled=NO;
    self.yzmBtn.alpha=0.5;


        NSString *string =[NSString stringWithFormat:@"<Data><Action>GETVTCODE</Action><USERID>%@</USERID><PWD>%@</PWD><SIM>%@</SIM></Data>",USER_NAME,self.pwdText.text,SIM_CODE];
        MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:string];
        manger.backSuccess=^void(NSDictionary *dictt){
            
            
            if ((NSObject*)[dictt objectForKey:@"ERROR"]==[NSNull null]) {
                [[NSUserDefaults standardUserDefaults]setObject:dictt[@"CUSTOMERINFO"] forKey:@"YZM"];
                
            }else{
                NSLog(@"11111%@",[dictt objectForKey:@"CUSTOMERINFO"]);
                [timer invalidate];
                self.yzmBtn.userInteractionEnabled=YES;
                self.yzmBtn.alpha=1;
                [self.yzmBtn setTitle:@"获取验证码" forState:0];
                timer=nil;
                [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"ERROR"]];
            }
            
};

}

-(void)requestControlData{
    NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETDEVICECTLS</Action><USERID>%@</USERID><PWD>%@</PWD><DGUID>%@</DGUID></Data>",USER_NAME,PASSWORD,_fromDic[@"DGUID"]];
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlString];
    manger.backSuccess=^void(NSDictionary *dictt){
        
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            _XMLDic=[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            _showArray=_XMLDic[@"R"];
            [CommonTool saveCooiker];
            NSLog(@"_showarray=======%@",_showArray);
            [self autorequestwitharr:_showArray];
        }else{
            
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
    };
}



-(void)autorequestwitharr:(NSArray*)array{


   
      if ([self.pwdText.text  isEqual:@""]) {
        [SVProgressHUD showErrorWithStatus:@"登陆密码不能为空"];
        return;
    }
   [SVProgressHUD showWithStatus:@"正在授权..."];

    NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>EXECMD</Action><USERID>%@</USERID><PWD>%@</PWD><TIME>%d</TIME><SIM>%@</SIM><VTCODE>%@</VTCODE><DGUID>%@</DGUID><DCGUID>%@</DCGUID><CMDCODE>AUONLINE</CMDCODE><CMDPARA><AUDATE>%@</AUDATE></CMDPARA></Data>",USER_NAME,self.pwdText.text,i-1,SIM_CODE,self.yzmTxt.text,_showArray[type][@"DGUID"],_showArray[type][@"DCGUID"],self.dateTxt.titleLabel.text];
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlString];
    manger.backSuccess=^void(NSDictionary *dictt){
        //[SVProgressHUD dismiss];
                if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            [SVProgressHUD showSuccessWithStatus:@"授权成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
      };
}


@end
