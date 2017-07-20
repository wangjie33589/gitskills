//
//  beRejectVC.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/3/23.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "beRejectVC.h"
#import "equipCheckCell.h"
#import "regist_Two_ViewController.h"
#import "ADD_VC.h"
#import "SevenViewCell.h"
#import "equipCheckCell.h"

@interface beRejectVC ()<UITableViewDataSource,UITableViewDelegate>{
    NSDictionary*_fromDic;
    NSMutableDictionary *  _XMLDic;
    NSMutableArray * _XmlArray;
    NSMutableDictionary *_showDic;
    NSInteger state;





}

@end

@implementation beRejectVC

-(id)initWithADic:(NSDictionary *)aDic
{
    self=[super init];
    if (self) {
        _fromDic=aDic;
        NSLog(@"frommmId======%@",_fromDic);
    }
    
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"维修登记";
    [SVProgressHUD  showWithStatus:@"努力加载中..."];
  
    UIBarButtonItem *barbtn =[[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target:self action:@selector(btclick)];
    self.navigationItem.rightBarButtonItem=barbtn;
    [self requestshowData];

    [self initView];
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.myTable reloadData];
    [self requestshowData];

    [self initView];

}

-(void)btclick{
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:@"10",@"STATECODE" ,nil];
    regist_Two_ViewController *vc =[[regist_Two_ViewController alloc]initWithADic:dict withTitle:@"报修登记"] ;
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)initView{
    
    state=2;
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    self.myTable.rowHeight=125;
    [self.myTable registerNib:[UINib nibWithNibName:@"equipCheckCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
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
        cell.fourLab.text=[NSString stringWithFormat:@"故障名称: %@",_showDic[@"ERRNAME"]];
        cell.fiveLab.text=[NSString stringWithFormat:@"驳回原因: %@",[CommonTool daFormatByComment:_showDic[@"REJECTREASON"]]];
        
    }else if ([_XMLDic[@"R"] isKindOfClass:[NSArray class]]){
        cell.firstLab.text=[NSString stringWithFormat:@"登记时间: %@",[CommonTool DataFormart:_XmlArray[indexPath.row][@"OPERATEDATE"]]];
        cell.secondLab.text=[NSString stringWithFormat:@"设备编号: %@",_XmlArray[indexPath.row][@"DID"]];
        cell.ThirdLab.text=[NSString stringWithFormat:@"客户名称: %@",_XmlArray[indexPath.row][@"CNAME"]];
        cell.fourLab.text=[NSString stringWithFormat:@"故障名称: %@",_XmlArray[indexPath.row][@"ERRNAME"]];
        cell.fiveLab.text=[NSString stringWithFormat:@"驳回原因: %@",[CommonTool daFormatByComment:_XmlArray[indexPath.row][@"REJECTREASON"]]];
        
        
        
    }else{
        
        
        
    }
    
    return  cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
        ADD_VC *vc =[[ADD_VC alloc]initWithADic:_XMLDic[@"R"] withTitle:@"维修登记"];
        vc.type =3;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([_XMLDic[@"R"] isKindOfClass:[NSArray class]]){
        ADD_VC *vc =[[ADD_VC alloc]initWithADic:_XMLDic[@"R"][indexPath.row] withTitle:@"维修登记"];
    
        
        vc.type=3;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
     }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestshowData{
    
    [SVProgressHUD showWithStatus:@"努力加载中..." ];
    [_XmlArray removeAllObjects];
    [_XMLDic removeAllObjects];
    [_showDic removeAllObjects];
    [self.myTable reloadData];
    NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETDEVICEREPAIR</Action><USERID>%@</USERID><PWD>%@</PWD><MCODE>%@</MCODE><STATE>3</STATE></Data>",USER_NAME,PASSWORD,_fromDic[@"MCODE"]];
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlString];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            _XMLDic=(NSMutableDictionary*)[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
                _showDic=_XMLDic[@"R"];
                NSLog(@"_DIC++++++%@",_XMLDic);
                NSLog(@"_xmlArray====%@",_XmlArray);
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

@end
