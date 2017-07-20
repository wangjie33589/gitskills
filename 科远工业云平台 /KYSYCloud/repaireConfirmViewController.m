//
//  repaireConfirmViewController.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/19.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "repaireConfirmViewController.h"
#import "SevenViewCell.h"
#import "equipCheckCell.h"
#import "ADD_VC.h"

@interface repaireConfirmViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSDictionary *  _fromDic;
NSMutableDictionary  *  _XMLDic;
NSMutableArray *  _XmlArray;
   NSMutableDictionary *_showDic;
    NSDictionary *_detilDic;
}

@end

@implementation repaireConfirmViewController
-(id)initWithADic:(NSDictionary *)aDic
{
    self=[super init];
    if (self) {
        _fromDic=aDic;
        
        
        NSLog(@"_reom adicv===%@",_fromDic);
    }
    
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_fromDic[@"MNAME"];

    self.segControl.selectedSegmentIndex=0;
      NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETDEVICEREPAIR</Action><USERID>%@</USERID><PWD>%@</PWD><MCODE>%@</MCODE><DGUID>%@</DGUID><STATE>1</STATE></Data>",USER_NAME,PASSWORD,_fromDic[@"MCODE"],@""];
    self.segControl.selectedSegmentIndex=0;
    [self requestRepaireConfimInfoWithXmlStr:xmlString];
    [self inittabeview];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.segControl.selectedSegmentIndex=0;
    NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETDEVICEREPAIR</Action><USERID>%@</USERID><PWD>%@</PWD><MCODE>%@</MCODE><DGUID>%@</DGUID><STATE>1</STATE></Data>",USER_NAME,PASSWORD,_fromDic[@"MCODE"],@""];
    self.segControl.selectedSegmentIndex=0;
    [self requestRepaireConfimInfoWithXmlStr:xmlString];
    [self inittabeview];

}





-(void)inittabeview{
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    [self.myTable registerNib:[UINib nibWithNibName:@"SevenViewCell" bundle:nil] forCellReuseIdentifier:@"sevenCell"];
    [self.myTable registerNib:[UINib nibWithNibName:@"equipCheckCell" bundle:nil] forCellReuseIdentifier:@"fivecell"];
    }


-(void)requestRepaireConfimInfoWithXmlStr:(NSString*)xmlstr{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    [_XMLDic removeAllObjects];
    [_showDic removeAllObjects];
    [_XmlArray removeAllObjects];
    [self.myTable reloadData];
  
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlstr];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            _XMLDic=(NSMutableDictionary*)[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
                _showDic=_XMLDic[@"R"];
            }else if ([_XMLDic[@"R"] isKindOfClass:[NSArray class]]){
                _XmlArray =_XMLDic[@"R"];
                
            }
            
            NSLog(@"+++++++++++++++=%@",_XMLDic);
                 [self.myTable reloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
        
        
    };
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
        return 1;
    }else{
        return _XmlArray.count;
    
        
    }




}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.segControl.selectedSegmentIndex==0) {
      return  175;
        
    }else{
       return  125;
        
        
    }






}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.segControl.selectedSegmentIndex==0) {
        SevenViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"sevenCell"];
        if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
            cell.firstLab.text=[NSString stringWithFormat:@"设备编号:%@",_showDic[@"DID"]];
            cell.secondLab.text=[NSString stringWithFormat:@"客户名称:%@",_showDic[@"CNAME"]];
            cell.thirdlab.text=[NSString stringWithFormat:@"故障名称:%@",_showDic[@"ERRNAME"]];
            cell.fourLab.text=[NSString stringWithFormat:@"故障现象:%@",_showDic[@"ERRDESC"]];
            cell.fivelab.text=[NSString stringWithFormat:@"故障原因:%@",_showDic[@"REASON"]];
            cell.sixlab.text=[NSString stringWithFormat:@"处理人员:%@",_showDic[@"OPERATOR"]];
            cell.sevenLab.text=[NSString stringWithFormat:@"处理时间:%@",[CommonTool DataFormart:_showDic[@"OPERATEDATE"]]];
            
        }else{
            cell.firstLab.text=[NSString stringWithFormat:@"设备编号:%@",_XmlArray[indexPath.row][@"DID"]];
            cell.secondLab.text=[NSString stringWithFormat:@"客户名称:%@",_XmlArray[indexPath.row][@"CNAME"]];
            cell.thirdlab.text=[NSString stringWithFormat:@"故障名称:%@",_XmlArray[indexPath.row][@"ERRNAME"]];
            cell.fourLab.text=[NSString stringWithFormat:@"故障现象:%@",_XmlArray[indexPath.row][@"ERRDESC"]];
            cell.fivelab.text=[NSString stringWithFormat:@"故障原因:%@",_XmlArray[indexPath.row][@"REASON"]];
            cell.sixlab.text=[NSString stringWithFormat:@"处理人员:%@",_XmlArray[indexPath.row][@"OPERATOR"]];
            cell.sevenLab.text=[NSString stringWithFormat:@"处理时间:%@",[CommonTool DataFormart:_XmlArray[indexPath.row][@"OPERATEDATE"]]];
            
        
        
        }
        
        
        
        
        
        return cell;
        

    }else{
    
        
        equipCheckCell *cell =[tableView dequeueReusableCellWithIdentifier:@"fivecell"];
        if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
            cell.firstLab.text=[NSString stringWithFormat:@"设备编号:%@",_showDic[@"DID"]];
            cell.secondLab.text=[NSString stringWithFormat:@"客户名称:%@",_showDic[@"CNAME"]];
            cell.ThirdLab.text=[NSString stringWithFormat:@"保养名称:%@",_showDic[@"MINAME"]];
            cell.fourLab.text=[NSString stringWithFormat:@"处理人员:%@",_showDic[@"PERSONNAME"]];
            cell.fiveLab.text=[NSString stringWithFormat:@"处理时间:%@",[CommonTool daFormatByComment:_showDic[@"SERVICETIME"]]];
            
            
            
        }else if(self.segControl.selectedSegmentIndex==1){
            cell.firstLab.text=[NSString stringWithFormat:@"设备编号:%@",_XmlArray[indexPath.row][@"DID"]];
            cell.secondLab.text=[NSString stringWithFormat:@"客户名称:%@",_XmlArray[indexPath.row][@"CNAME"]];
            cell.ThirdLab.text=[NSString stringWithFormat:@"保养名称:%@",_XmlArray[indexPath.row][@"MINAME"]];
            cell.fourLab.text=[NSString stringWithFormat:@"处理人员:%@",_XmlArray[indexPath.row][@"PERSONNAME"]];
            cell.fiveLab.text=[NSString stringWithFormat:@"处理时间:%@",[CommonTool daFormatByComment:_showDic[@"SERVICETIME"]]];
        }
           return cell;
    
    }
}

