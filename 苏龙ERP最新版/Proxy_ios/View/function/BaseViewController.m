//
//  BaseViewController.m
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/23.
//  Copyright © 2015年 keyuan. All rights reserved.

//

#import "BaseViewController.h"
#import "BaseTableViewCell.h"
#import "BaseDetailedViewController.h"
#import "MJRefresh.h"

@interface BaseViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UIButton* listButton;
    UIButton* valueButton;
    UILabel* timeLabelEnd;
    UILabel* timeLabel;
    
    BOOL isList;
    BOOL isValue;
    
    UITableView* listTableView;
    UITableView* valueTableView;
    UITableView* contensTableView;
    
    NSMutableDictionary* showBtnDict;
    
    NSString* dGuidStr;
    NSString* fGuidStr;
    
    UIView* pView;
    NSString* isEnd;
    UIDatePicker* datePicker;
    NSMutableArray* showRowArray;
    NSInteger startIndex;
    NSDictionary *refreshdict;
    NSString *firsyStr;
    NSString *secondStr;
    NSString *thirdStr;
    NSString *fourStr;
}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 缺陷查询
    self.title = _title_str;
    startIndex = 1;
    isList = YES;
    isValue = YES;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
    
    listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.tag = 0;
    listButton.backgroundColor = [UIColor whiteColor];
    listButton.frame = CGRectMake(10, 10, (LWidth-30)/2, 30);
    [listButton setTitle:@"【专业】" forState:0];
    [listButton setTitleColor:[UIColor blackColor] forState:0];
    listButton.layer.borderColor = [[UIColor colorWithRed:0.773 green:0.780 blue:0.776 alpha:1] CGColor];
    listButton.layer.borderWidth = .5f;
    listButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [listButton addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:listButton];
    
    valueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    valueButton.tag = 1;
    valueButton.backgroundColor = [UIColor whiteColor];
    valueButton.frame = CGRectMake((LWidth-30)/2+20, 10, (LWidth-30)/2, 30);
    [valueButton setTitle:@"【机组】" forState:0];
    [valueButton setTitleColor:[UIColor blackColor] forState:0];
    valueButton.layer.borderColor = [[UIColor colorWithRed:0.773 green:0.780 blue:0.776 alpha:1] CGColor];
    valueButton.layer.borderWidth = .5f;
    valueButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [valueButton addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:valueButton];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, (LWidth-30-100)/2, 25)];
    timeLabel.backgroundColor = [UIColor whiteColor];
    timeLabel.text = @"选择开始日期";
    timeLabel.userInteractionEnabled = YES;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = [UIFont systemFontOfSize:12];
    UITapGestureRecognizer * time = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(timeClick)];
    [timeLabel addGestureRecognizer:time];
    timeLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
    [self.view addSubview:timeLabel];
    
    UILabel* timeLabelZ = [[UILabel alloc] initWithFrame:CGRectMake(timeLabel.frame.origin.x+timeLabel.frame.size.width+5, 50, 15, 25)];
    timeLabelZ.backgroundColor = [UIColor clearColor];
    timeLabelZ.text = @"至";
    timeLabelZ.textAlignment = NSTextAlignmentCenter;
    timeLabelZ.font = [UIFont systemFontOfSize:12];
    timeLabelZ.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    [self.view addSubview:timeLabelZ];
    
    timeLabelEnd = [[UILabel alloc] initWithFrame:CGRectMake(timeLabel.frame.size.width+timeLabel.frame.origin.x+25, 50, (LWidth-30-100)/2, 25)];
    timeLabelEnd.backgroundColor = [UIColor whiteColor];
    timeLabelEnd.text = @"选择结束日期";
    timeLabelEnd.textAlignment = NSTextAlignmentCenter;
    timeLabelEnd.userInteractionEnabled = YES;
    timeLabelEnd.font = [UIFont systemFontOfSize:12];
    UITapGestureRecognizer * end = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endTimeClick)];
    [timeLabelEnd addGestureRecognizer:end];
    timeLabelEnd.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
    [self.view addSubview:timeLabelEnd];
    
    UIButton* searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.tag = 2;
    searchButton.backgroundColor = [UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1];
    searchButton.frame = CGRectMake(timeLabelEnd.frame.origin.x+timeLabelEnd.frame.size.width+10, 50, LWidth-20-(timeLabelEnd.frame.origin.x+timeLabelEnd.frame.size.width), 25);
    [searchButton setTitle:@"搜索" forState:0];
    [searchButton setTitleColor:[UIColor whiteColor] forState:0];
    searchButton.layer.masksToBounds = YES;
    searchButton.layer.cornerRadius = 3;
    searchButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [searchButton addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
    
    [self requestShowDataNews];
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
    
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, LWidth, 160)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    datePicker.minuteInterval = 5;
    datePicker.backgroundColor = [UIColor whiteColor];
    [pView addSubview:datePicker];
    [self initTableView];
    [self searchData];
}
- (void)timeClick
{
    isEnd = @"开始";
    [UIView animateWithDuration:0.25 animations:^{
        pView.frame = CGRectMake(0, LHeight-255, LWidth, 190);
    }];
}
- (void)endTimeClick
{
    isEnd = @"结束";
    [UIView animateWithDuration:0.25 animations:^{
        pView.frame = CGRectMake(0, LHeight-255, LWidth, 190);
    }];
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
    if ([isEnd isEqualToString:@"开始"]) timeLabel.text = dateAndTime;
    if ([isEnd isEqualToString:@"结束"]) timeLabelEnd.text = dateAndTime;
}
- (void)listButtonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            if (isList) {
                listTableView.hidden = NO;
                [listButton setTitle:@"取消" forState:0];
                [listButton setBackgroundColor:[UIColor orangeColor]];
                [listButton setTitleColor:[UIColor whiteColor] forState:0];
            }else{
                [listButton setTitle:@"【专业】" forState:0];
                listTableView.hidden = YES;
                [listButton setBackgroundColor:[UIColor whiteColor]];
                [listButton setTitleColor:[UIColor blackColor] forState:0];
            }
            isList = !isList;
        }
            break;
        case 1:
        {
            if (isValue) {
                [valueButton setTitle:@"取消" forState:0];
                valueTableView.hidden = NO;
                [valueButton setBackgroundColor:[UIColor orangeColor]];
                [valueButton setTitleColor:[UIColor whiteColor] forState:0];
            }else{
                [valueButton setTitle:@"【机组】" forState:0];
                valueTableView.hidden = YES;
                [valueButton setBackgroundColor:[UIColor whiteColor]];
                [valueButton setTitleColor:[UIColor blackColor] forState:0];
            }
            isValue = !isValue;
        }
            break;
        case 2:
        {
            [self searchData];
        }
            break;
            
        default:
            break;
    }
}
- (void)searchData
{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    if ([listButton.titleLabel.text isEqualToString:@"【专业】"] || [listButton.titleLabel.text isEqualToString:@"取消"]) dGuidStr = @"";
    if ([valueButton.titleLabel.text isEqualToString:@"【机组】"] || [valueButton.titleLabel.text isEqualToString:@"取消"]) fGuidStr = @"";
    NSString* timeStr = @"";
    if ([timeLabel.text isEqualToString:@"选择开始日期"]){
        timeStr = @"";
    }else{
        timeStr = timeLabel.text;
    }
    NSString* endTimeStr = @"";
    if ([timeLabelEnd.text isEqualToString:@"选择结束日期"]) {
        endTimeStr = @"";
    }else{
        endTimeStr = timeLabelEnd.text;
    }
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETEQUIPDEFECT",@"Action",@"10",@"Pagesize",@"1",@"Pageindex",@"DESC",@"Softtype",@"FBILLID",@"Softfield",fGuidStr,@"UNITGUID",dGuidStr,@"FMSGUID",timeStr,@"FEDITTIMEBEG",endTimeStr,@"FEDITTIMEEND", nil];
    firsyStr=fGuidStr;
    secondStr=dGuidStr;
    thirdStr=timeStr;
   fourStr=endTimeStr;
    //refreshdict=dict;
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/EAM/%@",HTTPIP,SLRD,PAGE_PROFIX_URL] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            [showRowArray removeAllObjects];
            showRowArray = [NSMutableArray arrayWithArray:[dictt objectForKey:@"data"]];
            [contensTableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}
- (void)requestShowDataRefresh
{
    startIndex = startIndex+1;
    NSString* pageIndex = [NSString stringWithFormat:@"%ld",(long)startIndex];
    if ([listButton.titleLabel.text isEqualToString:@"【专业】"] || [listButton.titleLabel.text isEqualToString:@"取消"]) dGuidStr = @"";
    if ([valueButton.titleLabel.text isEqualToString:@"【机组】"] || [valueButton.titleLabel.text isEqualToString:@"取消"]) fGuidStr = @"";
    NSString* timeStr = @"";
    if ([timeLabel.text isEqualToString:@"选择开始日期"]){
        timeStr = @"";
    }else{
        timeStr = timeLabel.text;
    }
    NSString* endTimeStr = @"";
    if ([timeLabelEnd.text isEqualToString:@"选择结束日期"]) {
        endTimeStr = @"";
    }else{
        endTimeStr = timeLabelEnd.text;
    }
    NSLog(@"dg=====%@",dGuidStr);
    NSLog(@"fg=====%@",fGuidStr);
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETEQUIPDEFECT",@"Action",@"10",@"Pagesize",pageIndex,@"Pageindex",@"DESC",@"Softtype",@"FBILLID",@"Softfield",firsyStr,@"UNITGUID",secondStr,@"FMSGUID",thirdStr,@"FEDITTIMEBEG",fourStr,@"FEDITTIMEEND", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/EAM/%@",HTTPIP,SLRD,PAGE_PROFIX_URL] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            NSMutableArray* array = [[NSMutableArray alloc] initWithArray:[dictt objectForKey:@"data"]];
            if (array.count < 10) {
                [SVProgressHUD showSuccessWithStatus:@"加载到底了"];
                for (NSUInteger i = 0; i < array.count; i ++) {
                    [showRowArray addObject:[array objectAtIndex:i]];
                }
                [contensTableView reloadData];
            }else{
                for (NSUInteger i = 0; i < array.count; i ++) {
                    [showRowArray addObject:[array objectAtIndex:i]];
                }
                [contensTableView reloadData];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}
- (void)initdropDownMenu;
{
    listTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 40, (LWidth-30)/2, 180)];
    listTableView.hidden = YES;
    listTableView.delegate = self;
    listTableView.dataSource = self;
    listTableView.rowHeight = 30;
    listTableView.tag = 0;
    listTableView.backgroundColor = [UIColor whiteColor];
    listTableView.layer.borderColor = [[UIColor colorWithRed:0.773 green:0.780 blue:0.776 alpha:1] CGColor];
    listTableView.layer.borderWidth = .5f;
    listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [listTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:listTableView];
    
    //    [self searchData];
}
- (void)initdropDownMenuValue;
{
    valueTableView = [[UITableView alloc] initWithFrame:CGRectMake((LWidth-30)/2+20, 40, (LWidth-30)/2, 180)];
    valueTableView.hidden = YES;
    valueTableView.delegate = self;
    valueTableView.dataSource = self;
    valueTableView.rowHeight = 30;
    valueTableView.tag = 1;
    valueTableView.backgroundColor = [UIColor whiteColor];
    valueTableView.layer.borderColor = [[UIColor colorWithRed:0.773 green:0.780 blue:0.776 alpha:1] CGColor];
    valueTableView.layer.borderWidth = .5f;
    valueTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [valueTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:valueTableView];
}
- (void)initTableView
{
    contensTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 85, LWidth, LHeight-116-35)];
    contensTableView.delegate = self;
    contensTableView.dataSource = self;
    contensTableView.tag = 2;
    contensTableView.sectionHeaderHeight =30;
    contensTableView.backgroundColor = [UIColor whiteColor];
    contensTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [contensTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [contensTableView addHeaderWithTarget:self action:@selector(upRefresh:)];
    [contensTableView addFooterWithTarget:self action:@selector(downRefresh:)];
    [self.view addSubview:contensTableView];
    [self.view bringSubviewToFront:pView];
}
#pragma mark ------ 下拉刷新
- (void)upRefresh:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self searchData];
        [contensTableView headerEndRefreshing];
    });
}
#pragma mark ------ 上拉加载
- (void)downRefresh:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestShowDataRefresh];
        [contensTableView footerEndRefreshing];
    });
}
- (void)requestShowDataNews
{
    [showBtnDict removeAllObjects];
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETBASEDATA",@"Action", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/EAM/ProxyMobile/DefectProxy.ashx",HTTPIP,SLRD] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        showBtnDict = [NSMutableDictionary dictionaryWithDictionary:[dictt objectForKey:@"Data"]];
        [self initdropDownMenu];
        [self initdropDownMenuValue];
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0) {
        return [[[showBtnDict objectForKey:@"SPEC"] objectForKey:@"R"] count];
    }else if (tableView.tag == 1) {
        return [[[showBtnDict objectForKey:@"UNIT"] objectForKey:@"R"] count];
    }else{
        return showRowArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2) {
        static NSString *CellIdentifier = @"CellIdentifier";
        BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BaseTableViewCell" owner:nil options:nil];
            for (id oneObject in nib)
            {
                if ([oneObject isKindOfClass:[BaseTableViewCell class]])
                {
                    cell = (BaseTableViewCell *)oneObject;
                }
            }
        }
        NSString*defectState=[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FSTATENAME"];
        //NSString *str=[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FBILLID"];
        //        cell.label1.textColor=[UIColor colorWithRed:139 green:0 blue:139 alpha:1];
        // cell.stateLAb.textColor=[UIColor colorWithRed:255 green:20 blue:147 alpha:1];
        //         cell.label1.text =[NSString stringWithFormat:@"%@【%@】%@ %@ %@",[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FSTATENAME"],[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FBILLID"],[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FCLASSNAME"],[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FMSNAME"],[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FUNITNAME"]];
        
        if ([[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FSTATENAME"] isEqualToString:@"编辑"])cell.label1.textColor=[UIColor colorWithRed:255.0/255 green:0.0/255 blue:147.0/255 alpha:1];
        
        else if([[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FSTATENAME"] isEqualToString:@"验收合格"])cell.label1.textColor=[UIColor colorWithRed:80.0/255 green:180.0/255 blue:50.0/255 alpha:1];
        else if([[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FSTATENAME"] isEqualToString:@"缺陷确认"]) cell.label1.textColor=[UIColor colorWithRed:237.0/255 green:86.0/255 blue:27.0/255 alpha:1];
        
        else if([[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FSTATENAME"] isEqualToString:@"缺陷处理"])cell.label1.textColor=[UIColor colorWithRed:255.0/255 green:0.0/255 blue:0.0/255 alpha:1];
        
        else if([[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FSTATENAME"] isEqualToString:@"提交验收"]) cell.label1.textColor=[UIColor colorWithRed:139.0/255 green:34.0/255 blue:82.0/255 alpha:1];
        
        else if([[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FSTATENAME"] isEqualToString:@"工单处理"])   cell.label1.textColor=[UIColor colorWithRed:153.0/255 green:153.0/255 blue:0.0/255 alpha:1] ;
        else if([[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FSTATENAME"] isEqualToString:@"值长确认"])
            cell.label1.textColor=[UIColor colorWithRed:0.0/255 green:100.0/255 blue:0.0/255 alpha:1] ;
        else if([[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FSTATENAME"] isEqualToString:@"发送缺陷"])
            cell.label1.textColor=[UIColor
                                   colorWithRed:0.8/255 green:0.8/255 blue:0.8/255 alpha:1];
        
        else if([[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FSTATENAME"] isEqualToString:@"延期同意"])cell.label1.textColor=[UIColor colorWithRed:139.0/255 green:0.0/255 blue:0.0/255 alpha:1] ;
        else if([[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FSTATENAME"] isEqualToString:@"延期不同意"])       cell.label1.textColor=[UIColor colorWithRed:47 green:79.0/255 blue:79.0/255 alpha:1];
        else if([[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FSTATENAME"] isEqualToString:@"驳回"])        cell.label1.textColor=[UIColor colorWithRed:32.0/255 green:178.0/255 blue:170.0/255 alpha:1];
        else if([[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FSTATENAME"] isEqualToString:@"作废"]) cell.label1.textColor=[UIColor colorWithRed:139.0/255 green:0.0/255 blue:139.0/255 alpha:1];
        else{
            cell.label1.text = [NSString stringWithFormat:@"%@【%@】%@ %@ %@",[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FSTATENAME"],[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FBILLID"],[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FCLASSNAME"],[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FMSNAME"],[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FUNITNAME"]];
            
            
        }
        cell.label1.text =[NSString stringWithFormat:@"%@【%@】%@ %@ %@",defectState,[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FBILLID"],[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FCLASSNAME"],[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FMSNAME"],[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FUNITNAME"]];
        
        NSLog(@"shjdgfhjadsghdsfadsjfghjkadfh====%@",[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FSTATENAME"]);
        cell.label2.text = [NSString stringWithFormat:@"描述:%@",[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FDESC"]];
        CGSize size = [self sizeWithString:cell.label2.text font:cell.label2.font];
        cell.label2.frame = CGRectMake(20, cell.label1.frame.origin.y+cell.label1.frame.size.height+15, LWidth-40, size.height);
        cell.label3.text = [NSString stringWithFormat:@"位置:%@",[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FLENAME"]];
        cell.label3.frame = CGRectMake(20, cell.label2.frame.origin.y+size.height+15, LWidth-40, 15);
        tableView.rowHeight = cell.label3.frame.origin.y+30;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bgImag.frame = CGRectMake(0, cell.label3.frame.origin.y+28, LWidth, 2);
        return cell;
    }else{
        static NSString *MyIdentifier = @"MyIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        }
        if (tableView.tag == 0) {
            cell.textLabel.text = [[[[showBtnDict objectForKey:@"SPEC"] objectForKey:@"R"] objectAtIndex:indexPath.row] objectForKey:@"DNAME"];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            UIImageView* imag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
            imag.frame = CGRectMake(0, 29, LWidth, 1);
            [cell.contentView addSubview:imag];
        }else if (tableView.tag == 1) {
            cell.textLabel.text = [[[[showBtnDict objectForKey:@"UNIT"] objectForKey:@"R"] objectAtIndex:indexPath.row] objectForKey:@"FNAME"];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            UIImageView* imag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
            imag.frame = CGRectMake(0, 29, LWidth, 1);
            [cell.contentView addSubview:imag];
        }
        
        return cell;
    }
}
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(LWidth-40, LHeight)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  | NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    return rect.size;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        [listButton setTitle:[[[[showBtnDict objectForKey:@"SPEC"] objectForKey:@"R"] objectAtIndex:indexPath.row] objectForKey:@"DNAME"] forState:0];
        [listButton setBackgroundColor:[UIColor whiteColor]];
        [listButton setTitleColor:[UIColor blackColor] forState:0];
        dGuidStr = [[[[showBtnDict objectForKey:@"SPEC"] objectForKey:@"R"] objectAtIndex:indexPath.row] objectForKey:@"GUID"];
        listTableView.hidden = YES;
        isList = YES;
    }else if (tableView.tag == 1) {
        [valueButton setTitle:[[[[showBtnDict objectForKey:@"UNIT"] objectForKey:@"R"] objectAtIndex:indexPath.row] objectForKey:@"FNAME"] forState:0];
        [valueButton setBackgroundColor:[UIColor whiteColor]];
        [valueButton setTitleColor:[UIColor blackColor] forState:0];
        fGuidStr = [[[[showBtnDict objectForKey:@"UNIT"] objectForKey:@"R"] objectAtIndex:indexPath.row] objectForKey:@"FGUID"];
        valueTableView.hidden = YES;
        isValue = YES;
    }else if (tableView.tag == 2) {
        BaseDetailedViewController* vc = [[BaseDetailedViewController alloc] initWithShowData:[showRowArray objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
