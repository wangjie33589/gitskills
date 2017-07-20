//
//  work_task_addVC.m
//  Proxy_ios
//
//  Created by sciyonSoft on 16/1/21.
//  Copyright © 2016年 keyuan. All rights reserved.
//

#import "work_task_addVC.h"
#import "workFlowupTable.h"
#import "PeopleViewController.h"

@interface work_task_addVC ()<PeopleViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>{
    NSDictionary* showData;
    NSString *FPSTIME;
    NSString *FRSNNAME;
    NSDictionary * showDataDict;
    UITableView *listTableView;
    UIDatePicker* datePicker;
    UIView * pView;
    NSString* isEnd;
    NSString *BeginTime;
    NSString *currentTime;
    NSDictionary *dict1;
    NSString *FCODE;
    NSString *SAVETYPE;
    NSString *FGUID;
    NSDictionary *GuidDic;
    NSArray *showArray;
    NSString *GUID;
    NSString *FTASKID;
    NSString *UPDATESTAMP;
    NSString *dataStr;
    workFlowupTable *table;
    BOOL tableisShow;
}

@end

@implementation work_task_addVC

- (void)viewDidLoad {
    [super viewDidLoad];
    dataStr=@"";
    tableisShow=YES;
    self.taskName.returnKeyType=UIReturnKeyDone;
    self.expextTime.returnKeyType=UIReturnKeyDone;
    self.myTextviee.returnKeyType=UIReturnKeyDone;
    [self.handelPerson setEnabled:NO];
    self.taskName.delegate=self;
    self.expextTime.delegate=self;
self.myTextviee.delegate=self;
    GUID=@"";
    FTASKID=@"";
    [self initRightItemBtn];
    [self initPikerView];
    [self initdropDownMenu];
    [self requestImport];
    
}
-(id)initWithArray:(NSDictionary *)Dic{
    self =[super init];
    
    
    if (self) {
        GuidDic=Dic;
    }
    
    return self;
    
    
}
//保存

