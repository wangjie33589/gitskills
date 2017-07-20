//
//  ForgetPwdViewController.m
//  SmartHome
//
//  Created by sciyonSoft on 16/7/21.
//
//

#import "ForgetPwdViewController.h"
#import "LoginViewController.h"
#import "HClActionSheet.h"
#import "MyMD5.h"
@interface ForgetPwdViewController ()<UITextFieldDelegate>{
    UILabel *Question;
}


@end

@implementation ForgetPwdViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    self.navigationItem.title = @"忘记密码";
    NSArray *imagNameArray =[[NSArray alloc]initWithObjects:@"new_user",@"key",@"unlock",@"password",@"password", nil];
    NSArray *placeHoderArray =[[NSArray alloc ]initWithObjects:@"请输入账号",@"",@"请输入您的答案",@"输入新密码",@"确认新密码", nil];
    UIButton *goBackBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    goBackBtn.frame=CGRectMake(18, 23, 30, 20);
    [goBackBtn setBackgroundImage:[UIImage imageNamed:@"goback"] forState:0];
    [goBackBtn addTarget:self action:@selector(BackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBackBtn];
    UILabel *Toplabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 5, LWidth, 55)];
    Toplabel.textColor=[UIColor whiteColor];
    Toplabel.text=@"忘记密码";
    Toplabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:Toplabel];
    
    
    for ( int i=0; i<5; i++) {
        UIView *view =[[UIView alloc]initWithFrame:CGRectMake(30, 80+40*i+20*i, LWidth-60, 40)];
        UIImageView *bgimageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        bgimageView.image=[UIImage imageNamed:@"frame"];
        UIImageView *smallBgImg =[[UIImageView alloc]initWithFrame:CGRectMake(3, 6, 32,28)];
        smallBgImg.image=[UIImage imageNamed:imagNameArray[i]];
        [view addSubview:bgimageView];
        [view addSubview:smallBgImg];
        [self.view addSubview:view];
        if (i==1) {
            Question =[[UILabel alloc]initWithFrame:CGRectMake(45, 0, view.frame.size.width-90, 40)];
            Question.font=[UIFont systemFontOfSize:14];
            Question.textColor=[UIColor whiteColor];
            Question.text=@"你的小学老师是谁？";
            
            [view addSubview:Question];
            
            UIButton *dropBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            dropBtn.frame=CGRectMake(view.frame.size.width-45, 10, 32, 20);
            [dropBtn addTarget:self action:@selector(dropMenuBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [dropBtn setBackgroundImage:[UIImage imageNamed:@"dropmenu"] forState:0];
            [view addSubview:dropBtn];
            
        }else{
            UITextField* textfiled =[[UITextField alloc]initWithFrame:CGRectMake(45, 0, view.frame.size.width-45, 40)];
            textfiled.delegate=self;
            
            if (i==3||i==4) {
                textfiled.secureTextEntry=YES;
            }
            textfiled.textColor= [UIColor whiteColor];
            textfiled.tag=i;
            textfiled.returnKeyType=UIReturnKeyDone;
            textfiled.placeholder=placeHoderArray[i];
            //passwordView.backgroundColor=[UIColor whiteColor];
            [view addSubview:textfiled];
            
            
            
        }
        
        
        
    }
    
    
    UIButton *loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame=CGRectMake(30,80+40*4+20*4+80, LWidth-60, 40) ;
    loginBtn.backgroundColor=[CommonTool colorWithHexString:@"#D3E9F6"];
    [loginBtn setTitleColor:[CommonTool colorWithHexString:@"#5BB2EB"] forState:0];
    [loginBtn setTitle:@"完 成" forState:0];
    loginBtn.layer.cornerRadius=10.0;
    [loginBtn addTarget:self action:@selector(saveBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
    
}
-(void)dropMenuBtnClick{
    
    NSArray *titleArray =[[NSArray alloc]initWithObjects:@"你的小学老师是谁？",@"你配偶生日是什么时候？",@"你最喜欢吃什么？",nil];
    UIAlertController *controller =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleAlert];
    for (NSString  *str in titleArray) {
        UIAlertAction *action =[UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            Question.text=str;
            
        }];
        [controller addAction:action];
    }
    
    
    [self presentViewController:controller animated:YES completion:nil];
    
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITextField *userCode=(UITextField*)[self.view viewWithTag:0];
    UITextField *Answer=(UITextField*)[self.view viewWithTag:2];
    UITextField *PwdNew=(UITextField*)[self.view viewWithTag:3];
    UITextField *SurePwdNew=(UITextField*)[self.view viewWithTag:4];
    if (![userCode isExclusiveTouch]) {
        [userCode resignFirstResponder];
    }
    if (![Answer isExclusiveTouch]) {
        [Answer resignFirstResponder];
    }
    if (![PwdNew isExclusiveTouch]) {
        [PwdNew resignFirstResponder];
    }
    if (![SurePwdNew isExclusiveTouch]) {
        [SurePwdNew resignFirstResponder];
    }
}

- (void)saveBtn{
    
    
    UITextField *Answer=(UITextField*)[self.view viewWithTag:2];
    UITextField *PwdNew=(UITextField*)[self.view viewWithTag:3];
    
    NSString *Answer1 =[Answer.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *PwdNew1 =[PwdNew.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Answer---%@",Answer.text);
    NSLog(@"新密码---%@",PwdNew.text);
    NSString *firstMd5=[MyMD5 md5:PwdNew1];
    NSString *secondMD5=[MyMD5 md5:firstMd5];
    NSString *lastMD5=[MyMD5 md5:secondMD5];
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10104\",\"accredquestion\":\"%@\",\"accredreply\":\"%@\",\"newpwd\":\"%@\",\"usercode\":\"%@\"}",Question.text,Answer1,lastMD5,USERCODE];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    NSLog(@"dict======%@",dict);
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            [SVProgressHUD showSuccessWithStatus:[dictt objectForKey:@"MSG"]];
            
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
            
        }
    };
    
}



- (void)BackBtn{
    UIStoryboard *story1 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *vc = [story1 instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:window cache:YES];
    [UIView commitAnimations];
    
    window.rootViewController = vc;
    
}


@end
