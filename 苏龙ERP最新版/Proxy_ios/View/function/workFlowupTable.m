//
//  Task_Two_ViewController.m
//  Proxy_ios
//
//  Created by E-Bans on 15/11/24.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "workFlowupTable.h"
#import "Task_Two_ViewController.h"
#import "XMLDictionary.h"
#import "TopView.h"
#import "scheduleTableView.h"
#import "Task_TableViewCell.h"
#import "PeopleViewController.h"
#import "ChangeViewController.h"
#import "AddRowViewController.h"
#import "UpData.h"
#import "IGLDropDownMenu.h"
#import "PeopleModel.h"
#import "PerplelistViewController.h"
#import "InformationViewController.h"
#import "NSViewController.h"

@interface workFlowupTable () <scheduleTableViewDelegate,NSXMLParserDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,IGLDropDownMenuDelegate,UITextViewDelegate,PerplelistViewControllerDelegate,PeopleViewControllerDelegate>
{
    NSDictionary* taskDict;
    
    NSMutableDictionary* showDictA;
    
    NSMutableArray* buttonsArray;
    
    NSDictionary* xmlDataDict;//返回的xml总数据
    NSDictionary* xmlData;//筛选出来的当前流程数据
    
    NSString* isGuid;
    
    NSString* appdbconn1;
    NSString* appdbtable1;
    NSString* appdbid;
    
    NSMutableDictionary* showDictB;
    NSMutableDictionary* showDictD;
    
    NSMutableDictionary* xmlDic;
    NSMutableArray* titleArray;
    NSMutableArray* showCountArray;//附表单
    NSMutableArray* showMainArray;
    CGRect xmlContens;
    UIScrollView* mainScroll;
    UIView* alertView;
    UITableView* upTable;
    
    UILabel* contens;
    UIView* upView;
    NSString* DataType;
    UIView* pView;
    UIView* pDView;
    UIView* pDTView;
    UIPickerView* pickView;
    NSArray* whenArray;
    NSString* timeStr;
    NSMutableArray* pointsArray;
    UIDatePicker* datePicker;
    UIDatePicker* dateTimePicker;
    NSInteger timeIndex;
    NSInteger dateTimeIndex;
    NSString* dataXmlStr;
    
    NSString* IsAdd;
    NSString* VIRTUALPATH;
    
    UIView* Comments;
    UIButton* chooseCom;
    UIView* chooseCB;
    UITextView* textView;
    NSInteger commIndex;
    
    NSString* userInfoId;
    NSString* isShow;
    UIImageView* imagvD;
    NSString* dateTimeStr;
    NSString* dateStr;
    NSString *FLOWGUID;
    NSString *FLOWVERSION;
    NSString *HGUID;
    NSString *DATAGUID;
    NSString *PROCESSGUID;
    NSString *FLOWINSTANCEGUID;
    NSString *ShowFile;
    
   }
@property (nonatomic, strong) IGLDropDownMenu *dropDownMenu;
@end

@implementation workFlowupTable
- (id)initWithData:(NSDictionary *)aData
{
    self = [super init];
    if (self) {
        taskDict = aData;
        NSLog(@"tasrt=====%@",taskDict);
}
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self timeView];
    self.title=@"流程处理";
    whenArray = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
    pointsArray = [[NSMutableArray alloc] init];
    for (NSInteger index = 01; index < 60; index ++) {
        NSString* time = [NSString stringWithFormat:@"%ld",(long)index];
        if (index<10) {
            time = [NSString stringWithFormat:@"0%@",time];
        }
        [pointsArray addObject:time];
    }
    
    [self dateTimeView];
       self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //[self requestShowDataList1];
     [self requestShowDataList2];
    
  }
- (void)initViewXml
{
    for (NSInteger index = 0; index < [[[xmlDataDict objectForKey:@"Activities"] objectForKey:@"Activity"] count]; index ++) {
        if ([[[[[xmlDataDict objectForKey:@"Activities"] objectForKey:@"Activity"] objectAtIndex:index] objectForKey:@"_stepId"] isEqualToString:isGuid]) {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            
            if ([[[[[xmlDataDict objectForKey:@"Activities"] objectForKey:@"Activity"] objectAtIndex:index] allKeys] containsObject:@"StopApp"])
            {
                isShow = [[[[xmlDataDict objectForKey:@"Activities"] objectForKey:@"Activity"] objectAtIndex:index] objectForKey:@"StopApp"];
            }
            if ([[[[[xmlDataDict objectForKey:@"Activities"] objectForKey:@"Activity"] objectAtIndex:index] allKeys] containsObject:@"ShowFile"])
            {
                ShowFile= [[[[xmlDataDict objectForKey:@"Activities"] objectForKey:@"Activity"] objectAtIndex:index] objectForKey:@"StopApp"];
            }
            
            if ([[[[[xmlDataDict objectForKey:@"Activities"] objectForKey:@"Activity"] objectAtIndex:index] objectForKey:@"AppDbOther"] isKindOfClass:[NSDictionary class]]) {
                [array addObject:[[[[xmlDataDict objectForKey:@"Activities"] objectForKey:@"Activity"] objectAtIndex:index] objectForKey:@"AppDbOther"]];
            }else{
                array = [[[[xmlDataDict objectForKey:@"Activities"] objectForKey:@"Activity"] objectAtIndex:index] objectForKey:@"AppDbOther"];
            }
            
            appdbconn1 = [[[[xmlDataDict objectForKey:@"Activities"] objectForKey:@"Activity"] objectAtIndex:index] objectForKey:@"AppDbConn"];
            appdbtable1 = [[[[xmlDataDict objectForKey:@"Activities"] objectForKey:@"Activity"] objectAtIndex:index] objectForKey:@"AppDbTable"];
            appdbid = [[[[xmlDataDict objectForKey:@"Activities"] objectForKey:@"Activity"] objectAtIndex:index] objectForKey:@"AppFlowField"];
            showMainArray = [NSMutableArray arrayWithArray:[[[[[xmlDataDict objectForKey:@"Activities"] objectForKey:@"Activity"] objectAtIndex:index] objectForKey:@"AppDb"] objectForKey:@"R"]];
            xmlData = [NSDictionary dictionaryWithDictionary:[[[xmlDataDict objectForKey:@"Activities"] objectForKey:@"Activity"] objectAtIndex:index]];
            
            
            NSLog(@"xmnlDATA=======%@",xmlData);
            
            
            for (NSInteger i = 0; i < array.count; i ++) {
                if ([[array objectAtIndex:i] objectForKey:@"_USE"]) {
                    [showCountArray addObject:[array objectAtIndex:i]];
                    
                    [titleArray addObject:[array[i] objectForKey:@"_NAME"]];
                }
            }
            break;
        }
    }
  
    if (![isShow isEqualToString:@"true"]) {
        //self.navigationItem.rightBarButtonItem = nil;
        [SVProgressHUD showErrorWithStatus:@"此流程不可在APP客户端操作"];
        [buttonsArray removeAllObjects];
        NSDictionary* prossBtn = [NSDictionary dictionaryWithObjectsAndKeys:@"-2",@"@Type",@"流程信息",@"Name", nil];
        [buttonsArray addObject:prossBtn];
        
    }
    if ([ShowFile isEqualToString:@"true"]) {
        NSDictionary* fileBtn = [NSDictionary dictionaryWithObjectsAndKeys:@"-3",@"@Type",@"附件",@"Name", nil];
        [buttonsArray addObject:fileBtn];
    }
}


//获取流程信息数据 获取右上角按钮之前需要用到的数据
- (void)requestShowDataList1  //右上角按钮前置@"HGUID" [taskDict objectForKey:@"HGUID"]
{
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETMOBILEURL",@"Action",@"4 F336F3F91785452CB36EB49C5237FA6E",@"IGUID", nil];
    NSLog(@"taskdict====%@",dict);
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/%@",HTTPIP,SLRD,MOBILE_URL] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            showDictA = [NSMutableDictionary dictionaryWithDictionary:[[dictt objectForKey:@"Data"] objectForKey:@"R"]];
            
            
            
            [self requestShowDataList2];
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}
//直接从第二次请求开始