//页面跳转;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (self.segControl.selectedSegmentIndex) {
        case 0:
        {
            
            if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
                ADD_VC *vc =[[ADD_VC alloc]initWithADic:_showDic withTitle:@"维保确认"];
                vc.type=1;
                vc.Mcode=_fromDic[@"MCODE"];
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([_XMLDic[@"R"] isKindOfClass:[NSArray class]]){
                ADD_VC *vc =[[ADD_VC alloc]initWithADic:_XmlArray[indexPath.row] withTitle:@"维保确认"];
                  vc.type=1;
                [self.navigationController pushViewController:vc animated:YES];
            }

       
        
        }
            break;
            
        default:{
            
            if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
                
                [self requestKeepDetileInfoWithASGUID:_showDic[@"ASGUID"]];
               
            }else{
                [self requestKeepDetileInfoWithASGUID:_XmlArray[indexPath.row][@"ASGUID"]];
                
            }
            

        
        
        
        }
            break;
    }



  


}
-(void)requestKeepDetileInfoWithASGUID:(NSString*)ASGIID{
    
 NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETASDETAIL</Action><USERID>%@</USERID><PWD>%@</PWD><ASGUID>%@</ASGUID></Data>",USER_NAME,PASSWORD,ASGIID];
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlString];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            _detilDic=[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            NSLog(@"detilduc====%@",_detilDic[@"R"]);
            [self initAlertControllerWithMassger:_detilDic[@"R"][@"REMARK"]];
            
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
        
        
    };







}
-(void)initAlertControllerWithMassger:(NSString*)meassge{
    
    UIAlertController *alertcontroller =[UIAlertController alertControllerWithTitle:@"月维护" message:meassge preferredStyle:  UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm =[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确认");
        
    }];
    UIAlertAction *back =[UIAlertAction actionWithTitle:@"驳回" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"驳回");
        
    }];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
        
    }];
    [alertcontroller addAction:confirm];
    [alertcontroller addAction:back];
    [alertcontroller addAction:cancel];

   
    [self presentViewController:alertcontroller animated:YES completion:nil];








}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)segChange:(UISegmentedControl *)sender {
    
    
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            
            NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETDEVICEREPAIR</Action><USERID>%@</USERID><PWD>%@</PWD><MCODE>%@</MCODE><DGUID>%@</DGUID><STATE>1</STATE></Data>",USER_NAME,PASSWORD,_fromDic[@"MCODE"],@""];
            [self requestRepaireConfimInfoWithXmlStr:xmlString];

        
        }
            break;
            
        default:{
            
            NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETMAINTAINDISPOSED</Action><USERID>%@</USERID><PWD>%@</PWD><MCODE>%@</MCODE><DID>%@</DID><CNAME>%@</CNAME><STATE>1</STATE></Data>",USER_NAME,PASSWORD,_fromDic[@"MCODE"],@"",@""];
            [self requestRepaireConfimInfoWithXmlStr:xmlString];

        
        
        
        
        }
            break;
    }
    
}
@end