- (IBAction)saveBtn:(UIButton *)sender {
    NSString *dataXmlStr;
    
    NSString *benginTimeString =[self.beginTime.titleLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *endtimeString =[self.endTime.titleLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if ([benginTimeString intValue]>[endtimeString intValue]) {
        [SVProgressHUD showErrorWithStatus:@"结束时间不能够大于开始时间"];
        return;
        
    }
    
    NSArray *array =[[NSArray alloc]initWithObjects:self.beginTime.titleLabel.text,self.endTime.titleLabel.text,self.expextTime.text,self.handelPerson.text,self.taskName.text,self.myTextviee.text, nil];
   NSArray *nameArray=[[NSArray alloc]initWithObjects:@"开始时间",@"结束时间",@"预计时间",@"处理人",@"任务名称", @"任务内容",nil];
    for ( int index=0; index<array.count; index++) {
        if ([array[index] isEqualToString:@""]||array[index]==nil||[array[index] isEqual:[NSNull null]]||[array[index] isEqualToString:@"任务名称："]) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"必填项(%@)为空",nameArray[index]]];
             return ;
        }
    }
    
    
    
        if ([GUID isEqualToString:@""]&[FTASKID isEqualToString:@""]) {
            dataXmlStr = [NSString stringWithFormat:@"&lt;Data&gt;&lt;Action&gt;SAVEBILL&lt;/Action&gt;&lt;FCLASS&gt;0&lt;/FCLASS&gt;&lt;FTYPEGUID&gt;BEDB6D34F1994C82A152D3D49E48FD7E&lt;/FTYPEGUID&gt;&lt;FTYPENAME&gt;日常工作&lt;/FTYPENAME&gt;&lt;FDELAY&gt;0&lt;/FDELAY&gt;&lt;FUGUID&gt;D9816E0F1F4B4D978045A3CA9CF83FEC&lt;/FUGUID&gt;&lt;FITEMNAME&gt;&lt;/FITEMNAME&gt;&lt;FITEMGUID&gt;&lt;/FITEMGUID&gt;&lt;FISGUID&gt;&lt;/FISGUID&gt;&lt;FISNAME&gt;&lt;/FISNAME&gt;&lt;FPCGUID&gt;&lt;/FPCGUID&gt;&lt;FPCNAME&gt;&lt;/FPCNAME&gt;&lt;FASS&gt;0&lt;/FASS&gt;&lt;FLEVELGUID&gt;F336F3F91785452CB36EB49C5237FA6E&lt;/FLEVELGUID&gt;&lt;FLEVELNAME&gt;高&lt;/FLEVELNAME&gt;&lt;FPSTIME&gt;%@&lt;/FPSTIME&gt;&lt;FPETIME&gt;%@&lt;/FPETIME&gt;&lt;FPHOURS&gt;%@&lt;/FPHOURS&gt;&lt;FRUGUID&gt;DFBFBD2819FB4A17804534D98EBCD7D3&lt;/FRUGUID&gt;&lt;FRUNAME&gt;%@&lt;/FRUNAME&gt;&lt;FCSUGUID&gt;undefined&lt;/FCSUGUID&gt;&lt;FCSUID&gt;undefined&lt;/FCSUID&gt;&lt;FCSUNAME&gt;&lt;/FCSUNAME&gt;&lt;FTITLE&gt;%@&lt;/FTITLE&gt;&lt;FCONTENT&gt;%@&lt;/FCONTENT&gt;&lt;/Data&gt;",self.beginTime.titleLabel.text,self.endTime.titleLabel.text,self.expextTime.text,self.handelPerson.text,self.taskName.text,self.myTextviee.text];//拼接整个data xml

            
        }else{
            dataXmlStr = [NSString stringWithFormat:@"&lt;Data&gt;&lt;Action&gt;SAVEBILL&lt;/Action&gt;&lt;FGUID&gt;%@&lt;/FGUID&gt;&lt;FTASKID&gt;%@&lt;/FTASKID&gt;&lt;UPDATESTAMP&gt;%@&lt;/UPDATESTAMP&gt;&lt;FCLASS&gt;0&lt;/FCLASS&gt;&lt;FTYPEGUID&gt;BEDB6D34F1994C82A152D3D49E48FD7E&lt;/FTYPEGUID&gt;&lt;FTYPENAME&gt;日常工作&lt;/FTYPENAME&gt;&lt;FDELAY&gt;0&lt;/FDELAY&gt;&lt;FUGUID&gt;D9816E0F1F4B4D978045A3CA9CF83FEC&lt;/FUGUID&gt;&lt;FITEMNAME&gt;&lt;/FITEMNAME&gt;&lt;FITEMGUID&gt;&lt;/FITEMGUID&gt;&lt;FISGUID&gt;&lt;/FISGUID&gt;&lt;FISNAME&gt;&lt;/FISNAME&gt;&lt;FPCGUID&gt;&lt;/FPCGUID&gt;&lt;FPCNAME&gt;&lt;/FPCNAME&gt;&lt;FASS&gt;0&lt;/FASS&gt;&lt;FLEVELGUID&gt;F336F3F91785452CB36EB49C5237FA6E&lt;/FLEVELGUID&gt;&lt;FLEVELNAME&gt;高&lt;/FLEVELNAME&gt;&lt;FPSTIME&gt;%@&lt;/FPSTIME&gt;&lt;FPETIME&gt;%@&lt;/FPETIME&gt;&lt;FPHOURS&gt;%@&lt;/FPHOURS&gt;&lt;FRUGUID&gt;DFBFBD2819FB4A17804534D98EBCD7D3&lt;/FRUGUID&gt;&lt;FRUNAME&gt;%@&lt;/FRUNAME&gt;&lt;FCSUGUID&gt;undefined&lt;/FCSUGUID&gt;&lt;FCSUID&gt;undefined&lt;/FCSUID&gt;&lt;FCSUNAME&gt;&lt;/FCSUNAME&gt;&lt;FTITLE&gt;%@&lt;/FTITLE&gt;&lt;FCONTENT&gt;%@&lt;/FCONTENT&gt;&lt;/Data&gt;",GUID,FTASKID,UPDATESTAMP,self.beginTime.titleLabel.text,self.endTime.titleLabel.text,self.expextTime.text,self.handelPerson.text,self.taskName.text,self.myTextviee.text];//拼接整个data xml
              }
    dataStr=[self xmlxtr:dataXmlStr];
   // }
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[self xmlxtr:dataXmlStr],@"FormInfo",@"SAVEFORM",@"Action",@"Sciyon.SyncPlant.MIS.Bll.RSM.WorkTask.WorktaskCRUD,Sciyon.SyncPlant.MIS.Bll.RSM",@"DataType", nil];
                   MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/%@",HTTPIP,SLRD,MOBILE_URL] withParameter:dict];
        manager.backSuccess = ^void(NSDictionary *dictt)
        {
            if ([[dictt objectForKey:@"success"] integerValue] == 1) {
                GUID=dictt[@"GUID"];
                FTASKID=dictt[@"Data"][@"FTASKID"];
                UPDATESTAMP=dictt[@"UPDATESTAMP"];
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                
            }else{
                [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
            }
        };
   
    
    
}

