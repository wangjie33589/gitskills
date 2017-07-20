//
//  SenceEidtVC.m
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/7/11.
//
//

#import "SenceEidtVC.h"
#import "executionCell.h"
#import "actionCell.h"
#import "TimerCell.h"
#import "CFDatePickerView.h"
#import "SkyAssociationMenuView.h"
#import "SenceChoice_erea_device_pancel_VC.h"


@interface SenceEidtVC ()<UITableViewDelegate,UITableViewDataSource,SkyAssociationMenuViewDelegate>{

    NSDictionary  *_fromDic;
    NSArray *_exeArray;
    NSArray *_actArray;
    NSArray *_timerArray;
    NSArray *_btnImgArray;
    BOOL flag[7];
    UIView*_Comments;
    UIDatePicker *_dataPicker;
    int value;
    int status;
  
}
@property (strong, nonatomic) SkyAssociationMenuView *v;
@property(nonatomic,strong)NSMutableArray *weekSelectarray;
@property (nonatomic, strong) CFDatePickerView *datePickerView;
@property(nonatomic,copy)NSString *hours;
@property(nonatomic,copy)NSString *minites;
@end

@implementation SenceEidtVC
-(instancetype)initWithaDic:(NSDictionary *)aDic{
    self=[super init];
    if (self) {
        _fromDic=aDic;
        
        
        NSLog(@" _fromDic====%@",_fromDic);
        
        
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self requestForExe];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _v = [SkyAssociationMenuView new];
    _v.delegate = self;
    //[self requestForExe];
    value=0;
   
    [self  initTableView];
}
-(void)initTableView{
    [self.myTable registerNib:[UINib nibWithNibName:@"executionCell" bundle:nil] forCellReuseIdentifier:@"exeCell"];
    [self.myTable registerNib:[UINib nibWithNibName:@"actionCell" bundle:nil] forCellReuseIdentifier:@"actCell"];
    [self.myTable registerNib:[UINib nibWithNibName:@"TimerCell" bundle:nil] forCellReuseIdentifier:@"timCell"];
        self.myTable.dataSource=self;
    self.myTable.delegate=self;
    
    self.myTable.separatorStyle= UITableViewCellSeparatorStyleNone;
    //self.myTable.rowHeight=60;
 
}
#pragma mark====TableViewDataSource TableViewDelete
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return _exeArray.count;
    }else if (section==1){
        return _actArray.count;
    
    }else{
        return _timerArray.count;
    
    }

   
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    executionCell *cell =[tableView dequeueReusableCellWithIdentifier:@"exeCell"];
    cell.selectionStyle=  UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:
        {    actionCell *cell =[tableView dequeueReusableCellWithIdentifier:@"actCell"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.numberLab.text=[NSString stringWithFormat:@"序号:%d",indexPath.row];
            cell.SWitch.tag=indexPath.row;
            cell.timerBtn.tag=indexPath.row;
            cell.tag=indexPath.row+10;
     
            cell.lightSwitchLab.text=_exeArray[indexPath.row][@"name"];
            cell.deviceLab.text=_exeArray[indexPath.row][@"devicename"];
            if (![_exeArray[indexPath.row][@"delaytime"] isKindOfClass:[NSNull class]]) {
                
                if ([_exeArray[indexPath.row][@"delaytime"]integerValue]==60) {
                    value=120;
                    
                    [cell.timerBtn setTitle:@"延时:1m"  forState:0];
                }else if ([_exeArray[indexPath.row][@"delaytime"]integerValue]==300){
                    value=600;
                    
                    [cell.timerBtn setTitle:@"延时:5m"  forState:0];
                    
                }else{
                    [cell.timerBtn setTitle:[NSString stringWithFormat:@"延时:%@s",_exeArray[indexPath.row][@"delaytime"]] forState:0];
                    value=[_exeArray[indexPath.row][@"delaytime"]integerValue]*2;
                    
                }

                
            }
            
            [cell.timerBtn addTarget:self action:@selector(timerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.SWitch addTarget:self action:@selector(uiswitchValueChange:) forControlEvents:UIControlEventValueChanged];
        
            return cell;
        
        }
            break;
            
        case 1:{
            actionCell *cell =[tableView dequeueReusableCellWithIdentifier:@"actCell"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.numberLab.text=[NSString stringWithFormat:@"序号:%d",indexPath.row];
            cell.SWitch.tag=indexPath.row;
            cell.timerBtn.tag=indexPath.row;
             [cell.timerBtn addTarget:self action:@selector(TWOSectionTimerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.tag=indexPath.row+100;

            cell.lightSwitchLab.text=_actArray[indexPath.row][@"name"];
            cell.deviceLab.text=_actArray[indexPath.row][@"devicename"];
            
            if (_actArray[indexPath.row][@"delaytime"]!=nil) {
                if ([_actArray[indexPath.row][@"delaytime"]integerValue]==60) {
                    
                    [cell.timerBtn setTitle:@"延时:1m"  forState:0];
                }else if ([_actArray[indexPath.row][@"delaytime"]integerValue]==300){
                    
                    [cell.timerBtn setTitle:@"延时:5m"  forState:0];
                    
                }else{
                    [cell.timerBtn setTitle:[NSString stringWithFormat:@"延时:%@s",_actArray[indexPath.row][@"delaytime"]] forState:0];
                    
                }

            }
           
            
            [cell.SWitch addTarget:self action:@selector(TWOSectionValueChange:) forControlEvents:UIControlEventValueChanged];
            
            return cell;
          }
            break;
        case 2:{
            
            TimerCell *cell =[tableView dequeueReusableCellWithIdentifier:@"timCell"];
            cell.selectionStyle=  UITableViewCellSelectionStyleNone;
            cell.label.text =[NSString stringWithFormat:@" %@:%@",_timerArray[indexPath.row][@"fhour"],_timerArray[indexPath.row][@"fmin"]];
            if ([_timerArray[indexPath.row][@"boolmon"]intValue]) {
                cell.MonDayImg.image=[UIImage imageNamed:@"mon_1"];
                
            }
            if ([_timerArray[indexPath.row][@"booltues"]intValue]){
                
                NSLog(@"asdgsh===%d",[_timerArray[indexPath.row][@"booltues"]intValue]);
            
               cell.TuesDayImg.image=[UIImage imageNamed:@"tus_1"];
            
            }
            if ([_timerArray[indexPath.row][@"boolwednes"]intValue]){
                cell.wedDayImg.image=[UIImage imageNamed:@"wen_1"];
            }
            if ([_timerArray[indexPath.row][@"boolthurs"]intValue]){
            
                cell.thurDayImg.image=[UIImage imageNamed:@"thu_1"];
            
            }
            if ([_timerArray[indexPath.row][@"boolfri"]intValue]){
            
                cell.friDayImg.image=[UIImage imageNamed:@"fri_1"];
            
            }
            if ([_timerArray[indexPath.row][@"boolstatur"]intValue]){
                cell.satDayImg.image=[UIImage imageNamed:@"sat_1"];
                
            
            }
            if ([_timerArray[indexPath.row][@"boolsun"]intValue]){
            
                cell.sunDayImg.image=[UIImage imageNamed:@"sun_1"];
        
            }
            
            return cell ;
        
        
        }
            break;
    }
        return cell;
    

}
-(void)uiswitchValueChange:(UISwitch*)sender{
    [self requestToChangeValuewithAdic:sender.tag];
//    
//    int statsu;
//    if (sender.isOn) {
//        [self ]
//        
//        
//        NSLog(@" shuchu  ======%d",sender.isOn);
//        
//    }else{
//    `
//        NSLog(@" shuchu  ======%d",sender.isOn);
//    
//    
////    }
//    UIButton *btn =(UIButton*)[self.view viewWithTag:sender.tag];
////   [self requestToChangeValuewithAdic:_exeArray[sender] WithValue:<#(int)#> WithonStatus:<#(int)#>]





}
-(void)timerBtnClick:(UIButton*)sender{
    
    UIAlertController *conter =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 =[UIAlertAction actionWithTitle:@"0s" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        value=0*2;
        [sender setTitle:@"延时 :0s" forState:0];
        [self requestToChangeValuewithAdic:sender.tag];
        
    }];
    UIAlertAction *action2 =[UIAlertAction actionWithTitle:@"3s" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        value=3*2;
         [sender setTitle:@"延时 :3s" forState:0];
        [self requestToChangeValuewithAdic:sender.tag];

        
    }];
    UIAlertAction *action3 =[UIAlertAction actionWithTitle:@"10s" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
         [sender setTitle:@"延时 :10s" forState:0];
        value=10*2;
        [self requestToChangeValuewithAdic:sender.tag];

        
    }];
    UIAlertAction *action4 =[UIAlertAction actionWithTitle:@"30s" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
         [sender setTitle:@"延时 :30s" forState:0];
        value=30*2;
        [self requestToChangeValuewithAdic:sender.tag];

        
    }];
    UIAlertAction *action5 =[UIAlertAction actionWithTitle:@"1m" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
         [sender setTitle:@"延时 :1m" forState:0];
        value=60*2;
        [self requestToChangeValuewithAdic:sender.tag];

        
    }];
    UIAlertAction *action6 =[UIAlertAction actionWithTitle:@"5m" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
         [sender setTitle:@"延时 :5m" forState:0];
        value=300*2;
        [self requestToChangeValuewithAdic:sender.tag];

        
    }];
    UIAlertAction *action7 =[UIAlertAction actionWithTitle:@"10m" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
         [sender setTitle:@"延时 :10m" forState:0];
        value=600*2;
        [self requestToChangeValuewithAdic:sender.tag];

        
    }];
    [conter addAction:action1];
    [conter addAction:action2];
    [conter addAction:action3];
    [conter addAction:action4];
    [conter addAction:action5];
    [conter addAction:action6];
    [conter addAction:action7];
    [self presentViewController:conter animated:YES completion:nil];



}

