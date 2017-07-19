//
//  LFLoginViewController.m
//  LF微博
//
//  Created by lf on 16/4/26.
//  Copyright © 2016年 lf. All rights reserved.
//

#import "LFLoginViewController.h"
#import "LFHallViewController.h"

@interface LFLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更多";
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.navigationController.navigationBar.tintColor
        = [UIColor whiteColor];
    
    
    self.navigationController.navigationBar.titleTextAttributes=@{UITextAttributeTextColor:[UIColor whiteColor]};
    UIImage *image = [UIImage imageNamed:@"RedButton"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    
    [_loginBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    
}
@end
