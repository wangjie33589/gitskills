//
//  WorkLogViewController.m
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/22.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "WorkLogViewController.h"
#import "WorkModel.h"
#import "WorkContensTableViewCell.h"
#import "MJRefresh.h"

@interface WorkLogViewController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray* showArray;
    NSMutableArray* dataArray;
    NSMutableArray* dataEndArray;
    UITableView* contensTableView;
    UITableView* listTableView;
    UITableView* valueTableView;
    UIButton* listButton;
    UIButton* valueButton;
    NSArray* valueArray;
    NSString* guidStr;
    BOOL isList;
    BOOL isValue;
    NSInteger startIndex;
    NSMutableArray* andMutableArray;
    NSString *refreshXml;
    NSString *refrehType;
    UIButton * reset ;
    UITextField *_textField;
}

@end

@implementation WorkLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _title_Str;
    startIndex = 1;
    [self initTableView];
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    self.view.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
    isList = YES;
    isValue = YES;
    listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.tag = 0;
    listButton.backgroundColor = [UIColor whiteColor];
    listButton.frame = CGRectMake(10, 10, (LWidth-30)/2, 40);
    [listButton setTitle:@"设备部_汽机检修班" forState:0];
    [listButton setTitleColor:[UIColor blackColor] forState:0];
    listButton.layer.borderColor = [[UIColor colorWithRed:0.773 green:0.780 blue:0.776 alpha:1] CGColor];
    listButton.layer.borderWidth = .5f;
    listButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [listButton addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:listButton];
    
    valueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    valueButton.tag = 1;
    valueButton.backgroundColor = [UIColor whiteColor];
    valueButton.frame = CGRectMake((LWidth-30)/2 +20,10, (LWidth-30)/2, 40);

    [valueButton setTitle:@"近三天" forState:0];
    [valueButton setTitleColor:[UIColor blackColor] forState:0];
    valueButton.layer.borderColor = [[UIColor colorWithRed:0.773 green:0.780 blue:0.776 alpha:1] CGColor];
    valueButton.layer.borderWidth = .5f;
    valueButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [valueButton addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:valueButton];
    
    
    
_textField =[[UITextField alloc]init];
    _textField.backgroundColor=[UIColor whiteColor];
    _textField.frame= CGRectMake(10, listButton.frame.origin.y+listButton.frame.size.height+10, LWidth-20, 35);
    _textField.returnKeyType=UIReturnKeyDone;
    _textField.delegate=self;
    _textField.placeholder=@"请输入检索的关键字";
    [self.view addSubview:_textField];

    
    
    reset = [UIButton buttonWithType:UIButtonTypeCustom];
    reset.frame = CGRectMake(10, _textField.frame.origin.y+_textField.frame.size.height+10, (LWidth-30)/2, 35);
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
      searchButton.frame = CGRectMake((LWidth-30)/2+20, reset.frame.origin.y, (LWidth-30)/2, 35);

    [searchButton setTitle:@"搜索" forState:0];
    [searchButton setTitleColor:[UIColor whiteColor] forState:0];
    searchButton.layer.masksToBounds = YES;
    searchButton.layer.cornerRadius = 3;
    searchButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [searchButton addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
    
    valueArray = @[@"近三天",@"近五天",@"近十天",@"近二十天",@"近一个月"];
    
    [self initdropDownMenu];
    [self initdropDownMenuValue];
    [self requestShowDataNews];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;


}

