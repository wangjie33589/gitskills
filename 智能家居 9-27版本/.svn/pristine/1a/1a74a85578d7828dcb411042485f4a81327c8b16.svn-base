//
//  TypeDetilViewController.m
//  SyncSmartHome
//
//  Created by SciyonSoft_WangJie on 16/5/10.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "TypeDetilViewController.h"
#import "CollectionViewCell.h"
#import "DeviceTableViewCell.h"
#import "TppeDetil_twoViewController.h"
#import "TypeDetilTableViewCell.h"

@interface TypeDetilViewController ()<UITableViewDelegate,UITableViewDataSource>{
   // NSArray *_titleArray;
    NSDictionary *_fromDic;
    NSArray *_showArray;
    
}

@end

@implementation TypeDetilViewController
-(id)initWithDic:(NSDictionary*)aDic{

    self =[super init];
    if (self) {
        _fromDic =aDic;
        
        
        NSLog(@"fromDic======%@",_fromDic);
        
        
    }

    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestShowData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设备";
    [SVProgressHUD showWithStatus:@"努力加载中。。。"];
    
  
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    [self.myTable registerNib:[UINib nibWithNibName:@"TypeDetilTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
   
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return  _showArray.count;
  
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TypeDetilTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
//    cell.img.image=[UIImage imageNamed:@"2"];
//    cell.firstLab.text=_titleArray[indexPath.row];
//    cell.secondLab.text=[NSString stringWithFormat:@"六键开关      大厅"];
//    ／／lamp_on lamp_off
    cell.titleLab.text=_showArray[indexPath.row][@"devicename"];
    
    if ([_showArray[indexPath.row][@"status"]integerValue]==0) {
        cell.imgView.image=[UIImage imageNamed:@"lamp_on"];
    }else{
    cell.imgView.image=[UIImage imageNamed:@"lamp_off"];
    }
    NSString *earname;
    if ([_showArray[indexPath.row][@"areaname"] isKindOfClass:[NSNull class]]) {
        earname=@"未分区";
    }else{
    
    earname=_showArray[indexPath.row][@"areaname"];
    
    }

    cell.rightlab.text =[NSString stringWithFormat:@"%@  %@  ",_showArray[indexPath.row][@"typename"],earname];
    
       
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TppeDetil_twoViewController *vc =[[TppeDetil_twoViewController alloc]initWithDic:_showArray[indexPath.row] andArr:_showArray];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
   



}
//请求设备面板相应数据

-(void)requestShowData{
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    
    //NSLog(@"urlstrin=[==%@",urlstring);
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10405\",\"serverid\":\"%@\",\"typeid\":\"%@\",\"userid\":\"%@\",\"isadmin\":\"1\"}",SERVERID,_fromDic[@"id"],USER_ID];
    

    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
       
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            //_AreaArray=dictt[@"DATA"];
            _showArray=dictt[@"DATA"];
            //NSLog(@"_AreaArray====%@",_AreaArray);
            
            
            [self.myTable reloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };



}


@end
