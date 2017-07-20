//
//  firstViewController.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/19.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "firstViewController.h"
#import "SecondViewController.h"
#import "fourLabViewCell.h"

@interface firstViewController (){

    NSDictionary *_fromDic;
    NSDictionary * _XMLDic;
    NSArray* _XmlArray;

}

@end

@implementation firstViewController
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
    self.title =_fromDic[@"MNAME"];
    [self.tableView registerNib:[UINib nibWithNibName:@"fourLabViewCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    self.tableView.rowHeight=125;
    
   
    [self requestMainInfo];

}
-(void)requestMainInfo{
     [SVProgressHUD showWithStatus:@"努力加载中..."];
    
    NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETCONSTRUCTIONPLANT</Action><USERID>%@</USERID><PWD>%@</PWD><MCODE>%@</MCODE></Data>",USER_NAME,PASSWORD,_fromDic[@"MCODE"]];
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlString];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            _XMLDic=[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            _XmlArray=_XMLDic[@"R"];
              [self.tableView reloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
        
        
    };
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _XmlArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    fourLabViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"CELL"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
        cell.firstLab.text=[NSString stringWithFormat:@"工地名称:%@",[CommonTool cleanNULL:_XmlArray[indexPath.row][@"CPNAME"]]];
  
    cell.secondLab.text=[NSString stringWithFormat:@"工地地址:%@",  [CommonTool cleanNULL:_XmlArray[indexPath.row][@"CPADDR"]]];
    
    
    cell.ThirdLab.text=[NSString stringWithFormat:@"维护人员:%@",[CommonTool cleanNULL:_XmlArray[indexPath.row][@"RPNAME"]]];
    NSLog(@"dfhghjfshjkjdgkljlkjfgkl;dafkshkgh=====%@",[CommonTool cleanNULL:_XmlArray[indexPath.row][@"RPNAME"]]);
   
    cell.fourLab.text=[NSString stringWithFormat:@"联系电话:%@", [CommonTool cleanNULL:_XmlArray[indexPath.row][@"PHONE"]]];
  
    
    
    
    
    return cell;
    

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SecondViewController *vc =[[SecondViewController alloc]initWithADic:_XmlArray[indexPath.row]];
    vc.Mcode=_fromDic[@"MCODE"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
@end
