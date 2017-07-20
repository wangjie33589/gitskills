//
//  SecondViewController.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/19.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "equipCheckCell.h"

@interface SecondViewController (){

    NSDictionary *_fromDic;
    NSDictionary  *_XMLDic;
    NSArray *_XmlArray;

}

@end

@implementation SecondViewController
-(id)initWithADic:(NSDictionary *)aDic
{
    self=[super init];
    if (self) {
        _fromDic=aDic;
    }
    
    return self;
    
}



- (void)viewDidLoad {
    self.title=@"工地查询";
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"equipCheckCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    self.tableView.rowHeight=125;
    
    [self requestShowData];
}
-(void)requestShowData{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    
    NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETDEVICEBYCPGUID</Action><USERID>%@</USERID><PWD>%@</PWD><MCODE>%@</MCODE><CPGUID>%@</CPGUID></Data>",USER_NAME,PASSWORD,self.Mcode,_fromDic[@"CPGUID"]];
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlString];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            _XMLDic=[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            _XmlArray=_XMLDic[@"R"];
            [CommonTool saveCooiker];
                      [self.tableView reloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
        
        
    };
    

    


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  }

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _XmlArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    equipCheckCell *cell =[tableView dequeueReusableCellWithIdentifier:@"CELL"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.firstLab.text=[NSString stringWithFormat:@"设备编号:%@",_XmlArray[indexPath.row][@"DID"]];
     cell.secondLab.text=[NSString stringWithFormat:@"设备名称:%@",_XmlArray[indexPath.row][@"PNAME"]];
     cell.ThirdLab.text=[NSString stringWithFormat:@"规格型号:%@",_XmlArray[indexPath.row][@"MODEL"]];
     cell.fourLab.text=[NSString stringWithFormat:@"客户名称:%@",_XmlArray[indexPath.row][@"CNAME"]];
     cell.fiveLab.text=[NSString stringWithFormat:@"所在楼层:%@",_XmlArray[indexPath.row][@"BUILDINGNO"]];
   
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ThirdViewController *vc =[[ThirdViewController alloc]initWithADic:_XmlArray[indexPath.row]];;
    [self.navigationController pushViewController:vc animated:YES];




}


@end
