//
//  LeftViewController.m
//  Proxy_ios
//
//  Created by E-Bans on 15/11/13.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "LeftViewController.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
#import "LeftTableViewCell.h"
#import "SetViewController.h"
#import "LeftModel.h"
#import "Home_Function_ViewController.h"
#import "MJRefresh.h"
#import "UserInfo.h"

@interface LeftViewController () <MyRequestDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView* popView;
    NSMutableArray* countArray;//区数组
    NSMutableArray* groupShowArray;//表数组
    NSMutableArray* rowArray;//行数组
}
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}
- (void)initView
{
    self.navigationController.navigationBar.hidden = YES;
    userImag.layer.masksToBounds = YES;
    userImag.layer.cornerRadius = userImag.frame.size.width/2;
    userImag.layer.borderColor = [[UIColor whiteColor] CGColor];
    userImag.layer.borderWidth = 1.5f;
    
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    [userImag sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@/Jsframe/SystemMng/PersonImages/%@",HTTPIP,SLRD,USERHEADIMAG]] placeholderImage:[UIImage imageNamed:@"imagUserIndex"]];
    userName.text = USERNAME;
    userTask.text = USERTASK;
    list_tableView.delegate = self;
    list_tableView.dataSource = self;
    list_tableView.sectionHeaderHeight = 35.0f;
    list_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [list_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [list_tableView addHeaderWithTarget:self action:@selector(upRefresh:)];
    
   
    [self requestShowDataList];     
    UIButton* setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame = CGRectMake(0, LHeight-49, ([UIScreen mainScreen].bounds.size.width-130)/2, 49);
    [setButton setTitle:@"   设置" forState:0];
    setButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [setButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] forState:0];
    [setButton addTarget:self action:@selector(setButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setButton];
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-130)/2, LHeight-49, ([UIScreen mainScreen].bounds.size.width-130)/2, 49);
    [backButton setTitle:@"   退出" forState:0];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [backButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] forState:0];
    [backButton addTarget:self action:@selector(go_back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIImageView* setImag = [[UIImageView alloc] initWithFrame:CGRectMake(IPHONE_5?10:25, 15, 20, 20)];
    setImag.image = [UIImage imageNamed:@"top_icon_set"];
    [setButton addSubview:setImag];
    
    UIImageView* backImag = [[UIImageView alloc] initWithFrame:CGRectMake(IPHONE_5?10:25, 15, 20, 20)];
    backImag.image = [UIImage imageNamed:@"end"];
    [backButton addSubview:backImag];
    
    
}
#pragma mark ------ 下拉刷新
- (void)upRefresh:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //[self requestShowDataList];
        [list_tableView headerEndRefreshing];
    });
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}
- (void)requestShowDataList
{
  
    [popView removeFromSuperview];//释放无用内存
    [groupShowArray removeAllObjects];//清空数组保证真实刷新
    groupShowArray = [[NSMutableArray alloc] init];
    [countArray removeAllObjects];
    countArray = [[NSMutableArray alloc] init];
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETUSERMENUS",@"Action",USERGUID,@"GUID", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/ProxyMobile/MobileFrame.ashx",HTTPIP,SLRD] withParameter:dict];
    manager.delegate = self;
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            for (NSDictionary* dictCount in [[dictt objectForKey:@"Data"] objectForKey:@"R"]) {
                if ([[dictCount objectForKey:@"PARENTID"] isEqualToString:@"-1"]) {
                    [countArray addObject:dictCount];
                }
            }
            
            for (NSInteger index = 0; index < countArray.count; index ++) {
                rowArray = [[NSMutableArray alloc] init];
                [rowArray removeAllObjects];
                for (NSDictionary* group in [[dictt objectForKey:@"Data"] objectForKey:@"R"]) {
                    if ([[group objectForKey:@"PARENTID"] isEqualToString:[[countArray objectAtIndex:index] objectForKey:@"ID"]]) {
                        [rowArray addObject:group];
                    }
                }
                [groupShowArray addObject:[LeftModel initWithAddData:rowArray]];
            }
            [list_tableView reloadData];

            
            }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
        [SVProgressHUD dismiss];
    };
}
#pragma mark ------------------------- 网络环境不可用时的页面
- (void)RequestErrorViewController
{
    [SVProgressHUD dismiss];
    popView = [[UIView alloc] initWithFrame:CGRectMake(0, list_tableView.frame.origin.y, ([UIScreen mainScreen].bounds.size.width-130), list_tableView.frame.size.height)];
    popView.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    UIImageView* imag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 160)];
    imag.center = popView.center;
    imag.image = [UIImage imageNamed:@"02e9868d724dae529e06525edbaf024e.png"];
    [popView addSubview:imag];
    [self.view addSubview:popView];
    UITapGestureRecognizer* regiontapGestureT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestShowDataList)];
    [popView addGestureRecognizer:regiontapGestureT];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)go_back:(UIButton *)sender {
    UIAlertAction* determine = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"passwork"];
        [userDefaults removeObjectForKey:@"login"];
        [UserInfo initWithDeleteUserInfo];
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController* loginVC = [story instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [App window].rootViewController = loginVC;
    }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"小提示" message:@"是否确认退出当前账号" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    [alert addAction:determine];
    [alert addAction:cancel];
}

