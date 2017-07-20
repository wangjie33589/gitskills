//
//  registerViewController.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/19.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "registerViewController.h"
#import "equipCheckCell.h"
#import "regist_Two_ViewController.h"

@interface registerViewController ()<UITableViewDataSource,UITableViewDelegate>{
    

    NSDictionary*_fromDic;
   NSMutableDictionary *  _XMLDic;
    NSMutableArray * _XmlArray;
    NSMutableDictionary *_showDic;
    NSInteger state;
 }

@end

@implementation registerViewController
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
    [SVProgressHUD  showWithStatus:@"努力加载中..."];
    self.title=_fromDic[@"MNAME"];
    UIBarButtonItem *barbtn =[[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target:self action:@selector(btclick)];
    self.navigationItem.rightBarButtonItem=barbtn;
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.mytable reloadData];
    [self requestshowData];
}
-(void)btclick{
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:@"10",@"STATECODE",@"",@"RRGUID",nil];
    regist_Two_ViewController *vc =[[regist_Two_ViewController alloc]initWithADic:dict withTitle:@"报修登记"] ;
        [self.navigationController pushViewController:vc animated:YES];

}


-(void)initView{
    self.segentcontrol.selectedSegmentIndex=1;
    state=2;
    self.mytable.dataSource=self;
    self.mytable.delegate=self;
    self.mytable.rowHeight=125;
    [self.mytable registerNib:[UINib nibWithNibName:@"equipCheckCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
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
            cell.secondLab.text=[NSString stringWithFormat:@"设备编号: %@", [CommonTool cleanNULL:_showDic[@"DID"]]];
            cell.ThirdLab.text=[NSString stringWithFormat:@"客户名称: %@",[CommonTool cleanNULL:_showDic[@"CNAME"]]];
            cell.fourLab.text=[NSString stringWithFormat:@"报修内容: %@",  [CommonTool cleanNULL:_showDic[@"CONTENT"]]];
            cell.fiveLab.text=[NSString stringWithFormat:@"联系方式: %@",[CommonTool daFormatByComment:_showDic[@"PHONE"]]];
        

    }else if ([_XMLDic[@"R"] isKindOfClass:[NSArray class]]){
  
            cell.firstLab.text=[NSString stringWithFormat:@"登记时间: %@", [CommonTool cleanNULL:_XmlArray[indexPath.row][@"OPERATEDATE"]]];
            cell.secondLab.text=[NSString stringWithFormat:@"设备编号: %@",  [CommonTool cleanNULL:_XmlArray[indexPath.row][@"DID"]]];
            cell.ThirdLab.text=[NSString stringWithFormat:@"客户名称: %@",  [CommonTool cleanNULL:_XmlArray[indexPath.row][@"CNAME"]]];
            cell.fourLab.text=[NSString stringWithFormat:@"报修内容: %@",[CommonTool cleanNULL:_XmlArray[indexPath.row][@"CONTENT"]]];
            cell.fiveLab.text=[NSString stringWithFormat:@"联系方式: %@",[CommonTool daFormatByComment:_XmlArray[indexPath.row][@"PHONE"]]];
        
        
        
    }else{
        
        
        
    }

       return  cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{



    if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
        regist_Two_ViewController *vc =[[regist_Two_ViewController alloc]initWithADic:_XMLDic[@"R"] withTitle:@"报修登记"];
        vc.type =(int)self.segentcontrol.selectedSegmentIndex;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([_XMLDic[@"R"] isKindOfClass:[NSArray class]]){
        regist_Two_ViewController *vc =[[regist_Two_ViewController alloc]initWithADic:_XMLDic[@"R"][indexPath.row] withTitle:@"报修登记"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        
        
    }
    


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segentclick:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
        {//未分配
            state=0;
        
        }
            break;
        case 1:{
            //未处理
            state=2;
        
        
        
        }break;
        case 2:{
            //草稿箱
            state=1;
        
        
        }break;
}
    
    
    [self requestshowData];
    
    
    
    
}
-(void)requestshowData{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    [_XmlArray removeAllObjects];
    [_XMLDic removeAllObjects];
    [_showDic removeAllObjects];
    [self.mytable reloadData];
    
    
    NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETREPAIRRECORD</Action><SIM>%@</SIM><STATE>%ld</STATE></Data>",SIM_CODE,state];
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlString];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            _XMLDic=(NSMutableDictionary*)[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
                       if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
                _showDic=_XMLDic[@"R"];
                     [self.mytable reloadData];
                
                
            }else if ([_XMLDic[@"R"] isKindOfClass:[NSArray class]]){
            
            
                _XmlArray=_XMLDic[@"R"];
            
                [self.mytable reloadData];
            
            }
                 }else{
            
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
        
        
    };
    
}

@end
