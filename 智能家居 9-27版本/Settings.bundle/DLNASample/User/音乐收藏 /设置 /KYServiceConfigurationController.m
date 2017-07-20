//
//  KYServiceConfigurationController.m
//  SmartHome
//
//  Created by sciyonSoft on 16/7/28.
//
//

#import "KYServiceConfigurationController.h"

@interface KYServiceConfigurationController ()
@property (strong, nonatomic) IBOutlet UISwitch *switchA;
@property (strong, nonatomic) IBOutlet UISwitch *switchB;

@end

@implementation KYServiceConfigurationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"服务器优先设置";
    self.tabBarController.tabBar.hidden = YES;
    
    
    if ([HTTPIP isEqualToString:CLOULD_SERVIER]) {
    
        [self.switchA setOn:YES];
        [self.switchB setOn:NO];
        
    }else{
        [self.switchA setOn:NO];
        [self.switchB setOn:YES];
    
    
    
    }
}

- (IBAction)switch1:(UISwitch *)sender {
    
    if (sender.on==YES) {
        [self.switchB setOn:NO];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"http"];
        [[NSUserDefaults standardUserDefaults]setObject:CLOULD_SERVIER forKey:@"http"];
        
        
    }else{
        [self.switchB setOn:YES];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"http"];
        [[NSUserDefaults standardUserDefaults]setObject:LOCAL_SERVIER forKey:@"http"];
    
    
    }
    
    
    
}
- (IBAction)switch2:(UISwitch *)sender {
    
    if (sender.on==YES) {
        [self.switchA setOn:NO];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"http"];
        [[NSUserDefaults standardUserDefaults]setObject:LOCAL_SERVIER forKey:@"http"];
        
        
    }else{
        [self.switchA setOn:YES];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"http"];
        [[NSUserDefaults standardUserDefaults]setObject:CLOULD_SERVIER forKey:@"http"];
        
        
    }
    

}



@end
