//
//  KYSettingViewController.m
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/6/18.
//
//

#import "KYSettingViewController.h"
#import "MasterViewController.h"
#import "RendererTableViewController.h"
#import "RenderList_detilVC.h"
#import "KYServiceConfigurationController.h"
#import "GesturesViewController.h"
#import "KYAboutUsViewController.h"
#import "KYPersonalCenterViewCell.h"
#import "KYSetGatewayViewController.h"
@interface KYSettingViewController ()<UITableViewDelegate,UITableViewDataSource>{


    NSMutableArray *_titlwArray;
    NSMutableArray *_ImageArray;
    NSString *str;
    NSString *str1;
    NSString *str2;


}

@end

@implementation KYSettingViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSLog(@"http=================%@",HTTPIP);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设置";

    [self initTableView];
    self.view.backgroundColor = [UIColor redColor];
    _myTable.scrollEnabled =NO; //设置tableview 不能滚动
      self.myTable.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _titlwArray = [NSMutableArray arrayWithArray:@[@"服务器优先设置",@"同步时间",@"网关设置",@"音箱管理",@"手势密码",@"关于我们"]];
    _ImageArray =[NSMutableArray arrayWithArray:@[@"setting_icon_server",@"main_navi_sence_normal",@"setting_icon_confirm",@"setup_music",@"setting_icon_gesture",@"setting_icon_check"]];
    
    
    
    [self gettime];
}


-(void)initTableView{

    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    self.myTable.rowHeight=50;
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
     [self.myTable registerNib:[UINib nibWithNibName:@"KYPersonalCenterViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];



}


- (void)gettime{
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10901\",\"actuserid\":\"%@\",\"serverid\":\"%@\"}",USER_ID,SERVERID];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            
            str=dictt[@"DATA"];
            str2 = str;
            NSLog(@"%@---9",dictt[@"DATA"]);
            [self.myTable reloadData];
            
        }
    };

}

- (void)regettime{
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10902\",\"timestr\":\"%@\",\"actuserid\":\"%@\",\"serverid\":\"%@\"}",str,USER_ID,SERVERID];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            [self gettime];
            [SVProgressHUD showSuccessWithStatus:@"刷新成功"];
            
            [self.myTable reloadData];
            
        }
    };
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

//    return  section==2?2:1;
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    KYPersonalCenterViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.lab1.text=_titlwArray[indexPath.row];
    [cell.image1 setImage:[UIImage imageNamed:_ImageArray[indexPath.row]]];
    if (indexPath.row ==1) {
        cell.lab2.text = str2;
    }
    return cell;



}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        if (indexPath.row==0) {
            KYServiceConfigurationController *vc =[[KYServiceConfigurationController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    if (indexPath.row ==1) {
        [self regettime];
    }
        if (indexPath.row==2) {
            KYSetGatewayViewController *vc = [[KYSetGatewayViewController alloc]init];
            vc.type=1;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row==3) {
            RenderList_detilVC* viewController =[[RenderList_detilVC alloc]initWithAvController:self.avController];
            self.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:viewController animated:YES];
            }
        if (indexPath.row==4) {
            GesturesViewController  *vc =[[GesturesViewController  alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        
        }
        if (indexPath.row==5) {
            KYAboutUsViewController  *vc =[[KYAboutUsViewController  alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }


}


@end
