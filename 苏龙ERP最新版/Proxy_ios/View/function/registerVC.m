//
//  registerVC.m
//  Proxy_ios
//
//  Created by sciyonSoft on 16/1/13.
//  Copyright © 2016年 keyuan. All rights reserved.
//

#import "registerVC.h"
#import "BaseViewController.h"
#import "BaseTableViewCell.h"
#import "BaseDetailedViewController.h"
#import "MJRefresh.h"
#import "AllTableViewCell.h"
#import "registerDetilVC.h"

@interface registerVC ()<UITableViewDataSource,UITableViewDelegate>{
    NSString* url;
    NSString* title_str;
    
    
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
    NSString *BeginTime;
    NSString *currentTime;
    NSDictionary * showDataDict;
    NSString *refreshBeginTime;
    NSString *refreshEndTime;
    

}

@end

@implementation registerVC
- (id)initWithUrl:(NSString *)aUrl title:(NSString *)titleStr
{
    self = [super init];
    if (self) {
        [SVProgressHUD showWithStatus:@"努力加载中..."];
        
        url = aUrl;
        title_str = titleStr;
    }
    return self;
}



-(void)viewWillAppear:(BOOL)animated{
    [contensTableView reloadData];
    
    [self searchData];




}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"外出登记";
    NSLog(@"titleStr===%@",title_str);
    startIndex = 1;
    isList = YES;
    isValue = YES;
    
    [self initBarbton];
       timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (LWidth-30)/2-5, 30)];
         timeLabel.backgroundColor = [UIColor whiteColor];
    timeLabel.text = @"选择开始日期";
    timeLabel.userInteractionEnabled = YES;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = [UIFont systemFontOfSize:12];
    UITapGestureRecognizer * time = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(timeClick)];
    [timeLabel addGestureRecognizer:time];
    timeLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
    [self.view addSubview:timeLabel];
    
    UILabel* timeLabelZ = [[UILabel alloc] initWithFrame:CGRectMake(timeLabel.frame.origin.x+timeLabel.frame.size.width+5,10, 15, 38)];
    timeLabelZ.backgroundColor = [UIColor clearColor];
    timeLabelZ.text = @"至";
    timeLabelZ.textAlignment = NSTextAlignmentCenter;
    timeLabelZ.font = [UIFont systemFontOfSize:12];
    timeLabelZ.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    [self.view addSubview:timeLabelZ];
    
    timeLabelEnd = [[UILabel alloc] initWithFrame:CGRectMake((LWidth-30)/2+5 +20,10, (LWidth-30)/2-5, 30)];
    timeLabelEnd.backgroundColor = [UIColor whiteColor];
    //timeLabelEnd.text = currentTime;
    timeLabelEnd.textAlignment = NSTextAlignmentCenter;
    timeLabelEnd.userInteractionEnabled = YES;
    timeLabelEnd.font = [UIFont systemFontOfSize:12];
    UITapGestureRecognizer * end = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endTimeClick)];
    [timeLabelEnd addGestureRecognizer:end];
    timeLabelEnd.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
    [self.view addSubview:timeLabelEnd];
    
    UIButton * reset = [UIButton buttonWithType:UIButtonTypeCustom];
    reset.frame = CGRectMake(10, timeLabel.frame.origin.y+timeLabel.frame.size.height+5, (LWidth-30)/2, 35);
    reset.tag = 3;
    reset.backgroundColor = [UIColor colorWithRed:19/255.0 green:153/255.0 blue:251/255.0 alpha:1];
    reset.layer.masksToBounds = YES;
    reset.layer.cornerRadius = 5;
    reset.titleLabel.font = [UIFont systemFontOfSize:16];
    [reset setTitle:@"重置" forState:0];
    [reset setTitleColor:[UIColor whiteColor] forState:0];
    [reset addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reset];
    
    UIButton* searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.tag = 2;
    searchButton.backgroundColor = [UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1];
   
    searchButton.frame = CGRectMake((LWidth-30)/2+20, timeLabel.frame.origin.y+timeLabel.frame.size.height+5, (LWidth-30)/2, 35);
    
    [searchButton setTitle:@"搜索" forState:0];
    [searchButton setTitleColor:[UIColor whiteColor] forState:0];
    searchButton.layer.masksToBounds = YES;
    searchButton.layer.cornerRadius = 3;
    searchButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [searchButton addTarget:self action:@selector(searchData) forControlEvents:UIControlEventTouchUpInside];
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
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal
                               components:NSYearCalendarUnit | NSMonthCalendarUnit
                               fromDate:now];
    comps.day = 1;
    NSDate *firstDay = [cal dateFromComponents:comps];
