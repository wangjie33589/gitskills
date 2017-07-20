//
//  DetilVC.m
//  ios版本科远APP
//
//  Created by sciyonSoft on 15/11/30.
//  Copyright © 2015年 sciyonSoft. All rights reserved.
//



#import "DetilVC.h"
#import "handelVC.h"
#import "confirmVC.h"
#import "reworkVC.h"
#import "TopView.h"
#import "workFlowupTable.h"


@interface DetilVC ()<TopViewDelegate>{
    UIScrollView *totalScrollView;
    NSArray *titleArray;
  NSDictionary *showDic;
    NSArray *showArray;
    BOOL tableisShow;
    workFlowupTable *table;
}

@end

@implementation DetilVC


-(id)initWithArray:(NSDictionary *)Dic{
    self =[super init];
    
    
    
      if (self) {
        showDic=Dic;
          
    }

    return self;


}

- (void)viewDidLoad {
    [super viewDidLoad];
    tableisShow=YES;
   
    self.title=@"工作任务";
    [self initRightItemBtn];
          
     titleArray=[[NSArray alloc]initWithObjects:@"处理信息",@"确认信息",@"返工信息",nil];
    
      totalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, LWidth, LHeight-104)];//总scrollView
    totalScrollView.backgroundColor = [UIColor whiteColor];
    totalScrollView.pagingEnabled = YES;
    totalScrollView.delegate = self;
    [self.view addSubview:totalScrollView];
    [self initViewXml];
    [self loadViewController];
    
    
}
-(void)initRightItemBtn{
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
    
    
}
-(void)callModalList{
  
    
    if (tableisShow) {
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"C9CAA8F1363B428CB8B76B351C4B1CA0",@"FLOWGUID",@"",@"FLOWVERSION",@"INITWFCONTROL",@"Action",showDic[@"FGUID"],@"DATAGUID",@"",@"FLOWINSTANCEGUID",@"normal",@"SHOWSTATUS",@"",@"PROCESSGUID",@"",@"HGUID",@"Sciyon.SyncPlant.MIS.Bll.RSM.WorkTask.WorktaskCRUD,Sciyon.SyncPlant.MIS.Bll.RSM",@"DATATYPE",nil];
              table =[[workFlowupTable alloc]initWithData:dict];
       
         table.showDic=showDic;

        table.view.backgroundColor=[UIColor clearColor];
        table.view.frame=CGRectMake(0, 0, LWidth, LHeight);
        [self.view addSubview:table.view];
        [self addChildViewController:table];
        tableisShow=!tableisShow;
    }else{
        [table.view removeFromSuperview];
        tableisShow=!tableisShow;
        
        
        
    }
    
    
}
- (void)initViewXml
{
    totalScrollView.contentSize = CGSizeMake(LWidth*3, 40);
    /// [self requestShowDataList4];
    
    TopView* vc = [[TopView alloc] initWithFrame:CGRectMake(0, 0, LWidth, 40)];
    vc.array = titleArray;
    vc.delegate = self;
    vc.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:vc];
  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadViewController{
    // 处理信息
    handelVC *ditilvc =[[handelVC alloc]initWithArray:showDic];
    ditilvc.view.frame=CGRectMake(0, 0, LWidth, totalScrollView.frame.size.height);
    [totalScrollView addSubview:ditilvc.view];
    [self addChildViewController:ditilvc];
    //确认信息
    confirmVC  *confirm =[[confirmVC alloc]initWithArray:showDic];
    confirm.view.frame=CGRectMake(LWidth, 0,LWidth, totalScrollView.frame.size.height);
    [totalScrollView addSubview:confirm.view];
    [self addChildViewController:confirm];
    //返工信息
    reworkVC *rework =[[reworkVC alloc]initWithArray:showDic];;
    rework.view.frame=CGRectMake(2*LWidth, 0, LWidth, totalScrollView.frame.size.height);
    [totalScrollView addSubview:rework.view];
    [self addChildViewController:rework];
 
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






@end
