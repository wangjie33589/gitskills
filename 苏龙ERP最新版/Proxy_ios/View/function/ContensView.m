//
//  ContensView.m
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/22.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "ContensView.h"
#import "ContensTableViewCell.h"
#import "MJRefresh.h"

@implementation ContensView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/
- (id)initWithModel:(NewsModel *)aModel
{
    self = [super init];
    if (self) {
        self.model = aModel;
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    startIndex = 1;
    [self requestShowDataNews];
}
- (void)requestShowDataNews
{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETNOTICEDATABYGUID",@"Action",@"DESC",@"Softtype",@"1",@"Pageindex",@"10",@"Pagesize",self.model.guid,@"GUID",@"EDITTIME",@"Softfield", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/NM/%@",HTTPIP,SLRD,PROXY_URL] withParameter:dict];
    //    manager.delegate = self;
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        contenTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        contenTableView.delegate = self;
        contenTableView.dataSource = self;
        contenTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [contenTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [contenTableView addHeaderWithTarget:self action:@selector(upRefresh:)];
        [contenTableView addFooterWithTarget:self action:@selector(downRefresh:)];
        [self addSubview:contenTableView];
        [self.dataArray removeAllObjects];
        self.dataArray = [NSMutableArray arrayWithArray:[dictt objectForKey:@"data"]];
        [contenTableView reloadData];
        [SVProgressHUD dismiss];
    };
}
- (void)requestShowDataRefresh
{
    startIndex = startIndex+1;
    NSString* pageStr = [NSString stringWithFormat:@"%ld",(unsigned long)startIndex];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETNOTICEDATABYGUID",@"Action",@"DESC",@"Softtype",pageStr,@"Pageindex",@"10",@"Pagesize",self.model.guid,@"GUID",@"EDITTIME",@"Softfield", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/NM/%@",HTTPIP,SLRD,PROXY_URL] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        NSMutableArray* array = [dictt objectForKey:@"data"];
        if (array.count < 10) {
            [SVProgressHUD showSuccessWithStatus:@"加载到底了"];
            for (NSUInteger i = 0; i < array.count; i ++) {
                [self.dataArray addObject:[array objectAtIndex:i]];
            }
            [contenTableView reloadData];
        }else{
            for (NSUInteger i = 0; i < array.count; i ++) {
                [self.dataArray addObject:[array objectAtIndex:i]];
            }
            [contenTableView reloadData];
        }
    };
}
#pragma mark ------ 下拉刷新
- (void)upRefresh:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestShowDataNews];
        [contenTableView headerEndRefreshing];
    });
}
#pragma mark ------ 上拉加载
- (void)downRefresh:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestShowDataRefresh];
        [contenTableView footerEndRefreshing];
    });
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"CellIdentifier";
    ContensTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContensTableViewCell" owner:nil options:nil];
        for (id oneObject in nib)
        {
            if ([oneObject isKindOfClass:[ContensTableViewCell class]])
            {
                cell = (ContensTableViewCell *)oneObject;
            }
        }
    }
    cell.title.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"TITLE"];
    cell.contens.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"CONTENT"];
    cell.time.text = [[[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"EDITTIME"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:16];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.rowHeight = 70;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(pushNewsViewController:)]) {
        [self.delegate pushNewsViewController:[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"GUID"]];
    }
}

@end