-(NSString *)xmlxtr :(NSString *)dataXmlStr{

    NSString *newDataXmlStr =[dataXmlStr stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    NSString *lastDataXmlStr =[newDataXmlStr stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    return lastDataXmlStr;
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;



}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    pView.hidden=YES;
    if ( IPHONE_5) {
           [self animateWithFrame:-150];
    }else {
     [self animateWithFrame:-80];
    
    
    }


}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
   
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
  
    return YES;



}
-(void)textViewDidEndEditing:(UITextView *)textView{
    pView.hidden=NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, 64.0f, self.view.frame.size.width, self.view.frame.size.height);
    }];
    






}
- (void)animateWithFrame:(float)frameY
{
  
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, frameY, self.view.frame.size.width, self.view.frame.size.height);
    }];
      }
-(void)callModalList{
    //GuidDic =[[NSMutableDictionary alloc]init];
  if (tableisShow) {
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"489F00CA2807465CA465F8457D25FAC2",@"FLOWGUID",@"",@"FLOWVERSION",@"INITWFCONTROL",@"Action",@"",@"DATAGUID",@"",@"FLOWINSTANCEGUID",@"normal",@"SHOWSTATUS",@"",@"PROCESSGUID",@"",@"HGUID",@"Sciyon.SyncPlant.MIS.Bll.RSM.WorkTask.WorktaskCRUD,Sciyon.SyncPlant.MIS.Bll.RSM",@"DATATYPE",dataStr,@"DATASTR",nil];
        table=[[workFlowupTable alloc]initWithData:dict];
    //[self.navigationController pushViewController:table animated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (IBAction)TimeBtnclick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 100:{
            
            [self timeClick];
            
        }
            
            break;
            
        case  200:{
            [self endTimeClick];
            
            
            
        }
            break;
    }

   
}


-(void)initPikerView{
    
    
    
    
    
    UITapGestureRecognizer * time = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(timeClick)];
    [self.beginTime addGestureRecognizer:time];
    
    
    UITapGestureRecognizer * end = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endTimeClick)];
    [self.endTime addGestureRecognizer:end];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal
                               components:NSYearCalendarUnit | NSMonthCalendarUnit|NSCalendarUnitDay|kCFCalendarUnitHour
                               fromDate:now];
    comps.hour = 8;
    NSDate *firstDay = [cal dateFromComponents:comps];
    BeginTime = [formatter stringFromDate:firstDay];
    [self.beginTime setTitle:BeginTime forState:0];
    comps.hour=17;
    
    
    NSDate *lasDAta =[cal  dateFromComponents:comps];
    
    currentTime = [formatter stringFromDate:lasDAta];
    [self.endTime setTitle:currentTime forState:0];

    
    
    
    
    pView = [[UIView alloc] initWithFrame:CGRectMake(0, LHeight, LWidth, 190)];
    pView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pView];
    [self.view bringSubviewToFront:pView];
    
    //    取消按钮
    UIButton* returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(10, 0, 50, 30);
    returnBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [returnBtn setTitle:@"取消" forState:0];
    [returnBtn setTitleColor:[UIColor colorWithRed:0.000 green:0.800 blue:0.600 alpha:1] forState:0];
    [returnBtn addTarget:self action:@selector(returnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [pView addSubview:returnBtn];
    
    //    确定按钮
    UIButton* endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    endBtn.frame = CGRectMake(LWidth-60, 0, 50, 30);
    endBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [endBtn setTitle:@"完成" forState:0];
    [endBtn setTitleColor:[UIColor colorWithRed:0.000 green:0.800 blue:0.600 alpha:1] forState:0];
    [endBtn addTarget:self action:@selector(endBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [pView addSubview:endBtn];
    
    //    横线
    UIImageView* bgimagViewA = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
    bgimagViewA.frame = CGRectMake(0, 0, LWidth, 2);
    [pView addSubview:bgimagViewA];
    UIImageView* bgimagViewB = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
    bgimagViewB.frame = CGRectMake(0, 28, LWidth, 2);
    [pView addSubview:bgimagViewB];
    
    
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, LWidth, 160)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    datePicker.minuteInterval = 5;
    datePicker.backgroundColor = [UIColor whiteColor];
    [pView addSubview:datePicker];
    
    
    
    
    
}


- (void)returnBtnClick:(UIButton *)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        pView.frame = CGRectMake(0, LHeight, LWidth, 190);
    }];
}
- (void)endBtnClick:(UIButton *)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        pView.frame = CGRectMake(0, LHeight, LWidth, 190);
    }];
    NSDate *select = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
    if ([isEnd isEqualToString:@"开始"])[self.beginTime  setTitle:dateAndTime forState:0];;   if ([isEnd isEqualToString:@"结束"] )[self.endTime  setTitle:dateAndTime forState:0];
}
- (void)timeClick
{
    NSLog(@"enddddddd=kaisgiu");
    isEnd = @"开始";
    [UIView animateWithDuration:0.25 animations:^{
        pView.frame = CGRectMake(0, LHeight-255, LWidth, 190);
    }];
}
- (void)endTimeClick
{
    NSLog(@"enddddddd=jieshu");
    isEnd = @"结束";
    [UIView animateWithDuration:0.25 animations:^{
        pView.frame = CGRectMake(0, LHeight-255, LWidth, 190);
    }];
}

