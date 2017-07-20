//
//  PerplelistViewController.m
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/12/2.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "PerplelistViewController.h"
#import "PeopleTableViewCell.h"
#import "PeopleModel.h"

@interface PerplelistViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSDictionary* parameterDict;
    NSMutableArray* dataArray;
    NSMutableArray* showArray;
    NSMutableArray* backArray;
    NSString* typeStr;
}
@end

@implementation PerplelistViewController
- (id)initWithDict:(NSDictionary *)urlDict type:(NSString *)aType
{
    self = [super init];
    if (self) {
        parameterDict =[NSDictionary dictionaryWithDictionary:urlDict];
        typeStr = aType;
    }
    return self;
}
- (void)viewDidLoad {
    
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
    
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    [super viewDidLoad];
    self.title = @"选取执行者";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self requestListData];
}
- (void)requestListData
{
    [dataArray removeAllObjects];
    dataArray = [[NSMutableArray alloc] init];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/%@",HTTPIP,SLRD,MOBILE_URL] withParameter:parameterDict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            if ([[dictt objectForKey:@"Data"] isKindOfClass:[NSDictionary class]]) {
                if ([[[dictt objectForKey:@"Data"] objectForKey:@"R"] isKindOfClass:[NSDictionary class]]) {
                    [dataArray addObject:[[dictt objectForKey:@"Data"] objectForKey:@"R"]];
                }else{
                    dataArray = [[dictt objectForKey:@"Data"] objectForKey:@"R"];
                }
                [self requestListData2];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}
- (void)requestListData2
{
    NSString* guid = nil;
    for (NSInteger index = 0; index < dataArray.count; index ++) {
        NSString* str = [NSString stringWithFormat:@"'%@'",[dataArray[index] objectForKey:@"FGUID"]];
        if (index==0) {
            guid = str;
        }else{
            guid = [NSString stringWithFormat:@"%@,%@",guid,str];
        }
    }
    [self requestListData3:guid];
}
- (void)requestListData3:(NSString *)guidStr
{
    [showArray removeAllObjects];
    showArray = [[NSMutableArray alloc] init];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETORGANDPERSONINFOBYGUIDLIST",@"Action",@"0",@"TYPE",@"0",@"SELFORG",@"1",@"LEVEL",guidStr,@"GUIDLIST",@"",@"CHILDRENOF", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/ProxyMobile/MobileFrame.ashx",HTTPIP,SLRD] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            if ([[dictt objectForKey:@"Data"] isKindOfClass:[NSDictionary class]]) {
                if ([[[dictt objectForKey:@"Data"] objectForKey:@"R"] isKindOfClass:[NSDictionary class]]) {
                    [showArray addObject:[PeopleModel initWithData:[[dictt objectForKey:@"Data"] objectForKey:@"R"]]];
                }else{
                    for (NSDictionary* modelDict in [[dictt objectForKey:@"Data"] objectForKey:@"R"]) {
                        [showArray addObject:[PeopleModel initWithData:modelDict]];
                    }
                }
                [self.tableView reloadData];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
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
    cell.model = showArray[indexPath.row];
    cell.title.text = [NSString stringWithFormat:@"%@   %@",[cell.model.data objectForKey:@"FDISPLAYNAME"],[cell.model.data objectForKey:@"PATHNAME"]];
    CGSize size = [self sizeWithStringTitle:cell.title.text font:cell.title.font sizwLwidth:LWidth-60];
    cell.title.frame = CGRectMake(10, 8, LWidth-60, size.height);
    tableView.rowHeight = size.height+17;
    cell.row.frame = CGRectMake(0, tableView.rowHeight-1, LWidth, 1);
    cell.indexBtn.tag = indexPath.row;
    [cell.indexBtn setBackgroundImage:[UIImage imageNamed:cell.model.isSelected?@"home_write_caogao_1.png":@"home_write_caogao.png"] forState:UIControlStateNormal];
    [cell.indexBtn addTarget:self action:@selector(indexBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)indexBtnClick:(UIButton *)sender
{
    PeopleModel* model = showArray[sender.tag];
    model.isSelected = !model.isSelected;
    [self.tableView reloadData];
}
- (void)backUpdata
{
    [self.navigationController popViewControllerAnimated:YES];
    backArray = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < showArray.count; index ++) {
        PeopleModel* model = showArray[index];
        if (model.isSelected) {
            [backArray addObject:showArray[index]];
        }
    }
    if ([self.delegate respondsToSelector:@selector(backUpDataViewController:data:type:)]) {
        [self.delegate backUpDataViewController:backArray data:parameterDict type:typeStr];
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
