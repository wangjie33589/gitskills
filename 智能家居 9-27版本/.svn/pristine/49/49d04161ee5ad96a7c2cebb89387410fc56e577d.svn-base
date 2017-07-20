//
//  KYuser_manger_ViewController.m
//  SyncSmartHome
//
//  Created by SciyonSoft_WangJie on 16/5/26.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "KYuser_manger_ViewController.h"
#import "KYmangerTableViewCell.h"
#import "adduserViewController.h"
#import "MJRefresh.h"
#import "modifyRowViewController.h"
#import "MBProgressHUD+MJ.h"
@interface KYuser_manger_ViewController ()<UITableViewDelegate,UITableViewDataSource>{

    NSMutableArray *showArray;
    NSInteger startIndex;
    
    NSMutableArray *haverole;
    NSMutableArray *haverole2;
}
@property (strong, nonatomic) IBOutlet UITableView *myTable;

@end

@implementation KYuser_manger_ViewController


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    haverole = [NSMutableArray array];
    haverole2 = [NSMutableArray array];
    [self requestShowData];
    [self.myTable reloadData];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"用户管理";
    self.tabBarController.tabBar.hidden=YES;

    [self initTableView];
    startIndex =1;
    UIBarButtonItem *rightBtn =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    
    [self.view addSubview:self.myTable];
    [self.myTable addHeaderWithTarget:self action:@selector(upRefresh:)];
    [self.myTable addFooterWithTarget:self action:@selector(downRefresh:)];
    [self requestShowData];

//    _dataArray = [NSMutableArray arrayWithArray:_showArray];
    [self.myTable reloadData];
}

#pragma mark ------ 下拉刷新
- (void)upRefresh:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestShowData];
        startIndex =1;
        [self.myTable headerEndRefreshing];
    });
}
#pragma mark ------ 上拉加载
- (void)downRefresh:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestShowDataRefresh];
        [_myTable footerEndRefreshing];
    });
}



-(void)rightBtnClick{
    adduserViewController *vc =[[adduserViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
   self.hidesBottomBarWhenPushed=YES;
}

-(void)requestShowData{
    NSLog(@"%@---000",SERVERID);
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10201\",\"serverid\":\"%@\",\"pageno\":\"1\",\"pagesize\":\"10\"}",SERVERID];
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    NSLog(@"manager--%@",manager);
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        if ([[dictt objectForKey:@"SS"] integerValue]==200) {
            showArray = [NSMutableArray arrayWithArray:dictt[@"DATA"]];
            [self.myTable reloadData];
           

        }
    };
}

- (void)requestShowDataRefresh{
    
            startIndex = startIndex + 2;
    NSString *pageStr = [NSString stringWithFormat:@"%d",startIndex];
//    NSString *pageStr = [NSString stringWithFormat:@"%d",startIndex];
    NSLog(@"%@--%d---666",SERVERID,startIndex);
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10201\",\"serverid\":\"%@\",\"pageno\":\"%@\"}",SERVERID,pageStr];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    NSLog(@"dict======%@",dict);
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    // manager.delegate = self;
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        if ([[dictt objectForKey:@"SS"] integerValue]==200) {
            NSMutableArray *array =dictt[@"DATA"];
            NSLog(@"%d---123456789---",showArray.count);
            if (array.count < 5) {
                [SVProgressHUD showSuccessWithStatus:@"加载到底了"];
                for (NSUInteger i = 0; i < array.count; i ++) {
                    [showArray addObject:[array objectAtIndex:i]];
                }
                [self.myTable reloadData];
            }else{
                for (NSUInteger i = 0; i < array.count; i ++) {
                    [showArray addObject:[array objectAtIndex:i]];
                }
            [self.myTable reloadData];

            }  }
    };
}


-(void)initTableView{
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    self.myTable.rowHeight=60;

//  self.myTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//     _myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTable registerNib:[UINib nibWithNibName:@"KYmangerTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return showArray.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    KYmangerTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
         cell = [[[NSBundle mainBundle] loadNibNamed:@"KYmangerTableViewCell" owner:self options:nil] lastObject];
    }
    cell.imageview.layer.masksToBounds = YES;
    cell.imageview.layer.cornerRadius = 27;

    if (![showArray[indexPath.row][@"user"][@"username"] isKindOfClass:[NSNull class]]) {
        cell.firstLab.text=showArray[indexPath.row][@"user"][@"username"];
        cell.firstLab.textColor = [UIColor blackColor];
    }
    
    if (![showArray[indexPath.row][@"user"][@"usercode"] isKindOfClass:[NSNull class]]) {
        cell.secondLab.text = showArray[indexPath.row][@"user"][@"usercode"];
        cell.secondLab.textColor = [UIColor blackColor];
    }
    if (![showArray[indexPath.row][@"user"][@"userimg"] isKindOfClass:[NSNull class]]) {
        
      
        [cell.imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@%@",HTTPIP,IMAGE_URL,showArray[indexPath.row][@"user"][@"userimg"]]] placeholderImage:[UIImage imageNamed:@"10-1-角色管理-_03"]];
    }
    
    if ([showArray[indexPath.row][@"user"][@"userstatus"] isKindOfClass:[NSNull class]]) {
        [cell.indicateImage setImage:[UIImage imageNamed:@"user_user_mng_disable"]];
        cell.online.text = @"离线";
    }
    
    if (![showArray[indexPath.row][@"user"][@"userstatus"] isKindOfClass:[NSNull class]]) {
        if ([showArray[indexPath.row][@"user"][@"userstatus"] isEqualToString:@"1"]) {
            [cell.indicateImage setImage:[UIImage imageNamed:@"user_user_mng_online"]];
            cell.online.text = @"在线";
//            cell.online.textColor = [UIColor greenColor];
        }else if ([showArray[indexPath.row][@"user"][@"userstatus"] isEqualToString:@"2"]) {
            [cell.indicateImage setImage:[UIImage imageNamed:@"user_user_mng_disable"]];
            cell.online.text = @"离线";
        }else if ([showArray[indexPath.row][@"user"][@"userstatus"] isEqualToString:@"3"]) {
            [cell.indicateImage setImage:[UIImage imageNamed:@"user_user_mng_offline"]];
            cell.online.text = @"禁用";
//            cell.online.textColor = [UIColor orangeColor];
        }
    }

  
    return cell;
}




- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"这是删除操作--%@",showArray[indexPath.row][@"user"][@"id"]);
        NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
        NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10205\",\"userid\":\"%@\"}",showArray[indexPath.row][@"user"][@"id"]];
        NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
        NSLog(@"dict======%@",dict);
        MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
        manager.backSuccess = ^void(NSDictionary *dictt)
        {
            if ([[dictt objectForKey:@"SS"] integerValue]==200) {
                
                [self requestShowData];
                [self.myTable reloadData];
            }
        };

       [self.myTable reloadData];
        

        
        
    }];
    
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"下线" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        
        NSLog(@"这是下线操作--%@",showArray[indexPath.row][@"user"][@"id"]);
        NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
        NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10210\",\"userid\":\"%@\",\"userstatus\":\"%@\",\"actuserid\":\"%@\"}",showArray[indexPath.row][@"user"][@"id"],@"2",USER_ID];
        NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
        NSLog(@"dict======%@",dict);
        MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
        manager.backSuccess = ^void(NSDictionary *dictt)
        {
            if ([[dictt objectForKey:@"SS"] integerValue]==200) {
                
                [self requestShowData];
                [self.myTable reloadData];
            }
        };
        
        [self.myTable reloadData];
        
        
        
    }];
    
    topRowAction.backgroundColor = [UIColor blueColor];
    
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"禁用" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"这是禁用操作--%@",showArray[indexPath.row][@"user"][@"id"]);
        NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
        NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10211\",\"userid\":\"%@\",\"userstatus\":\"%@\",\"actuserid\":\"%@\"}",showArray[indexPath.row][@"user"][@"id"],@"3",USER_ID];
        NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
        NSLog(@"dict======%@",dict);
        MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
        manager.backSuccess = ^void(NSDictionary *dictt)
        {
            if ([[dictt objectForKey:@"SS"] integerValue]==200) {
              [SVProgressHUD showSuccessWithStatus:dictt[@"MSG"]];
                [self requestShowData];
                [self.myTable reloadData];
            }
            
        };
    
        [self.myTable reloadData];

        
    }];

    return @[deleteRoWAction,topRowAction,moreRowAction];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![showArray[indexPath.row][@"user"][@"id"] isKindOfClass:[NSNull class]]) {
        [[NSUserDefaults standardUserDefaults]setValue:showArray[indexPath.row][@"user"][@"id"] forKey:@"userids"];
    }
    if (![showArray[indexPath.row][@"user"][@"usercode"]  isKindOfClass:[NSNull class]]) {
       [[NSUserDefaults standardUserDefaults]setValue:showArray[indexPath.row][@"user"][@"usercode"] forKey:@"currentusercode"];
    }
    if (![showArray[indexPath.row][@"user"][@"username"]  isKindOfClass:[NSNull class]]) {
        [[NSUserDefaults standardUserDefaults]setValue:showArray[indexPath.row][@"user"][@"username"] forKey:@"reviseusername"];
    }
    if (![showArray[indexPath.row][@"user"][@"phonenumber"]   isKindOfClass:[NSNull class]]) {
         [[NSUserDefaults standardUserDefaults]setValue:showArray[indexPath.row][@"user"][@"phonenumber"] forKey:@"userphonenumber"];
    }
   
   
//      NSLog(@"%@-----0000001",showArray[indexPath.row][@"user"][@"id"]);
//      NSLog(@"%@--%@--%@-0000002",showArray[indexPath.row][@"user"][@"usercode"],showArray[indexPath.row][@"user"][@"username"],showArray[indexPath.row][@"user"][@"phonenumber"]);
//    NSLog(@"选中该用户所拥有的角色---%@",showArray[indexPath.row][@"role"]);
 
    haverole = [NSMutableArray arrayWithArray:showArray[indexPath.row][@"role"]];
    for (int i = 0; i<haverole.count; i++) {
        [haverole2 addObject:haverole[i][@"rolename"]];
    }
    NSLog(@"选中该用户所拥有的角色名数组---%@",haverole);
     NSString *selnamestring=[haverole2 componentsJoinedByString:@","];
    NSLog(@"选中该用户所拥有的角色名字符串---%@",selnamestring);
    modifyRowViewController *vc = [[modifyRowViewController alloc]initWithUserRoleIds:selnamestring];
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSMutableArray *)deleteData
{
    if (showArray == nil) {
        showArray = [NSMutableArray array];
    }
    return showArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
