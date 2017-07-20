//
//  KYQuestionViewController.m
//  SmartHome
//
//  Created by sciyonSoft on 16/7/22.
//
//

#import "KYQuestionViewController.h"
#import "HClActionSheet.h"
#import "MyMD5.h"
@interface KYQuestionViewController ()
@property (strong, nonatomic) IBOutlet UITextField *OldPwd;
@property (strong, nonatomic) IBOutlet UITextField *Youranswer;
@property (strong, nonatomic) IBOutlet UILabel *YourQuestion;
@property (strong, nonatomic) IBOutlet UIButton *btn1;
@property (strong, nonatomic) IBOutlet UIButton *btn2;

@end

@implementation KYQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"认证问题设置";
    self.tabBarController.tabBar.hidden = YES;
    
    _btn1.layer.cornerRadius= 10.0;
    _btn2.layer.cornerRadius= 10.0;
     _btn1.backgroundColor = [UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1];
    _btn2.backgroundColor = [UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1];
    NSLog(@"PWD---%@",PWD);
    
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)SelectedQuestion:(id)sender {
    
    HClActionSheet *actionSheet = [[HClActionSheet alloc] initWithTitle:nil style:HClSheetStyleDefault itemTitles:@[@"你的小学老师是谁？",@"你配偶生日是什么时候？",@"你最喜欢吃什么？"]];
    
    actionSheet.delegate = self;
    actionSheet.tag = 50;
    __weak typeof(self) weakSelf = self;
    [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
        
        NSLog(@"block----%ld----%@", (long)index, title);
        weakSelf.YourQuestion.text = [NSString stringWithFormat:@"%@", title];
    }];
    
}

- (IBAction)SaveBtn:(UIButton *)sender {
      NSString *OldPwd =[_OldPwd.text stringByReplacingOccurrencesOfString:@" " withString:@""];
     NSString *Youranswer=[_Youranswer.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *firstMd51=[MyMD5 md5:OldPwd ];
    NSString *secondMD51=[MyMD5 md5:firstMd51];
    NSString *lastMD51=[MyMD5 md5:secondMD51];
    if (![lastMD51 isEqualToString:PWD]) {
        [SVProgressHUD showErrorWithStatus:@"您的密码输入错误，请重新输入"];
    }else{
        NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
        NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10218\",\"userid\":\"%@\",\"actuserid\":\"%@\",\"accredquestion\":\"%@\",\"accredreply\":\"%@\"}",USER_ID,USER_ID,_YourQuestion.text,Youranswer];
        NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
        NSLog(@"dict======%@",dict);
        MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
        manager.backSuccess = ^void(NSDictionary *dictt)
        {
            
            if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
//                _myDic=dictt[@"DATA"];
                
                //      NSLog(@"dict:==%@",dictt[@"DATA"]);
                
//                [[NSUserDefaults standardUserDefaults] setObject:_text2.text forKey:@"pwd"];
//                NSLog(@"新密码-%@--%@",PWD,lastMD5);
                //[[NSUserDefaults standardUserDefaults]setValue:_XmlArray forKey:@"XmlArray"];
                [SVProgressHUD showSuccessWithStatus:[dictt objectForKey:@"MSG"]];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
                
                
            }
        };

        
        
    }
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_OldPwd isExclusiveTouch]) {
        [_OldPwd resignFirstResponder];
    }
    if (![_Youranswer isExclusiveTouch]) {
        [_Youranswer resignFirstResponder];
    }
}


@end
