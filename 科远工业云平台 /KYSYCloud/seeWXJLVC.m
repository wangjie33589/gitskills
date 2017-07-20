//
//  seeWXJLVC.m
//  KYSYCloud
//
//  Created by SciyonSoft_WangJie on 16/4/11.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "seeWXJLVC.h"
#import "SevenViewCell.h"
#import "ADD_VC.h"


@interface seeWXJLVC ()<UITableViewDelegate,UITableViewDataSource>{

    NSDictionary *_fromDic;
    NSMutableDictionary *  _XMLDic;
    NSMutableArray * _XmlArray;
    NSMutableDictionary *_showDic;
    NSInteger state;
    NSDictionary *_detilDic;
}

@end

@implementation seeWXJLVC
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
    self.title=@"查看维修记录";
        [self requestRepaireConfimInfoWithXmlStr];
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
       [self.myTable registerNib:[UINib nibWithNibName:@"SevenViewCell" bundle:nil] forCellReuseIdentifier:@"sevenCell"];
}
-(void)requestRepaireConfimInfoWithXmlStr{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    [_XmlArray removeAllObjects];
    [_showDic removeAllObjects];
    [_XMLDic removeAllObjects];
    [self.myTable reloadData];
    NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETDEVICEREPAIR</Action><USERID>%@</USERID><PWD>%@</PWD><MCODE>%@</MCODE><DGUID>%@</DGUID><STATE>2</STATE></Data>",USER_NAME,PASSWORD,self.Mcode,_fromDic[@"DGUID"]];
    
    
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
        return cell;
    
    
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
        ADD_VC *vc =[[ADD_VC alloc]initWithADic:_showDic withTitle:@"维修登记"];
        vc.Mcode=self.Mcode;
        vc.type=0;
        vc.tag=110;
        [self.navigationController pushViewController:vc animated:YES];

    }else{
        ADD_VC *vc =[[ADD_VC alloc]initWithADic:_XmlArray[indexPath.row] withTitle:@"维修记录"];
        vc.Mcode=self.Mcode;
        vc.tag=110;
        vc.type=1;
        [self.navigationController pushViewController:vc animated:YES];
    
    
    }
   
   
            
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
