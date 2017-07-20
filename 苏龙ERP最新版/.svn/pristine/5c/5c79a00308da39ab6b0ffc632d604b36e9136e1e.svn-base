//
//  AllQueryViewController.m
//  Proxy_ios
//
//  Created by E-Bans on 15/12/7.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "AllQueryViewController.h"
#import "SBJSON.h"
#import "AllTableViewCell.h"
#import "AllQuery_news_ViewController.h"
#import "MJRefresh.h"
#import "MyTool.h"

@interface AllQueryViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray* buttonsArray;//上边按钮数组
    UITableView* dataTableView;
    NSString* getUrl;
    NSArray* getArray;
    SBJsonParser* json;
    NSString* urlPin;
    NSMutableArray* xmlArray;
    UIView* pView;
    UIDatePicker* datePicker;//时间选择器
    NSInteger xmlIndex;
    NSDictionary* dataAllDict;
    NSMutableArray* showArray;//数据展示数组
    NSMutableArray* showArrayKey;
    NSArray* mainTableTitle;
    NSDictionary* mainTaleData;
    NSArray* subTablesArray;
    NSInteger startIndex;
    NSString* title_str;
    NSString* showTypeConten;
    NSString *showColor;
    NSString *_fileCodeString;
    NSString *refreshXmlStr;

}

@end

