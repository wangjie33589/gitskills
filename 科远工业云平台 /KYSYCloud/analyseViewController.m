//
//  analyseViewController.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/20.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "analyseViewController.h"
#import "OneLabCell.h"
#import "analyse_two_ViewController.h"

@interface analyseViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSDictionary *_fromDic;
    NSArray *_titleArray;
    NSArray *_urlArray;



}

@end

@implementation analyseViewController
-(id)initWithADic:(NSDictionary *)aDic
{
    self=[super init];
    if (self) {
        _fromDic=aDic;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_fromDic[@"MNAME"];
    _titleArray =[[NSArray alloc]initWithObjects:@"设备年龄", @"设备在线率", @"客户设备平均年限", @"产品总销量排行", @"客户总销量排行", @"设备在线周报", @"设备故障分析", @"近两年产品销量趋势", nil];
    _urlArray=[[NSArray alloc]initWithObjects:@"C0004",@"C0010",@"C0007",@"C0001",@"C0006",@"C0009",@"C0011",@"C0003", nil];
    [self initTableview];
    
    

}
-(void)initTableview{
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    [self.myTable registerNib:[UINib nibWithNibName:@"OneLabCell" bundle:nil] forCellReuseIdentifier:@"ONECELL"];


}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 8;
    

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OneLabCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ONECELL"];
    cell.label.text=_titleArray[indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    analyse_two_ViewController *vc =[[analyse_two_ViewController alloc]initWithTitle:_titleArray[indexPath.row] withUrl:_urlArray[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