-(void)TWOSectionValueChange:(UISwitch*)sender{
       [self requestTWOActionChangeValuewithAdic:sender.tag];
    
    
    
    
    
}
-(void)TWOSectionTimerBtnClick:(UIButton*)sender{
    
    
    UIAlertController *conter =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 =[UIAlertAction actionWithTitle:@"0s" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        value=0*2;
        [sender setTitle:@"延时 :0s" forState:0];
        [self requestTWOActionChangeValuewithAdic:sender.tag];
        
    }];
    UIAlertAction *action2 =[UIAlertAction actionWithTitle:@"3s" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [sender setTitle:@"延时 :3s" forState:0];
        value=3*2;
     [self requestTWOActionChangeValuewithAdic:sender.tag];
        
    }];
    
    
    
//    
    UIAlertAction *action3 =[UIAlertAction actionWithTitle:@"10s" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
       [sender setTitle:@"延时 :10s" forState:0];
        value=10*2;
          [self requestTWOActionChangeValuewithAdic:sender.tag];
    }];
    UIAlertAction *action4 =[UIAlertAction actionWithTitle:@"30s" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [sender setTitle:@"延时 :30s" forState:0];
        value=30*2;
          [self requestTWOActionChangeValuewithAdic:sender.tag];
        
    }];
    UIAlertAction *action5 =[UIAlertAction actionWithTitle:@"1m" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [sender setTitle:@"延时 :1m" forState:0];
        value=60*2;
      [self requestTWOActionChangeValuewithAdic:sender.tag];
        
        
    }];
    UIAlertAction *action6 =[UIAlertAction actionWithTitle:@"5m" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [sender setTitle:@"延时 :5m" forState:0];
        value=300*2;
        [self requestTWOActionChangeValuewithAdic:sender.tag];
        
    }];
    UIAlertAction *action7 =[UIAlertAction actionWithTitle:@"10m" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [sender setTitle:@"延时 :10m" forState:0];
        value=600*2;
         [self requestTWOActionChangeValuewithAdic:sender.tag];
    }];
    [conter addAction:action1];
    [conter addAction:action2];
    [conter addAction:action3];
    [conter addAction:action4];
    [conter addAction:action5];
    [conter addAction:action6];
    [conter addAction:action7];
    [self presentViewController:conter animated:YES completion:nil];
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return indexPath.section==0?35:(indexPath.section==1?35:40);


}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 44;

}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSArray *titarray =[[NSArray alloc]initWithObjects:@"执行单元信息",@"动作单元信息",@"定时器信息", nil];
      UIView *view =[[UIView alloc]init];
    view.backgroundColor=[UIColor redColor];
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, LWidth-100, 44)];
    label.text=titarray[section];
    label.font =[UIFont systemFontOfSize:14];
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame=CGRectMake(LWidth-30, 0, 44, 44);
    btn.tag=section;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];

    view.backgroundColor= [CommonTool colorWithHexString:@"#DCDCDC"];
    [view addSubview:label];

    
    
    return view;




}
//设置可以编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//实现表的滑动删除 按钮
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //[_timerArray removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        if (indexPath.section==0) {
            [self requetToDelteExe:_exeArray[indexPath.row]];
            
        }
        if (indexPath.section==1) {
            [self requetToDelteAction:_actArray[indexPath.row]];
        }

        
        if (indexPath.section==2) {
             //[self  requetToDelteTimer:_timerArray[indexPath.row]];
//             [self.myTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
     }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
