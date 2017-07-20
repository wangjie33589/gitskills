//
//  KYAlarm1ViewController.m
//  SmartHome
//
//  Created by sciyonSoft on 16/7/6.
//
//

#import "KYOpreationViewController.h"
#import "JPullDownMenu.h"
#import "KYOpreationTableViewCell.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
@interface KYOpreationViewController ()<UITableViewDelegate,UITableViewDataSource>{

 NSMutableArray *_eventData;
     NSInteger startIndex;
}

@property (nonatomic) JPullDownMenu *menu;
@property (nonatomic,strong)NSMutableArray *showArray;
@property (nonatomic,strong)NSMutableArray *deleteData;

@property (nonatomic,strong)NSMutableArray *dataArray;//日志
@end

@implementation KYOpreationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"操作日志";
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"beforDate"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selecteduserid"];
    NSLog(@"selecteduserid------%@,beforDate------%@",SELECTEDUSERID,DAYBEFOR);
   [self showLog];
    [self initDataArray];
    [self initTableView];
    
    startIndex = 1;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(requestShowDataList)];
    
    _deleteData =[[NSMutableArray alloc]init];
    _showArray = [[NSMutableArray alloc]init];
//   _eventData = [[NSMutableArray alloc]init];
//    _dataArray= [[NSMutableArray alloc]init];
    self.menu = [[JPullDownMenu alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 40) menuTitleArray:@[@"用户",@"时间"]];
    NSLog(@"%@",self.menu.menuDataArray);
    NSArray *sortRuleArray=@[@"近三天",@"近五天",@"近十天",@"近二十天",@"近一个月"];
    self.menu.menuDataArray = [NSMutableArray arrayWithObjects:_showArray, sortRuleArray, nil];
    [self.view addSubview:self.menu];
    __weak typeof(self) _self = self;
    [self.menu setHandleSelectDataBlock:^(NSString *selectTitle, NSUInteger selectIndex, NSUInteger selectButtonTag) {
        
    }];
    
    [self.myTabble addHeaderWithTarget:self action:@selector(upRefresh:)];
    [self.myTabble addFooterWithTarget:self action:@selector(downRefresh:)];
   
    [self.myTabble reloadData];
}

//主人的日志
- (void)showLog{

//    startIndex = startIndex + 1;
    NSString *pageStr = [NSString stringWithFormat:@"%d",startIndex];
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10601\",\"userid\":\"%@\",\"logtype\":\"1\",\"pageno\":\"1\",\"actuserid\":\"%@\",\"pagesize\":\"10\"}",USER_ID,USER_ID];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
        {
            if ([[dictt objectForKey:@"SS"] integerValue]==200) {
                NSLog(@"dict:==%@",dictt[@"DATA"]);
                _dataArray = [NSMutableArray arrayWithArray:dictt[@"DATA"]];
                [_myTabble reloadData];
                NSLog(@"这是数据d---%@",dictt[@"DATA"]);
                
            }
        };
}

- (void)showLogRefreshing{
    
    startIndex = startIndex + 1;
    NSString *pageStr = [NSString stringWithFormat:@"%d",startIndex];
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10601\",\"userid\":\"%@\",\"logtype\":\"1\",\"pageno\":\"%@\",\"actuserid\":\"%@\"}",USER_ID,pageStr,USER_ID];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if ([[dictt objectForKey:@"SS"] integerValue]==200) {
            NSMutableArray *array =dictt[@"DATA"];
//             _dataArray = [NSMutableArray array];
            if (array.count < 5) {
                [SVProgressHUD showSuccessWithStatus:@"加载到底了"];
                for (NSUInteger i = 0; i < array.count; i ++) {
                    [ _dataArray addObject:[array objectAtIndex:i]];
                }
                [self.myTabble reloadData];
            }else{
                for (NSUInteger i = 0; i < array.count; i ++) {
                    [ _dataArray addObject:[array objectAtIndex:i]];
                }
                [self.myTabble reloadData];
                
            }         }
    };
}

#pragma mark ------ 下拉刷新
- (void)upRefresh:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
   
        if (SELECTEDUSERID ==nil) {
              [self showLog];
            NSLog(@"刷新成功");
            
        }else{
            
        [self requestShowDataList];
        }
        [self.myTabble headerEndRefreshing];
    });
}
#pragma mark ------ 上拉加载
- (void)downRefresh:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (SELECTEDUSERID==nil) {
          
            [self showLogRefreshing];
        }
        [self requestShowDataRefresh];
        [self.myTabble footerEndRefreshing];
    });
}