- (void)listButtonClick:(UIButton *)sender
{
    [self.view bringSubviewToFront:valueTableView];
    [self.view bringSubviewToFront:listTableView];
    switch (sender.tag) {
        case 0:
        {
            if (isList) {
                listTableView.hidden = NO;
                [listButton setTitle:@"取消" forState:0];
                [listButton setBackgroundColor:[UIColor orangeColor]];
                [listButton setTitleColor:[UIColor whiteColor] forState:0];
            }else{
                [listButton setTitle:@"【岗位】" forState:0];
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
                [valueButton setTitle:@"近三天" forState:0];
                valueTableView.hidden = YES;
                [valueButton setBackgroundColor:[UIColor whiteColor]];
                [valueButton setTitleColor:[UIColor blackColor] forState:0];
            }
            isValue = !isValue;
        }
            break;
        case 2:
        {
            [SVProgressHUD showWithStatus:@"请稍后..."];
            [self searchData];
        }
            break;
        case 3:{
            if (isList) {
             
                            [listButton setTitle:@"设备部_汽机检修班" forState:0];
                [valueButton setTitle:@"近三天" forState:0];
            
                [listButton setBackgroundColor:[UIColor whiteColor]];
                [listButton setTitleColor:[UIColor blackColor] forState:0];
                [self searchData];
            }
            
        
        
        
        
        
        
        }break;

       
    }
}
- (void)requestShowDataNews
{
    
    
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETSCHEDULE",@"Action",USERORGGUID,@"PERSONGUID", nil];
    NSLog(@"US====%@",USERORGGUID);
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/%@",HTTPIP,SLRD,BASE_URL] withParameter:dict];
    
    
      
    
    
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [showArray removeAllObjects];
        showArray = [[NSMutableArray alloc] init];
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            [showArray addObject:@{@"FNAME":@"全部"}];
            for (NSDictionary* Data in [[dictt objectForKey:@"Data"] objectForKey:@"R"]) {
                [showArray addObject:Data];
            }
            [listTableView reloadData];
            [self searchData];
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}
- (void)searchData
{
    NSString* guid = @"";
    if ( [listButton.titleLabel.text isEqualToString:@"全部"] ||[listButton.titleLabel.text isEqualToString:@"取消"]) {
        
    guidStr = [showArray[0] objectForKey:@"FGUID"];
        
        NSLog(@"showARRAY==%@",showArray);
        for (NSInteger index = 0; index < showArray.count; index ++) {
            if (index == 0) {
                guidStr = [NSString stringWithFormat:@"%@,",[showArray[index] objectForKey:@"FGUID"]];

                
                
            }else if (index == showArray.count-1) {
                guidStr = [NSString stringWithFormat:@"%@,%@",guidStr,[showArray[index] objectForKey:@"FGUID"]];
                
               
            }else{
                guidStr = [NSString stringWithFormat:@"%@,%@,",guidStr,[showArray[index] objectForKey:@"FGUID"]];
            }
        }
        guid = guidStr;
    }else if ([listButton.titleLabel.text isEqualToString:@"设备部_汽机检修班"] ){
      
    
        for (int  index=0 ; index<showArray.count; index++) {
            if ([[showArray[index] objectForKey:@"FNAME"] isEqualToString:@"设备部_汽机检修班"]){
                
                guid=[showArray[index] objectForKey:@"FGUID"];
                [listButton setTitle:@"设备部_汽机检修班" forState:0];
            }
            
            
        }

    }
    else{
        guid = guidStr;
    }
    
    
    NSLog(@"GUIDSTR==%@",guid);
    NSString* type = @"";
    if ([valueButton.titleLabel.text isEqualToString:@"取消"]) type = @"1";
    if ([valueButton.titleLabel.text isEqualToString:@"近三天"]) type = @"1";
    if ([valueButton.titleLabel.text isEqualToString:@"近五天"]) type = @"2";
    if ([valueButton.titleLabel.text isEqualToString:@"近十天"]) type = @"3";
    if ([valueButton.titleLabel.text isEqualToString:@"近二十天"]) type = @"4";
    if ([valueButton.titleLabel.text isEqualToString:@"近一个月"]) type = @"5";
    [dataArray removeAllObjects];
    dataArray = [[NSMutableArray alloc] init];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETWORKLOGDETAIL",@"Action",@"10",@"Pagesize",@"1",@"Pageindex",type,@"DATETYPE",@"ASC,DESC,ASC,ASC",@"Softtype",@"FSNAME,FDATE,FTIMEHOUR,FTIMEMINUTE",@"Softfield",guid,@"SGUID", _textField.text,@"CONTENT",nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/%@",HTTPIP,SLRD,PAGIN_URL] withParameter:dict];
      //搜索条件修改
    refreshXml=guid;
    refrehType=type;
    
    
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            BOOL isAdd = YES;
            [dataEndArray removeAllObjects];
            dataEndArray = [[NSMutableArray alloc] init];
            dataArray = [NSMutableArray arrayWithArray:[dictt objectForKey:@"data"]];
            [andMutableArray removeAllObjects];
            andMutableArray = [NSMutableArray arrayWithArray:[dictt objectForKey:@"data"]];
            for (NSInteger index = 0; index < dataArray.count; index ++) {
                
                NSMutableArray* contensArray = [[NSMutableArray alloc] init];
                
                NSString* date = [NSString stringWithFormat:@"%@,%@",[dataArray[index] objectForKey:@"FSNAME"],[[dataArray[index] objectForKey:@"FDATE"] substringWithRange:NSMakeRange(0,10)]];
                
                [contensArray addObject:dataArray[index]];
                for (NSInteger j = 0; j < index; j ++) {
                    NSString* dateTwo = [NSString stringWithFormat:@"%@,%@",[dataArray[j] objectForKey:@"FSNAME"],[[dataArray[j] objectForKey:@"FDATE"] substringWithRange:NSMakeRange(0,10)]];
                    if ([dateTwo isEqualToString:date]) {
                        isAdd = NO;
                    }else if (j==index-1) {
                        isAdd = YES;
                        for (NSInteger two = index+1; two < dataArray.count; two ++) {
                            if (isAdd) {
                                NSString* dateTwo = [NSString stringWithFormat:@"%@,%@",[dataArray[two] objectForKey:@"FSNAME"],[[dataArray[two] objectForKey:@"FDATE"] substringWithRange:NSMakeRange(0,10)]];
                                if ([date isEqualToString:dateTwo]) {
                                    [contensArray addObject:dataArray[two]];
                                }
                                if (two == dataArray.count-1) {
                                    NSMutableDictionary* modelDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:contensArray,@"data", nil];
                                    [dataEndArray addObject:[WorkModel initWithAddData:modelDict]];
                                }
                            }
                        }
                    }
                }
                if (index==0) {
                    for (NSInteger two = index+1; two < dataArray.count; two ++) {
                        if (isAdd) {
                            NSString* dateTwo = [NSString stringWithFormat:@"%@,%@",[dataArray[two] objectForKey:@"FSNAME"],[[dataArray[two] objectForKey:@"FDATE"] substringWithRange:NSMakeRange(0,10)]];
                            if ([date isEqualToString:dateTwo]) {
                                [contensArray addObject:dataArray[two]];
                            }
                            if (two == dataArray.count-1) {
                                NSMutableDictionary* modelDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:contensArray,@"data", nil];
                                [dataEndArray addObject:[WorkModel initWithAddData:modelDict]];
                            }
                        }
                    }
                }
            }
            
            [contensTableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}
