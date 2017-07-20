//
//  ChangePartrRecordVC.m
//  KYSYCloud
//
//  Created by SciyonSoft_WangJie on 16/4/11.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "ChangePartrRecordVC.h"
#import "SecondViewController.h"
#import "fourLabViewCell.h"

@interface ChangePartrRecordVC ()<UITableViewDataSource,UITableViewDelegate>{

    NSDictionary *_fromDic;
    NSDictionary * _XMLDic;
    NSArray* _XmlArray;
    NSDictionary *_showDic;


}

@end

@implementation ChangePartrRecordVC
-(id)initWithADic:(NSDictionary *)aDic
{
    self=[super init];
    if (self) {
        _fromDic=aDic;
        
        NSLog(@"_fromDic=====%@",_fromDic);
    }
    
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"查看部件更换记录";
    [self.myTable registerNib:[UINib nibWithNibName:@"fourLabViewCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    self.myTable.rowHeight=125;
    
    
    [self requestMainInfo];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestMainInfo{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    
    NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETPARTCHANGE</Action><USERID>%@</USERID><PWD>%@</PWD><DGUID>%@</DGUID></Data>",USER_NAME,PASSWORD,_fromDic[@"DGUID"]];
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlString];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            _XMLDic=[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
                _showDic =_XMLDic[@"R"];
                NSLog(@"_showdic=====%@",_showDic);
            }else{
                _XmlArray=_XMLDic[@"R"];

            
            }
            
            NSLog(@"asdfghdasf===%@",_XmlArray);
         
            [self.myTable reloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
        
        
    };
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
        return 1;
    }else{
    
     return _XmlArray.count;
    
    }
   
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    fourLabViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"CELL"];
   
    
    if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
        cell.firstLab.text=[NSString stringWithFormat:@"部件名称:%@",[CommonTool cleanNULL:_showDic[@"DPNAME"]]];
        
        cell.secondLab.text=[NSString stringWithFormat:@"替换前编号:%@",  [CommonTool cleanNULL:_showDic[@"OPID"]]];
        
        
        cell.ThirdLab.text=[NSString stringWithFormat:@"替换后编号:%@",[CommonTool cleanNULL:_showDic[@"NPID"]]];
       
      
        cell.fourLab.text=[NSString stringWithFormat:@"替换人员:%@", [CommonTool cleanNULL:_showDic[@"REPAIRPERSON"]]];

        
    }else{
        cell.firstLab.text=[NSString stringWithFormat:@"部件名称:%@",[CommonTool cleanNULL:_XmlArray[indexPath.row][@"DPNAME"]]];
        
        cell.secondLab.text=[NSString stringWithFormat:@"替换前编号:%@",  [CommonTool cleanNULL:_XmlArray[indexPath.row][@"OPID"]]];
        
        
        cell.ThirdLab.text=[NSString stringWithFormat:@"替换后编号:%@",[CommonTool cleanNULL:_XmlArray[indexPath.row][@"NPID"]]];
        NSLog(@"dfhghjfshjkjdgkljlkjfgkl;dafkshkgh=====%@",[CommonTool cleanNULL:_XmlArray[indexPath.row][@"RPNAME"]]);
        
        cell.fourLab.text=[NSString stringWithFormat:@"替换人员:%@", [CommonTool cleanNULL:_XmlArray[indexPath.row][@"REPAIRPERSON"]]];
        

    
    
    }
    
    
    
    
    return cell;
    
    
}



@end