@implementation AllQueryViewController
- (id)initWithUrl:(NSString *)url title:(NSString *)titleStr
{
    self = [super init];
    if (self) {
        getUrl = url;
        title_str = titleStr;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[App ddMenu] setEnableGesture:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = title_str;
    startIndex = 1;
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    //self.view.backgroundColor=[UIColor clearColor];
    
    pView = [[UIView alloc] initWithFrame:CGRectMake(0, LHeight, LWidth, 190)];
    pView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pView];
    
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
    
    urlPin = @"";
    xmlArray = [[NSMutableArray alloc] init];
    json = [[SBJsonParser alloc] init];
    getArray = [[[NSArray arrayWithArray:[getUrl componentsSeparatedByString:@"?"]] objectAtIndex:1] componentsSeparatedByString:@"&"];
    [self requestShowButtons];
    
    [SVProgressHUD showWithStatus:@"努力加载中..."];
}
//初始化上边按钮，以及初始化搜索条件
- (void)initView
{
    if (buttonsArray.count>0) {
    for (NSInteger index = 0; index < buttonsArray.count; index ++) {
        NSInteger X = index%2*((LWidth-30)/2+10);
        NSInteger Y = index/2*(40+5);
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(X+10, Y+10, (LWidth-30)/2, 40);
        button.tag = index;
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.layer.borderColor = [[UIColor colorWithRed:0.773 green:0.780 blue:0.776 alpha:1] CGColor];
        button.layer.borderWidth = 1;
         [button setTitle:[buttonsArray[index] objectForKey:@"fieldName"] forState:0];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *now = [NSDate date];
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSRange range =[cal  rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]];
        NSInteger numberOfDaysInMonth=range.length;
        NSDateComponents *comps = [cal
                                   components:NSYearCalendarUnit | NSMonthCalendarUnit
                                   fromDate:now];
        comps.day = 1;
        NSDate *firstDay = [cal dateFromComponents:comps];
        NSString *nowMonthfirstDay = [formatter stringFromDate:firstDay];
        
        comps.day=numberOfDaysInMonth;
        NSDate *lasdate = [cal dateFromComponents:comps];

        NSString *nowMonthLastDay = [formatter stringFromDate:lasdate];
                comps.month=1;
        comps.day=1;
        
        NSDate *YearfirstDay=[cal dateFromComponents:comps];
       NSString *nowYearfirstDay=[formatter stringFromDate:YearfirstDay];
        
        comps.month=12;
        comps.day=31;
        NSDate *YearLastDay=[cal dateFromComponents:comps];
        NSString *nowYearLastDay=[formatter stringFromDate:YearLastDay];
     
       
            
            if ([[buttonsArray[index] allKeys] containsObject:@"defaultValue"]){
                if (![[buttonsArray[index] objectForKey:@"defaultValue"] isEqualToString:@""]) {
                    [button setTitle:[buttonsArray[index] objectForKey:@"defaultValue"] forState:0];
                    
                    if ([(NSString *)buttonsArray[index][@"defaultValue"] isEqualToString:@"当前日期"]) {[button setTitle:[formatter stringFromDate:[NSDate date]] forState:0];
                        [xmlArray addObject:[formatter stringFromDate:[NSDate date]]];}
                    
                    else if ([(NSString *)buttonsArray[index][@"defaultValue"] isEqualToString:@"当月第一天"]){ [button setTitle:nowMonthfirstDay  forState:0]; [xmlArray addObject:nowMonthfirstDay];}
                    else if ([(NSString *)buttonsArray[index][@"defaultValue"] isEqualToString:@"当月最后最后一天"]){[button setTitle:nowMonthLastDay  forState:0];[xmlArray addObject:nowMonthLastDay];}
                    else if ([(NSString *)buttonsArray[index][@"defaultValue"] isEqualToString:@"当年第一天"]){[button setTitle:nowYearfirstDay  forState:0];[xmlArray addObject:nowYearfirstDay];}
                    else if ([(NSString *)buttonsArray[index][@"defaultValue"] isEqualToString:@"当年最后一天"]){[button setTitle:nowYearLastDay forState:0];[xmlArray addObject:nowYearLastDay];}
                    else{[button setTitle:[buttonsArray[index] objectForKey:@"defaultValue"] forState:0];
                       [xmlArray addObject:button.titleLabel.text];
                    }
                    
                    
                }else{
                    [button setTitle:[buttonsArray[index] objectForKey:@"fieldName"] forState:0];
                   [xmlArray addObject:@"空"];
                
                
                
                }
                
                
                
                
                   }else{
            [button setTitle:[buttonsArray[index] objectForKey:@"fieldName"] forState:0];
           [xmlArray addObject:@"空"];

        
        
        }

      
        
        [button setTitleColor:[UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1] forState:0];
        [button addTarget:self action:@selector(editorConditions:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        
               if (
index == buttonsArray.count-1) {
            
            
            UIButton * reset = [UIButton buttonWithType:UIButtonTypeCustom];
            reset.frame = CGRectMake(10, button.frame.origin.y+button.frame.size.height+10, (LWidth-30)/2, 35);
            reset.tag = 1000;
            reset.backgroundColor = [UIColor colorWithRed:19/255.0 green:153/255.0 blue:251/255.0 alpha:1];
            reset.layer.masksToBounds = YES;
            reset.layer.cornerRadius = 5;
            reset.titleLabel.font = [UIFont systemFontOfSize:16];
            [reset setTitle:@"重置" forState:0];
            [reset setTitleColor:[UIColor whiteColor] forState:0];
            [reset addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:reset];
            
            
            
            
            UIButton * query = [UIButton buttonWithType:UIButtonTypeCustom];
            query.frame = CGRectMake((LWidth-30)/2+20, button.frame.origin.y+button.frame.size.height+10, (LWidth-30)/2, 35);
            query.tag = 1000;
            query.backgroundColor = [UIColor colorWithRed:19/255.0 green:153/255.0 blue:251/255.0 alpha:1];
            query.layer.masksToBounds = YES;
            query.layer.cornerRadius = 5;
            query.titleLabel.font = [UIFont systemFontOfSize:16];
            [query setTitle:@"搜索" forState:0];
            [query setTitleColor:[UIColor whiteColor] forState:0];
            [query addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:query];
            
            dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, query.frame.size.height+query.frame.origin.y+10, LWidth, LHeight-64-(query.frame.size.height+query.frame.origin.y+10))];
            dataTableView.delegate = self;
            dataTableView.dataSource = self;
            dataTableView.sectionHeaderHeight = 30.0f;
            dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [dataTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
            [dataTableView addHeaderWithTarget:self action:@selector(upRefresh:)];
            [dataTableView addFooterWithTarget:self action:@selector(downRefresh:)];
            [self.view addSubview:dataTableView];
        }
    }
    
}
else{
    dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LWidth, LHeight)];
    dataTableView.delegate = self;
    dataTableView.dataSource = self;
    dataTableView.sectionHeaderHeight = 30.0f;
    dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [dataTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [dataTableView addHeaderWithTarget:self action:@selector(upRefresh:)];
    [dataTableView addFooterWithTarget:self action:@selector(downRefresh:)];
    [self.view addSubview:dataTableView];
    
    
    
}
    
       [self search];
}

