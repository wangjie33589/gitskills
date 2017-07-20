//
//  KYBindPhoneViewController.m
//  SmartHome
//
//  Created by sciyonSoft on 16/7/13.
//
//

#import "KYBindPhoneViewController.h"

@interface KYBindPhoneViewController (){
    NSMutableArray *_showArray;
}
@property (weak, nonatomic) IBOutlet UITextField *phone;

@end

@implementation KYBindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"绑定手机号";
    self.tabBarController.tabBar.hidden = YES;
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtn)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    // Do any additional setup after loading the view from its nib.
}

- (void)saveBtn{
    NSLog(@"点击了---%@",_phone.text);
     NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10215\",\"userid\":\"%@\",\"phonenumber\":\"%@\"}",USER_ID,_phone.text];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        [SVProgressHUD showSuccessWithStatus:@"保存成功..."];
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
//            _showArray=dictt[@"DATA"];
//              NSLog(@"%@---返回的数据",_showArray);
//            [self performSelector:@selector(hehe) withObject:nil afterDelay:5];
            [SVProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        }
    };

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_phone isExclusiveTouch]) {
        [_phone resignFirstResponder];
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