BeginTime = [formatter stringFromDate:firstDay];
    timeLabel.text=BeginTime;
    
currentTime = [formatter stringFromDate:[NSDate date]];
    timeLabelEnd.text=currentTime;
    
    
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

-(void)initBarbton{
    self.view.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
    
    UIBarButtonItem * addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    
    self.navigationItem.rightBarButtonItem = addButton;
    

}
-(void)add{
    
    registerDetilVC* vc = [[registerDetilVC alloc]initWithShowData:showDataDict];
    vc.type=2;
    [self.navigationController pushViewController:vc animated:YES];
    
   

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
    if ([isEnd isEqualToString:@"开始"]) timeLabel.text =dateAndTime;
    if ([isEnd isEqualToString:@"结束"]) timeLabelEnd.text=dateAndTime;
}
- (void)listButtonClick:(UIButton *)sender
{
    timeLabel.text=BeginTime;
    timeLabelEnd.text=currentTime;
    [self searchData];
}
- (void)searchData
{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
   
    NSString* timeStr = @"";
    
    timeStr = [NSString stringWithFormat:@"%@ 00:00:00",timeLabel.text];
  
       NSString* endTimeStr = @"";
          endTimeStr = [NSString stringWithFormat:@"%@ 23:59:59",timeLabelEnd.text];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETGETOUTDATA",@"Action",@"10",@"Pagesize",@"1",@"Pageindex",@"DESC",@"Softtype",@"FAPPSDATE",@"Softfield",timeStr,@"BDATE",endTimeStr,@"EDATE", nil];
   
   refreshBeginTime=timeStr;
  refreshEndTime=endTimeStr;
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/EPM/%@",HTTPIP,SLRD,PAGE_PROFIX_URL] withParameter:dict];
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

    NSString* timeStr = @"";
    timeStr = [NSString stringWithFormat:@"%@",timeLabel.text];
        NSString* endTimeStr = @"";
    endTimeStr = [NSString stringWithFormat:@"%@",timeLabelEnd.text];
 
   
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETGETOUTDATA",@"Action",@"10",@"Pagesize",pageIndex,@"Pageindex",@"DESC",@"Softtype",@"FAPPSDATE",@"Softfield",refreshBeginTime,@"BDATE",refreshEndTime,@"EDATE", nil];
        MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/EPM/%@",HTTPIP,SLRD,PAGE_PROFIX_URL] withParameter:dict];
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
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETGETOUTDATA",@"Action", nil];
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
        
                    static NSString *cellStr = @"CellIdentifier";
        AllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if(cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AllTableViewCell" owner:nil options:nil];
            for (id oneObject in nib)
            {
                if ([oneObject isKindOfClass:[AllTableViewCell class]])
                {
                    cell = (AllTableViewCell *)oneObject;
                }
            }
        }
    NSString *begintime =[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FAPPEDATE"];
    NSString *endtime =[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FAPPSDATE"];
      
    NSString *contents=[NSString stringWithFormat:@"%@:%@   %@~%@    事由:%@",[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FCREATORNAME"],[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FTYPE"], [self replecString:begintime],[self replecString:endtime],[[showRowArray objectAtIndex:indexPath.row] objectForKey:@"FREASON"]];
    
    CGSize size = [self sizeWithString:contents font:cell.title.font];
    cell.title.text =contents;
    

        cell.title.frame = CGRectMake(10, 8, LWidth-20, size.height);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.rowHeight = size.height+17;
        cell.rowImag.frame = CGRectMake(0, tableView.rowHeight-1, LWidth, 1);
        return cell;

        
        
}
-(NSString *)replecString:(NSString *)string{
   
    NSString *newBtime =[string stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSString *nowStr =[newBtime stringByReplacingOccurrencesOfString:@"+08:00" withString:@""];
    return nowStr;




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
       registerDetilVC* vc = [[registerDetilVC alloc] initWithShowData:[showRowArray objectAtIndex:indexPath.row]];
        vc.type=1;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
