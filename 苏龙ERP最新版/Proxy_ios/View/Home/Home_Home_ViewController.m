//
//  Home_Home_ViewController.m
//  Proxy_ios
//
//  Created by E-Bans on 15/11/13.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "Home_Home_ViewController.h"
#import "LeftViewController.h"
#import "SetViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "Home_TableViewCell.h"
#import "Home_TwoTableViewCell.h"
#import "BookViewController.h"
#import "BYMainController.h"
#import "RunLogViewController.h"
#import "WorkLogViewController.h"
#import "BaseViewController.h"
#import "NoticeViewController.h"
#import "HotNewsViewController.h"
#import "AllQueryViewController.h"
#import "SimplePingHelper.h"//ping

@interface Home_Home_ViewController () <LeftViewControllerDelegate,LeftViewControllerPushDelegate,UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,MyRequestDelegate>
{
    NSArray* capacityArray;
    NSArray* mgArray;
    NSMutableArray* showDataArray;
    UIView* roundView;
    UIView* popView;
    NSMutableArray* historyArray;
    
    NSMutableArray* historyArray1;
    NSTimer *timer;
}
@end

@implementation Home_Home_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    
    
    
    [self configWebView];
    [self requestHistoryShowDataList];
    
    
    
    UIBarButtonItem * lefyButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@""
                                    style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(callModalList)];
    
    [lefyButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:15], NSFontAttributeName,
                                        [UIColor whiteColor], NSForegroundColorAttributeName,
                                        nil]
                              forState:UIControlStateNormal];
    lefyButton.image = [UIImage imageNamed:@"leftImag"];
    self.navigationItem.leftBarButtonItem = lefyButton;
    roundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LWidth, 120)];
    
    roundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:roundView];
    self.view.backgroundColor = [UIColor colorWithRed:0.01 green:0.33 blue:0.64 alpha:1];
    
    self.home_tableView_two = [[UITableView alloc] init];
    self.home_tableView_two.frame = CGRectMake(10, LHeight-193, LWidth-20, 80);
    if (LWidth>375)self.home_tableView_two.frame = CGRectMake(10, LHeight-206, LWidth-20, 80);
    if (LWidth==375)self.home_tableView_two.frame = CGRectMake(10, LHeight-200, LWidth-20, 80);
    self.home_tableView_two.delegate = self;//最下方的表
    self.home_tableView_two.tag = 1;
    self.home_tableView_two.dataSource = self;
    self.home_tableView_two.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.home_tableView_two setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.home_tableView_two.backgroundColor = [UIColor clearColor];
    self.home_tableView_two.userInteractionEnabled = NO;
    self.home_tableView_two.rowHeight = 20;
    
    [self.view addSubview:self.home_tableView_two];
    
    
    
    
    
    self.home_tableView = [[UITableView alloc] init];
    
    self.home_tableView.delegate = self;//上方的表
    self.home_tableView.tag = 0;
    self.home_tableView.dataSource = self;
    self.home_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.home_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.home_tableView.backgroundColor = [UIColor clearColor];
    
    self.home_tableView.userInteractionEnabled = NO;
    if (LWidth==375)self.home_tableView.frame = CGRectMake(10, LHeight-200-193-140, LWidth-20, 140);
    if (LWidth<375)self.home_tableView.frame = CGRectMake(10, LHeight-160-193-140, LWidth-20, 140);
    if (LWidth>375)self.home_tableView.frame = CGRectMake(10, LHeight-220-223-140, LWidth-20, 140);
    self.home_tableView.rowHeight = 20;
    [self.view addSubview:self.home_tableView];
    
    NSArray* array = @[@"发电负荷",@"日发电量",@"供汽流量",@"日供汽量"];
    NSArray* colorArray = @[[UIColor colorWithRed:0.65 green:0.57 blue:0.49 alpha:1],[UIColor colorWithRed:0.39 green:0.61 blue:0.56 alpha:1],[UIColor colorWithRed:0.15 green:0.62 blue:0.82 alpha:1],[UIColor colorWithRed:0.56 green:0.45 blue:0.62 alpha:1]];
    for (NSInteger index = 0; index < 4; index ++) {
        NSInteger X = index%4*((LWidth-5)/4);
        
        UIImageView* imagView = [[UIImageView alloc] init];
        imagView.frame = CGRectMake(X+5, IPHONE_5?0:20, (LWidth-30)/4, (LWidth-30)/4);
        imagView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.png",index+1]];
        [roundView addSubview:imagView];
        
        UILabel* labelTitle = [[UILabel alloc] init];
        labelTitle.textAlignment = NSTextAlignmentCenter;
        labelTitle.font = [UIFont systemFontOfSize:14];
        labelTitle.frame = CGRectMake(X+5, IPHONE_5?15:40, (LWidth-30)/4, 20);
        labelTitle.textColor = colorArray[index];
        labelTitle.text = array[index];
        [roundView addSubview:labelTitle];
    }
    
    capacityArray = [NSArray arrayWithObjects:@"",@"137.5",@"137.5",@"140.0",@"140.0",@"330.0",@"330.0", nil];
    mgArray = [NSArray arrayWithObjects:@"烟尘折算[Mg/Nm³]",@"二氧化硫[Mg/Nm³]",@"氮氧化物[Mg/Nm³]", nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
  
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(seconds_5) userInfo:nil repeats:YES];
    
    
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    
    
    [super viewWillDisappear:YES];
    [timer invalidate];
}