//将delte 改为中文
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{

return @"删除";


}
-(void)btnClick:(UIButton*)sender{

    NSLog(@"sendertag===%d",sender.tag);
    switch (sender.tag) {
        case 0:
        {
            // [_v showAsDrawDownView:sender];
            SenceChoice_erea_device_pancel_VC *VC =[[SenceChoice_erea_device_pancel_VC alloc]initWithADic:_fromDic AndTitle:@"添加执行单元"];
            UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:VC];
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 1:
        {
            SenceChoice_erea_device_pancel_VC *VC =[[SenceChoice_erea_device_pancel_VC alloc]initWithADic:_fromDic AndTitle:@"添加动作单元"];;
            UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:VC];
            [self presentViewController:nav animated:YES completion:nil];
            // [_v showAsDrawDownView:sender];
            NSLog(@"2");
        }
            break;
        case 2:
        {
            NSLog(@"3");
            [self showDataPickView];
          
            
        }
            break;
            
    }



}
#pragma mark===============SkyAssociationMenuViewDelegate
- (NSInteger)assciationMenuView:(SkyAssociationMenuView*)asView countForClass:(NSInteger)idx {
    NSLog(@"choose %ld", (long)idx);
    return 5;
}

- (NSString*)assciationMenuView:(SkyAssociationMenuView*)asView titleForClass_1:(NSInteger)idx_1 {
    NSLog(@"title %ld", (long)idx_1);
    return [NSString stringWithFormat:@"title %ld", (long)idx_1];
}

