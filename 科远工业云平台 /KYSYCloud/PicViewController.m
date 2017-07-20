//
//  PicViewController.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/3/8.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "PicViewController.h"
#define ROW [[NSUserDefaults standardUserDefaults]objectForKey:@"row"]

@interface PicViewController ()<UIScrollViewDelegate>{
    NSMutableArray *_picArray;
    int page;
    UIScrollView *scrollow;
    UIImageView *iView;
    NSDictionary *_fromdic;
    NSString *_titlestr;
}

@end

@implementation PicViewController
-(id)initWithArray:(NSArray *)aArr withDic:(NSDictionary*)aDic withTitleStr:(NSString *)title{
    
    self =[super init];
    if (self) {
        _picArray =(NSMutableArray*)aArr;
        _fromdic=aDic;
        _titlestr=title;
        
    }

    return self;
}

- (IBAction)deleBtn:(UIButton *)sender {
    if (_picArray.count>0) {
        [_picArray removeObjectAtIndex:page];
        [self initScrollow];
        scrollow.contentOffset=CGPointMake(page*LWIDTH, 0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([_titlestr isEqualToString:@"维修登记"]) {
        if (self.type==0||self.type==3) {
            }else{ self.deleBtn.hidden=YES;
        }

    }else if ([_titlestr isEqualToString:@"维修记录"]){
        self.deleBtn.hidden=YES;
    
    
    
    }else if ([_titlestr isEqualToString:@"维保确认"]){
        self.deleBtn.hidden=YES;
        }else {
        if (self.type==10||self.type==1) {
           }else{
             self.deleBtn.hidden=YES;
           }
    }
       [self initScrollow];
    
}

-(void)initScrollow{
    NSLog(@"asdghshfgahsdgfhjgfd====%@",_picArray);
    
    [scrollow removeFromSuperview];
    scrollow=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, LWIDTH, LHIGHT-100)];
    scrollow.contentSize=CGSizeMake(_picArray.count*LWIDTH, LHIGHT);
    scrollow.contentOffset=CGPointMake([_fromdic[@"row"]integerValue]*LWIDTH, 0);
        scrollow.pagingEnabled=YES;
    scrollow.delegate=self;
    
    
     for (int i=0; i<_picArray.count; i++) {
           iView =[[UIImageView alloc]initWithImage:_picArray[i]];
        iView.frame=CGRectMake(i*LWIDTH, 0, LWIDTH, LHIGHT-100);
            [scrollow addSubview:iView];
      }
    [self.button setTitle:[NSString stringWithFormat:@"完成(%lu/9)",(unsigned long)_picArray.count] forState:0];
    [self.view addSubview:scrollow];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)compelteBtn:(UIButton *)sender {
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:_picArray, @"array",nil];
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    
      [self dismissViewControllerAnimated:YES completion:nil];
}
@end