- (void)requestShowDataRefresh
{
    startIndex = startIndex+1;
    NSString* pageStr = [NSString stringWithFormat:@"%ld",(long)startIndex];
//    NSString* guid = @"";
//    if ([listButton.titleLabel.text isEqualToString:@"全部"] || [listButton.titleLabel.text isEqualToString:@"取消"]) {
//        guidStr = [showArray[0] objectForKey:@"FGUID"];
//        for (NSInteger index = 0; index < showArray.count; index ++) {
//            if (index == 0) {
//                guidStr = [NSString stringWithFormat:@"%@,",[showArray[index] objectForKey:@"FGUID"]];
//            }else if (index == showArray.count-1) {
//                guidStr = [NSString stringWithFormat:@"%@,%@",guidStr,[showArray[index] objectForKey:@"FGUID"]];
//            }else{
//                guidStr = [NSString stringWithFormat:@"%@,%@,",guidStr,[showArray[index] objectForKey:@"FGUID"]];
//            }
//        }
//        guid = guidStr;
//    }else if ([listButton.titleLabel.text isEqualToString:@"设备部_汽机检修班"] ){
//        
//        
//        for (int  index=0 ; index<showArray.count; index++) {
//            if ([[showArray[index] objectForKey:@"FNAME"] isEqualToString:@"设备部_汽机检修班"]){
//                
//                guid=[showArray[index] objectForKey:@"FGUID"];
//                [listButton setTitle:@"设备部_汽机检修班" forState:0];
//            }
//            
//            
//        }
//        
//    }
//    
//    
//    
//    
//    else{
//        guid = guidStr;
//    }
    
    NSString* type = @"";
    if ([valueButton.titleLabel.text isEqualToString:@"取消"]) type = @"1";
    if ([valueButton.titleLabel.text isEqualToString:@"近三天"]) type = @"1";
    if ([valueButton.titleLabel.text isEqualToString:@"近五天"]) type = @"2";
    if ([valueButton.titleLabel.text isEqualToString:@"近十天"]) type = @"3";
    if ([valueButton.titleLabel.text isEqualToString:@"近二十天"]) type = @"4";
    if ([valueButton.titleLabel.text isEqualToString:@"近一个月"]) type = @"5";
    [dataArray removeAllObjects];
    dataArray = [[NSMutableArray alloc] init];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETWORKLOGDETAIL",@"Action",@"10",@"Pagesize",pageStr,@"Pageindex",refrehType,@"DATETYPE",@"ASC,DESC,ASC,ASC",@"Softtype",@"FSNAME,FDATE,FTIMEHOUR,FTIMEMINUTE",@"Softfield",refreshXml,@"SGUID",_textField.text,@"CONTENT", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/%@",HTTPIP,SLRD,PAGIN_URL] withParameter:dict];
    NSLog(@"sdsadf===%@",[NSString stringWithFormat:@"http://%@%@/%@",HTTPIP,SLRD,PROXY_URL]);
    NSLog(@"dict===%@",dict);
    
    
    
    
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            [dataEndArray removeAllObjects];
            dataEndArray = [[NSMutableArray alloc] init];
            BOOL isAdd = YES;
            NSMutableArray* newArray = [[NSMutableArray alloc] init];
            dataArray = [NSMutableArray arrayWithArray:[dictt objectForKey:@"data"]];
            for (NSInteger index = 0; index < dataArray.count; index ++) {
                [andMutableArray addObject:dataArray[index]];
            }
            for (NSInteger index = 0; index < andMutableArray.count; index ++) {
                
                NSMutableArray* contensArray = [[NSMutableArray alloc] init];
                
                NSString* date = [NSString stringWithFormat:@"%@,%@",[andMutableArray[index] objectForKey:@"FSNAME"],[[andMutableArray[index] objectForKey:@"FDATE"] substringWithRange:NSMakeRange(0,10)]];
                
                [contensArray addObject:andMutableArray[index]];
                for (NSInteger j = 0; j < index; j ++) {
                    NSString* dateTwo = [NSString stringWithFormat:@"%@,%@",[andMutableArray[j] objectForKey:@"FSNAME"],[[andMutableArray[j] objectForKey:@"FDATE"] substringWithRange:NSMakeRange(0,10)]];
                    if ([dateTwo isEqualToString:date]) {
                        isAdd = NO;
                    }else if (j==index-1) {
                        isAdd = YES;
                        for (NSInteger two = index+1; two < andMutableArray.count; two ++) {
                            if (isAdd) {
                                NSString* dateTwo = [NSString stringWithFormat:@"%@,%@",[andMutableArray[two] objectForKey:@"FSNAME"],[[andMutableArray[two] objectForKey:@"FDATE"] substringWithRange:NSMakeRange(0,10)]];
                                if ([date isEqualToString:dateTwo]) {
                                    [contensArray addObject:andMutableArray[two]];
                                }
                                if (two == andMutableArray.count-1) {
                                    NSMutableDictionary* modelDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:contensArray,@"data", nil];
                                    [newArray addObject:[WorkModel initWithAddData:modelDict]];
                                }
                            }
                        }
                    }
                }
                if (index==0) {
                    for (NSInteger two = index+1; two < andMutableArray.count; two ++) {
                        if (isAdd) {
                            NSString* dateTwo = [NSString stringWithFormat:@"%@,%@",[andMutableArray[two] objectForKey:@"FSNAME"],[[andMutableArray[two] objectForKey:@"FDATE"] substringWithRange:NSMakeRange(0,10)]];
                            if ([date isEqualToString:dateTwo]) {
                                [contensArray addObject:andMutableArray[two]];
                            }
                            if (two == andMutableArray.count-1) {
                                NSMutableDictionary* modelDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:contensArray,@"data", nil];
                                [newArray addObject:[WorkModel initWithAddData:modelDict]];
                            }
                        }
                    }
                }
            }
            if (newArray.count < 10) {
                for (NSUInteger i = 0; i < newArray.count; i ++) {
                    [dataEndArray addObject:[newArray objectAtIndex:i]];
                }
                [contensTableView reloadData];
            }else{
                for (NSUInteger i = 0; i < newArray.count; i ++) {
                    [dataEndArray addObject:[newArray objectAtIndex:i]];
                }
                [contensTableView reloadData];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}