- (NSString*)assciationMenuView:(SkyAssociationMenuView*)asView titleForClass_1:(NSInteger)idx_1 class_2:(NSInteger)idx_2 {
    NSLog(@"title %ld, %ld", (long)idx_1, (long)idx_2);
    return [NSString stringWithFormat:@"title %ld, %ld", (long)idx_1, (long)idx_2];
}

- (NSString*)assciationMenuView:(SkyAssociationMenuView*)asView titleForClass_1:(NSInteger)idx_1 class_2:(NSInteger)idx_2 class_3:(NSInteger)idx_3 {
    NSLog(@"title %ld, %ld, %ld", (long)idx_1, (long)idx_2, (long)idx_3);
  
    return [NSString stringWithFormat:@"%ld,%ld,%ld", (long)idx_1, (long)idx_2, (long)idx_3];
}

//添加定时
-(void)showDataPickView{
    self.weekSelectarray =[NSMutableArray array];
    for (int i =0; i<7; i++) {
        [self.weekSelectarray addObject:@"0"];
    }

    _Comments = [[UIView alloc] init];
    _Comments.frame = CGRectMake(0, 0, LWidth, LHeight);
    _Comments.backgroundColor = [UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:0.3];
    [self.view addSubview:_Comments];
    [self.view bringSubviewToFront:_Comments];
    
    UIView *dataPickView =[[UIView alloc]init];
    dataPickView.frame=CGRectMake((LWidth-300)/2, 100, 300, 240);
    dataPickView.backgroundColor=[UIColor whiteColor];
    [_Comments addSubview:dataPickView];
    
    _dataPicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(10, 0, 300-20, 100)] ;
   [_dataPicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"Chinese"]];
    [_dataPicker setDatePickerMode:UIDatePickerModeTime];
    [_dataPicker setTimeZone:[NSTimeZone defaultTimeZone]];
    [dataPickView addSubview:_dataPicker];
    
   // int btnWigth =LWidth-60
    _btnImgArray =[[NSArray alloc]initWithObjects:@"sun",@"mon", @"tus",@"wen",@"thu",@"fri",@"sat",nil];
    
    for (int i=0; i<7; i++) {
        UIButton *weedbtn =[UIButton buttonWithType:UIButtonTypeCustom];
        weedbtn.frame=CGRectMake(1+(40+3)*i,120,  40, 40);
        //[weedbtn setImage:[UIImage imageNamed:btnImgArray[i]] forState:0];
        [weedbtn setBackgroundImage:[UIImage imageNamed:_btnImgArray[i]] forState:0];
        weedbtn.tag=i;
        [weedbtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        weedbtn.backgroundColor=[UIColor whiteColor];
        [dataPickView addSubview:weedbtn];
        
    }
    NSArray *btnArray =[[NSArray alloc]initWithObjects:@"取消",@"确定", nil];

    for (int i=0; i<2; i++) {
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius=5;
        button.layer.masksToBounds=YES;
        button.frame=CGRectMake(40+(90+40)*i, 180, 90, 40);
        [button setTitle:btnArray[i] forState:0];
        [button setTintColor:[UIColor whiteColor]];
        button.tag=i+100;
        [button addTarget:self action:@selector(confirmOrCancelClick:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor=[CommonTool colorWithHexString:@"1E90FF"];
        [dataPickView addSubview:button];
    }



}
//选中按钮
-(void)selectClick:(UIButton*)button{
      NSLog(@"flag__-1====%d",flag[button.tag]);
    flag[button.tag]=!flag[button.tag];
    
    NSLog(@"flag=+++2===%d",flag[button.tag]);
    
    if (flag[button.tag]) {
        [self.weekSelectarray setObject:@"1" atIndexedSubscript:button.tag];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_1",_btnImgArray[button.tag]]] forState:0];

    }else{
        [self.weekSelectarray setObject:@"0" atIndexedSubscript:button.tag];
         [button setBackgroundImage:[UIImage imageNamed:_btnImgArray[button.tag]] forState:0];

    }
  

}
//取消和确定
-(void)confirmOrCancelClick:(UIButton*)sender{
    
  
    flag[0]=flag[1]=flag[2]=flag[3]=flag[4]=flag[5]=flag[6]=NO;
    [_Comments removeFromSuperview];
    switch (sender.tag-100) {
        case 0:
        {
        
        
        }
            break;
            
        case 1:{
        
            [self requesToAddTimer];
        
        }break;
    }
}

- (NSString *)getHourStrFromDate:(NSDate *)date{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"HH";
    NSString *dataStr = [format stringFromDate:date];
    return dataStr;
}

- (NSString *)getMinStrFromDate:(NSDate *)date{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"mm";
    NSString *dataStr = [format stringFromDate:date];
    return dataStr;
}
//获取执行单元

-(void)requestForExe{
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10513\",\"serverid\":\"%@\",\"sceneid\":\"%@\",\"typecode\":\"%@\",\"actuserid\":\"%@\"}",SERVERID,_fromDic[@"id"],@"1",USER_ID];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    NSLog(@"dict======%@",dict);
    
    
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
     manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
          _exeArray=dictt[@"DATA"];
            
            
            NSLog(@"111111111111111====%@",_exeArray);
            
            
            
            
            [self requestForAct];
            
        }else{
            
            
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
}
//获取动作单元
-(void)requestForAct{
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    
    
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10513\",\"serverid\":\"%@\",\"sceneid\":\"%@\",\"typecode\":\"%@\",\"actuserid\":\"%@\"}",SERVERID,_fromDic[@"id"],@"2",USER_ID];
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    NSLog(@"dict======%@",dict);
    
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
           _actArray=dictt[@"DATA"];
            
            
            //NSLog(@"2222222222222222====%@",_actArray[0]);
           // [self requestForTime];
            [self.myTable reloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };

}
////查询时间
//-(void)requestForTime{
//    
//    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
//    
//    
//    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10514\",\"serverid\":\"%@\",\"sceneid\":\"%@\"}",_fromDic[@"serverid"],_fromDic[@"sceneid"]];
//    
//    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
//    NSLog(@"dict======%@",dict);
//    
//    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
//    
//    manager.backSuccess = ^void(NSDictionary *dictt)
//    {
//        
//        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
//            // NSLog(@"dict:==%@",dictt[@"DATA"]);
//            _timerArray=dictt[@"DATA"];
//            NSLog(@"3333333333333333====%@",_timerArray
//                  );
//            [self.myTable reloadData];
//            
//            
//        }else{
//            
//            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
//            
//        }
//    };
//}


