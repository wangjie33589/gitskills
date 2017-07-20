//
//  Maintain_detil_VC.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/3/9.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "Maintain_detil_VC.h"
#import "equipCheckCell.h"
#import "SevenViewCell.h"
#import "ADD_VC.h"


@interface Maintain_detil_VC ()<UITableViewDelegate,UITableViewDataSource>{
    NSDictionary *_fromDic;
    NSMutableDictionary *  _XMLDic;
    NSMutableArray * _XmlArray;
    NSMutableDictionary *_showDic;
    NSInteger state;
    NSDictionary *_detilDic;
    
}

@end

@implementation Maintain_detil_VC
-(id)initWithDic:(NSDictionary *)aDic{
    self =[super init];
    
    if (self) {
        _fromDic=aDic;
        
        
        
        NSLog(@"asfadshjgvdsfvsdfjkhv====%@",_fromDic);
    }

    return self;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"维修登记";
    self.mySeg.selectedSegmentIndex=0;
      self.mySeg.selectedSegmentIndex=0;
    [self requestRepaireConfimInfoWithXmlStr];
    [self inittabeview];


  
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.myTable reloadData];



}
-(void)inittabeview{
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    [self.myTable registerNib:[UINib nibWithNibName:@"SevenViewCell" bundle:nil] forCellReuseIdentifier:@"sevenCell"];
    [self.myTable registerNib:[UINib nibWithNibName:@"equipCheckCell" bundle:nil] forCellReuseIdentifier:@"fivecell"];
}


-(void)requestRepaireConfimInfoWithXmlStr{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    [_XmlArray removeAllObjects];
    [_showDic removeAllObjects];
    [_XMLDic removeAllObjects];
    [self.myTable reloadData];
    NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETDEVICEREPAIR</Action><USERID>%@</USERID><PWD>%@</PWD><MCODE>%@</MCODE><DGUID>%@</DGUID><STATE>%ld</STATE></Data>",USER_NAME,PASSWORD,self.Mcode,_fromDic[@"DGUID"],self.mySeg.selectedSegmentIndex+1];

    
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlString];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            
            
            _XMLDic=(NSMutableDictionary*)[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            
            
            NSLog(@"xml====%@",_XMLDic);
            [CommonTool saveCooiker];
            
            
            if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
                _showDic=_XMLDic[@"R"];
            }else if ([_XMLDic[@"R"] isKindOfClass:[NSArray class]]){
                _XmlArray =_XMLDic[@"R"];
                
                
            }
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
    
    
        return  175;
        
    
    
    
    
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SevenViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"sevenCell"];
    

    
    if (self.mySeg.selectedSegmentIndex==0) {
       
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
        
        
        
        
        
        //return cell;
        
        
    }else if(self.mySeg.selectedSegmentIndex==1){
        
        
              if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
            cell.firstLab.text=[NSString stringWithFormat:@"设备编号:%@",_showDic[@"DID"]];
            cell.secondLab.text=[NSString stringWithFormat:@"客户名称:%@",_showDic[@"CNAME"]];
            cell.thirdlab.text=[NSString stringWithFormat:@"故障名称:%@",_showDic[@"ERRNAME"]];
            cell.fourLab.text=[NSString stringWithFormat:@"故障现象:%@",_showDic[@"ERRDESC"]];
            cell.fivelab.text=[NSString stringWithFormat:@"故障原因:%@",_showDic[@"REASON"]];
            cell.fourLab.text=[NSString stringWithFormat:@"处理人员:%@",_showDic[@"OPERATOR"]];
            cell.fivelab.text=[NSString stringWithFormat:@"确认人员:%@",_showDic[@"VERIFIER"]];
            
            
            
        }else{
            cell.firstLab.text=[NSString stringWithFormat:@"设备编号:%@",_XmlArray[indexPath.row][@"DID"]];
            cell.secondLab.text=[NSString stringWithFormat:@"客户名称:%@",_XmlArray[indexPath.row][@"CNAME"]];
            cell.thirdlab.text=[NSString stringWithFormat:@"故障名称:%@",_XmlArray[indexPath.row][@"ERRNAME"]];
            cell.fourLab.text=[NSString stringWithFormat:@"故障现象:%@",_XmlArray[indexPath.row][@"ERRDESC"]];
            cell.fivelab.text=[NSString stringWithFormat:@"故障原因:%@",_XmlArray[indexPath.row][@"REASON"]];
            cell.sixlab.text=[NSString stringWithFormat:@"处理人员:%@",_XmlArray[indexPath.row][@"OPERATOR"]];
            cell.sevenLab.text=[NSString stringWithFormat:@"确认人员:%@",_XmlArray[indexPath.row][@"VERIFIER"]];        }
        
        
        //return cell;
        
        
    }
    return cell;
    

}



    

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (self.mySeg.selectedSegmentIndex) {
        case 0:
        {
            
        
      
            
            
        }
            break;
            
        default:{
            
            if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
                
               // [self requestKeepDetileInfoWithASGUID:_showDic[@"ASGUID"]];
                
            }else{
                //[self requestKeepDetileInfoWithASGUID:_XmlArray[indexPath.row][@"ASGUID"]];
                
            }
            
            
        }
            break;
    }
    
    
    
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
}


- (IBAction)btnClick:(UIButton *)sender {
    ADD_VC *vc =[[ADD_VC alloc]initWithADic:_fromDic withTitle:@"维修登记"];
    vc.Mcode=self.Mcode;
    vc.type=0;
    [self.navigationController pushViewController:vc animated:YES];
      
}
- (IBAction)segControl:(UISegmentedControl *)sender {
    [self requestRepaireConfimInfoWithXmlStr];
    
    
  
}

@end