-(void)configWebView{
    
    
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"chartLine" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
 
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;

    self.webView = [[UIWebView alloc] init];
    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.contentSize = CGSizeMake(0, 0);
    if (LWidth==375)self.webView.frame = CGRectMake(0, LHeight-193-200, LWidth, 200);
    if (LWidth<375)self.webView.frame = CGRectMake(0, LHeight-193-160, LWidth, 160);
    if (LWidth>375)self.webView.frame = CGRectMake(0, LHeight-213-220, LWidth, 220);
    [self.webView loadRequest:request];
    
    self.webView.delegate = self;
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"addData('%@?%@');",[NSString stringWithFormat:@"%@",@[@"100",@"400",@"80",@"230"]],[NSString stringWithFormat:@"%@",@[@"100",@"400",@"80",@"230"]]]];
    
    //    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"addData('%@');",[NSString stringWithFormat:@"%@",@[@"10",@"200",@"80",@"230"]]]];
    //
    //
    //    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"addData('%@');",[NSString stringWithFormat:@"%@",@[@"100",@"400",@"80",@"230"]]]];
    
    [self.view addSubview:self.webView];
    
    
    
    
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    UILabel *Linelabel =[[UILabel alloc]init];
    Linelabel.backgroundColor=[UIColor clearColor];
    Linelabel.text=@"发电负荷";
    Linelabel.textColor=[UIColor redColor];
    Linelabel.font=[UIFont systemFontOfSize:12];
        if (LWidth==375)Linelabel.frame= CGRectMake(43, 184, 80, 8);

    if (LWidth<375)Linelabel.frame= CGRectMake(43,144, 80, 8);

    if (LWidth>375)Linelabel.frame= CGRectMake(43, 204, 80, 8);

    [self.webView addSubview:Linelabel];
    UIView *lineview =[[UIView alloc]initWithFrame:CGRectMake(20, Linelabel.center.y-4, 20, 1.5)];;
    lineview.backgroundColor =[UIColor redColor];
    [self.webView addSubview:lineview];

    

    UIView *lineview_two =[[UIView alloc]initWithFrame:CGRectMake(Linelabel.center.x+35, Linelabel.center.y-4, 20, 1.5)];;
    lineview_two.backgroundColor =[UIColor greenColor];
    [self.webView addSubview:lineview_two];
    
    UILabel *Linelabel_two =[[UILabel alloc]initWithFrame:CGRectMake(lineview_two.center.x+23,Linelabel.center.y-4, 80, 8)];
    Linelabel_two.backgroundColor=[UIColor clearColor];
    Linelabel_two.text=@"供汽流量";
    Linelabel_two.textColor=[UIColor greenColor];
    Linelabel_two.font=[UIFont systemFontOfSize:12];
    [self.webView addSubview:Linelabel_two];
    




}