- (void)requestShowDataList2 //右上角按钮
{

    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/%@",HTTPIP,SLRD,MOBILE_URL] withParameter:taskDict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
          buttonsArray = [[NSMutableArray alloc] init];
        
        NSLog(@"dictttt====%@",dictt);
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            showDictA = [NSMutableDictionary dictionaryWithDictionary:[dictt objectForKey:@"Data"]];

            if ([[[dictt objectForKey:@"Data"] objectForKey:@"BUTTONS"] isKindOfClass:[NSDictionary class]]||[[[dictt objectForKey:@"Data"] objectForKey:@"BUTTONS"] isKindOfClass:[NSArray class]]) {
                
                NSMutableArray* butt = [[NSMutableArray alloc] init];
                //如果返回的流程列表是一个字典，把字典里面的东西加入到数组当中
                if ([[[[dictt objectForKey:@"Data"] objectForKey:@"BUTTONS"] objectForKey:@"Button"] isKindOfClass:[NSDictionary class]]) {
                    [butt addObject:[[[dictt objectForKey:@"Data"] objectForKey:@"BUTTONS"] objectForKey:@"Button"]];
                }else{
                    //如果返回的流程是一个数组，直接取出数组
                    butt = [NSMutableArray arrayWithArray:[[[dictt objectForKey:@"Data"] objectForKey:@"BUTTONS"] objectForKey:@"Button"]];
                }
              
                for (NSInteger index = 0; index < butt.count; index ++) {
                    NSString* type = [[butt objectAtIndex:index] objectForKey:@"@Type"];
                    if ([type isEqualToString:@"0"]||[type isEqualToString:@"1"]||[type isEqualToString:@"2"]||[type isEqualToString:@"3"]||[type isEqualToString:@"4"]||[type isEqualToString:@"6"]||[type isEqualToString:@"8"]||[type isEqualToString:@"9"]||[type isEqualToString:@"11"]||[type isEqualToString:@"20"]||[type isEqualToString:@"12"]) {
                        [buttonsArray addObject:[butt objectAtIndex:index]];
                    }
                    if (index==butt.count-1) {
                        NSDictionary* processBtn = [NSDictionary dictionaryWithObjectsAndKeys:@"-2",@"@Type",@"流程信息",@"Name", nil];
                        [buttonsArray addObject:processBtn];
                        
                        NSLog(@"buttonsDFHSdvadsfv====%@",buttonsArray);
                        }
                }
                IsAdd = [[dictt objectForKey:@"Data"] objectForKey:@"ISADD"];
                DataType = [[dictt objectForKey:@"Data"] objectForKey:@"DATATYPE"];
                VIRTUALPATH = [[dictt objectForKey:@"Data"] objectForKey:@"VIRTUALPATH"];
                
                FLOWGUID=[[dictt objectForKey:@"Data"] objectForKey:@"FLOWGUID"];
                FLOWVERSION=[[dictt objectForKey:@"Data"] objectForKey:@"FLOWVERSION"];
                HGUID=[[dictt objectForKey:@"Data"] objectForKey:@"HGUID"];
                DATAGUID=[[dictt objectForKey:@"Data"] objectForKey:@"DATAGUID"];
                PROCESSGUID=[[dictt objectForKey:@"Data"] objectForKey:@"PROCESSGUID"];
                FLOWINSTANCEGUID=[[dictt objectForKey:@"Data"] objectForKey:@"FLOWINSTANCEGUID"];
                         [self.tableView reloadData];
                 [self requestShowDataList3];
               
            }else{
                if ([[dictt objectForKey:@"Data"] objectForKey:@"BUTTONS"]==nil||[[[dictt objectForKey:@"Data"] objectForKey:@"BUTTONS"] isEqual:[NSNull null]]||[[[dictt objectForKey:@"Data"] objectForKey:@"BUTTONS"] isEqualToString:@""]) {
//                    NSDictionary* processBtn = [NSDictionary dictionaryWithObjectsAndKeys:@"-2",@"@Type",@"流程信息",@"Name", nil];
//                    [buttonsArray addObject:processBtn];
                    [self.tableView reloadData];
                    [self requestShowDataList3];
                }
            }
        }else{
            //            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}
- (void)requestShowDataList3//获取xml布局控件
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:FLOWGUID,@"FLOWGUID",FLOWVERSION,@"FLOWVERSION",@"GETFLOWINFOCONFIG",@"Action",HGUID,@"HGUID", nil];
  
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/%@",HTTPIP,SLRD,MOBILE_URL] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        NSLog(@"dicyyyyyy===%@",dictt);
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            xmlDataDict = [NSDictionary dictionaryWithXMLString:[[[dictt objectForKey:@"Data"] objectForKey:@"WF_FLOWINFO"] objectForKey:@"CONTENT"]];
            
            NSLog(@"xmldaduct==========%@",xmlDataDict);
            isGuid = [dictt objectForKey:@"GUID"];
            [self initViewXml];
        }else{
            //            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}
//获取表单数据
- (void)requestShowDataList4//获取xml控件数据
{//获取表单数据
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:appdbconn1,@"APPDBCONN",@"GETDETAILFLOWDATA",@"Action",appdbtable1,@"APPDBTABLE",@"",@"GUID",appdbid,@"APPFLOWFIELD", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/%@",HTTPIP,SLRD,MOBILE_URL] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            showDictD = [NSMutableDictionary dictionaryWithDictionary:[[dictt objectForKey:@"Data"] objectForKey:@"R"]];
            
            NSLog(@"SHODICT===%@",showDictD);
         
           //[self initMainTable];
        }else{
            //            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}



- (void)RowViewController:(NSString *)xmlStr data:(NSDictionary *)aData rowData:(NSArray *)rowArray isType:(NSString *)type
{
    if ([type isEqualToString:@"修改"]||[type isEqualToString:@"查看"]) {
        ChangeViewController* changeVC = [[ChangeViewController alloc] initWithXmlStr:xmlStr data:aData type:rowArray title:type];
        [self.navigationController pushViewController:changeVC animated:YES];
    }else if ([type isEqualToString:@"添加"]) {
        AddRowViewController* addVC = [[AddRowViewController alloc] initWithXmlStr:xmlStr data:aData type:rowArray];
        [self.navigationController pushViewController:addVC animated:YES];
    }
}
//右上角按钮对应的下拉框图表代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//右上角按钮对应的下拉框图表代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [buttonsArray count];
}
//右上角按钮对应的下拉框图表代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"CellIdentifier";
    Task_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Task_TableViewCell" owner:nil options:nil];
        for (id oneObject in nib)
        {
            if ([oneObject isKindOfClass:[Task_TableViewCell class]])
            {
                cell = (Task_TableViewCell *)oneObject;
            }
        }
    }
    cell.backgroundColor=[UIColor whiteColor];
    tableView.backgroundColor=[UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:0.3];
    cell.title.text = [[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"Name"];
    return cell;
}
//右上角按钮对应的下拉框图表代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"@Type"]);
    [tableView reloadData];
    alertView.hidden = YES;
    NSString* nullStr = @"";
    
    
    //进入流程处理页面
      if ([[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"@Type"] isEqualToString:@"-2"]) {
          NSDictionary* dict;
         if (![FLOWINSTANCEGUID isEqualToString:@""]) {

              dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETOPINIONLIST",@"Action",FLOWINSTANCEGUID,@"FLOWINSTANCEGUID", nil];
          
         }else if(![HGUID isEqualToString:@""]){
         
             dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETOPINIONLISTBYHGUID",@"Action",HGUID,@"HGUID", nil];
             
         }else{
              dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETOPINIONLISTBYDATAGUID",@"Action",DATAGUID,@"DATAGUID", nil];
         
         }

               NSString* url = [NSString stringWithFormat:@"http://%@%@/WorkFlowWebDesigner/Mobile/FlowInfo/WorkFlowGraph.aspx?FlowGuid=%@&FlowVersion=%@&FlowInstance=%@",HTTPIP,SLRD,FLOWGUID,FLOWVERSION,FLOWINSTANCEGUID];
          
          NSLog(@"urllll===%@",url);
          NSLog(@"dict=====%@",dict);
          
          
        InformationViewController* vc =[[InformationViewController alloc] initWithUrl:url list:dict];
        [self.navigationController pushViewController:vc animated:YES];
      }else if ([[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"@Type"] isEqualToString:@"-3"]){
          NSViewController *vc =[[NSViewController alloc]initWithUrl:DATAGUID WithTitleStr:@"附件"];
          
          NSLog(@"aasdasd====%@0",[taskDict objectForKey:@"DATAGUID"]);
          [self.navigationController pushViewController:vc animated:YES];
          
          
          
      }
      else{
        //if (![self isXMLNull]) {//0驳回
            if ([[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"@Type"] isEqualToString:@"0"]) {
                commIndex = indexPath.row;
                [self editComments:@"0"];
            }else if ([[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"@Type"] isEqualToString:@"1"]) {//1.正常提交
                if ([taskDict[@"DATASTR"] isEqualToString:@""]) {
                    [SVProgressHUD showErrorWithStatus:@"你的任务未保存"];
                    [self.navigationController popViewControllerAnimated:YES];
                    return;
                }
                NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
                [dict setObject:@"同意" forKey:@"OpinionInfo"];
                [dict setObject:@"RUNFLOW" forKey:@"Action"];
                [dict setObject:nullStr forKey:@"TaskTitle"];
                [dict setObject:taskDict[@"DATASTR"] forKey:@"FormInfo"];
                [dict setObject:DATAGUID forKey:@"DataGuid"];
                [dict setObject:HGUID forKey:@"HGuid"];
                [dict setObject:PROCESSGUID forKey:@"ProcessGuid"];
                [dict setObject:IsAdd forKey:@"IsAdd"];
                [dict setObject:[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"RouteId"] forKey:@"RouteId"];
                [dict setObject:VIRTUALPATH forKey:@"VIRTUALPATH"];
                [dict setObject:taskDict[@"DATATYPE"] forKey:@"DataType"];
                [dict setObject:FLOWGUID forKey:@"FlowGuid"];
                [dict setObject:nullStr forKey:@"TaskRemark"];
                [dict setObject:nullStr forKey:@"AddInfo"];
                [dict setObject:nullStr forKey:@"SendToUsers"];
                [dict setObject:nullStr forKey:@"WorkFlowApprove"];
                [dict setObject:nullStr forKey:@"LimitTime"];
                [self request:[NSDictionary dictionaryWithDictionary:dict]];
            }else if ([[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"@Type"] isEqualToString:@"2"]) {//填写意见之后提交
                commIndex = indexPath.row;
                [self editComments:nil];
            }else if ([[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"@Type"] isEqualToString:@"3"]) {//选择执行者之后提交
                if ([[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"OrgExpression"]==nil||[[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"OrgExpression"] isEqualToString:@""]||[[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"OrgExpression"] isEqual:[NSNull null]]) {
                    commIndex = indexPath.row;
                    [self alertActionPeople:nil data:nil userId:nil type:@"3"];
                }else{
                    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"PARSEORGEXPRESSION",@"Action",[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"OrgExpression"],@"EXPRESSION",[showDictA objectForKey:@"HGUID"],@"HGUID",[showDictA objectForKey:@"DATAGUID"],@"DATAGUID", nil];
                    commIndex = indexPath.row;
                    [self alertActionPeople:nil data:dict userId:nil type:@"3"];
                }
            }else if ([[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"@Type"] isEqualToString:@"4"]) {//选择执行者并且填写意见之后提交
                commIndex = indexPath.row;
                if ([[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"OrgExpression"]==nil||[[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"OrgExpression"] isEqualToString:@""]||[[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"OrgExpression"] isEqual:[NSNull null]]) {
                    [self alertActionPeople:nil data:nil userId:nil type:@"4"];
                }else{
                    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"PARSEORGEXPRESSION",@"Action",[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"OrgExpression"],@"EXPRESSION",[showDictA objectForKey:@"HGUID"],@"HGUID",[showDictA objectForKey:@"DATAGUID"],@"DATAGUID", nil];
                    [self alertActionPeople:nil data:dict userId:nil type:@"4"];
                }
            }else if ([[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"@Type"] isEqualToString:@"6"]) {//填写意见之后作废废止
                commIndex = indexPath.row;
                [self editComments:@"6"];
            }else if ([[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"@Type"] isEqualToString:@"8"]) {  // 填写意之后终止
                commIndex = indexPath.row;
                [self editComments:@"8"];
            }else if ([[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"@Type"] isEqualToString:@"9"]) {//填写意见之后加入签环节的提交
                commIndex = indexPath.row;
                [self editComments:nil];
            }else if ([[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"@Type"] isEqualToString:@"11"]) {//回退
                [self processBack:[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"RollBack"]];
            }else if ([[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"@Type"] isEqualToString:@"20"]) {//回退，显示回退菜单
                [self processBack:[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"RollBack"]];
            }else if ([[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"@Type"] isEqualToString:@"12"]) {//12选择委托人之后委托
                commIndex = indexPath.row;
                [self alertActionPeople:nil data:nil userId:nil type:@"12"];
            }
        //}
    }
}
- (void)request:(NSDictionary *)dict
{
    [SVProgressHUD showWithStatus:@"提交中..."];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/%@",HTTPIP,SLRD,MOBILE_URL] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}

#pragma mark ---------------------------------- 回退提交
- (void)processBack:(NSArray *)btns
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    for (NSInteger index = 0; index < btns.count; index ++) {
        NSString* str = [btns[index] objectForKey:@"@ToActivityName"];
        NSString* idstr = [btns[index] objectForKey:@"@RouteId"];
        UIAlertAction* btns = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //提交
            NSString* nullStr = @"";
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
            [dict setObject:nullStr forKey:@"OpinionInfo"];
            [dict setObject:@"ROLLBACK" forKey:@"Action"];
            [dict setObject:dataXmlStr forKey:@"FormInfo"];
            [dict setObject:[showDictA objectForKey:@"DATAGUID"] forKey:@"DataGuid"];
            [dict setObject:[showDictA objectForKey:@"PROCESSGUID"] forKey:@"ProcessGuid"];
            [dict setObject:idstr forKey:@"RouteId"];
            [dict setObject:VIRTUALPATH forKey:@"VIRTUALPATH"];
            [dict setObject:DataType forKey:@"DataType"];
            [dict setObject:[showDictA objectForKey:@"FLOWGUID"] forKey:@"FlowGuid"];
            [dict setObject:nullStr forKey:@"TaskRemark"];
            [dict setObject:nullStr forKey:@"TaskTitle"];
            [dict setObject:@"Back" forKey:@"BackOrForward"];
            [dict setObject:nullStr forKey:@"SendToUsers"];
            [dict setObject:nullStr forKey:@"WorkFlowApprove"];
            [dict setObject:nullStr forKey:@"LimitTime"];
            [self request:[NSDictionary dictionaryWithDictionary:dict]];
            [self.view endEditing:YES];
            [Comments removeFromSuperview];
        }];
        [alert addAction:btns];
    }
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark ---------------------------------- 填写意见并提交
- (void)editComments:(NSString *)user
{
    userInfoId = user;
    Comments = [[UIView alloc] init];
    Comments.frame = CGRectMake(0, 0, LWidth, LHeight);
    Comments.backgroundColor = [UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:0.3];
    [self.view addSubview:Comments];
    [self.view bringSubviewToFront:Comments];
    
    chooseCB = [[UIView alloc] initWithFrame:CGRectMake(30, 50, LWidth-60, 260)];
    chooseCB.backgroundColor = [UIColor whiteColor];
    chooseCB.layer.masksToBounds = YES;
    chooseCB.layer.cornerRadius = 6;
    chooseCB.layer.borderColor = [[UIColor colorWithRed:0.773 green:0.780 blue:0.776 alpha:1] CGColor];
    chooseCB.layer.borderWidth = .5f;
    [Comments addSubview:chooseCB];
    
    UILabel* titleD = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, chooseCB.frame.size.width, 30)];
    titleD.textAlignment = NSTextAlignmentCenter;
    titleD.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    titleD.text = @"填写意见";
    titleD.font = [UIFont systemFontOfSize:15];
    [chooseCB addSubview:titleD];
    
    chooseCom = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseCom.frame = CGRectMake(30, chooseCB.frame.origin.y+30, chooseCB.frame.size.width, 30);
    chooseCom.backgroundColor = [UIColor whiteColor];
    chooseCom.userInteractionEnabled = NO;
    [Comments addSubview:chooseCom];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 70, chooseCB.frame.size.width-10, 150)];
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 6;
    textView.text = @"同意";
    textView.delegate = self;
    textView.layer.borderColor = [[UIColor colorWithRed:0.773 green:0.780 blue:0.776 alpha:1] CGColor];
    textView.layer.borderWidth = 1;
    [chooseCB addSubview:textView];
    
    UIButton* left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(0, 225, chooseCB.frame.size.width/2, 30);
    left.backgroundColor = [UIColor whiteColor];
    left.titleLabel.font = [UIFont systemFontOfSize:15];
    [left setTitle:@"确定" forState:0];
    left.tag = 0;
    [left setTitleColor:[UIColor blueColor] forState:0];
    if (user==nil||[user isEqualToString:@""]||[user isEqual:[NSNull null]]) {
        [left addTarget:self action:@selector(upDataCom:) forControlEvents:UIControlEventTouchUpInside];
    }else if ([user isEqualToString:@"6"]||[user isEqualToString:@"8"]) {
        [left addTarget:self action:@selector(upDataDeleteCom:) forControlEvents:UIControlEventTouchUpInside];
    }else if ([user isEqualToString:@"0"]) {
        [left addTarget:self action:@selector(upDatarejected:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [left addTarget:self action:@selector(upDataUserCom:) forControlEvents:UIControlEventTouchUpInside];
    }
    [chooseCB addSubview:left];
    
    UIButton* right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(chooseCB.frame.size.width/2, 225, chooseCB.frame.size.width/2, 30);
    right.backgroundColor = [UIColor whiteColor];
    right.titleLabel.font = [UIFont systemFontOfSize:15];
    right.tag = 1;
    [right setTitle:@"取消" forState:0];
    [right setTitleColor:[UIColor blueColor] forState:0];
    [right addTarget:self action:@selector(upDataCom:) forControlEvents:UIControlEventTouchUpInside];
    [chooseCB addSubview:right];
    
    [self initdropDownMenu];
}
- (void)initdropDownMenu
{
    NSMutableArray *dropdownItems = [[NSMutableArray alloc] init];
    NSArray* array = @[@"同意",@"阅",@"请领导阅示",@"照此办理",@"请领导批示",@"打回",@"先放着",@"不同意"];
    for (int i = 0; i < array.count; i++) {
        IGLDropDownItem *item = [[IGLDropDownItem alloc] init];
        [item setText:array[i]];
        [dropdownItems addObject:item];
    }
    
    self.dropDownMenu = [[IGLDropDownMenu alloc] init];
    self.dropDownMenu.menuText = @"【选择意见】";
    self.dropDownMenu.dropDownItems = dropdownItems;
    self.dropDownMenu.paddingLeft = 15;
    [self.dropDownMenu setFrame:chooseCom.frame];
    self.dropDownMenu.delegate = self;
    [self setUpParamsForDemo];
    [self.dropDownMenu reloadView];
    [Comments addSubview:self.dropDownMenu];
    [Comments bringSubviewToFront:self.dropDownMenu];
}
- (void)setUpParamsForDemo
{
    self.dropDownMenu.type = IGLDropDownMenuTypeNormal;
    self.dropDownMenu.flipWhenToggleView = YES;
}
#pragma mark - IGLDropDownMenuDelegate
- (void)selectedItemAtIndex:(NSInteger)index
{
    IGLDropDownItem *item = self.dropDownMenu.dropDownItems[index];
    textView.text = item.text;
}
- (void)upDataUserCom:(UIButton *)sender
{
    NSString* nullStr = @"";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:textView.text forKey:@"OpinionInfo"];
    [dict setObject:@"RUNFLOW" forKey:@"Action"];
    [dict setObject:dataXmlStr forKey:@"FormInfo"];
    [dict setObject:[showDictA objectForKey:@"DATAGUID"] forKey:@"DataGuid"];
    [dict setObject:[showDictA objectForKey:@"HGUID"] forKey:@"HGuid"];
    [dict setObject:[showDictA objectForKey:@"PROCESSGUID"] forKey:@"ProcessGuid"];
    [dict setObject:IsAdd forKey:@"IsAdd"];
    [dict setObject:[[buttonsArray objectAtIndex:commIndex] objectForKey:@"RouteId"] forKey:@"RouteId"];
    [dict setObject:VIRTUALPATH forKey:@"VIRTUALPATH"];
    [dict setObject:DataType forKey:@"DataType"];
    [dict setObject:[showDictA objectForKey:@"FLOWGUID"] forKey:@"FlowGuid"];
    [dict setObject:nullStr forKey:@"TaskRemark"];
    [dict setObject:nullStr forKey:@"TaskTitle"];
    [dict setObject:nullStr forKey:@"AddInfo"];
    [dict setObject:userInfoId forKey:@"SendToUsers"];
    [dict setObject:nullStr forKey:@"WorkFlowApprove"];
    [dict setObject:nullStr forKey:@"LimitTime"];
    [self request:[NSDictionary dictionaryWithDictionary:dict]];
    [self.view endEditing:YES];
    [Comments removeFromSuperview];
}
- (void)upDataCom:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            NSString* nullStr = @"";
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
            [dict setObject:textView.text forKey:@"OpinionInfo"];
            [dict setObject:@"RUNFLOW" forKey:@"Action"];
            [dict setObject:dataXmlStr forKey:@"FormInfo"];
            [dict setObject:[showDictA objectForKey:@"DATAGUID"] forKey:@"DataGuid"];
            [dict setObject:[showDictA objectForKey:@"HGUID"] forKey:@"HGuid"];
            [dict setObject:[showDictA objectForKey:@"PROCESSGUID"] forKey:@"ProcessGuid"];
            [dict setObject:IsAdd forKey:@"IsAdd"];
            [dict setObject:[[buttonsArray objectAtIndex:commIndex] objectForKey:@"RouteId"] forKey:@"RouteId"];
            [dict setObject:VIRTUALPATH forKey:@"VIRTUALPATH"];
            [dict setObject:DataType forKey:@"DataType"];
            [dict setObject:[showDictA objectForKey:@"FLOWGUID"] forKey:@"FlowGuid"];
            [dict setObject:nullStr forKey:@"TaskRemark"];
            [dict setObject:nullStr forKey:@"AddInfo"];
            [dict setObject:nullStr forKey:@"TaskTitle"];
            [dict setObject:nullStr forKey:@"SendToUsers"];
            [dict setObject:nullStr forKey:@"WorkFlowApprove"];
            [dict setObject:nullStr forKey:@"LimitTime"];
            [self request:[NSDictionary dictionaryWithDictionary:dict]];
            [self.view endEditing:YES];
            [Comments removeFromSuperview];
        }
            break;
        case 1:
        {
            [self.view endEditing:YES];
            [Comments removeFromSuperview];
        }
            break;
            
        default:
            break;
    }
}
//回去表单数据
- (void)upDataDeleteCom:(UIButton *)sender
{
    NSString* APPDB = [xmlData objectForKey:@"AppDbConn"];
    NSString* APPTABLE = [xmlData objectForKey:@"AppDbTable"];
    NSString* APPCFIDKEY = [xmlData objectForKey:@"AppFlowField"];
    NSString* APPCFID = [showDictD objectForKey:[xmlData objectForKey:@"AppFlowField"]];
    NSString* xmlDel = [NSString stringWithFormat:@"<Data><Action>SAVEDATA</Action><CMDTYPE>update</CMDTYPE><CLIENTSRC>MOBILE</CLIENTSRC><APPDB>%@</APPDB><APPTABLE>%@</APPTABLE><TABLENAME>%@</TABLENAME><%@ type='flowfield'>%@</%@></Data>",APPDB,APPTABLE,APPTABLE,APPCFIDKEY,APPCFID,APPCFIDKEY];
    NSString* nullStr = @"";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:textView.text forKey:@"OpinionInfo"];
    [dict setObject:@"TerminateFlow" forKey:@"Action"];
    [dict setObject:xmlDel forKey:@"FormInfo"];
    [dict setObject:[showDictA objectForKey:@"DATAGUID"] forKey:@"DataGuid"];
    [dict setObject:[showDictA objectForKey:@"PROCESSGUID"] forKey:@"ProcessGuid"];
    [dict setObject:nullStr forKey:@"RouteId"];
    [dict setObject:VIRTUALPATH forKey:@"VIRTUALPATH"];
    [dict setObject:DataType forKey:@"DataType"];
    [dict setObject:[showDictA objectForKey:@"FLOWGUID"] forKey:@"FlowGuid"];
    [dict setObject:nullStr forKey:@"TaskRemark"];
    [dict setObject:nullStr forKey:@"WorkFlowApprove"];
    [dict setObject:nullStr forKey:@"LimitTime"];
    [dict setObject:nullStr forKey:@"SendToUsers"];
    [dict setObject:nullStr forKey:@"TaskTitle"];
    [self request:[NSDictionary dictionaryWithDictionary:dict]];
    [self.view endEditing:YES];
    [Comments removeFromSuperview];
}
- (void)upDatarejected:(UIButton *)sender
{
    NSString* nullStr = @"";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:textView.text forKey:@"OpinionInfo"];
    [dict setObject:@"Back" forKey:@"BackOrForward"];
    [dict setObject:@"RUNFLOW" forKey:@"Action"];
    [dict setObject:dataXmlStr forKey:@"FormInfo"];
    [dict setObject:[showDictA objectForKey:@"DATAGUID"] forKey:@"DataGuid"];
    [dict setObject:[showDictA objectForKey:@"HGUID"] forKey:@"HGuid"];
    [dict setObject:[showDictA objectForKey:@"PROCESSGUID"] forKey:@"ProcessGuid"];
    [dict setObject:[[buttonsArray objectAtIndex:commIndex] objectForKey:@"RouteId"] forKey:@"RouteId"];
    [dict setObject:VIRTUALPATH forKey:@"VIRTUALPATH"];
    [dict setObject:DataType forKey:@"DataType"];
    [dict setObject:[showDictA objectForKey:@"FLOWGUID"] forKey:@"FlowGuid"];
    [dict setObject:nullStr forKey:@"TaskRemark"];
    [dict setObject:nullStr forKey:@"SendToUsers"];
    [dict setObject:nullStr forKey:@"WorkFlowApprove"];
    [dict setObject:nullStr forKey:@"TaskTitle"];
    [dict setObject:nullStr forKey:@"LimitTime"];
    [self request:[NSDictionary dictionaryWithDictionary:dict]];
}
- (void)commentsRemove
{
    [self.view endEditing:YES];
    [Comments removeFromSuperview];
}


