//
//  MaintainRecondVC.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/3/2.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "MaintainRecondVC.h"
#import "SYQRCodeViewController.h"
#import "equipCheckCell.h"
#import "equipCheckDetilVC.h"
#import "RealWatchController.h"
#import "Maintain_detil_VC.h"
#import "noHandleVC.h"
#import "beRejectVC.h"

@interface MaintainRecondVC () <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSDictionary *_fromDic;
    NSDictionary *  _XMLDic;
    NSArray * _XmlArray;
    NSDictionary *_showDic;
    NSInteger state;
    NSString *searStr;
    NSString *_firstTextString;
    NSString * CUSTOMERINFO;
}

@end

@implementation MaintainRecondVC
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
   
    self.mySearchBar.text=CUSTOMERINFO;

    [super viewDidLoad];
    self.title=_fromDic[@"MNAME"];
    self.mySearchBar.returnKeyType=UIReturnKeyDone;
    self.mySearchBar.delegate=self;
    self.mySearchBar.returnKeyType=UIReturnKeyDone;
    self.MyTableView.delegate=self;
    self.MyTableView.dataSource=self;
    self.MyTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.MyTableView registerNib:[UINib nibWithNibName:@"equipCheckCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    self.MyTableView.rowHeight=125;
    //[self requestShowData];
    _firstTextString=@"";
    UIBarButtonItem *rightBtn =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ewmClick:) name:@"ewmtongzhi" object:nil];
    
    
}

-(void)rightBtnClick{

    UIAlertController *controler =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action =[UIAlertAction actionWithTitle:@"从报修单登记" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        noHandleVC *vc =[[noHandleVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    UIAlertAction *TwoAction =[UIAlertAction actionWithTitle:@"被驳回的登记" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        beRejectVC *vc =[[beRejectVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controler addAction:action];
    [controler addAction:TwoAction];
    [controler addAction:cancel];
    [self presentViewController:controler animated:YES completion:nil];
    
    

}
//扫描二维码完成之后调用这个方法
-(void)ewmClick:(NSNotification*)text{
    
    _firstTextString=text.userInfo[@"text"];
    if (![_firstTextString isEqualToString:@""]) {
        self.mySearchBar.text=_firstTextString;
        [self firstRequest:_firstTextString];
    }
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return   _XmlArray.count>0?1:_XmlArray.count;
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
        cell.firstLab.text=[NSString stringWithFormat:@"设备编号: %@",_XmlArray[indexPath.row][@"DID"]];
        cell.secondLab.text=[NSString stringWithFormat:@"设备名称: %@",_XmlArray[indexPath.row][@"PNAME"]];
        cell.ThirdLab.text=[NSString stringWithFormat:@"规格型号: %@",_XmlArray[indexPath.row][@"MODEL"]];
        cell.fourLab.text=[NSString stringWithFormat:@"客户名称: %@",_XmlArray[indexPath.row][@"CNAME"]];
        cell.fiveLab.text=[NSString stringWithFormat:@"出厂日期: %@",[CommonTool daFormatByComment:_XmlArray[indexPath.row][@"FACTROYDATE"]]];
        
        
        
    }else if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]){
        cell.firstLab.text=[NSString stringWithFormat:@"设备编号: %@",_XMLDic[@"R"][@"DID"]];
        cell.secondLab.text=[NSString stringWithFormat:@"设备名称: %@",_XMLDic[@"R"][@"PNAME"]];
        cell.ThirdLab.text=[NSString stringWithFormat:@"规格型号: %@",_XMLDic[@"R"][@"MODEL"]];
        cell.fourLab.text=[NSString stringWithFormat:@"客户名称: %@",_XMLDic[@"R"][@"CNAME"]];
        cell.fiveLab.text=[NSString stringWithFormat:@"出厂日期: %@",[CommonTool daFormatByComment:_XMLDic[@"R"][@"FACTROYDATE"]]];
        
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_XMLDic[@"R"] isKindOfClass:[NSArray class]]) {
        Maintain_detil_VC *vc =[[Maintain_detil_VC alloc]initWithDic:_XmlArray[indexPath.row]];
         vc.Mcode =_fromDic[@"MCODE"];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]){
        
        Maintain_detil_VC *vc =[[Maintain_detil_VC alloc]initWithDic:_showDic];
        vc.Mcode =_fromDic[@"MCODE"];
        [self.navigationController pushViewController:vc animated:YES];
        
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
    //    searStr=@"";
    //
    //    [self requestShowData];
    //
    
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
        NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETDEVICEBOOK</Action><USERID>%@</USERID><PWD>%@</PWD><MCODE>%@</MCODE><P1>%@</P1></Data>",USER_NAME,PASSWORD,_fromDic[@"MCODE"],searStr];
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlString];
    manger.backSuccess=^void(NSDictionary *dictt){
        
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            _XMLDic=[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            //
            //
            NSLog(@"XMLDIC+++%@",_XMLDic);
            
            
            if ([_XMLDic[@"R"] isKindOfClass:[NSArray class]]) {
                _XmlArray=_XMLDic[@"R"];
                
            }else if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]){
                _showDic=_XMLDic[@"R"];
            }
                [self.MyTableView reloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
    };
  }
-(void)firstRequest:(NSString*)string{
    NSString *xmlstring =[NSString stringWithFormat:@"<Data><Action>SCANBARCODE</Action><BARCODE>%@</BARCODE></Data>",string];
    NSLog(@"xmlstring====%@",xmlstring);
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlstring];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            
            CUSTOMERINFO=dictt[@"CUSTOMERINFO"];
            searStr=CUSTOMERINFO;
            [self requestShowData];
            self.mySearchBar.text=CUSTOMERINFO;
            
            
        }else{


      
            UIAlertController *controler =[UIAlertController alertControllerWithTitle:@"温馨提示" message:dictt[@"ERROR"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [controler addAction:cancel];
            [self presentViewController:controler animated:YES completion:nil];
            
        }
        
        
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   }





- (IBAction)EWMBtnClick:(UIButton *)sender {
    SYQRCodeViewController *vc =[[SYQRCodeViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
    
}
@end