- (void)requestHistoryShowDataList1
{
    //[SVProgressHUD showWithStatus:@"努力加载中..."];
    
    
    
    NSDate* senddate=[NSDate date];
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString* date = [dateformatter stringFromDate:senddate];
    
    NSDateFormatter* dateformatterTime = [[NSDateFormatter alloc] init];
    [dateformatterTime setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateTime = [dateformatterTime stringFromDate:senddate];
    
    NSString* timeXml = [NSString stringWithFormat:@"<p><a>h</a><t1>%@ 00:00:00</t1><t2>%@</t2><ts>3600</ts><sis server='SYNCBASE5'><tg n='JY1_1232AI' /><tg n='JY2_1232AI' /><tg n='JY3_2423AI' /><tg n='JY4_2423AI'/><tg n='JY5_GRLIHJ' /><tg n='JY6_6GR_QS_PNT'/></sis></p>",date,dateTime];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETSERIAL",@"Action",timeXml,@"XmlData",@"SYNCBASE5",@"EngineName", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@/slrd/SISMonitor/ProxyMobile/GetSISData.ashx",HTTPIP] withParameter:dict];
    NSLog(@"%@",[NSString stringWithFormat:@"http://%@/slrd/SISMonitor/ProxyMobile/GetSISData.ashx",HTTPIP]);
    NSLog(@"hhttp===%@",HTTPIP);
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        
        if ([[[dictt objectForKey:@"sis"] allKeys] containsObject:@"tg"])
        {
            
            
            
            historyArray1 = [NSMutableArray arrayWithArray:[[dictt objectForKey:@"sis"] objectForKey:@"tg"]];
            [self performSelector:@selector(addDataHis1) withObject:nil afterDelay:.5];
            
        }else{
            
            [self performSelector:@selector(addData1) withObject:nil afterDelay:.5];
            
            
            
        }
    };
}

-(void)addDataHis1{
    [self initHistory];
    
}
- (void)initHistory1
{
    float andNumber = 0;
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < [[[historyArray1 objectAtIndex:0] objectForKey:@"s"] count]; index++) {
        for (NSInteger row = 0; row < historyArray1.count; row ++) {
            andNumber = andNumber+[[[[[historyArray1 objectAtIndex:row] objectForKey:@"s"] objectAtIndex:index] objectForKey:@"v"] floatValue];
            if (row==historyArray1.count-1) {
                [dataArray addObject:[NSString stringWithFormat:@"%f",andNumber]];
                andNumber = 0;
            }
        }
    }
    NSString* dataStr = @"";
    for (NSInteger index = 0; index < dataArray.count; index ++) {
        if (index==0) {
            dataStr = [NSString stringWithFormat:@"%@",dataArray[index]];
        }else{
            dataStr = [NSString stringWithFormat:@"%@,%@",dataStr,dataArray[index]];
        }
    }
    
    
    [SVProgressHUD dismiss];
    
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"addData('%@');",dataStr]];
    [self requestShowDataList];
}



-(void)addData1{
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"addData('0,1?3,4');"]];
    
}






- (void)requestHistoryShowDataList
{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    
    
    
    NSDate* senddate=[NSDate date];
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString* date = [dateformatter stringFromDate:senddate];
    
    NSDateFormatter* dateformatterTime = [[NSDateFormatter alloc] init];
    [dateformatterTime setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateTime = [dateformatterTime stringFromDate:senddate];
    
    NSString* timeXml = [NSString stringWithFormat:@"<p><a>h</a><t1>%@ 00:00:00</t1><t2>%@</t2><ts>3600</ts><sis server='SYNCBASE5'><tg n='JY1_4844AI' /><tg n='JY2_4844AI' /><tg n='JY3_3A51AI' /><tg n='JY4_3A51AI'/><tg n='JY5_5E01JA001' /><tg n='JY6_6E01JA001'/></sis></p>",date,dateTime];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETSERIAL",@"Action",timeXml,@"XmlData",@"SYNCBASE5",@"EngineName", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@/slrd/SISMonitor/ProxyMobile/GetSISData.ashx",HTTPIP] withParameter:dict];
    NSLog(@"%@",[NSString stringWithFormat:@"http://%@/slrd/SISMonitor/ProxyMobile/GetSISData.ashx",HTTPIP]);
    NSLog(@"hhttp===%@",HTTPIP);
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        
        if ([[[dictt objectForKey:@"sis"] allKeys] containsObject:@"tg"])
        {
            
            
            
            historyArray = [NSMutableArray arrayWithArray:[[dictt objectForKey:@"sis"] objectForKey:@"tg"]];
            [self performSelector:@selector(addDataHis) withObject:nil afterDelay:.5];
            
        }else{
            
            [self performSelector:@selector(addData) withObject:nil afterDelay:.5];
            
            
            
        }
    };
}

