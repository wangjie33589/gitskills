//
//  AllQueryTableView.m
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/12/8.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "AllQueryTableView.h"
#import "ScheduleTableViewCell.h"

@implementation AllQueryTableView

- (id)initWithModel:(NSDictionary *)dict title:(NSString *)aStr
{
    self = [super init];
    if (self) {
        requestDict = [NSDictionary dictionaryWithDictionary:dict];
        titleStr = aStr;
        [self initView];
    }
    return self;
}
- (void)initView {
    [[App ddMenu] setEnableGesture:NO];
    showTitleArray = [[NSMutableArray alloc] init];
    NSArray* array1 = [NSArray arrayWithArray:[titleStr componentsSeparatedByString:@"]"]];
    for (NSInteger index = 0; index < array1.count; index ++) {
        NSArray* array2 = [[array1 objectAtIndex:index] componentsSeparatedByString:@"["];
        if (index!=array1.count-1) [showTitleArray addObject:array2[1]];
    }
    
    showArray = [[NSMutableArray alloc] init];
    contenTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LWidth, LHeight-104)];
    contenTableView.delegate = self;
    contenTableView.dataSource = self;
    contenTableView.bounces = NO;
    contenTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [contenTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addSubview:contenTableView];
    [self requestShowDataNews];
}
- (void)requestShowDataNews
{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/ProxyMobile/MobileFrame.ashx",HTTPIP,SLRD] withParameter:requestDict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        NSLog(@"dict====%@",dictt);
        
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            if ([dictt objectForKey:@"Data"]==nil||[[dictt objectForKey:@"Data"] isEqual:[NSNull null]]) {
            }else{
                if ([[[dictt objectForKey:@"Data"] objectForKey:@"R"] isKindOfClass:[NSArray class]]) {
                    showArray = [[NSMutableArray alloc] initWithArray:[[dictt objectForKey:@"Data"] objectForKey:@"R"]];
                    
                    NSLog(@"111====%@",showArray);

                }else if ([[[dictt objectForKey:@"Data"] objectForKey:@"R"] isKindOfClass:[NSDictionary class]]){
                    [showArray addObject:[[dictt objectForKey:@"Data"] objectForKey:@"R"]];
                    NSLog(@"22222==%@",showArray);

                }
                
                  NSLog(@"33333==%@",showArray);
                
                              [contenTableView reloadData];
            }
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
    [SVProgressHUD dismiss];
}
#pragma mark ------- 表代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"CellIdentifier";
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ScheduleTableViewCell" owner:nil options:nil];
        for (id oneObject in nib)
        {
            if ([oneObject isKindOfClass:[ScheduleTableViewCell class]])
            {
                cell = (ScheduleTableViewCell *)oneObject;
            }
        }
    }
    
    NSArray *keyArrays = [showArray[indexPath.row] allKeys];
  
    NSString* contents = titleStr;
    for (NSInteger key = 0; key < keyArrays.count; key ++) {
        
        NSString *newkey=keyArrays[key];
        NSString *nowkey=[NSString stringWithFormat:@"[%@]",newkey];
        contents = [contents stringByReplacingOccurrencesOfString:nowkey withString:[showArray[indexPath.row] objectForKey:keyArrays[key]]];
    }
    
    
//      NSLog(@"KEY==%@",contents);
//   contents = [[contents stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];
    
    CGSize size = [self sizeWithString:contents font:cell.title.font];
    cell.title.text = contents;
   
    cell.title.numberOfLines=0;
    cell.title.frame = CGRectMake(10, 8, LWidth-20, size.height);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.rowHeight = size.height+17;
    cell.bg.frame = CGRectMake(0, tableView.rowHeight-1, LWidth, 1);
    return cell;
}
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(LWidth-30, LHeight)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  | NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    return rect.size;
}
@end
