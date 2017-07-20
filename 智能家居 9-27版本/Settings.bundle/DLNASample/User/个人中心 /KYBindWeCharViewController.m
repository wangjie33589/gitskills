//
//  KYBindWeCharViewController.m
//  SmartHome
//
//  Created by sciyonSoft on 16/7/13.
//
//

#import "KYBindWeCharViewController.h"

@interface KYBindWeCharViewController ()
@property (weak, nonatomic) IBOutlet UITextField *WeChar;

@end

@implementation KYBindWeCharViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"绑定微信号";
    self.tabBarController.tabBar.hidden = YES;
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtn)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    // Do any additional setup after loading the view from its nib.
}

- (void)saveBtn{
  
  
        NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10216\",\"userid\":\"%@\",\"wechat\":\"%@\"}",USER_ID,_WeChar.text];
      NSLog(@"urlstring---%@",urlstring);
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    NSLog(@"dict======%@",dict);
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        [SVProgressHUD showSuccessWithStatus:@"保存成功..."];
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {

            [SVProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        }
    };

}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_WeChar isExclusiveTouch]) {
        [_WeChar resignFirstResponder];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
