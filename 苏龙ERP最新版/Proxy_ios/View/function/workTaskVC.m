//
//  workTaskVC.m
//  ios版本科远APP
//
//  Created by sciyonSoft on 15/11/28.
//  Copyright © 2015年 sciyonSoft. All rights reserved.
//

#import "workTaskVC.h"
#import "TopView.h"
#import "work_task_first_VC.h"
#import "work_task_addVC.h"
@interface workTaskVC ()<TopViewDelegate>{
    NSString *getUrl;
    NSString*  title_str;
    UIScrollView *totalScrollView;
    NSArray *titleArray;
TopView* vc;
}

@end

@implementation workTaskVC


- (id)initWithUrl:(NSString *)url title:(NSString *)titleStr{
    self=[super init];
    if (self) {
        getUrl = url;
        title_str = titleStr;
        }


    return self;



}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title=@"工作任务";
    titleArray=[[NSArray alloc]initWithObjects:@"我的任务",@"我分配的" ,nil];
    UIBarButtonItem *rightButton =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(callModalList)];
    
    [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont systemFontOfSize:15], NSFontAttributeName,
                                         [UIColor whiteColor], NSForegroundColorAttributeName,
                                         nil]
                               forState:UIControlStateNormal];
       self.navigationItem.rightBarButtonItem = rightButton;
       totalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, LWidth, LHeight-104)];//总scrollView
       totalScrollView.pagingEnabled = YES;
    totalScrollView.delegate = self;
    [self.view addSubview:totalScrollView];
    [self initViewXml];
    
    NSLog(@"???");
    [self loazdViewControllers];
    
   
}

- (void)initViewXml
{
        totalScrollView.contentSize = CGSizeMake(LWidth*2, 40);
   /// [self requestShowDataList4];
  vc = [[TopView alloc] initWithFrame:CGRectMake(0, 0, LWidth, 40)];
    vc.array = titleArray;
    vc.delegate = self;
    vc.backgroundColor = [UIColor blackColor];
    [self.view addSubview:vc];
}

-(void)loazdViewControllers{
    for (int i=0; i<2; i++) {
        work_task_first_VC*btview =[[work_task_first_VC alloc]initWithAType:i?@"2":@"1"];;
              btview.view.frame=CGRectMake(LWidth*i, 0, LWidth, totalScrollView.frame.size.height);
            [totalScrollView addSubview:btview.view];
            //btview.flag=i;
            [self addChildViewController:btview];
        
    }
    
   

}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(unsigned long)(scrollView.contentOffset.x / scrollView.frame.size.width)],@"indexpage", nil];
    //通知原来也可以传递字典
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
- (void)pushNewsViewController:(NSInteger)page
{
    [totalScrollView setContentOffset:CGPointMake(LWidth*page, 0) animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)callModalList {
        
    work_task_addVC *task =[[work_task_addVC alloc]init];
    [self.navigationController pushViewController:task animated:YES];
    
    
    
    
}
@end