- (void)requestShowDataList{
    NSDate * mydate = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:+1];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    NSString *endDate = [dateFormatter stringFromDate:newdate];
    if (SELECTEDUSERID==nil) {
        [SVProgressHUD showWithStatus:@"请先选择用户"];
        // GCD
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 移除遮盖
            [SVProgressHUD dismiss];
            
        });

    }
    if (DAYBEFOR==nil) {
        [SVProgressHUD showWithStatus:@"请选择时间"];
        // GCD
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 移除遮盖
            [SVProgressHUD dismiss];
            
        });

    }
    
   
        NSLog(@"你选择的数据为--%@--%@",SELECTEDUSERID,DAYBEFOR);
        NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
        NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10601\",\"userid\":\"%@\",\"startdate\":\"%@\",\"enddate\":\"%@\",\"logtype\":\"1\",\"pageno\":\"1\",\"actuserid\":\"%@\"}",SELECTEDUSERID,DAYBEFOR,endDate,USER_ID];
        NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
        NSLog(@"dict======%@",dict);
        MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
        manager.backSuccess = ^void(NSDictionary *dictt)
        {
            if ([[dictt objectForKey:@"SS"] integerValue]==200) {
//                NSLog(@"dict:==%@",dictt[@"DATA"]);
                _dataArray = [NSMutableArray arrayWithArray:dictt[@"DATA"]];
//                _dataArray= [NSMutableArray arrayWithArray:_eventData];
                if (SELECTEDUSERID!=nil&&_eventData.count==0) {
                    [SVProgressHUD showWithStatus:[dictt objectForKey:@"MSG"]];
                    // GCD
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        // 移除遮盖
                        [SVProgressHUD dismiss];
                        
                    });
                }
                [_myTabble reloadData];

                
            }else{
                [SVProgressHUD showWithStatus:[dictt objectForKey:@"MSG"]];
                // GCD
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 移除遮盖
                    [SVProgressHUD dismiss];
                    
                });

            
            }
        };
}


- (void)requestShowDataRefresh{
    startIndex = startIndex + 1;
    NSDate * mydate = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:+1];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    NSString *endDate = [dateFormatter stringFromDate:newdate];
    NSString *pageStr = [NSString stringWithFormat:@"%d",startIndex];
    NSLog(@"%@--%d---666",SERVERID,startIndex);
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10601\",\"userid\":\"%@\",\"startdate\":\"%@\",\"enddate\":\"%@\",\"logtype\":\"1\",\"pageno\":\"%@\",\"actuserid\":\"%@\"}",SELECTEDUSERID,DAYBEFOR,endDate,pageStr,USER_ID];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        if ([[dictt objectForKey:@"SS"] integerValue]==200) {
            
            NSMutableArray *array =dictt[@"DATA"];
//            _dataArray = [NSMutableArray array];
            if (array.count < 5) {
                [SVProgressHUD showSuccessWithStatus:@"加载到底了"];
                for (NSUInteger i = 0; i < array.count; i ++) {
                    [ _dataArray addObject:[array objectAtIndex:i]];
                }
                [self.myTabble reloadData];
            }else{
              
//                [ _dataArray addObjectsFromArray:_eventData];
                
                
                for (NSUInteger i = 0; i < array.count; i ++) {
                    [ _dataArray addObject:[array objectAtIndex:i]];
                }
                [self.myTabble reloadData];
                
            }  }
    };
}






//取用户列表数组
- (void)initDataArray
{
        NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10201\",\"serverid\":\"%@\"}",SERVERID];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        if ([[dictt objectForKey:@"SS"] integerValue]==200) {
            NSLog(@"dict:==%@",dictt[@"DATA"]);
            _deleteData=dictt[@"DATA"];
            
            
            for (int i=0; i<_deleteData.count; i++) {
                NSLog(@"%@", _deleteData[i][@"user"][@"username"]);
                [_showArray addObject:_deleteData[i][@"user"][@"username"]];
            }
            
            NSLog(@"用户名为---%@", _showArray);
        }
    };
    
}


-(void)initTableView{
    self.myTabble.dataSource=self;
    self.myTabble.delegate=self;
    self.myTabble.rowHeight=60;
    
    [self.myTabble registerNib:[UINib nibWithNibName:@"KYOpreationTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
  
        return  _dataArray.count;
}




-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KYOpreationTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (![_dataArray[indexPath.row][@"logtime"] isKindOfClass:[NSNull class]]) {
        cell.Time.text =  _dataArray[indexPath.row][@"logtime"];
    }
     if (![ _dataArray[indexPath.row][@"logcontent"] isKindOfClass:[NSNull class]]) {
    cell.Event.text =  _dataArray[indexPath.row][@"logcontent"];
     }
    

    return cell;
}



@end
