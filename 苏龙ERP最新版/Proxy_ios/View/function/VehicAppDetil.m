//
//  VehicAppDetil.m
//  Proxy_ios
//
//  Created by SciyonSoft_WangJie on 17/7/6.
//  Copyright © 2017年 keyuan. All rights reserved.
//

#import "VehicAppDetil.h"

@interface VehicAppDetil ()

@end

@implementation VehicAppDetil

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title=@"用车登记";
    self.mytextView.userInteractionEnabled=NO;
    self.mytextView.font =[UIFont systemFontOfSize:13];
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@" "
                                     style:UIBarButtonItemStyleDone
                                     target:self
                                     action:@selector(callModalList)];
    
    [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont systemFontOfSize:15], NSFontAttributeName,
                                         [UIColor whiteColor], NSForegroundColorAttributeName,
                                         nil]
                               forState:UIControlStateNormal];
    rightButton.image = [UIImage imageNamed:@"icon_5_n"];
    self.navigationItem.rightBarButtonItem = rightButton;

    
    self.mytextView.text=[NSString stringWithFormat:@"  申请人:\n\n  申请部门:\n\n  申请日期:\n\n  乘车人数:\n\n  目的城市:\n\n  申请用车时间:%@至%@\n\n  用车事由:\n\n  车牌号:\n\n  车型:\n\n  驾驶员:\n\n  行车里程:\n\n  开始表码:\n\n  结束表码 :\n\n  实际用车时间:%@至%@\n\n  备注:\n\n",@"",@"",@"",@""];
    
    
}
-(void)callModalList{

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