#pragma mark ---------------------------------- 选择执行人
- (void)alertActionPeople:(NSString *)aStr data:(NSDictionary *)dict userId:(NSString *)userStr type:(NSString *)aType
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"选择执行者"] message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* determine = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //提交
        if (alert.textFields[0].text==nil||[alert.textFields[0].text isEqualToString:@""]||[alert.textFields[0].text isEqual:[NSNull null]]) {
            [SVProgressHUD showErrorWithStatus:@"请选择执行者"];
        }else{
            if ([aType isEqualToString:@"4"]) {
                [self editComments:userStr];
            }else if ([aType isEqualToString:@"12"]) {
                NSString* nullStr = @"";
                NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
                [dict setObject:nullStr forKey:@"OpinionInfo"];
                [dict setObject:@"AUTHORISETO" forKey:@"Action"];
                [dict setObject:taskDict[@"DATASTR"] forKey:@"FormInfo"];
                [dict setObject:[showDictA objectForKey:@"DATAGUID"] forKey:@"DataGuid"];
                [dict setObject:[showDictA objectForKey:@"HGUID"] forKey:@"HGuid"];
                [dict setObject:[showDictA objectForKey:@"PROCESSGUID"] forKey:@"ProcessGuid"];
                [dict setObject:IsAdd forKey:@"IsAdd"];
                [dict setObject:nullStr forKey:@"RouteId"];
                [dict setObject:VIRTUALPATH forKey:@"VIRTUALPATH"];
                [dict setObject:taskDict[@"DATATYPE"] forKey:@"DataType"];
                [dict setObject:[showDictA objectForKey:@"FLOWGUID"] forKey:@"FlowGuid"];
                [dict setObject:nullStr forKey:@"AddInfo"];
                [dict setObject:userStr forKey:@"UserOrgGuid"];
                [dict setObject:nullStr forKey:@"WorkFlowApprove"];
                [dict setObject:nullStr forKey:@"TaskTitle"];
                [dict setObject:nullStr forKey:@"LimitTime"];
                [self request:[NSDictionary dictionaryWithDictionary:dict]];
            }else{
                NSString* nullStr = @"";
                NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
                [dict setObject:nullStr forKey:@"OpinionInfo"];
                [dict setObject:@"RUNFLOW" forKey:@"Action"];
                [dict setObject:dataXmlStr forKey:@"FormInfo"];
                [dict setObject:[showDictA objectForKey:@"DATAGUID"] forKey:@"DataGuid"];
                [dict setObject:[showDictA objectForKey:@"HGUID"] forKey:@"HGuid"];
                [dict setObject:[showDictA objectForKey:@"PROCESSGUID"] forKey:@"ProcessGuid"];
                [dict setObject:IsAdd forKey:@"IsAdd"];
                [dict setObject:nullStr forKey:@"TaskTitle"];
                [dict setObject:[[buttonsArray objectAtIndex:commIndex] objectForKey:@"RouteId"] forKey:@"RouteId"];
                [dict setObject:VIRTUALPATH forKey:@"VIRTUALPATH"];
                [dict setObject:DataType forKey:@"DataType"];
                [dict setObject:[showDictA objectForKey:@"FLOWGUID"] forKey:@"FlowGuid"];
                [dict setObject:nullStr forKey:@"TaskRemark"];
                [dict setObject:nullStr forKey:@"AddInfo"];
                [dict setObject:userStr forKey:@"SendToUsers"];
                [dict setObject:nullStr forKey:@"WorkFlowApprove"];
                [dict setObject:nullStr forKey:@"LimitTime"];
                [self request:[NSDictionary dictionaryWithDictionary:dict]];
            }
        }
    }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction* push = [UIAlertAction actionWithTitle:@"选择执行者" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (dict == nil) {
            PeopleViewController* peopleVC =[[PeopleViewController alloc] initWithType:aType];
            peopleVC.delegate = self;
            [self.navigationController pushViewController:peopleVC animated:YES];
        }else{
            PerplelistViewController* peropleVC = [[PerplelistViewController alloc] initWithDict:dict type:aType];
            peropleVC.delegate = self;
            [self.navigationController pushViewController:peropleVC animated:YES];
        }
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor blueColor];
        textField.text = aStr;
        textField.userInteractionEnabled = NO;
    }];
    [self presentViewController:alert animated:YES completion:nil];
    [alert addAction:push];
    [alert addAction:determine];
    [alert addAction:cancel];
}
- (void)backUpDataViewController:(NSArray *)array data:(NSDictionary *)dict type:(NSString *)aType
{
    NSString* name = @"";
    NSString* userid = @"";
    for (NSInteger index = 0; index < array.count; index ++) {
        PeopleModel* model = array[index];
        if (index==0) {
            name = [model.data objectForKey:@"FDISPLAYNAME"];
            userid = [NSString stringWithFormat:@"1|%@||",[model.data objectForKey:@"FGUID"]];
        }else{
            name = [NSString stringWithFormat:@"%@,%@",name,[model.data objectForKey:@"FDISPLAYNAME"]];
            userid = [NSString stringWithFormat:@"%@,%@",userid,[NSString stringWithFormat:@"1|%@||",[model.data objectForKey:@"FGUID"]]];
        }
    }
    [self alertActionPeople:name data:dict userId:userid type:aType];
}
- (void)All_backUpDataViewController:(NSArray *)array data:(NSDictionary *)dict type:(NSString *)aType
{
    NSString* name = @"";
    NSString* userid = @"";
    for (NSInteger index = 0; index < array.count; index ++) {
        if (index==0) {
            name = [array[index] objectForKey:@"FDISPLAYNAME"];
            if ([aType isEqualToString:@"12"]) {
                userid = [NSString stringWithFormat:@"%@",[array[index] objectForKey:@"FGUID"]];
            }else{
                userid = [NSString stringWithFormat:@"1|%@||",[array[index] objectForKey:@"FGUID"]];
            }
        }else{
            name = [NSString stringWithFormat:@"%@,%@",name,[array[index] objectForKey:@"FDISPLAYNAME"]];
            if ([aType isEqualToString:@"12"]) {
                userid = [NSString stringWithFormat:@"%@,%@",userid,[NSString stringWithFormat:@"%@",[array[index] objectForKey:@"FGUID"]]];
            }else{
                userid = [NSString stringWithFormat:@"%@,%@",userid,[NSString stringWithFormat:@"1|%@||",[array[index] objectForKey:@"FGUID"]]];
            }
        }
    }
    [self alertActionPeople:name data:dict userId:userid type:aType];
}
- (void)editDataClick:(UIButton *)sender
{
    if ([[showMainArray[sender.tag-1000] objectForKey:@"APPDBFIELDCONTROL"] isEqualToString:@"4"]) {
        for (id view in [mainScroll subviews]) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton* mobileView = (UIButton *)view;
                if (mobileView.tag==sender.tag) {
                    for (id aView in [mobileView subviews]) {
                        if ([aView isKindOfClass:[UILabel class]]) {
                            UILabel* mobileLabel = (UILabel *)aView;
                            if (mobileLabel.tag == sender.tag-900) {
                                dateStr = mobileLabel.text;
                            }
                        }
                    }
                }
            }
        }
        timeIndex = sender.tag;
        [self.view bringSubviewToFront:pView];
        [UIView animateWithDuration:0.25 animations:^{
            pView.frame = CGRectMake(0, LHeight-255, LWidth, 190);
        }];
    }else if ([[showMainArray[sender.tag-1000] objectForKey:@"APPDBFIELDCONTROL"] isEqualToString:@"5"]) {
        for (id view in [mainScroll subviews]) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton* mobileView = (UIButton *)view;
                if (mobileView.tag==sender.tag) {
                    for (id aView in [mobileView subviews]) {
                        if ([aView isKindOfClass:[UILabel class]]) {
                            UILabel* mobileLabel = (UILabel *)aView;
                            if (mobileLabel.tag == sender.tag-900) {
                                dateTimeStr = mobileLabel.text;
                            }
                        }
                    }
                }
            }
        }
        dateTimeIndex = sender.tag;
        [self.view bringSubviewToFront:pDTView];
        [UIView animateWithDuration:0.25 animations:^{
            pDTView.frame = CGRectMake(0, LHeight-255, LWidth, 190);
        }];
    }else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"修改（%@）信息",[showMainArray[sender.tag-1000] objectForKey:@"APPDBFIELDLABEL"]] message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* determine = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self refactoringView:sender.tag contens:alert.textFields[0].text];
        }];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            for (id view in [sender subviews]) {
                if ([view isKindOfClass:[UILabel class]]) {
                    UILabel* mobileLabel = (UILabel *)view;
                    if (mobileLabel.tag == sender.tag-900) {
                        textField.text = mobileLabel.text;
                    }
                }
            }
            textField.textColor = [UIColor blueColor];
            if ([[showMainArray[sender.tag-1000] objectForKey:@"APPDBFIELDCONTROL"] isEqualToString:@"2"])textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        [self presentViewController:alert animated:YES completion:nil];
        [alert addAction:determine];
        [alert addAction:cancel];
    }
}


