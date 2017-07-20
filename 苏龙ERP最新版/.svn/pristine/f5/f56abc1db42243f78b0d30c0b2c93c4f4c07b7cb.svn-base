//
//  PeopleViewController.m
//  Proxy_ios
//
//  Created by E-Bans on 15/11/27.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "PeopleViewController.h"
#import "PeopleTableViewCell.h"

@interface PeopleViewController () <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray* dataArrayA;
    NSMutableArray* dataArrayB;
    UITableView* tableA;
    UITableView* tableB;
    NSString* typeStr;
}
@end

@implementation PeopleViewController
- (id)initWithType:(NSString *)aType
{
    self = [super init];
    if (self) {
        typeStr = aType;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择执行者";
    self.view.backgroundColor = [UIColor grayColor];
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"确定"
                                     style:UIBarButtonItemStyleDone
                                     target:self
                                     action:@selector(backUpdata)];
    
    [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont systemFontOfSize:15], NSFontAttributeName,
                                         [UIColor whiteColor], NSForegroundColorAttributeName,
                                         nil]
                               forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    dataArrayB = [[NSMutableArray alloc] init];
    searchBarPeople.delegate = self;
    searchBarPeople.returnKeyType = UIReturnKeyDone;
    
    tableA = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, LWidth, (LHeight-104)/2)];
    tableA.delegate = self;
    tableA.dataSource = self;
    tableA.tag = 0;
    tableA.sectionHeaderHeight = 30.0f;
    tableA.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableA setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:tableA];
    
    tableB = [[UITableView alloc] initWithFrame:CGRectMake(0, 40+((LHeight-104)/2), LWidth, (LHeight-104)/2)];
    tableB.delegate = self;
    tableB.dataSource = self;
    tableB.tag = 1;
    tableB.sectionHeaderHeight = 30.0f;
    tableB.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableB setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:tableB];
}
#pragma mark ------- 表代理
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    sectionView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    UILabel* sectionLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LWidth, 30)];
    sectionLable.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1];
    sectionLable.text = tableView.tag?@"已选执行人":@"待选执行人";
    sectionLable.font = [UIFont systemFontOfSize:14];
    sectionLable.backgroundColor = [UIColor clearColor];
    sectionLable.textAlignment = NSTextAlignmentLeft;
    [sectionView addSubview:sectionLable];
    
    return sectionView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==0) {
        return dataArrayA.count;
    }else{
        return dataArrayB.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"CellIdentifier";
    PeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PeopleTableViewCell" owner:nil options:nil];
        for (id oneObject in nib)
        {
            if ([oneObject isKindOfClass:[PeopleTableViewCell class]])
            {
                cell = (PeopleTableViewCell *)oneObject;
            }
        }
    }
    if (tableView.tag==0) {
        cell.title.text = [NSString stringWithFormat:@"%@   %@",[dataArrayA[indexPath.row] objectForKey:@"FDISPLAYNAME"],[dataArrayA[indexPath.row] objectForKey:@"PATHNAME"]];
        CGSize size = [self sizeWithStringTitle:cell.title.text font:cell.title.font sizwLwidth:LWidth-60];
        cell.title.frame = CGRectMake(10, 8, LWidth-60, size.height);
        tableView.rowHeight = size.height+17;
        cell.row.frame = CGRectMake(0, tableView.rowHeight-1, LWidth, 1);
        cell.indexBtn.tag = indexPath.row;
        [cell.indexBtn setBackgroundImage:[UIImage imageNamed:@"home_write_caogao.png"] forState:UIControlStateNormal];
        [cell.indexBtn addTarget:self action:@selector(indexBtnClickA:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell.title.text = [NSString stringWithFormat:@"%@   %@",[dataArrayB[indexPath.row] objectForKey:@"FDISPLAYNAME"],[dataArrayB[indexPath.row] objectForKey:@"PATHNAME"]];
        CGSize size = [self sizeWithStringTitle:cell.title.text font:cell.title.font sizwLwidth:LWidth-60];
        cell.title.frame = CGRectMake(10, 8, LWidth-60, size.height);
        tableView.rowHeight = size.height+17;
        cell.row.frame = CGRectMake(0, tableView.rowHeight-1, LWidth, 1);
        cell.indexBtn.tag = indexPath.row;
        [cell.indexBtn setBackgroundImage:[UIImage imageNamed:@"home_write_caogao_1.png"] forState:UIControlStateNormal];
        [cell.indexBtn addTarget:self action:@selector(indexBtnClickB:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)indexBtnClickA:(UIButton *)sender
{
    if ([typeStr isEqualToString:@"12"]) {
        for (NSInteger index = 0; index < dataArrayB.count; index ++) {
            [dataArrayA addObject:dataArrayB[index]];
        }
        [dataArrayB removeAllObjects];
        [dataArrayB addObject:[dataArrayA objectAtIndex:sender.tag]];
        [dataArrayA removeObjectAtIndex:sender.tag];
        [tableB reloadData];
        [tableA reloadData];
    }else{
        [dataArrayB addObject:[dataArrayA objectAtIndex:sender.tag]];
        [dataArrayA removeObjectAtIndex:sender.tag];
        [tableB reloadData];
        [tableA reloadData];
    }
}
- (void)indexBtnClickB:(UIButton *)sender
{
    [dataArrayA addObject:[dataArrayB objectAtIndex:sender.tag]];
    [dataArrayB removeObjectAtIndex:sender.tag];
    [tableA reloadData];
    [tableB reloadData];
}
- (void)backUpdata
{
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(All_backUpDataViewController:data:type:)]) {
        [self.delegate All_backUpDataViewController:dataArrayB data:nil type:typeStr];
    }
}
#pragma mark ------------------ UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES];
    
    for(id cc in [searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO];
    self.navigationItem.rightBarButtonItem = nil;
    [self.view endEditing:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self requestListData:searchBar.text];
    [self.view endEditing:YES];
}
- (void)requestListData:(NSString *)str
{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    [dataArrayA removeAllObjects];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETORGANDPERSONINFOBYGUIDLIST",@"Action",@"9",@"TYPE",@"0",@"SELFORG",@"1",@"LEVEL",str,@"GUIDLIST",@"",@"CHILDRENOF", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/ProxyMobile/MobileFrame.ashx",HTTPIP,SLRD] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            if ([[dictt objectForKey:@"Data"] isKindOfClass:[NSDictionary class]]) {
                if ([[[dictt objectForKey:@"Data"] objectForKey:@"R"] isKindOfClass:[NSDictionary class]]) {
                    dataArrayA = [[NSMutableArray alloc] init];
                    [dataArrayA addObject:[[dictt objectForKey:@"Data"] objectForKey:@"R"]];
                }else{
                    dataArrayA = [NSMutableArray arrayWithArray:[[dictt objectForKey:@"Data"] objectForKey:@"R"]];
                }
                if ([typeStr isEqualToString:@"12"]) {
                    for (NSInteger index = 0; index < dataArrayA.count; index ++) {
                        if (![[dataArrayA[index] objectForKey:@"FKIND"] isEqualToString:@".PSM"]) {
                            [dataArrayA removeObjectAtIndex:index];
                        }
                    }
                }
                [SVProgressHUD dismiss];
                [tableA reloadData];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
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

@end