- (void)initdropDownMenu;//班组
{
    listTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 40, LWidth/3+20, LHeight-150)];
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
- (void)initdropDownMenuValue;//天
{
    valueTableView = [[UITableView alloc] initWithFrame:CGRectMake(LWidth/3-65+(LWidth/3-20), 40, LWidth/3-20, 150)];
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
    contensTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, LWidth, LHeight-116-43)];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------- 表代理
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WorkModel* model = dataEndArray[section];
    //    区头View
    UIView* sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    sectionView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    UILabel* sectionLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    sectionLable.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1];
    sectionLable.text = [NSString stringWithFormat:@"%@,%@",[model.dataArray[0] objectForKey:@"FSNAME"],[[model.dataArray[0] objectForKey:@"FDATE"] substringWithRange:NSMakeRange(0,10)]];
    sectionLable.font = [UIFont systemFontOfSize:14];
    sectionLable.backgroundColor = [UIColor clearColor];
    sectionLable.textAlignment = NSTextAlignmentLeft;
    [sectionView addSubview:sectionLable];
    
    UIImageView *fgiv2 = [[UIImageView alloc]initWithFrame:CGRectMake(LWidth-30, 14, 15, 7)];
    fgiv2.tag = section;
    fgiv2.image = [UIImage imageNamed:@"find_down"];
    if (model.isGoru) {
        CGAffineTransform transform= CGAffineTransformMakeRotation(-M_PI/2);
        fgiv2.transform = transform;//旋转
    }
    [sectionView addSubview:fgiv2];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = section;
    btn.frame = CGRectMake(0, 0, LWidth, sectionView.frame.size.height);
    [btn addTarget:self action:@selector(sectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:btn];
    
    if (tableView.tag == 2) {
        return sectionView;
    }else{
        return nil;
    }
}
- (void)sectionButtonClick:(UIButton *)sender
{
    WorkModel* model = dataEndArray[sender.tag];
    model.isGoru = !model.isGoru;
    [contensTableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 2) {
        return dataEndArray.count;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0) {
        return showArray.count;
    }else if (tableView.tag == 1) {
        return valueArray.count;
    }else{
        WorkModel* model = dataEndArray[section];
        return model.isGoru?model.dataArray.count:0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2) {
        static NSString *CellIdentifier = @"CellIdentifier";
        WorkContensTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WorkContensTableViewCell" owner:nil options:nil];
            for (id oneObject in nib)
            {
                if ([oneObject isKindOfClass:[WorkContensTableViewCell class]])
                {
                    cell = (WorkContensTableViewCell *)oneObject;
                }
            }
        }
        WorkModel* model = dataEndArray[indexPath.section];
        cell.time.text = [NSString stringWithFormat:@"%@:%@",[[model.dataArray[indexPath.row] objectForKey:@"FTIMEHOUR"] length]==1?[NSString stringWithFormat:@"0%@",[model.dataArray[indexPath.row] objectForKey:@"FTIMEHOUR"]]:[model.dataArray[indexPath.row] objectForKey:@"FTIMEHOUR"],[[model.dataArray[indexPath.row] objectForKey:@"FTIMEMINUTE"] length]==1?[NSString stringWithFormat:@"0%@",[model.dataArray[indexPath.row] objectForKey:@"FTIMEMINUTE"]]:[model.dataArray[indexPath.row] objectForKey:@"FTIMEMINUTE"]];
        cell.title.text = [model.dataArray[indexPath.row] objectForKey:@"FTHEMENAME"];
        cell.name.text = [model.dataArray[indexPath.row] objectForKey:@"FCONTNET"];
        if (indexPath.row == model.dataArray.count-1 & indexPath.section < dataEndArray.count-1) cell.imagbg.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGSize size = [self sizeWithString:cell.name.text font:cell.name.font];
        cell.name.frame = CGRectMake(70, cell.name.frame.origin.y, cell.name.frame.size.width-70, size.height+10);
        cell.imagbg.frame = CGRectMake(cell.imagbg.frame.origin.x, cell.name.frame.origin.y+size.height+10, LWidth, 1);
        tableView.rowHeight = cell.contentView.frame.size.height+size.height-20+5;
        return cell;
    }else{
        static NSString *MyIdentifier = @"MyIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        }
        if (tableView.tag == 0) {
            cell.textLabel.text = [showArray[indexPath.row] objectForKey:@"FNAME"];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            UIImageView* imag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
            imag.frame = CGRectMake(0, 29, LWidth, 1);
            [cell.contentView addSubview:imag];
        }else if (tableView.tag == 1) {
            cell.textLabel.text = valueArray[indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            UIImageView* imag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
            imag.frame = CGRectMake(0, 29, LWidth, 1);
            [cell.contentView addSubview:imag];
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        [listButton setTitle:[showArray[indexPath.row] objectForKey:@"FNAME"] forState:0];
        [listButton setBackgroundColor:[UIColor whiteColor]];
        [listButton setTitleColor:[UIColor blackColor] forState:0];
        guidStr = [showArray[indexPath.row] objectForKey:@"FGUID"];
        listTableView.hidden = YES;
        isList = YES;
    }else if (tableView.tag == 1) {
        [valueButton setTitle:valueArray[indexPath.row] forState:0];
        [valueButton setBackgroundColor:[UIColor whiteColor]];
        [valueButton setTitleColor:[UIColor blackColor] forState:0];
        valueTableView.hidden = YES;
        isValue = YES;
    }
}


//修改
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(LWidth-100, LHeight)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  | NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    
    return rect.size;
}



@end