#pragma mark ---------------------------------- 主表编辑重新计算UI
- (void)refactoringView:(NSInteger)tag contens:(NSString *)str
{
    for (id view in [mainScroll subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* mobileView = (UIButton *)view;
            float y = 0.0;
            if (mobileView.tag==tag) {
                for (id aView in [mobileView subviews]) {
                    if ([aView isKindOfClass:[UILabel class]]) {
                        UILabel* mobileLabel = (UILabel *)aView;
                        if (mobileLabel.tag == tag-900) {
                            mobileLabel.text = str;
                            CGSize size = [self sizeWithStringTitle:str font:[UIFont systemFontOfSize:15] sizwLwidth:LWidth-15-mobileLabel.frame.origin.x];
                            y = size.height>mobileLabel.frame.size.height?mobileLabel.frame.origin.y+size.height+9:mobileView.frame.origin.y;
                            mobileLabel.frame = CGRectMake(mobileLabel.frame.origin.x, mobileLabel.frame.origin.y, size.width, size.height);
                            mobileView.frame = CGRectMake(mobileView.frame.origin.x, mobileView.frame.origin.y, LWidth, size.height+18);
                            xmlContens = mobileView.frame;
                        }
                    }
                }
                for (id aView in [mobileView subviews]) {
                    if ([aView isKindOfClass:[UIImageView class]]) {
                        UIImageView* mobileIV = (UIImageView *)aView;
                        if (mobileIV.tag == tag-900) {
                            mobileIV.frame = CGRectMake(0, xmlContens.size.height-1, LWidth, 1);
                        }
                    }
                }
            }
            if (mobileView.tag>tag) {
                mobileView.frame = CGRectMake(mobileView.frame.origin.x, xmlContens.origin.y+xmlContens.size.height, LWidth, mobileView.frame.size.height);
                xmlContens = mobileView.frame;
            }
        }
    }
    mainScroll.contentSize = CGSizeMake(LWidth, xmlContens.size.height+xmlContens.origin.y+40);
    upView.frame = CGRectMake(0, xmlContens.origin.y+xmlContens.size.height, LWidth, 40);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(unsigned long)(scrollView.contentOffset.x / scrollView.frame.size.width)],@"indexpage", nil];
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
- (void)initMainTable
{
    //    xml控件
    
    
    for (NSInteger m = 0; m < showMainArray.count; m ++) {
        UIButton* xmlView = [UIButton buttonWithType:UIButtonTypeCustom];
        xmlView.tag = m+1000;
        NSString* isEdit = [[NSString stringWithFormat:@"%@",[showMainArray[m] objectForKey:@"APPDBFIELDEDIT"]] stringByReplacingOccurrencesOfString:@"_" withString:@""];
        xmlView.userInteractionEnabled = [isEdit isEqual:@"true"]?YES:NO;
        [xmlView addTarget:self action:@selector(editDataClick:) forControlEvents:UIControlEventTouchUpInside];
        [mainScroll addSubview:xmlView];
        
        UILabel* title = [[UILabel alloc] init];
        title.textAlignment = NSTextAlignmentRight;
        title.tag = 10000;
        title.numberOfLines = 0;
        title.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        title.text = [NSString stringWithFormat:@"%@:",[showMainArray[m] objectForKey:@"APPDBFIELDLABEL"]==nil?@"":[showMainArray[m] objectForKey:@"APPDBFIELDLABEL"]];
        NSLog(@"SHOWMAINARRAY+++%@",showMainArray);
        title.font = [UIFont systemFontOfSize:14];
        CGSize titleSize = [self sizeWithStringTitle:[NSString stringWithFormat:@"%@:",[showMainArray[m] objectForKey:@"APPDBFIELDLABEL"]] font:title.font sizwLwidth:90];
        title.frame = CGRectMake(5, 8, 90, titleSize.height);
        [xmlView addSubview:title];
        
        contens = [[UILabel alloc] init];
        contens.textAlignment = NSTextAlignmentLeft;
        contens.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
        contens.numberOfLines = 0;
        contens.font = [UIFont systemFontOfSize:14];
        contens.tag = m+100;
        
        if ([[showMainArray[m] objectForKey:@"APPDBFIELDCONTROL"] isEqualToString:@"4"]) {
            if ([[showDictD objectForKey:[showMainArray[m] objectForKey:@"APPDBFIELDNAME"]] length]>10) {
                contens.text = [[[showDictD objectForKey:[showMainArray[m] objectForKey:@"APPDBFIELDNAME"]] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringWithRange:NSMakeRange(0,10)];
            }else{
                
                contens.text = [showDictD objectForKey:[showMainArray[m] objectForKey:@"APPDBFIELDNAME"]];
            }
        }else if ([[showMainArray[m] objectForKey:@"APPDBFIELDCONTROL"] isEqualToString:@"5"]) {
            if ([[showDictD objectForKey:[showMainArray[m] objectForKey:@"APPDBFIELDNAME"]] length]>19) {
                contens.text = [[[showDictD objectForKey:[showMainArray[m] objectForKey:@"APPDBFIELDNAME"]] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringWithRange:NSMakeRange(0,19)];
            }else{
                contens.text = [showDictD objectForKey:[showMainArray[m] objectForKey:@"APPDBFIELDNAME"]];
            }
        }else if([[showMainArray[m] objectForKey:@"APPDBFIELDCONTROL"] isEqualToString:@"2"]){
            NSLog(@"STRINF====%@",[showMainArray[m] objectForKey:@"APPDBFIELDFORMAT"] );
            NSString *str=[showDictD objectForKey:[showMainArray[m] objectForKey:@"APPDBFIELDNAME"]];
            if ([str containsString:@"."]) {
                //  格式化
                NSInteger a=[[showMainArray[m] objectForKey:@"APPDBFIELDFORMAT"]length]-2;
                
                float b =[str floatValue];
                switch (a) {
                    case 1:
                    {
                        contens.text =[NSString stringWithFormat:@"%.1f",b];
                        
                    }
                        
                    case 2:
                    {
                        contens.text =[NSString stringWithFormat:@"%.2f",b];
                        
                    }
                        break;
                    case 3:
                    {
                        contens.text =[NSString stringWithFormat:@"%.3f",b];
                    }
                        break;
                    case 4:
                    {
                        contens.text =[NSString stringWithFormat:@"%.4f",b];
                        
                    }
                        break;
                        
                    case 5:
                    { contens.text =[NSString stringWithFormat:@"%.5f",b];
                        
                    }
                        break;
                        
                        
                }
                
                
            }
            else{
                contens.text=str;
            }
        }
        else{
            
            contens.text = [showDictD objectForKey:[showMainArray[m] objectForKey:@"APPDBFIELDNAME"]];
            
            
        }
        NSString* strMR = [NSString stringWithFormat:@"%@",[showMainArray[m] objectForKey:@"APPDBFIELDDEFAULT"]==nil||[[showMainArray[m] objectForKey:@"APPDBFIELDDEFAULT"] isEqual:[NSNull null]]?@"0":[showMainArray[m] objectForKey:@"APPDBFIELDDEFAULT"]];
        if ([strMR isEqualToString:@"0"]) {
        }else if ([strMR isEqualToString:@"1"]) {
            contens.text = USERNAME;
        }else if ([strMR isEqualToString:@"2"]) {
            contens.text = USERGUID;
        }else if ([strMR isEqualToString:@"3"]) {
            NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSString *currentTime = [formatter stringFromDate:[NSDate date]];
            contens.text = [NSString stringWithFormat:@"%@",currentTime];
        }else if ([strMR isEqualToString:@"4"]) {
            contens.text = @"同意";
        }
        
        CGSize btnSize = [self sizeWithStringTitle:contens.text font:title.font sizwLwidth:LWidth-15-(title.frame.size.width+title.frame.origin.x)];
        contens.frame = CGRectMake(title.frame.size.width+10, 8, btnSize.width, btnSize.height);
        
        if ([isEdit isEqual:@"true"]) {
            contens.textColor = [UIColor blackColor];
        }
        
        [xmlView addSubview:contens];
        
        float y = title.frame.size.height>contens.frame.size.height?title.frame.size.height+title.frame.origin.y:contens.frame.size.height+contens.frame.origin.y;
        xmlView.frame = CGRectMake(0, m==0?imagvD.frame.origin.y+1:xmlContens.origin.y+xmlContens.size.height, LWidth, y+9);
        
        UIImageView* row = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
        row.frame = CGRectMake(0, xmlView.frame.size.height-1, LWidth, 1);
        row.alpha = 0.4;
        row.tag = m+100;
        [xmlView addSubview:row];
        [xmlView bringSubviewToFront:row];
        xmlContens = xmlView.frame;
    }
    upView = [[UIView alloc] init];
    [self changeUpButton];
    [mainScroll addSubview:upView];
    mainScroll.contentSize = CGSizeMake(LWidth, xmlContens.size.height+xmlContens.origin.y+40);
    upView.frame = CGRectMake(0, xmlContens.origin.y+xmlContens.size.height, LWidth, 40);
}

- (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
    
}



- (void)changeUpButton
{
    if (![isShow isEqualToString:@"true"]) {
        UIButton* updata = [UIButton buttonWithType:UIButtonTypeCustom];
        updata.backgroundColor = [UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1];
        updata.frame = CGRectMake(20, 5, (LWidth-60)/2, 30);
        [updata setTitle:@"保存" forState:0];
        updata.layer.cornerRadius = 3;
        updata.layer.masksToBounds = YES;
        updata.titleLabel.font = [UIFont systemFontOfSize:15];
        [updata setTitleColor:[UIColor whiteColor] forState:0];
        [updata addTarget:self action:@selector(upDataRequest) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:updata];
        
        UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
        back.backgroundColor = [UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1];
        back.frame = CGRectMake(40+((LWidth-60)/2), 5, (LWidth-60)/2, 30);
        [back setTitle:@"取消" forState:0];
        back.layer.cornerRadius = 3;
        back.layer.masksToBounds = YES;
        [back setTitleColor:[UIColor whiteColor] forState:0];
        back.titleLabel.font = [UIFont systemFontOfSize:15];
        [back addTarget:self action:@selector(go_back) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:back];
        [self performSelector:@selector(svpDismiss) withObject:self afterDelay:3];
    }else{
        [SVProgressHUD showErrorWithStatus:@"当前流程环节不允许移动端处理，请到电脑端处理"];
        UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
        back.backgroundColor = [UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1];
        back.frame = CGRectMake(30, 5, (LWidth-60), 30);
        [back setTitle:@"取消" forState:0];
        back.layer.cornerRadius = 3;
        back.layer.masksToBounds = YES;
        back.titleLabel.font = [UIFont systemFontOfSize:15];
        [back setTitleColor:[UIColor whiteColor] forState:0];
        [back addTarget:self action:@selector(go_back) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:back];
    }
    [self performSelector:@selector(svpDismiss) withObject:self afterDelay:3];
}
- (void)svpDismiss
{
    [SVProgressHUD dismiss];
}

/**************************************************************************************************/
//    控件自适应
/**************************************************************************************************/
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(LWidth-10-70, LHeight)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  | NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    return rect.size;
}
- (CGSize)sizeWithStringTitle:(NSString *)string font:(UIFont *)font sizwLwidth:(float)width
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, LHeight)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  | NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    return rect.size;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**************************************************************************************************/
//    保存
/**************************************************************************************************/
- (void)upDataRequest//主表保存
{
    if (![self isXMLNull]) {//必填项不为空的话  发起保存
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:dataXmlStr,@"FormInfo",@"SAVEFORM",@"Action",DataType,@"DataType", nil];
        MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/%@",HTTPIP,SLRD,MOBILE_URL] withParameter:dict];
        manager.backSuccess = ^void(NSDictionary *dictt)
        {
            if ([[dictt objectForKey:@"success"] integerValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            }else{
                [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
            }
        };
    }
}
//
- (BOOL)isXMLNull
{
    NSString* xml = @"";
    for (NSInteger index = 0; index < showMainArray.count; index ++) {//拼接可编辑控件xml
        for (id view in [mainScroll subviews]) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton* mobileView = (UIButton *)view;
                if (mobileView.tag==index+1000) {
                    for (id aView in [mobileView subviews]) {
                        if ([aView isKindOfClass:[UILabel class]]) {
                            UILabel* mobileLabel = (UILabel *)aView;
                            if (mobileLabel.tag == index+100) {
                                NSString* strMR = [NSString stringWithFormat:@"%@",[showMainArray[index] objectForKey:@"APPDBFIELDDEFAULT"]==nil||[[showMainArray[index] objectForKey:@"APPDBFIELDDEFAULT"] isEqual:[NSNull null]]?@"0":[showMainArray[index] objectForKey:@"APPDBFIELDDEFAULT"]];
                                NSString* isEdit = [[NSString stringWithFormat:@"%@",[showMainArray[index] objectForKey:@"APPDBFIELDEDIT"]] stringByReplacingOccurrencesOfString:@"_" withString:@""];
                                if ((![strMR isEqualToString:@"0"])||([[showMainArray[index] objectForKey:@"APPDBFIELDSHOW"] isEqualToString:@"true"]&[isEdit isEqualToString:@"true"])) {
                                    xml = [NSString stringWithFormat:@"%@<%@ type='%@'>%@</%@>",xml,[showMainArray[index] objectForKey:@"APPDBFIELDNAME"],[showMainArray[index] objectForKey:@"APPDBFIELDCONTROL"],[mobileLabel.text isEqualToString:@""]||mobileLabel.text == nil||[mobileLabel.text isEqual:[NSNull null]]?@"":mobileLabel.text,[showMainArray[index] objectForKey:@"APPDBFIELDNAME"]];
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    NSString* APPDB = [xmlData objectForKey:@"AppDbConn"];
    NSString* APPTABLE = [xmlData objectForKey:@"AppDbTable"];
    NSString* APPCFIDKEY = [xmlData objectForKey:@"AppFlowField"];
    NSString* APPCFID = [showDictD objectForKey:[xmlData objectForKey:@"AppFlowField"]];
    dataXmlStr = [NSString stringWithFormat:@"<Data><Action>SAVEDATA</Action><CMDTYPE>update</CMDTYPE><CLIENTSRC>MOBILE</CLIENTSRC><APPDB>%@</APPDB><APPTABLE>%@</APPTABLE><TABLENAME>%@</TABLENAME><%@ type='flowfield'>%@</%@>%@</Data>",APPDB,APPTABLE,APPTABLE,APPCFIDKEY,APPCFID,APPCFIDKEY,xml];//拼接整个data xml
    for (NSInteger index = 0; index < showMainArray.count; index ++) {//验证必填项
        for (id view in [mainScroll subviews]) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton* mobileView = (UIButton *)view;
                if (mobileView.tag==index+1000) {
                    for (id aView in [mobileView subviews]) {
                        if ([aView isKindOfClass:[UILabel class]]) {
                            UILabel* mobileLabel = (UILabel *)aView;
                            if (mobileLabel.tag == index+100) {
                                if ([[showMainArray[index] objectForKey:@"APPDBREQUIRED"] isEqualToString:@"true"]) {
                                    if ([mobileLabel.text isEqualToString:@""]||mobileLabel.text == nil||[mobileLabel.text isEqual:[NSNull null]]) {
                                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"必填项(%@)为空",[showMainArray[index] objectForKey:@"APPDBFIELDLABEL"]]];
                                        return YES;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return NO;
}
- (void)go_back
{
    [self.navigationController popViewControllerAnimated:YES];
}


/**************************************************************************************************/
//    日期
/**************************************************************************************************/
- (void)timeView
{
    pView = [[UIView alloc] initWithFrame:CGRectMake(0, LHeight, LWidth,190)];
    pView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pView];
    
    //    取消按钮
    UIButton* returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(10, 0, 50, 30);
    returnBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [returnBtn setTitle:@"取消" forState:0];
    [returnBtn setTitleColor:[UIColor colorWithRed:0.000 green:0.800 blue:0.600 alpha:1] forState:0];
    [returnBtn addTarget:self action:@selector(returnBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [pView addSubview:returnBtn];
    
    //    确定按钮
    UIButton* endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    endBtn.frame = CGRectMake(LWidth-60, 0, 50, 30);
    endBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [endBtn setTitle:@"完成" forState:0];
    [endBtn setTitleColor:[UIColor colorWithRed:0.000 green:0.800 blue:0.600 alpha:1] forState:0];
    [endBtn addTarget:self action:@selector(endBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [pView addSubview:endBtn];
    
    //    横线
    UIImageView* bgimagViewA = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
    bgimagViewA.frame = CGRectMake(0, 0, LWidth, 2);
    [pView addSubview:bgimagViewA];
    UIImageView* bgimagViewB = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
    bgimagViewB.frame = CGRectMake(0, 28, LWidth, 2);
    [pView addSubview:bgimagViewB];
    
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, LWidth, 160)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    datePicker.minuteInterval = 5;
    datePicker.backgroundColor = [UIColor whiteColor];
    [pView addSubview:datePicker];
    
    if (dateStr.length != 0) {
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd"];
        NSDate* date = [formater dateFromString:dateStr];
        [datePicker setDate:date animated:YES];
    }
}
- (void)returnBtnClick
{
    [UIView animateWithDuration:0.25 animations:^{
        pView.frame = CGRectMake(0, LHeight, LWidth, 190);
    }];
}
- (void)endBtnClick
{
    [UIView animateWithDuration:0.25 animations:^{
        pView.frame = CGRectMake(0, LHeight, LWidth, 190);
    }];
    NSDate *select = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
    [self refactoringView:timeIndex contens:dateAndTime];
}

/**************************************************************************************************/
//    日期+时间
/**************************************************************************************************/
- (void)dateTimeView
{
    pDTView = [[UIView alloc] initWithFrame:CGRectMake(0, LHeight, LWidth, 190)];
    pDTView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pDTView];
    
    UILabel* labtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, LWidth, 20)];
    labtitle.text = @"选择日期";
    labtitle.textAlignment = NSTextAlignmentCenter;
    labtitle.textColor = [UIColor blackColor];
    labtitle.font = [UIFont systemFontOfSize:15];
    labtitle.backgroundColor = [UIColor clearColor];
    [pDTView addSubview:labtitle];
    //    取消按钮
    UIButton* returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(10, 0, 50, 30);
    returnBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [returnBtn setTitle:@"取消" forState:0];
    [returnBtn setTitleColor:[UIColor colorWithRed:0.000 green:0.800 blue:0.600 alpha:1] forState:0];
    [returnBtn addTarget:self action:@selector(returnDTBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [pDTView addSubview:returnBtn];
    
    //    确定按钮
    UIButton* endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    endBtn.frame = CGRectMake(LWidth-60, 0, 50, 30);
    endBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [endBtn setTitle:@"完成" forState:0];
    [endBtn setTitleColor:[UIColor colorWithRed:0.000 green:0.800 blue:0.600 alpha:1] forState:0];
    [endBtn addTarget:self action:@selector(endBtnDTClick) forControlEvents:UIControlEventTouchUpInside];
    [pDTView addSubview:endBtn];
    
    //    横线
    UIImageView* bgimagViewA = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
    bgimagViewA.frame = CGRectMake(0, 0, LWidth, 2);
    [pDTView addSubview:bgimagViewA];
    UIImageView* bgimagViewB = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
    bgimagViewB.frame = CGRectMake(0, 28, LWidth, 2);
    [pDTView addSubview:bgimagViewB];
    
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    dateTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, LWidth, 160)];
    dateTimePicker.datePickerMode = UIDatePickerModeDate;
    [dateTimePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    dateTimePicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    dateTimePicker.minuteInterval = 5;
    dateTimePicker.datePickerMode=UIDatePickerModeDate;
    dateTimePicker.backgroundColor = [UIColor whiteColor];
    [pDTView addSubview:dateTimePicker];
    
    if (dateTimeStr.length != 0) {
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate* date = [formater dateFromString:dateTimeStr];
        [dateTimePicker setDate:date animated:YES];
    }
}
- (void)dateView
{
    timeStr = nil;
    [pDView removeFromSuperview];
    pDView = [[UIView alloc] initWithFrame:CGRectMake(0, LHeight, LWidth, 190)];
    pDView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pDView];
    
    UILabel* labtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, LWidth, 20)];
    labtitle.text = @"选择时分";
    labtitle.textAlignment = NSTextAlignmentCenter;
    labtitle.textColor = [UIColor blackColor];
    labtitle.font = [UIFont systemFontOfSize:15];
    labtitle.backgroundColor = [UIColor clearColor];
    [pDView addSubview:labtitle];
    //    取消按钮
    UIButton* returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(10, 0, 50, 30);
    returnBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [returnBtn setTitle:@"取消" forState:0];
    [returnBtn setTitleColor:[UIColor colorWithRed:0.000 green:0.800 blue:0.600 alpha:1] forState:0];
    [returnBtn addTarget:self action:@selector(returnDBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [pDView addSubview:returnBtn];
    
    //    确定按钮
    UIButton* endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    endBtn.frame = CGRectMake(LWidth-60, 0, 50, 30);
    endBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [endBtn setTitle:@"完成" forState:0];
    [endBtn setTitleColor:[UIColor colorWithRed:0.000 green:0.800 blue:0.600 alpha:1] forState:0];
    [endBtn addTarget:self action:@selector(endBtnDClick) forControlEvents:UIControlEventTouchUpInside];
    [pDView addSubview:endBtn];
    
    //    横线
    UIImageView* bgimagViewA = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
    bgimagViewA.frame = CGRectMake(0, 0, LWidth, 2);
    [pDView addSubview:bgimagViewA];
    UIImageView* bgimagViewB = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
    bgimagViewB.frame = CGRectMake(0, 28, LWidth, 2);
    [pDView addSubview:bgimagViewB];
    
    
    pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, LWidth, 160)];
    pickView.backgroundColor = [UIColor whiteColor];
    pickView.delegate = self;
    pickView.dataSource = self;
    [pickView selectRow:0 inComponent:0 animated:YES];
    [pDView addSubview:pickView];
    
    [UIView animateWithDuration:0.25 animations:^{
        pDView.frame = CGRectMake(0, LHeight-255, LWidth, 190);
    }];
    [self.view bringSubviewToFront:pDView];
}
- (void)returnDTBtnClick
{
    [UIView animateWithDuration:0.25 animations:^{
        pDTView.frame = CGRectMake(0, LHeight, LWidth, 190);
    }];
}
- (void)endBtnDTClick
{
    [UIView animateWithDuration:0.25 animations:^{
        pDTView.frame = CGRectMake(0, LHeight, LWidth, 190);
    } completion:^(BOOL finished) {
        [self dateView];
    }];
}
- (void)returnDBtnClick
{
    [UIView animateWithDuration:0.25 animations:^{
        pDView.frame = CGRectMake(0, LHeight, LWidth, 190);
    }];
}
- (void)endBtnDClick
{
    [UIView animateWithDuration:0.25 animations:^{
        pDView.frame = CGRectMake(0, LHeight, LWidth, 190);
    }];
    NSDate *select = [dateTimePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
    
    if (timeStr==nil||[timeStr isEqualToString:@""]||[timeStr isEqual:[NSNull null]]) {
        timeStr = [NSString stringWithFormat:@"%@ 00:00:00",dateAndTime];
    }else{
        timeStr = [NSString stringWithFormat:@"%@ %@:00",dateAndTime,timeStr];
    }
    [self refactoringView:dateTimeIndex contens:timeStr];
}
#pragma mark ----------------------------- pickview
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 24;
    }else{
        return 60;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return whenArray[row];
    }else{
        return pointsArray[row];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString* timeh = @"";
    NSString* timem = @"";
    if (component == 0) {
        timeh = whenArray[row];
    }else{
        timem = pointsArray[row];
    }
    timeStr = [NSString stringWithFormat:@"%@:%@",timeh==nil||[timeh isEqualToString:@""]||[timeh isEqual:[NSNull null]]?whenArray[0]:timeh,timem==nil||[timem isEqualToString:@""]||[timem isEqual:[NSNull null]]?pointsArray[0]:timem];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
    }
    return YES;
}




@end
