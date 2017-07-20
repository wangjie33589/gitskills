//
//  NewtaskVC.m
//  ios版本科远APP
//
//  Created by sciyonSoft on 15/11/30.
//  Copyright © 2015年 sciyonSoft. All rights reserved.
//

#import "NewtaskVC.h"
#import <QuartzCore/QuartzCore.h>


#import "DetilVC.h"

@interface NewtaskVC ()<UITextViewDelegate>

@end

@implementation NewtaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.view.backgroundColor=[UIColor redColor];
//    _contentView =[[UITextView alloc]initWithFrame:CGRectMake(52, 386, 310, 142)];
//    _contentView.delegate=self;
//    [self.view addSubview:_contentView];
  self.contentView.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor greenColor]);
    
    self.contentView.layer.borderWidth =1.0;
    
    self.contentView.layer.cornerRadius =5.0;
    

    
    
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    //注册通知,监听键盘出现
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidShow:)
                                                name:UIKeyboardDidShowNotification
                                              object:nil];
    //注册通知，监听键盘消失事件
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidHidden)
                                                name:UIKeyboardDidHideNotification
                                              object:nil];
    [super viewWillAppear:YES];
}

//监听事件
- (void)handleKeyboardDidShow:(NSNotification*)paramNotification
{
    //获取键盘高度
    NSValue *keyboardRectAsObject=[[paramNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    [keyboardRectAsObject getValue:&keyboardRect];
    
    _contentView.contentInset=UIEdgeInsetsMake(0, 0,keyboardRect.size.height-200, 0);
}

- (void)handleKeyboardDidHidden
{
    _contentView.contentInset=UIEdgeInsetsZero;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    [self.view endEditing:YES];
    
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

- (IBAction)distrbution:(UIButton *)sender {
    
       
    NSLog(@"distribution");
    
    
    
    
}

- (IBAction)gobackBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
