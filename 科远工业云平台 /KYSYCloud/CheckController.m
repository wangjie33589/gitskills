//
//  CheckController.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/19.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "CheckController.h"
#import "equipCheckCell.h"
#import "equipCheckDetilVC.h"
#import "RealWatchController.h"


@interface CheckController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    NSDictionary  *_fromDic;
    NSString*_titlestr;
    NSArray *_showArray;
    NSString *searStr;
    NSDictionary *_XMLDic;
   NSArray *_XmlArray;
    NSDictionary *_showDic;


}

@end

@implementation CheckController
-(id)initWithADic:(NSDictionary *)aDic
{
    self=[super init];
    if (self) {
        _fromDic=aDic;
        
        
        
        
        NSLog(@"gsdjhfgjkhdgjhdkjhfghsfdhjkgfd=====%@",_fromDic);
    }

    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title=_fromDic[@"MNAME"];
   
    NSLog(@"selu===%f",self.navigationController.navigationBar.frame.size.height);
    self.mySearchbar.delegate=self;
    self.mySearchbar.returnKeyType=UIReturnKeyDone;
    self.MyTabkeView.delegate=self;
    self.MyTabkeView.dataSource=self;
    self.MyTabkeView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.MyTabkeView registerNib:[UINib nibWithNibName:@"equipCheckCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    self.MyTabkeView.rowHeight=125;
    if ([_fromDic[@"APPADDR"] isEqualToString:@"DeviceOpeView"]){
        UIBarButtonItem *rigbtn =[[UIBarButtonItem alloc]initWithTitle:@"更多查询" style: UIBarButtonItemStylePlain target:self action:@selector(moreInqurity)];
        self.navigationItem.rightBarButtonItem=rigbtn;
        
        
    }
    
    
}
-(void)moreInqurity{
    
    
    UIAlertController *conter =[UIAlertController alertControllerWithTitle:@"更多查询" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [conter addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"设备编号";
        
    }];
    [conter addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"条形码";
    }];
    [conter addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"客户名称";
    }];
    [conter addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    textField .placeholder=@"授权日期（多少天后过期）";
        
    }];
    UIAlertAction *action =[UIAlertAction actionWithTitle:@"仅显示在线设备" style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
       }];
    
    