//添加定时请求
-(void)requesToAddTimer{
    [SVProgressHUD showWithStatus:@"加载中..."];
    self.hours =[self getHourStrFromDate:_dataPicker.date];
    self.minites=[self getMinStrFromDate:_dataPicker.date];
    
    
    
    NSLog(@"self.mut===%@",self.minites);
    NSLog(@"self hour ==%@",self.hours);
    
    
    NSLog(@"weekSecr====%@",self.weekSelectarray);
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    
    
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10508\",\"sceneid\":\"%@\",\"boolmon\":\"%@\",\"booltues\":\"%@\",\"boolwednes\":\"%@\",\"boolthurs\":\"%@\",\"boolfri\":\"%@\",\"boolstatur\":\"%@\",\"boolsun\":\"%@\",\"fhour\":\"%@\",\"fmin\":\"%@\",\"booluse\":\"%@\",\"actuserid\":\"%@\"}",_fromDic[@"id"],self.weekSelectarray[1],self.weekSelectarray[2],self.weekSelectarray[3],self.weekSelectarray[4],self.weekSelectarray[5],self.weekSelectarray[6],self.weekSelectarray[0],self.hours,self.minites,@"1",USER_ID];
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    NSLog(@"dict======%@",dict);
    
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];

            //[self requestForTime];
            
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };



}
//删除执行单元
-(void)requetToDelteExe:(NSDictionary*)aDic{
    
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    
    
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10517\",\"serverid\":\"%@\",\"id\":\"%@\",\"actuserid\":\"%@\"}",_fromDic[@"serverid"],aDic[@"id"],USER_ID];
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    NSLog(@"dict======%@",dict);
    
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
            
            [self requestForExe];
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
    
    
}
//删除动作单元
-(void)requetToDelteAction:(NSDictionary*)aDic{
    
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    
    
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10518\",\"serverid\":\"%@\",\"id\":\"%@\",\"actuserid\":\"%@\"}",_fromDic[@"serverid"],aDic[@"id"],USER_ID];
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    NSLog(@"dict======%@",dict);
    
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
            
            [self requestForAct];
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
    
    
}

