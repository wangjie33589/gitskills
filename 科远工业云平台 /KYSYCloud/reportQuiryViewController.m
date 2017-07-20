//
//  reportQuiryViewController.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/19.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "reportQuiryViewController.h"
#import "equipCheckCell.h"
#import "regist_Two_ViewController.h"

@interface reportQuiryViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSDictionary * _fromDic;
  
    NSMutableDictionary *  _XMLDic;
    NSMutableArray * _XmlArray;
  NSMutableDictionary *_showDic;
     NSInteger state;
    
}

@end

@implementation reportQuiryViewController
-(id)initWithADic:(NSDictionary *)aDic
{
    self=[super init];
    if (self) {
        _fromDic=aDic;
    }
    
    return self;
    
}
-(void)initView{
    self.mySeg.selectedSegmentIndex=0;
    state=0;
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    self.myTable.rowHeight=125;
    [self.myTable registerNib:[UINib nibWithNibName:@"equipCheckCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    [self requestshowData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
        return 1;
    }else if ([_XMLDic[@"R"] isKindOfClass:[NSArray class]]){
        return _XmlArray.count;
          }else{
        return 0;
               
    }
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    equipCheckCell *cell =[tableView dequeueReusableCellWithIdentifier:@"CELL"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
        cell.firstLab.text=[NSString stringWithFormat:@"登记时间: %@",[CommonTool DataFormart:_showDic[@"OPERATEDATE"]]];
        cell.secondLab.text=[NSString stringWithFormat:@"设备编号: %@",_showDic[@"DID"]];
        cell.ThirdLab.text=[NSString stringWithFormat:@"客户名称: %@",_showDic[@"CNAME"]];
        cell.fourLab.text=[NSString stringWithFormat:@"报修内容: %@",_showDic[@"CONTENT"]];
        cell.fiveLab.text=[NSString stringWithFormat:@"联系方式: %@",[CommonTool daFormatByComment:_showDic[@"PHONE"]]];
        
        
    }else if ([_XMLDic[@"R"] isKindOfClass:[NSArray class]]){
        cell.firstLab.text=[NSString stringWithFormat:@"登记时间: %@",[CommonTool DataFormart:_XmlArray[indexPath.row][@"OPERATEDATE"]]];
        cell.secondLab.text=[NSString stringWithFormat:@"设备编号: %@",_XmlArray[indexPath.row][@"DID"]];
        cell.ThirdLab.text=[NSString stringWithFormat:@"客户名称: %@",_XmlArray[indexPath.row][@"CNAME"]];
        cell.fourLab.text=[NSString stringWithFormat:@"报修内容: %@",_XmlArray[indexPath.row][@"CONTENT"]];
        cell.fiveLab.text=[NSString stringWithFormat:@"联系方式: %@",[CommonTool daFormatByComment:_XmlArray[indexPath.row][@"PHONE"]]];
        
    }else{
        }
    
    return  cell;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_fromDic[@"MNAME"];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   }

- (IBAction)segclick:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            state=0;
            
        }
            break;
        case 1:{
            state=2;
            
        }break;
        case 2:{
            state=3;
            
            
        }break;
    }
    
    
    [self requestshowData];
    

}
-(void)requestshowData{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
  
    [_XMLDic removeAllObjects];
    [_XmlArray removeAllObjects];
    [_showDic removeAllObjects];
    [self.myTable reloadData];

          NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETREPAIRRECORD</Action><LISTFLAG>0</LISTFLAG><USERID>%@</USERID><PWD>%@</PWD><STATE>%ld</STATE></Data>",USER_NAME,PASSWORD,state];
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlString];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
             _XMLDic=(NSMutableDictionary*)[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            
            if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
                _showDic=_XMLDic[@"R"];
                    [self.myTable reloadData];
               }else if ([_XMLDic[@"R"] isKindOfClass:[NSArray class]]){
                     _XmlArray=_XMLDic[@"R"];
                [self.myTable reloadData];
                }
        }else{
            
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
      };
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
        regist_Two_ViewController *vc =[[regist_Two_ViewController alloc]initWithADic:_showDic withTitle:@"报修查询"];
        [self.navigationController pushViewController:vc animated:YES];
        

        
    }else if ([_XMLDic[@"R"] isKindOfClass:[NSArray class]]){
        regist_Two_ViewController *vc =[[regist_Two_ViewController alloc]initWithADic:_XmlArray[indexPath.row] withTitle:@"报修查询"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }

}


@end