- (void)initdropDownMenu;//班组
{
    [self.impontBtn setTitle:showDataDict[@"ITEMNAME"] forState:0];
    self.impontBtn.userInteractionEnabled=-NO;
    //[self.impontBtn setTitle:@"高" forState:UIControlStateNormal];
    listTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.impontBtn.center.x, self.impontBtn.center.y, LWidth/3+20, 100)];
    listTableView.hidden = YES;
    listTableView.delegate = self;
    listTableView.dataSource = self;
    listTableView.rowHeight = 20;
    listTableView.tag = 0;
    listTableView.backgroundColor = [UIColor whiteColor];
    listTableView.layer.borderColor = [[UIColor colorWithRed:0.773 green:0.780 blue:0.776 alpha:1] CGColor];
    listTableView.layer.borderWidth = .5f;
    [listTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:listTableView];
}

#pragma mark=====tableviewDelegte
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idfer=@"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:idfer];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idfer];
    }
    NSArray *arr =[[NSArray alloc]initWithObjects:@"高",@"低", nil];
    cell.textLabel.text=arr[indexPath.row];
    
    
    
    return cell;
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        [self.impontBtn setTitle:@"高" forState:UIControlStateNormal];
        
        
        listTableView.hidden=YES;
        self.impontBtn.tag=1;
        
    }else{
        [self.impontBtn setTitle:@"低" forState:UIControlStateNormal];
        
        listTableView.hidden=YES;
        self.impontBtn.tag=2;
        
        
        
        
    }
    
    
    
    
}




- (IBAction)chosepersonBtn:(id)sender {
    PeopleViewController* peopleVC =[[PeopleViewController alloc] initWithType:@"12"];
    peopleVC.delegate = self;
    [self.navigationController pushViewController:peopleVC animated:YES];
}
-(void)All_backUpDataViewController:(NSArray *)array data:(NSDictionary *)dict type:(NSString *)aType{
    
    if (array.count>0) {
        self.handelPerson.text=array[0][@"FDISPLAYNAME"];

    }
    
   // NSLog(@"arrayyyy======%@   type=========%@",array,aType);
    
    
    

}
- (void)requestImport
{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    
    NSDictionary* dict =[NSDictionary dictionaryWithObjectsAndKeys:@"GETCATITEMS",@"Action",@"ERP_OA_TASKLEVEL",@"CATCODE",@"0",@"ALLSHOW", nil];
    
    NSLog(@"搜索条件==========%@",dict);
    
    
    
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/ProxyMobile/MobileFrame.ashx",HTTPIP,SLRD] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
          
          // showArray = [NSMutableArray arrayWithArray:[dictt objectForKey:@"Data"]];
            showDataDict=[dictt objectForKey:@"Data"][@"Items"];
            NSLog(@"shoedict===%@",showDataDict);
            [self initdropDownMenu];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}

//-(void)backUpDataViewController:(NSArray *)array data:(NSDictionary *)dict type:(NSString *)aType{
//
//
// NSLog(@"arrayyyy======%@   type=========%@",array,aType);
//
//}

- (IBAction)impotnClick:(id)sender {
    listTableView.hidden=NO;

}
@end