////删除定时
//-(void)requetToDelteTimer:(NSDictionary*)aDic{
//
//    
//    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
//    
//
//    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10519\",\"serverid\":\"%@\",\"id\":\"%@\",\"actuserid\":\"%@\"}",_fromDic[@"serverid"],aDic[@"id"],USER_ID];
//    
//    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
//    NSLog(@"dict======%@",dict);
//    
//    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
//    
//    manager.backSuccess = ^void(NSDictionary *dictt)
//    {
//        
//        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
//            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
//
//            //[self requestForTime];
//        }else{
//            
//            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
//            
//        }
//    };
//
//
//}
//

//请求延时。
-(void)requetTimer:(NSDictionary*)aDic{
    
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    
    
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10507\",\"serverid\":\"%@\",\"id\":\"%@\",\"actuserid\":\"%@\"}",_fromDic[@"serverid"],aDic[@"id"],USER_ID];
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    NSLog(@"dict======%@",dict);
    
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
            
            //[self requestForTime];
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
    
    
}
//修改执行单元的定时，修改开关
-(void)requestToChangeValuewithAdic:(int)index{
    
    NSDictionary *dic=_exeArray[index];
    actionCell  *cell =(actionCell*)[self.view viewWithTag:index+100];
    
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10515\",\"id\":\"%@\",\"sceneid\":\"%@\",\"scenetype\":\"%@\",\"deviceid\":\"%@\",\"addr\":\"%@\",\"onstatus\":\"%d\",\"highvalue\":\"%@\",\"lowvalue\":\"%@\",\"value\":\"%d\",\"triggermode\":\"%d\",\"delaytime\":\"%d\",\"typecode\":\"%@\",\"actuserid\":\"%@\",\"serverid\":\"%@\"}",dic[@"id"],dic[@"sceneid"],_fromDic[@"hostsceneid"],dic[@"deviceid"],dic[@"addr"],cell.SWitch.on,dic[@"highvalue"],dic[@"lowvalue"],cell.SWitch.on,0,value,@"1",USER_ID,SERVERID ];
    
    
    NSLog(@"urlstrinhf====%@",urlstring);
    
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
            
            //[self requestForTime];
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
    
}

//修改动作单元的定时，修改开关
-(void)requestTWOActionChangeValuewithAdic:(int)index{
    
    
    NSLog(@"index====%d",index);
    NSLog(@"dic====%@",_actArray[index]);
    NSDictionary *dic=_actArray[index];
    actionCell  *cell =(actionCell*)[self.view viewWithTag:index+10];
    
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10516\",\"id\":\"%@\",\"sceneid\":\"%@\",\"scenetype\":\"%@\",\"deviceid\":\"%@\",\"addr\":\"%@\",\"onstatus\":\"%d\",\"highvalue\":\"%@\",\"lowvalue\":\"%@\",\"value\":\"%d\",\"triggermode\":\"%d\",\"delaytime\":\"%d\",\"typecode\":\"%@\",\"actuserid\":\"%@\",\"serverid\":\"%@\"}",dic[@"id"],dic[@"sceneid"],_fromDic[@"hostsceneid"],dic[@"deviceid"],dic[@"addr"],cell.SWitch.on,dic[@"highvalue"],dic[@"lowvalue"],cell.SWitch.on,0,value,@"2",USER_ID,SERVERID ];
    
    
    NSLog(@"urlstrinhf====%@",urlstring);
    
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
            
            //[self requestForTime];
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
    
}




@end
