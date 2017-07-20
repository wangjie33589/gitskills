//
//  KYSetGatewayViewController.m
//  SmartHome
//
//  Created by sciyonSoft on 16/8/17.
//
//

#import "KYSetGatewayViewController.h"
#import "LoginViewController.h"

@interface KYSetGatewayViewController ()

@property (strong, nonatomic) IBOutlet UITextField *gateWay;
@end

@implementation KYSetGatewayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"网关设置";
    self.tabBarController.tabBar.hidden = YES;
//    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _gateWay.text = HTTPIP;
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtn)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    if (self.type==0) {
        UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBtn)];
        self.navigationItem.leftBarButtonItem = leftBtn;
    }

    // Do any additional setup after loading the view from its nib.
}
-(void)backBtn{
    [self dismissViewControllerAnimated:YES completion:nil];
    

    

}
- (void)saveBtn{
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"http"];
    [[NSUserDefaults standardUserDefaults]setObject:_gateWay.text forKey:@"http"];
    
    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    // GCD
      if (self.type==0) {
          [self dismissViewControllerAnimated:YES completion:nil];
      }else{
    
        [self.navigationController popViewControllerAnimated:YES];
    
    }
     // [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
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