#pragma mark ------ 下拉刷新
- (void)upRefresh:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self search];
        [dataTableView headerEndRefreshing];
    });
}
#pragma mark ------ 上拉加载
- (void)downRefresh:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestShowDataRefresh];
        [dataTableView footerEndRefreshing];
    });
}
//请求上边按钮数据
- (void)requestShowButtons
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"GETQUERYCONFIG" forKey:@"Action"];
    for (NSInteger index = 0; index < getArray.count; index ++) {
        [dict setObject:[[getArray[index] componentsSeparatedByString:@"="][1] uppercaseString] forKey:[[getArray[index] componentsSeparatedByString:@"="][0] uppercaseString]];
    }
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/ProxyMobile/MobileFrame.ashx",HTTPIP,SLRD] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            NSDictionary* data = [json objectWithString:[[[dictt objectForKey:@"Data"] objectForKey:@"R"] objectForKey:@"content"]];
            dataAllDict = [NSDictionary dictionaryWithDictionary:data];
            buttonsArray = [[NSMutableArray alloc] initWithArray:[data objectForKey:@"listQuerys"]];
            mainTableTitle = [NSArray arrayWithArray:[data objectForKey:@"details"]];
            subTablesArray = [NSArray arrayWithArray:[data objectForKey:@"subTables"]];
            showTypeConten = [dataAllDict objectForKey:@"listShowType"];
            showColor =[dataAllDict objectForKey:@"listShowColor"];
            
            
            [self initView];
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}
//添加搜索条件
- (void)editorConditions:(UIButton *)sender
{
    
    
    if ([[buttonsArray[sender.tag] objectForKey:@"showType"] isEqualToString:@"0"]||[[buttonsArray[sender.tag] objectForKey:@"showType"] isEqualToString:@"1"]||[[buttonsArray[sender.tag] objectForKey:@"showType"] isEqualToString:@"4"]) {
        NSString* title = [buttonsArray[sender.tag] objectForKey:@"fieldName"];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* determine = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [sender setTitle:alert.textFields[0].text forState:0];
            [xmlArray replaceObjectAtIndex:sender.tag withObject:alert.textFields[0].text];
        }];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.textColor = [UIColor blueColor];
            textField.text = sender.titleLabel.text;
            if ([[buttonsArray[sender.tag] objectForKey:@"showType"] isEqualToString:@"4"])textField.keyboardType = UIKeyboardTypeNumberPad;;
        }];
        [self presentViewController:alert animated:YES completion:nil];
        [alert addAction:determine];
        [alert addAction:cancel];
    }else if ([[buttonsArray[sender.tag] objectForKey:@"showType"] isEqualToString:@"2"]) {
        
        NSString* str = [NSString stringWithFormat:@"%@",[[json objectWithString:[buttonsArray[sender.tag] objectForKey:@"cmbConfig"]] objectForKey:@"dataFrom"]];//下拉框数据位置
        
        if ([str isEqualToString:@"0"]) {//下拉数据在本条数据
            NSArray* array = [[json objectWithString:[buttonsArray[sender.tag] objectForKey:@"cmbConfig"]] objectForKey:@"cmbSimpleCn"];
            NSString* title = [buttonsArray[sender.tag] objectForKey:@"fieldName"];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
            for (NSInteger index = 0; index < array.count; index ++) {
                NSString* title = [array[index] objectForKey:@"TEXT"];
                NSString* idStr = [array[index] objectForKey:@"VALUE"];
                UIAlertAction* addType = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [sender setTitle:title forState:0];
                    [xmlArray replaceObjectAtIndex:sender.tag withObject:idStr];
                }];
                [alert addAction:addType];
            }
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            }];
            [self presentViewController:alert animated:YES completion:nil];
            [alert addAction:cancel];
        }else if ([str isEqualToString:@"1"]) {
            
            [SVProgressHUD showWithStatus:@"稍等..."];
            NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETQUERYSPINNER",@"Action",[[json objectWithString:[buttonsArray[sender.tag] objectForKey:@"cmbConfig"]] objectForKey:@"dbText"],@"dbtext",[[json objectWithString:[buttonsArray[sender.tag] objectForKey:@"cmbConfig"]] objectForKey:@"dbFrom"],@"type",[[json objectWithString:[buttonsArray[sender.tag] objectForKey:@"cmbConfig"]] objectForKey:@"dbValue"],@"dbvalue", nil];
            MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/ProxyMobile/MobileFrame.ashx",HTTPIP,SLRD] withParameter:dict];
                 manager.backSuccess = ^void(NSDictionary *dictt)
            {
                
                
                
                
                if ([[dictt objectForKey:@"success"] integerValue] == 1) {
                    if ([[[json objectWithString:[buttonsArray[sender.tag] objectForKey:@"cmbConfig"]] objectForKey:@"dbFrom"] isEqualToString:@"0"]) {
                        NSArray* array = [[dictt objectForKey:@"Data"] objectForKey:@"Items"];
                        NSString* title = [buttonsArray[sender.tag] objectForKey:@"fieldName"];
                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
                        for (NSInteger index = 0; index < array.count; index ++) {
                            NSString* title = [array[index] objectForKey:@"ITEMNAME"];
                            NSString* idStr = [array[index] objectForKey:@"ITEMGUID"];
                            UIAlertAction* addType = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                [sender setTitle:title forState:0];
                                [xmlArray replaceObjectAtIndex:sender.tag withObject:idStr];
                            }];
                            [alert addAction:addType];
                        }
                        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        }];
                        [self presentViewController:alert animated:YES completion:nil];
                        [alert addAction:cancel];
                    }else if([[[json objectWithString:[buttonsArray[sender.tag] objectForKey:@"cmbConfig"]] objectForKey:@"dbFrom"] isEqualToString:@"2"]){
                        NSArray* array = [[dictt objectForKey:@"Data"] objectForKey:@"R"];
                        NSString* title = [buttonsArray[sender.tag] objectForKey:@"fieldName"];
                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
                        for (NSInteger index = 0; index < array.count; index ++) {
                            NSString* title = [array[index] objectForKey:@"TEXT"];
                            NSString* idStr = [array[index] objectForKey:@"VALUE"];
                            UIAlertAction*addType = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                [sender setTitle:title forState:0];
                                [xmlArray replaceObjectAtIndex:sender.tag withObject:idStr];
                            }];
                            [alert addAction:addType];
                        }
                        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        }];
                        [self presentViewController:alert animated:YES completion:nil];
                        [alert addAction:cancel];

                        
                    }else{
                        NSArray* array = [[dictt objectForKey:@"Data"] objectForKey:@"R"];
                        NSString* title = [buttonsArray[sender.tag] objectForKey:@"fieldName"];
                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
                        for (NSInteger index = 0; index < array.count; index ++) {
                            NSString* title = [array[index] objectForKey:@"BSKEY"];
                            NSString* idStr = [array[index] objectForKey:@"BSKEY"];
                            UIAlertAction* addType = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                [sender setTitle:title forState:0];
                                [xmlArray replaceObjectAtIndex:sender.tag withObject:idStr];
                            }];
                            [alert addAction:addType];
                        }
                        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        }];
                        [self presentViewController:alert animated:YES completion:nil];
                        [alert addAction:cancel];
                    }
                    
                    [SVProgressHUD dismiss];
                }else{
                    [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
                }
            };
        }
    }else if ([[buttonsArray[sender.tag] objectForKey:@"showType"] isEqualToString:@"3"]) {
        [self.view bringSubviewToFront:pView];
        xmlIndex = sender.tag;
        [UIView animateWithDuration:0.25 animations:^{
            pView.frame = CGRectMake(0, LHeight-255, LWidth, 190);
        }];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [showArray count];
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
    NSString* title = @"";
    for (NSInteger index = 0; index < showArrayKey.count; index ++) {
        if (index==0) {
            title = [NSString stringWithFormat:@"%@",[showArray[indexPath.row] objectForKey:showArrayKey[index]]];
        }else{
            title = [NSString stringWithFormat:@"%@，%@",title,[showArray[indexPath.row] objectForKey:showArrayKey[index]]];
        }
    }
    
    NSArray *keyArrays = [showArray[indexPath.row] allKeys];
    NSString* contents = showTypeConten;
    for (NSInteger key = 0; key < keyArrays.count; key ++) {
        
        NSString *newkey=keyArrays[key];
        NSString *nowkey=[NSString stringWithFormat:@"[%@]",newkey];
                contents = [contents stringByReplacingOccurrencesOfString:nowkey withString:[showArray[indexPath.row] objectForKey:keyArrays[key]]];
    }
    if ([[showArray[indexPath.row] allKeys] containsObject:@"STRCOLORSETTING"]) {
         cell.title.textColor=[MyTool colorWithHexString:[showArray[indexPath.row] objectForKey:@"STRCOLORSETTING"]];
    }else{
         cell.title.textColor=[MyTool colorWithHexString:@"#333333"];
    
    }

      CGSize size = [self sizeWithString:contents font:cell.title.font];
    cell.title.text = contents;
    cell.title.frame = CGRectMake(10, 8, LWidth-20, size.height);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        tableView.rowHeight = size.height+17;

    cell.rowImag.frame = CGRectMake(0, tableView.rowHeight-1, LWidth, 1);
    
      return cell;
  


}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    mainTaleData = [NSDictionary dictionaryWithDictionary:showArray[indexPath.row]];
    AllQuery_news_ViewController* vc = [[AllQuery_news_ViewController alloc] initWithTableTitle:mainTableTitle titleData:mainTaleData viceTitle:subTablesArray title:title_str ];
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(LWidth-20, LHeight)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  | NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    return rect.size;
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
    for (id view in [self.view subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* mobileView = (UIButton *)view;
            if (mobileView.tag==xmlIndex) {
                [mobileView setTitle:dateAndTime forState:0];
            }
        }
    }
    [xmlArray replaceObjectAtIndex:xmlIndex withObject:dateAndTime];
}
//重置
-(void)reset{
    [xmlArray removeAllObjects];
    [dataTableView removeFromSuperview];
    [self initView];
    
    
    
}
//搜索
- (void)search
{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    NSString* xmlStr;
    for (NSInteger index = 0; index < buttonsArray.count; index ++) {
        NSString* query = @"0";
        if ([[buttonsArray[index] objectForKey:@"queryType"] isEqualToString:@"LIKE"])query=@"1";
        if ([[buttonsArray[index] objectForKey:@"queryType"] isEqualToString:@"="])query=@"2";
        if ([[buttonsArray[index] objectForKey:@"queryType"] isEqualToString:@">"])query=@"3";
        if ([[buttonsArray[index] objectForKey:@"queryType"] isEqualToString:@">="])query=@"4";
        if ([[buttonsArray[index] objectForKey:@"queryType"] isEqualToString:@"<"])query=@"5";
        if ([[buttonsArray[index] objectForKey:@"queryType"] isEqualToString:@"<="])query=@"6";
        if ([[buttonsArray[index] objectForKey:@"queryType"] isEqualToString:@"<>"])query=@"7";
        
        NSString* contens = xmlArray[index];
        
             if ([contens isEqualToString:@"空"])contens=@"";
        
        if (index==0) {
            xmlStr = [NSString stringWithFormat:@"<%@ type='%@' query='%@'>%@</%@>",[buttonsArray[index] objectForKey:@"fieldCode"],[buttonsArray[index] objectForKey:@"showType"],query,contens,[buttonsArray[index] objectForKey:@"fieldCode"]];
        }else{
            xmlStr = [NSString stringWithFormat:@"%@<%@ type='%@' query='%@'>%@</%@>",xmlStr,[buttonsArray[index] objectForKey:@"fieldCode"],[buttonsArray[index] objectForKey:@"showType"],query,contens,[buttonsArray[index] objectForKey:@"fieldCode"]];
        }
    }
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"<Data>%@</Data>",xmlStr],@"SearchXml",@"GETQUERYMAINLIST",@"Action",@"10",@"Pagesize",@"1",@"Pageindex",[dataAllDict objectForKey:@"mainTableCode"],@"Tablecode",[dataAllDict objectForKey:@"fieldOrderType"],@"Softtype",[dataAllDict objectForKey:@"fieldOrder"],@"Softfield",[dataAllDict objectForKey:@"mainTableFrom"],@"Tablefrom",showColor,@"strColorSetting", nil];
    
    NSLog(@"搜索条件==========%@",dict);
    
    refreshXmlStr=xmlStr;
    
       MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/ProxyMobile/MobileFrame.ashx",HTTPIP,SLRD] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
              
        
        
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            [showArray removeAllObjects];
            showArray = [NSMutableArray arrayWithArray:[dictt objectForKey:@"data"]];
            NSLog(@"SHOWSARRAY===%@",showArray);
            [dataTableView reloadData];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}
