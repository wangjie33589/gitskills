//
//  NoticeViewController.m
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/22.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeTableViewCell.h"
#import "NSViewController.h"
#import "MJRefresh.h"

@interface NoticeViewController () <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray* showArray;
    NSUInteger startIndex;
}
@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _title_str;
    startIndex = 1;
    self.noticeSearchBar.delegate = self;
    [self.noticeSearchBar setKeyboardType:UIKeyboardTypeEmailAddress];
    self.noticeSearchBar.returnKeyType = UIReturnKeyDone;
    
    self.noticeTableView.delegate = self;
    self.noticeTableView.dataSource = self;
    self.noticeTableView.sectionHeaderHeight = 35.0f;
    self.noticeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.noticeTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.noticeTableView addHeaderWithTarget:self action:@selector(upRefresh:)];
    [self.noticeTableView addFooterWithTarget:self action:@selector(downRefresh:)];
    
    [self requestShowDataNews];
//    UIBarButtonItem *rightBtn =[[UIBarButtonItem alloc]initWithTitle:@"文件" style:    UIBarButtonItemStylePlain target:self action:@selector(next)];
//    self.navigationItem.leftBarButtonItem=rightBtn;
    
}
-(void)next{
//    [[NSUserDefaults standardUserDefaults] setObject:@"y" forKey:@"BDF644BD9F0E4F2FB5D47B4AEA278C98"];
//    NSViewController* nsVC = [[NSViewController alloc] initWithUrl:@"BDF644BD9F0E4F2FB5D47B4AEA278C98"];
//    [self.navigationController pushViewController:nsVC animated:YES];



}
#pragma mark ------ 下拉刷新
- (void)upRefresh:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestShowDataNews];
        [self.noticeTableView headerEndRefreshing];
    });
}
#pragma mark ------ 上拉加载
- (void)downRefresh:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestShowDataRefresh];
        [self.noticeTableView footerEndRefreshing];
    });
}
- (void)requestShowDataRefresh
{
    startIndex = startIndex+1;
    NSString* pageStr = [NSString stringWithFormat:@"%ld",(unsigned long)startIndex];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETCOMPANYNOTICEBYTYPE",@"Action",@"10",@"Pagesize",pageStr,@"Pageindex",@"DESC",@"Softtype",@"EDITTIME",@"Softfield",@"002",@"TYPEVALUE", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/NM/%@",HTTPIP,SLRD,PROXY_URL] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        NSMutableArray* array = [dictt objectForKey:@"data"];
        if (array.count < 10) {
            [SVProgressHUD showSuccessWithStatus:@"加载到底了"];
            for (NSUInteger i = 0; i < array.count; i ++) {
                [showArray addObject:[array objectAtIndex:i]];
            }
            [self.noticeTableView reloadData];
        }else{
            for (NSUInteger i = 0; i < array.count; i ++) {
                [showArray addObject:[array objectAtIndex:i]];
            }
            [self.noticeTableView reloadData];
        }
    };
}
- (void)requestShowDataNews
{
    [showArray removeAllObjects];
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETCOMPANYNOTICEBYTYPE",@"Action",@"10",@"Pagesize",@"1",@"Pageindex",@"DESC",@"Softtype",@"EDITTIME",@"Softfield",@"002",@"TYPEVALUE", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/NM/%@",HTTPIP,SLRD,PROXY_URL] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        showArray = [NSMutableArray arrayWithArray:[dictt objectForKey:@"data"]];
        [self.noticeTableView reloadData];
        [SVProgressHUD dismiss];
    };
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO];
    self.navigationItem.rightBarButtonItem = nil;
    [self.view endEditing:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [showArray removeAllObjects];
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETCOMPANYNOTICEBYTYPE",@"Action",@"10",@"Pagesize",@"1",@"Pageindex",@"DESC",@"Softtype",@"EDITTIME",@"Softfield",@"002",@"TYPEVALUE",searchBar.text,@"TITLE", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/NM/%@",HTTPIP,SLRD,PROXY_URL] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        showArray = [NSMutableArray arrayWithArray:[dictt objectForKey:@"data"]];
        [self.noticeTableView reloadData];
        [SVProgressHUD dismiss];
    };
    [self.view endEditing:YES];
}
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
    static NSString *CellIdentifier = @"CellIdentifier";
    NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NoticeTableViewCell" owner:nil options:nil];
        for (id oneObject in nib)
        {
            if ([oneObject isKindOfClass:[NoticeTableViewCell class]])
            {
                cell = (NoticeTableViewCell *)oneObject;
            }
        }
    }
    cell.title.text = [showArray[indexPath.row] objectForKey:@"TITLE"];
    cell.time.text = [[showArray[indexPath.row] objectForKey:@"EDITTIME"] substringWithRange:NSMakeRange(5, 5)];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:[showArray[indexPath.row] objectForKey:@"GUID"]]) {
        cell.title.textColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1];
        cell.time.textColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.noticeTableView reloadData];
    [[NSUserDefaults standardUserDefaults] setObject:@"y" forKey:[showArray[indexPath.row] objectForKey:@"GUID"]];
    NSViewController* nsVC = [[NSViewController alloc] initWithUrl:[showArray[indexPath.row] objectForKey:@"GUID"] WithTitleStr:@"公告详情"];
    [self.navigationController pushViewController:nsVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
