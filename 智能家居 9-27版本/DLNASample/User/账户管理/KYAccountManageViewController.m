//
//  KYAccountManageViewController.m
//  SyncSmartHome
//
//  Created by sciyonSoft on 16/5/10.
//  Copyright © 2016年 sciyonSoft. All rights reserved.


#import "KYAccountManageViewController.h"
#import "KY_role_manger_ViewController.h"
#import "KYuser_manger_Viewcontroller.h"
#import "KYPersonalCenterViewCell.h"
@interface KYAccountManageViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_titArray;
    NSArray *_imgNameArray;

}

@property (nonatomic, strong)NSMutableArray *dataList;
@end

@implementation KYAccountManageViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"账户管理";
    self.tabBarController.tabBar.hidden=YES;
    self.myTable.backgroundColor = [UIColor groupTableViewBackgroundColor];

    [self initTableView];
    _titArray=[[NSArray alloc]initWithObjects:@"用户管理", @"角色管理",nil];
    _imgNameArray =[[NSArray alloc]initWithObjects:@"user_user.png",@"user_role.png", nil];
}

-(void)initTableView{

    self.myTable.dataSource=self;
    self.myTable.delegate=self;
       _myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTable.scrollEnabled=NO;
    self.myTable.rowHeight=50;
    [self.myTable registerNib:[UINib nibWithNibName:@"KYPersonalCenterViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];


}
#pragma mark====UItableViewDatasource UItableviewDelegte
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titArray.count;


}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  KYPersonalCenterViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

   // cell.image1.image=[UIImage imageNamed:_imgNameArray[indexPath.row]];
    cell.lab1.text=_titArray[indexPath.row];
    [cell.image1 setImage:[UIImage imageNamed:_imgNameArray[indexPath.row]]];
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        self.hidesBottomBarWhenPushed=YES;
        KYuser_manger_ViewController *vc =[[KYuser_manger_ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed=YES;
           }else{
               self.hidesBottomBarWhenPushed=YES;
               KY_role_manger_ViewController *vc1 =[[KY_role_manger_ViewController alloc]init];
               [self.navigationController pushViewController:vc1 animated:YES];
               self.hidesBottomBarWhenPushed=YES;

    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