- (void)setButtonClick:(UIButton *)sender {
    [[App ddMenu] showRootController:NO];
    [App tabBarCtr].selectedIndex = 0;
    if ([self.delegate respondsToSelector:@selector(pushSetViewController)]) {
        [self.delegate pushSetViewController];
    }
}
#pragma mark ------- 表代理
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LeftModel* model = groupShowArray[section];
    //    区头View
    UIView* sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 35)];
    sectionView.backgroundColor = [UIColor whiteColor];
    UILabel* sectionLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 35)];
    sectionLable.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1];
    sectionLable.text = [NSString stringWithFormat:@"      %@",[[countArray objectAtIndex:section] objectForKey:@"MENUNAME"]];
    sectionLable.font = [UIFont systemFontOfSize:14];
    sectionLable.backgroundColor = [UIColor clearColor];
    sectionLable.textAlignment = NSTextAlignmentLeft;
    [sectionView addSubview:sectionLable];
    
    UIImageView *fgiv2 = [[UIImageView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-130)-30, 14, 15, 7)];
    fgiv2.tag = section;
    fgiv2.image = [UIImage imageNamed:@"find_down"];
    if (model.anRow) {
        CGAffineTransform transform= CGAffineTransformMakeRotation(-M_PI/2);
        fgiv2.transform = transform;//旋转
    }
    [sectionView addSubview:fgiv2];
    
    UIImageView* imagViewB = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
    imagViewB.frame = CGRectMake(0, 34, LWidth, 1);
    imagViewB.tag = section+100;
    [sectionLable addSubview:imagViewB];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = section;
    btn.frame = CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width-130), sectionView.frame.size.height);
    [btn addTarget:self action:@selector(sectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:btn];
    
    return sectionView;
}
- (void)sectionButtonClick:(UIButton *)sender
{
    LeftModel* model = groupShowArray[sender.tag];
    model.anRow = !model.anRow;
    [list_tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return countArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    LeftModel* model = groupShowArray[section];
    return model.anRow?model.dataArray.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LeftTableViewCell" owner:nil options:nil];
        for (id oneObject in nib)
        {
            if ([oneObject isKindOfClass:[LeftTableViewCell class]])
            {
                cell = (LeftTableViewCell *)oneObject;
            }
        }
    }
  
    LeftModel* model = groupShowArray[indexPath.section];
    cell.title.text = [model.dataArray[indexPath.row] objectForKey:@"MENUNAME"];
    if (indexPath.row == model.dataArray.count-1 & indexPath.section < countArray.count-1) {
        cell.imagRow.frame = CGRectMake(0, cell.imagRow.frame.origin.y, LWidth, 1);
    }
    cell.taskID = [model.dataArray[indexPath.row] objectForKey:@"ID"];
    cell.gifName = [model.dataArray[indexPath.row] objectForKey:@"GIFNAME"];
    cell.url = [model.dataArray[indexPath.row] objectForKey:@"URL2"];
    UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
    [cell addGestureRecognizer:longPressGesture];
    tableView.rowHeight = 32;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[App ddMenu] showRootController:NO];
    LeftModel* model = groupShowArray[indexPath.section];
    if ([self.delegatePush respondsToSelector:@selector(pushMenuViewController:titleUp:)]) {
        [App tabBarCtr].selectedIndex = 0;
        
            [self.delegatePush pushMenuViewController:[[model.dataArray objectAtIndex:indexPath.row] objectForKey:@"URL3"]titleUp:[[model.dataArray objectAtIndex:indexPath.row] objectForKey:@"MENUNAME"]];
      
        
    }
}
- (void)cellLongPress:(UIGestureRecognizer *)recognizer
{
    LeftTableViewCell *cell = (LeftTableViewCell *)recognizer.view;
    UIAlertAction* determine = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self upQuickMenu:cell];
        if ([self.delegateFunction respondsToSelector:@selector(refreshDataViewController)]) {
            [self.delegateFunction refreshDataViewController];
        }
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"小提示" message:[NSString stringWithFormat:@"是否添加[%@]为快捷方式",cell.title.text] preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    [alert addAction:determine];
    [alert addAction:cancel];
}
- (void)upQuickMenu:(LeftTableViewCell *)cell
{
    [SVProgressHUD showWithStatus:@"请稍后..."];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"ADDSHORTCUT",@"Action",cell.gifName,@"GIFNAME",USERGUID,@"USERGUID",cell.taskID,@"MGUID",USERNAME,@"USERNAME",cell.title.text,@"MNAME",cell.url,@"URL2",cell.url,@"URL2",cell.url,@"URL", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/ProxyMobile/MobileFrame.ashx",HTTPIP,SLRD] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}
@end