UIAlertAction * action_two=[UIAlertAction actionWithTitle:@"查询" style:0 handler:^(UIAlertAction * _Nonnull action) {
 }];
    UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [conter addAction:action];
    [conter addAction:action_two];
    [conter addAction:cancel];
    [self presentViewController:conter animated:YES completion:nil];
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_XMLDic[@"R"] isKindOfClass:[NSArray class]]) {
        return _XmlArray.count;
        
    }else if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]){
        return 1;
    }else{
        return 0;
        }
    


}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    equipCheckCell *cell =[tableView dequeueReusableCellWithIdentifier:@"CELL" ];
    if ([_XMLDic[@"R"] isKindOfClass:[NSArray class]]) {
      
                cell.firstLab.text=[NSString stringWithFormat:@"设备编号: %@",  [CommonTool cleanNULL:_XmlArray[indexPath.row][@"DID"]]];
                         cell.secondLab.text=[NSString stringWithFormat:@"设备名称: %@",[CommonTool cleanNULL:_XmlArray[indexPath.row][@"PNAME"]]];
                cell.ThirdLab.text=[NSString stringWithFormat:@"规格型号: %@",  [CommonTool cleanNULL:_XmlArray[indexPath.row][@"MODEL"]]];
                cell.fourLab.text=[NSString stringWithFormat:@"客户名称: %@", [CommonTool cleanNULL:_XmlArray[indexPath.row][@"CNAME"]]];
        if ([_fromDic[@"APPADDR"] isEqualToString:@"DeviceBookView"]) {
            NSLog(@"设备台账");
            cell.fiveLab.text=[NSString stringWithFormat:@"出厂日期: %@",[CommonTool daFormatByComment:_XmlArray[indexPath.row][@"FACTROYDATE"]]];

            
        }else if ([_fromDic[@"APPADDR"] isEqualToString:@"RealWatchView"]){
                      NSLog(@"实时监控");
            if ([_XmlArray[indexPath.row][@"ISONLINE"]intValue]==0) {
                cell.fiveLab.text=[NSString stringWithFormat:@"是否在线: %@",@"否"];
                cell.fiveLab.textColor=[UIColor  redColor];
                
            }else{
                cell.fiveLab.text=[NSString stringWithFormat:@"是否在线: %@",@"是"];
                cell.fiveLab.textColor=[UIColor greenColor];
            }
            
        }else if ([_fromDic[@"APPADDR"] isEqualToString:@"DeviceOpeView"]){
                  cell.fiveLab.text=@"";
        }
        
    }else if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]){
        
      

        cell.firstLab.text=[NSString stringWithFormat:@"设备编号: %@",[CommonTool cleanNULL:_XMLDic[@"R"][@"DID"]]];
        cell.secondLab.text=[NSString stringWithFormat:@"设备名称: %@",    [CommonTool cleanNULL:_XMLDic[@"R"][@"PNAME"]]];
        cell.ThirdLab.text=[NSString stringWithFormat:@"规格型号: %@",   [CommonTool cleanNULL:_XMLDic[@"R"][@"MODEL"]]];
        cell.fourLab.text=[NSString stringWithFormat:@"客户名称: %@",[CommonTool cleanNULL:_XMLDic[@"R"][@"CNAME"]]];
        if ([_fromDic[@"APPADDR"] isEqualToString:@"DeviceBookView"]) {
            NSLog(@"设备台账");
            cell.fiveLab.text=[NSString stringWithFormat:@"出厂日期: %@",[CommonTool daFormatByComment:_XMLDic[@"R"][@"FACTROYDATE"]]];

        }else if ([_fromDic[@"APPADDR"] isEqualToString:@"RealWatchView"]){
                    NSLog(@"实时监控");
            if ([_XMLDic[@"R"][@"ISONLINE"]intValue]==0) {
                cell.fiveLab.text=[NSString stringWithFormat:@"是否在线: %@",@"否"];
                cell.firstLab.textColor=[UIColor greenColor];

            }else{
                cell.fiveLab.text=[NSString stringWithFormat:@"是否在线: %@",@"是"];
                cell.firstLab.textColor=[UIColor redColor];
        }
           
            
            
        }
        
        
    }
  
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
    




}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_XMLDic[@"R"] isKindOfClass:[NSArray class]]) {
        if ([_fromDic[@"APPADDR"] isEqualToString:@"DeviceBookView"]) {
            equipCheckDetilVC *vc =[[equipCheckDetilVC alloc]initWithDic:_XMLDic[@"R"][indexPath.row] withTitle:@"设备台账"];
            vc.Mcode=_fromDic[@"MCODE"];
            vc.type=0;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([_fromDic[@"APPADDR"] isEqualToString:@"RealWatchView"]){
            
            RealWatchController *vc =[[RealWatchController alloc]initWithDic:_XMLDic[@"R"][indexPath.row]];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }else if ([_fromDic[@"APPADDR"] isEqualToString:@"DeviceOpeView"]){
           equipCheckDetilVC *vc =[[equipCheckDetilVC alloc]initWithDic:_XMLDic[@"R"][indexPath.row] withTitle:@"设备操控"];
            vc.type=1;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        

        
    }else if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]){
        if ([_fromDic[@"APPADDR"] isEqualToString:@"DeviceBookView"]) {
            equipCheckDetilVC *vc =[[equipCheckDetilVC alloc]initWithDic:_XMLDic[@"R"] withTitle:@"设备台账"];
            vc.type=0;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([_fromDic[@"APPADDR"] isEqualToString:@"RealWatchView"]){
            
            RealWatchController *vc =[[RealWatchController alloc]initWithDic:_XMLDic[@"R"]];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }else if ([_fromDic[@"APPADDR"] isEqualToString:@"DeviceOpeView"]){
            equipCheckDetilVC *vc =[[equipCheckDetilVC alloc]initWithDic:_XMLDic[@"R"] withTitle:@"设备操控"];
            vc.type=1;
            [self.navigationController pushViewController:vc animated:YES];    }

      
    }
    
    
    
}

#pragma mark ------------------ UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES];
    
    for(id cc in [searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(cancel) forControlEvents: UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}
-(void)cancel{
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO];
    self.navigationItem.rightBarButtonItem = nil;
    [self.view endEditing:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{ searStr=@"";
    searStr=searchBar.text;
    [self requestShowData];
    [self.view endEditing:YES];
}



-(void)requestShowData{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    
    NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETDEVICEBOOK</Action><USERID>%@</USERID><PWD>%@</PWD><P1>%@</P1></Data>",USER_NAME,PASSWORD,searStr];
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlString];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
           _XMLDic=[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
           NSLog(@"XMLDIC+++%@",_XMLDic);
            
            
            if ([_XMLDic[@"R"] isKindOfClass:[NSArray class]]) {
                  _XmlArray=_XMLDic[@"R"];
                
            }else if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]){
                _showDic=_XMLDic[@"R"];
            }
                 [self.MyTabkeView reloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
        
        
    };
    
     
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   }


@end