-(void)addDataHis{
    
    [self requestHistoryShowDataList1];
    
}


-(void)addData{
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"addData('0,1?2,3');"]];
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    NSLog(@"errror====%@",error);
    
    
    
    
}
- (void)initHistory
{
    float andNumber = 0;
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < [[[historyArray objectAtIndex:0] objectForKey:@"s"] count]; index++) {
        for (NSInteger row = 0; row < historyArray.count; row ++) {
            andNumber = andNumber+[[[[[historyArray objectAtIndex:row] objectForKey:@"s"] objectAtIndex:index] objectForKey:@"v"] floatValue];
            if (row==historyArray.count-1) {
                [dataArray addObject:[NSString stringWithFormat:@"%f",andNumber]];
                andNumber = 0;
            }
        }
    }
    NSString* dataStr = @"";
    for (NSInteger index = 0; index < dataArray.count; index ++) {
        if (index==0) {
            dataStr = [NSString stringWithFormat:@"%@",dataArray[index]];
        }else{
            dataStr = [NSString stringWithFormat:@"%@,%@",dataStr,dataArray[index]];
        }
    }
    
    
    float andNumber1 = 0;
    NSMutableArray* dataArray1 = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < [[[historyArray1 objectAtIndex:0] objectForKey:@"s"] count]; index++) {
        for (NSInteger row = 0; row < historyArray1.count; row ++) {
            andNumber1 = andNumber1+[[[[[historyArray1 objectAtIndex:row] objectForKey:@"s"] objectAtIndex:index] objectForKey:@"v"] floatValue];
            if (row==historyArray1.count-1) {
                [dataArray1 addObject:[NSString stringWithFormat:@"%f",andNumber1]];
                andNumber1 = 0;
            }
        }
    }
    
    
    NSString* dataStr1 = @"";
    for (NSInteger index = 0; index < dataArray1.count; index ++) {
        if (index==0) {
            dataStr1 = [NSString stringWithFormat:@"%@",dataArray1[index]];
        }else{
            dataStr1 = [NSString stringWithFormat:@"%@,%@",dataStr1,dataArray1[index]];
        }
    }
    
    
    
    
    
    
    [SVProgressHUD dismiss];
    NSLog(@"dataSTYR+++%@",dataStr);
    NSLog(@"dataSTR+++%@",dataStr1);
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"addData('%@?%@');",dataStr,dataStr1]];
    [self requestShowDataList];
}
#pragma mark ------------------------- 网络环境不可用时的页面
- (void)RequestErrorViewController
{
    //    [SVProgressHUD dismiss];
    //    popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LWidth, LHeight)];
    //    popView.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    //    UIImageView* imag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 160)];
    //    imag.center = popView.center;
    //    imag.image = [UIImage imageNamed:@"02e9868d724dae529e06525edbaf024e.png"];
    //    [popView addSubview:imag];
    //    [self.view addSubview:popView];
    //    UITapGestureRecognizer* regiontapGestureT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestShowDataList)];
    //    [popView addGestureRecognizer:regiontapGestureT];
    //[popView removeFromSuperview];
}
- (void)requestShowDataList
{
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETREAL",@"Action",@"<p><a>r</a><sis server='SYNCBASE5'><tg n='JY1_4844AI' /><tg n='JY2_4844AI' /><tg n='JY3_3A51AI' /><tg n='JY4_3A51AI'/><tg n='JY5_5E01JA001' /><tg n='JY6_6E01JA001'/><tg n='JY1_1232AI' /><tg n='JY2_1232AI'/><tg n='JY3_2423AI' /><tg n='JY4_2423AI'/><tg n='JY5_GRLIHJ' /><tg n='JY6_6GR_QS_PNT'/><tg n='JY1_ECY' /><tg n='JY2_ECY'/><tg n='JY3_ECY' /><tg n='JY4_ECY'/><tg n='JY5_ECY' /><tg n='JY6_ECY'/><tg n='JY1_EFHL' /><tg n='JY2_EFHL'/><tg n='JY3_EFHL' /><tg n='JY4_EFHL'/><tg n='JY5_EFHL' /><tg n='JY6_EFHL'/><tg n='JYTL1_YCZBP' /><tg n='JYTL2_YCZBP'/><tg n='JYTL5_YCZBP' /><tg n='JYTL6_YCZBP'/><tg n='JYTL1_LA2200_HR1P' /><tg n='TL1_SH0100P'/><tg n='JY3TL_DPU1051_SH0082_AALM008202P' /><tg n='JY3TL_RA2200_HR2P'/><tg n='JYTL1_NOXP' /><tg n='JYTL2_NOXP'/><tg n='JYTL5_NOXP' /><tg n='JYTL6_NOXP'/><tg n='JY0_RFDLLJ'/><tg n='JY0_QCGRZLLR'/></sis></p>",@"XmlData",@"SYNCBASE5",@"EngineName", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@/slrd/SISMonitor/ProxyMobile/GetSISData.ashx",HTTPIP] withParameter:dict];
    manager.delegate = self;
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
          NSArray* array = @[@"发电负荷",@"日发电量",@"供汽流量",@"日供汽量"];
        //NSArray* array = @[@"装机容量",@"运行容量",@"发电负荷",@"供热流量"];
        NSArray* colorArray = @[[UIColor colorWithRed:0.65 green:0.57 blue:0.49 alpha:1],[UIColor colorWithRed:0.39 green:0.61 blue:0.56 alpha:1],[UIColor colorWithRed:0.15 green:0.62 blue:0.82 alpha:1],[UIColor colorWithRed:0.56 green:0.45 blue:0.62 alpha:1]];
        [showDataArray removeAllObjects];
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            showDataArray = [NSMutableArray arrayWithArray:[[dictt objectForKey:@"sis"] objectForKey:@"tg"]];
            
            NSLog(@"showDATAARRAY==%@",showDataArray);
            [self.home_tableView reloadData];
            [self.home_tableView_two reloadData];
            [roundView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            for (NSInteger index = 0; index < 4; index ++) {
                NSInteger X = index%4*((LWidth-5)/4);
                UILabel* label = [[UILabel alloc] init];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:14];
                label.frame = CGRectMake(X+5, IPHONE_5?40:70, (LWidth-30)/4, 20);
                label.textColor = colorArray[index];
                label.text = [NSString stringWithFormat:@"%.2f",[[self stringNumber:index] floatValue]];
                [roundView addSubview:label];
                
                UIImageView* imagView = [[UIImageView alloc] init];
                imagView.frame = CGRectMake(X+5, IPHONE_5?0:20, (LWidth-30)/4, (LWidth-30)/4);
                imagView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.png",index+1]];
                [roundView addSubview:imagView];
                
                UILabel* labelTitle = [[UILabel alloc] init];
                labelTitle.textAlignment = NSTextAlignmentCenter;
                labelTitle.font = [UIFont systemFontOfSize:14];
                labelTitle.frame = CGRectMake(X+5, IPHONE_5?15:40, (LWidth-30)/4, 20);
                labelTitle.textColor = colorArray[index];
                labelTitle.text = array[index];
                [roundView addSubview:labelTitle];
            }
            
            
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"addData('%@?%@');",[NSString stringWithFormat:@"%.2f",[[self stringNumber:0] floatValue]],[NSString stringWithFormat:@"%.2f",[[self stringNumber:2]floatValue]]]];
        }else{
            //[SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableView.tag?4:7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView.tag == 0) {
        static NSString *CellIdentifier = @"CellIdentifier";
        Home_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Home_TableViewCell" owner:nil options:nil];
            for (id oneObject in nib)
            {
                if ([oneObject isKindOfClass:[Home_TableViewCell class]])
                {
                    cell = (Home_TableViewCell *)oneObject;
                }
            }
        }
        if (indexPath.row == 0) {
            cell.bgImag.layer.masksToBounds = YES;
            cell.bgImag.layer.cornerRadius = 2;
            cell.bgImag.hidden = NO;
            cell.bgImag.backgroundColor = [UIColor colorWithRed:0.15 green:0.38 blue:0.65 alpha:1];
            cell.capacity.text = @"容量";
            cell.indexStr.text = @"机组";
            cell.load.text = @"负荷";
            cell.heating.text = @"供热";
            cell.loadRate.text = @"负荷率";
            cell.dosage.text = @"厂电用率";
            
            cell.capacity.textColor = cell.indexStr.textColor = cell.load.textColor = cell.heating.textColor = cell.loadRate.textColor = cell.dosage.textColor = [UIColor colorWithRed:0.65 green:0.79 blue:0.94 alpha:1];
        }else{
            
            
            cell.capacity.textColor = cell.indexStr.textColor = cell.load.textColor = cell.heating.textColor = cell.loadRate.textColor = cell.dosage.textColor = [UIColor colorWithRed:0.89 green:0.96 blue:0.97 alpha:1];
            cell.capacity.text = capacityArray[indexPath.row];
            cell.indexStr.text = [NSString stringWithFormat:@"#%ld",(long)indexPath.row];
            cell.load.text = [[NSString stringWithFormat:@"%.2f",[[[showDataArray[(indexPath.row -1)] objectForKey:@"s"] objectForKey:@"v"] floatValue]] stringByReplacingOccurrencesOfString:@"" withString:@"NaN"];
            cell.heating.text = [[NSString stringWithFormat:@"%.1f",[[[showDataArray[((indexPath.row -1)+6)] objectForKey:@"s"] objectForKey:@"v"] floatValue]] stringByReplacingOccurrencesOfString:@"" withString:@"NaN"];
            cell.loadRate.text = [[NSString stringWithFormat:@"%.1f%%",[[[showDataArray[((indexPath.row -1)+18)] objectForKey:@"s"] objectForKey:@"v"] floatValue]] stringByReplacingOccurrencesOfString:@"" withString:@"NaN"];
            cell.dosage.text = [[NSString stringWithFormat:@"%.1f%%",[[[showDataArray[((indexPath.row -1)+12)] objectForKey:@"s"] objectForKey:@"v"] floatValue]] stringByReplacingOccurrencesOfString:@"" withString:@"NaN"];
            if (indexPath.row == 6) {
                cell.backImage.hidden = YES;
            }
        }
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else{
        static NSString *CellIdentifier = @"CellIdentifier";
        Home_TwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Home_TwoTableViewCell" owner:nil options:nil];
            for (id oneObject in nib)
            {
                if ([oneObject isKindOfClass:[Home_TwoTableViewCell class]])
                {
                    cell = (Home_TwoTableViewCell *)oneObject;
                }
            }
        }
        if (indexPath.row == 0) {
            cell.backImage.hidden = YES;
            cell.bgImag.layer.masksToBounds = YES;
            cell.bgImag.layer.cornerRadius = 2;
            cell.bgImag.hidden = NO;
            cell.bgImag.backgroundColor = [UIColor colorWithRed:0.15 green:0.38 blue:0.65 alpha:1];
            cell.mg.text = @"环保数据";
            cell.mg.textColor =  cell.nper1.textColor= cell.nper2.textColor = cell.unit.textColor = cell.unit2.textColor =[UIColor colorWithRed:0.65 green:0.79 blue:0.94 alpha:1];
            cell.nper1.text = @"一期";
            cell.nper2.text = @"二期";
            cell.unit.text = @"#5机组";
            cell.unit2.text = @"#6机组";
        }else {
            
            cell.mg.textColor =  cell.nper2.textColor =  cell.unit2.textColor =[UIColor colorWithRed:0.57 green:0.72 blue:0.88 alpha:1];
            cell.nper1.textColor=  cell.unit.textColor = [UIColor colorWithRed:0.89 green:0.96 blue:0.97 alpha:1];
            cell.mg.text = [NSString stringWithFormat:@"%@",mgArray[indexPath.row -1]];
            cell.nper1.text = [[NSString stringWithFormat:@"%.2f",[[[showDataArray[ 24 +(indexPath.row-1)*4] objectForKey:@"s"] objectForKey:@"v"] floatValue]] stringByReplacingOccurrencesOfString:@"" withString:@"NaN"];
            cell.nper2.text = [[NSString stringWithFormat:@"%.2f",[[[showDataArray[ 25+(indexPath.row-1)*4] objectForKey:@"s"] objectForKey:@"v"] floatValue]] stringByReplacingOccurrencesOfString:@"" withString:@"NaN"];
            cell.unit.text = [[NSString stringWithFormat:@"%.2f",[[[showDataArray[26+(indexPath.row-1)*4] objectForKey:@"s"] objectForKey:@"v"] floatValue]] stringByReplacingOccurrencesOfString:@"" withString:@"NaN"];
            cell.unit2.text = [[NSString stringWithFormat:@"%.2f",[[[showDataArray[ 27+(indexPath.row-1)*4] objectForKey:@"s"] objectForKey:@"v"] floatValue]] stringByReplacingOccurrencesOfString:@"" withString:@"NaN"];
            
            
            
            
            if (indexPath.row == 3) {
                cell.backImage.hidden = YES;
            }
        }
        
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
}
- (void)seconds_5
{
    [SimplePingHelper ping:HTTPWIFI target:self sel:@selector(pingResult:)];
    
    [self requestShowDataList];
    
}
- (void)pingResult:(NSNumber*)success {
    if (success.boolValue) {
        NSLog(@"链接成功");
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"http"];
        [[NSUserDefaults standardUserDefaults] setObject:HTTPWIFI forKey:@"http"];
        
        
    } else {
        NSLog(@"链接失败");
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"http"];
        [[NSUserDefaults standardUserDefaults] setObject:HTTPSIM forKey:@"http"];
        
    }
}
- (void)callModalList
{
    AppDelegate *aAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [aAppDelegate.ddMenu showLeftController:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)pushSetViewController//设置-代理
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SetViewController* loginVC = [story instantiateViewControllerWithIdentifier:@"SetViewController"];
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}
- (void)pushMenuViewController:(NSString *)title titleUp:(NSString *)titleStr
{
    
    if (title==nil||[title isEqual:[NSNull null]]||[title isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"出错了，此功能没有配置"];
    }else{
        if ([title isEqualToString:@"oa.ContactsActivity"]) {
            
            
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            BookViewController* bookVC = [story instantiateViewControllerWithIdentifier:@"BookViewController"];
            bookVC.hidesBottomBarWhenPushed = YES;
            bookVC.title_Str = titleStr;
            [self.navigationController pushViewController:bookVC animated:YES];
        }else if ([title isEqualToString:@"oa.NewsCenterActivity"]) {
            BYMainController* newsVC = [BYMainController new];
            newsVC.title_Str = titleStr;
            newsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newsVC animated:YES];
        }else if ([title isEqualToString:@"dm.DutyLogListActivity"]) {
           
            
            
            RunLogViewController* runVC = [RunLogViewController new];
            runVC.hidesBottomBarWhenPushed = YES;
            runVC.title_Str = titleStr;
            [self.navigationController pushViewController:runVC animated:YES];
        }else if ([title isEqualToString:@"dm.WorkLog_NoteListActivity"]) {
            WorkLogViewController* workVC = [WorkLogViewController new];
            workVC.hidesBottomBarWhenPushed = YES;
            workVC.title_Str = titleStr;
            [self.navigationController pushViewController:workVC animated:YES];
        }else if ([title isEqualToString:@"oa.AnnocActivity"]) {
            NoticeViewController* noticeVC = [NoticeViewController new];
            noticeVC.hidesBottomBarWhenPushed = YES;
            noticeVC.title_str = titleStr;
            [self.navigationController pushViewController:noticeVC animated:YES];
        }else if ([title isEqualToString:@"eam.EAM_DefectListActivity"]) {
            BaseViewController* baseVC = [BaseViewController new];
            baseVC.hidesBottomBarWhenPushed = YES;
            baseVC.title_str = titleStr;
            [self.navigationController pushViewController:baseVC animated:YES];
        }else if ([[title substringToIndex:7] isEqualToString:@"http://"]) {
            // NSLog(@"%@",[title substringWithRange:NSMakeRange(7, 9)]);
            
            
            if ([title rangeOfString:FLAG].location!=NSNotFound ) {
                NSString *NEWtitle= [title stringByReplacingOccurrencesOfString:FLAG withString:HTTPIP];
                
                
                HotNewsViewController* hotVC = [[HotNewsViewController alloc] initWithUrl:NEWtitle title:titleStr];
                hotVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:hotVC animated:YES];
                
            }
        }else if ([[title substringToIndex:23] isEqualToString:@"query.QueryListActivity"]) {
            
            AllQueryViewController* vc = [[AllQueryViewController alloc] initWithUrl:title title:titleStr];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (NSString *)stringNumber:(NSInteger)aType
{
    NSString* str = nil;
    switch (aType) {
        case 0:
        {// 发电负荷
            NSLog(@"showDataArray====%@",showDataArray);
             str = [NSString stringWithFormat:@"%f",[[[showDataArray[0] objectForKey:@"s"] objectForKey:@"v"] floatValue]+[[[showDataArray[1] objectForKey:@"s"] objectForKey:@"v"] floatValue]+[[[showDataArray[2] objectForKey:@"s"] objectForKey:@"v"] floatValue]+[[[showDataArray[3] objectForKey:@"s"] objectForKey:@"v"] floatValue]+[[[showDataArray[4] objectForKey:@"s"] objectForKey:@"v"] floatValue]+[[[showDataArray[5] objectForKey:@"s"] objectForKey:@"v"] floatValue]];
                       return str;
        }
        break;
        case 1:
        {
//            str = [NSString stringWithFormat:@"%f",([[[showDataArray[0] objectForKey:@"s"] objectForKey:@"v"] floatValue]>0?137.5:0)+([[[showDataArray[1] objectForKey:@"s"] objectForKey:@"v"] floatValue]>0?137.5:0)+([[[showDataArray[2] objectForKey:@"s"] objectForKey:@"v"] floatValue]>0?140:0)+([[[showDataArray[3] objectForKey:@"s"] objectForKey:@"v"] floatValue]>0?140:0)+([[[showDataArray[4] objectForKey:@"s"] objectForKey:@"v"] floatValue]>0?330:0)+([[[showDataArray[5] objectForKey:@"s"] objectForKey:@"v"] floatValue]>0?330:0)];
            
            str=[NSString stringWithFormat:@"%f",[[[showDataArray[36] objectForKey:@"s"] objectForKey:@"v"] floatValue]];
            
            
            return str;
        }
        break;
        case 2:
        {
            //供热流量
            str = [NSString stringWithFormat:@"%f",[[[showDataArray[6] objectForKey:@"s"] objectForKey:@"v"] floatValue]+[[[showDataArray[7] objectForKey:@"s"] objectForKey:@"v"] floatValue]+[[[showDataArray[8] objectForKey:@"s"] objectForKey:@"v"] floatValue]+[[[showDataArray[9] objectForKey:@"s"] objectForKey:@"v"] floatValue]+[[[showDataArray[10] objectForKey:@"s"] objectForKey:@"v"] floatValue]+[[[showDataArray[11] objectForKey:@"s"] objectForKey:@"v"] floatValue]];
            NSLog(@"str22======%@",str);
           
          

            
            NSLog(@"str======%@",str);
            return str;
        }
        break;
        case 3:
        {
            
            str=[NSString stringWithFormat:@"%.f",[[[showDataArray[37] objectForKey:@"s"] objectForKey:@"v"] floatValue]];
//              str = [NSString stringWithFormat:@"%f",137.5+137.5+140+140+330+330];
            return str;
        }
        break;
        
        default:
        break;
    }
    return str;
}
@end