//下拉刷新，上啦刷新加载
- (void)requestShowDataRefresh
{
    startIndex = startIndex+1;
    NSString* pageStr = [NSString stringWithFormat:@"%ld",(long)startIndex];
    [SVProgressHUD showWithStatus:@"努力加载中..."];
//    NSString* xmlStr;
//    for (NSInteger index = 0; index < buttonsArray.count; index ++) {
//        NSString* query = @"0";
//        if ([[buttonsArray[index] objectForKey:@"queryType"] isEqualToString:@"LIKE"])query=@"1";
//        if ([[buttonsArray[index] objectForKey:@"queryType"] isEqualToString:@"="])query=@"2";
//        if ([[buttonsArray[index] objectForKey:@"queryType"] isEqualToString:@">"])query=@"3";
//        if ([[buttonsArray[index] objectForKey:@"queryType"] isEqualToString:@">="])query=@"4";
//        if ([[buttonsArray[index] objectForKey:@"queryType"] isEqualToString:@"<"])query=@"5";
//        if ([[buttonsArray[index] objectForKey:@"queryType"] isEqualToString:@"<="])query=@"6";
//        if ([[buttonsArray[index] objectForKey:@"queryType"] isEqualToString:@"<>"])query=@"7";
//        NSString* contens = xmlArray[index];
//        if ([contens isEqualToString:@"空"])contens=@"";
//        
//        if (index==0) {
//            xmlStr = [NSString stringWithFormat:@"<%@ type='%@' query='%@'>%@</%@>",[buttonsArray[index] objectForKey:@"fieldCode"],[buttonsArray[index] objectForKey:@"showType"],query,contens,[buttonsArray[index] objectForKey:@"fieldCode"]];
//        }else{
//            xmlStr = [NSString stringWithFormat:@"%@<%@ type='%@' query='%@'>%@</%@>",xmlStr,[buttonsArray[index] objectForKey:@"fieldCode"],[buttonsArray[index] objectForKey:@"showType"],query,contens,[buttonsArray[index] objectForKey:@"fieldCode"]];
//        }
//    }
          NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"<Data>%@</Data>",refreshXmlStr],@"SearchXml",@"GETQUERYMAINLIST",@"Action",@"10",@"Pagesize",pageStr,@"Pageindex",[dataAllDict objectForKey:@"mainTableCode"],@"Tablecode",[dataAllDict objectForKey:@"mainTableFrom"],@"Tablefrom",[dataAllDict objectForKey:@"fieldOrderType"],@"Softtype",[dataAllDict objectForKey:@"fieldOrder"],@"Softfield", showColor,@"strColorSetting", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/ProxyMobile/MobileFrame.ashx",HTTPIP,SLRD] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            NSMutableArray* array = [dictt objectForKey:@"data"];
            NSLog(@"SSSSSSSS=%@",array);
            if (array.count < 10) {
                [SVProgressHUD showSuccessWithStatus:@"加载到底了"];
                for (NSUInteger i = 0; i < array.count; i ++) {
                    [showArray addObject:[array objectAtIndex:i]];
                }
                [dataTableView reloadData];
            }else{
                for (NSUInteger i = 0; i < array.count; i ++) {
                    [showArray addObject:[array objectAtIndex:i]];
                }
                [dataTableView reloadData];
            }
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.d
}

@end
