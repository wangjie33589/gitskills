//
//  equipCheckDetilVC.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/29.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "equipCheckDetilVC.h"
#import "equipCheckCell.h"
#import "nineLabViewCell.h"
#import "fourLabViewCell.h"
#import "lastBtnCell.h"
#import "authorVC.h"
#import "equipCheckDetilVC.h"
#import "RealWatchController.h"
#import "alertViewController.h"
#import "Maintain_detil_VC.h"
#import "Maintain_detil_VC.h"
#import "ChangePartrRecordVC.h"
#import "seeWXJLVC.h"
#import "repaireViewController.h"
#import "contollerLogVC.h"
@interface equipCheckDetilVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSDictionary *_showDic;
    NSDictionary *_XMLDic;
    NSArray *_xmlArray;
    NSArray *_itemArray;
    NSDictionary *_ShowRequestDic;
    NSArray *_dpArray;
    NSString *_title;
    NSDictionary *_auDateDic;
    NSArray *_auDateArray;
 


}

@end

@implementation equipCheckDetilVC
-(id)initWithDic:(NSDictionary *)dic withTitle:(NSString *)title{
    self=[super init];
    if (self) {
        _showDic=dic;
        _title=title;
        
    }


    return self;


}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title=_title;
    
    
    NSLog(@"selftype=====%d",self.type);
    NSLog(@"tiuttlt======%@",_title);

     UIBarButtonItem *rightBtn =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_5_n"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    
      [self initTableView];
    [self requestShowData];
    if (self.type==1) {
        [self requestAUDATE];
    }
 
  
   
}

-(void)leftBtnClick{
    
    if (self.type==0) {
        UIAlertController *conter =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
      
        UIAlertAction *action1 =[UIAlertAction actionWithTitle:@"实时监控" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            RealWatchController *vc =[[RealWatchController alloc]initWithDic:_showDic];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }];
        UIAlertAction *action2 =[UIAlertAction actionWithTitle:@"设备操控" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            equipCheckDetilVC *vc =[[equipCheckDetilVC alloc]initWithDic:_showDic withTitle:@"设备操控"];
            vc.type=1;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }]; UIAlertAction *action3 =[UIAlertAction actionWithTitle:@"报警提醒" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            alertViewController *vc=[[alertViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }];
        UIAlertAction *action4 =[UIAlertAction actionWithTitle:@"维修登记" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            Maintain_detil_VC *vc =[[Maintain_detil_VC alloc]initWithDic:_showDic];
            vc.Mcode =_showDic[@"MCODE"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        UIAlertAction *canccel =[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [conter addAction:action1];
        [conter addAction:action2];
        [conter addAction:action3];
        [conter addAction:action4];
        [conter addAction:canccel];
        [self presentViewController:conter animated:YES completion:nil];

    }else{
        
        UIAlertController *conter =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 =[UIAlertAction actionWithTitle:@"设备台账" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            equipCheckDetilVC *vc =[[equipCheckDetilVC alloc]initWithDic:_showDic withTitle:@"设备台账"];
            vc.type=0;
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        UIAlertAction *action2 =[UIAlertAction actionWithTitle:@"实时监控" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            RealWatchController *vc =[[RealWatchController alloc]initWithDic:_showDic];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }];
     UIAlertAction *action3 =[UIAlertAction actionWithTitle:@"报警提醒" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            alertViewController *vc=[[alertViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }];
        UIAlertAction *action4 =[UIAlertAction actionWithTitle:@"维修登记" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            Maintain_detil_VC *vc =[[Maintain_detil_VC alloc]initWithDic:_showDic];
            vc.Mcode =_showDic[@"MCODE"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        UIAlertAction *canccel =[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [conter addAction:action1];
        [conter addAction:action2];
        [conter addAction:action3];
        [conter addAction:action4];
        [conter addAction:canccel];
        [self presentViewController:conter animated:YES completion:nil];

    
    
    
    
    
    
    
    
    
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
       
}
-(void)initTableView{
    
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    [self.myTable registerNib:[UINib nibWithNibName:@"fourLabViewCell" bundle:nil] forCellReuseIdentifier:@"fourcell"];
    [self.myTable registerNib:[UINib nibWithNibName:@"equipCheckCell" bundle:nil] forCellReuseIdentifier:@"fivecell"];
    [self.myTable registerNib:[UINib nibWithNibName:@"nineLabViewCell" bundle:nil] forCellReuseIdentifier:@"ninecell"];
    [self.myTable registerNib:[UINib nibWithNibName:@"lastBtnCell" bundle:nil] forCellReuseIdentifier:@"lastcell"];
    





}
-(void)requestShowData{
    
    NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETDEVICEOPT</Action><USERID>%@</USERID><PWD>%@</PWD><DGUID>%@</DGUID></Data>",USER_NAME,PASSWORD,_showDic[@"DGUID"]];
    
    
    
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlString];
    manger.backSuccess=^void(NSDictionary *dictt){
    
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            _XMLDic=[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            
            
            NSLog(@"XMLDIC+++%@",_XMLDic);
           _ShowRequestDic=_XMLDic[@"R"];
                     [self requestShowDiviceItem];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
        
        
    };
    
    
    
    
    
    
}
-(void)requestShowDiviceItem{
    
    NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETDEVICEPART</Action><USERID>%@</USERID><PWD>%@</PWD><DGUID>%@</DGUID></Data>",USER_NAME,PASSWORD,_showDic[@"DGUID"]];
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlString];
    manger.backSuccess=^void(NSDictionary *dictt){
        
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            _XMLDic=[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            
            
           
          _dpArray=_XMLDic[@"R"];
           [self requestAUDATE];
            [self.myTable reloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
        
        
    };
    
    
}
-(void)requestAUDATE{
    
    NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETDEVICECTLS</Action><USERID>%@</USERID><PWD>%@</PWD><DGUID>%@</DGUID></Data>",USER_NAME,PASSWORD,_showDic[@"DGUID"]];
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlString];
    manger.backSuccess=^void(NSDictionary *dictt){
        
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            _auDateDic=[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            
            
            NSLog(@"auDate=========%@",_auDateDic);
            if ([_auDateDic[@"R"] isKindOfClass:[NSDictionary class]]) {
                
            }else{
                _auDateArray=_auDateDic[@"R"];

            
            }
            
            
            
            NSLog(@"audic=========%@",_auDateArray);
            
            [self.myTable reloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
        
        
    };
    
    
}


#pragma mark====UItableViewDataSource表代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.type==0) {
        return 2;
    }else{
        return 1;
    
    
    }
  
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type==0) {
        return section==0?2:_dpArray.count+1;

    }else{
        return 3;
    
    
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==0) {
                return 100;
            }else{
                return 225;
            
            }
        
        
        }
            break;
                   default:{
                       
            return 100;
        
    }
            break;
    }
    
   

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==0?0:20;

}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
       return section==0?@"":@"部件列表";
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    fourLabViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"fourcell"];
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
  
    
    switch (indexPath.section) {
       
        case 0:{
            
            
            if (indexPath.row==0) {
                cell.firstLab.text=[NSString stringWithFormat:@"设备编号：%@",[CommonTool cleanNULL:_ShowRequestDic[@"DID"]]];
                cell.secondLab.text=[NSString stringWithFormat:@"设备名称: %@", [CommonTool cleanNULL:_ShowRequestDic[@"PNAME"]]];
                
                cell.ThirdLab.text=[NSString stringWithFormat:@"出厂日期： %@",[CommonTool daFormatByComment:_ShowRequestDic[@"FACTROYDATE"]]];
                cell.fourLab.text=[NSString stringWithFormat:@"当前位置：%@", [CommonTool cleanNULL:_ShowRequestDic[@"USEPLACE"]]];
                return cell;
                
                    }else if(indexPath.row==1){
                nineLabViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ninecell"];
                           cell.selectionStyle= UITableViewCellSelectionStyleNone;
           
                cell.firstLab.text=[NSString stringWithFormat:@"客户：%@",  [CommonTool cleanNULL:_ShowRequestDic[@"CNAME"]]];
                cell.secondLab.text=[NSString stringWithFormat:@"电话：%@",[CommonTool cleanNULL:_ShowRequestDic[@"PHONE"]]];
                cell.ThirdLab.text=[NSString stringWithFormat:@"传真： %@", [CommonTool cleanNULL:_ShowRequestDic[@"FAX"]]];
                cell.fourLab.text=[NSString stringWithFormat:@"邮编: %@",[CommonTool cleanNULL:_ShowRequestDic[@"ZIPCODE"]]];
                cell.fiveLab.text=[NSString stringWithFormat:@"地址：%@",  [CommonTool cleanNULL:_ShowRequestDic[@"ADDR"]]];
                cell.sixLab.text=[NSString stringWithFormat:@"现场联系人：%@",[CommonTool cleanNULL:_ShowRequestDic[@"LINKER"]]];
                cell.sevenLab.text=[NSString stringWithFormat:@"联系电话：%@", [CommonTool cleanNULL:_ShowRequestDic[@"LINKPHONE"]]];
                        
                cell.aintinLab.text=[NSString stringWithFormat:@"售出日期：%@",[CommonTool daFormatByComment:_ShowRequestDic[@"SALETIME"]]];
                cell.nineLab.text=[NSString stringWithFormat:@"销售人员：%@", [CommonTool cleanNULL:_ShowRequestDic[@"PERSONNAME"]]];
                        
                          
                return cell;
                    }else{
                        
                        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(0, 20, LWIDTH, 20)];
                        label.text=[NSString stringWithFormat:@"授权截止：%@", @""];
                        [cell addSubview:label];
                        UILabel *label1 =[[UILabel alloc]initWithFrame:CGRectMake(0, 40, LWIDTH, 20)];
                        label1.font=[UIFont systemFontOfSize:12];
                        UILabel *label2 =[[UILabel alloc]initWithFrame:CGRectMake(0, 60, LWIDTH, 20)];
                        
                        label2.font=[UIFont systemFontOfSize:12];
                        [cell addSubview:label2];

                        if ([_auDateArray isKindOfClass:[NSArray class]]) {
                            
                            label1.text=[NSString stringWithFormat:@"%@（%@）：%@", [CommonTool cleanNULL:_auDateArray[0][@"CONTRONAME"]],[CommonTool cleanNULL:_auDateArray[0][@"SERVICENO"]],[CommonTool daFormatByComment:_auDateArray[0][@"AUDATE"]]];
                            label2.text=[NSString stringWithFormat:@"%@（%@）：%@", [CommonTool cleanNULL:_auDateArray[1][@"CONTRONAME"]],[CommonTool cleanNULL:_auDateArray[1][@"SERVICENO"]],[CommonTool daFormatByComment:_auDateArray[1][@"AUDATE"]]];

                            
                        }else{
                            label1.text=[NSString stringWithFormat:@"%@（%@）：%@", [CommonTool cleanNULL:_auDateDic[@"CONTRONAME"]],[CommonTool cleanNULL:_auDateDic[@"SERVICENO"]],[CommonTool daFormatByComment:_auDateDic[@"AUDATE"]]];
//                            label2.text=[NSString stringWithFormat:@"%@（%@）：%@", [CommonTool cleanNULL:_auDateArray[1][@"CONTRONAME"]],[CommonTool cleanNULL:_auDateArray[1][@"SERVICENO"]],[CommonTool daFormatByComment:_auDateArray[1][@"AUDATE"]]];
//                            
                            
                    }
                       
                    
                        [cell addSubview:label1];
                                         UIButton *seeLogBtn =[UIButton buttonWithType:UIButtonTypeCustom];
                        seeLogBtn.frame=CGRectMake(200,50, LWIDTH-200, 40);
                        [seeLogBtn setTitle:@"查看操作日志>>" forState:0];
                        [seeLogBtn setTitleColor:[UIColor blueColor] forState:0];
                        [cell addSubview:seeLogBtn];
                        seeLogBtn.backgroundColor=[UIColor whiteColor];
                       seeLogBtn.tag=1;
                        [seeLogBtn addTarget:self action:@selector(authorbtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        
                            UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
                            button.frame=CGRectMake(100, 170, LWIDTH-200, 40);
                            [button setTitle:@"在线授权" forState:0];
                            [cell addSubview:button];
                        button.backgroundColor=[UIColor blueColor];
                            button.tag=0;
                            [button addTarget:self action:@selector(authorbtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        return cell;
           
                    }
            
        }
            break;
            
        case 1:{
            
            if (indexPath.row<_dpArray.count) {
                cell.firstLab.text=[NSString stringWithFormat:@"部件编号：%@",  [CommonTool cleanNULL:_dpArray[indexPath.row][@"DPCODE"]]];
                cell.secondLab.text=[NSString stringWithFormat:@"部件名称：%@",[CommonTool cleanNULL:_dpArray[indexPath.row][@"DPNAME"]]];
                cell.ThirdLab.text=[NSString stringWithFormat:@"制造厂家：%@",  [CommonTool cleanNULL:_dpArray[indexPath.row][@"FACTORY"]]];
                cell.fourLab.text=[NSString stringWithFormat:@"质保时间：%@",[CommonTool daFormatByComment:_dpArray[indexPath.row][@"QGTIME"]]];
                
                return cell;
                
            }else{
                lastBtnCell *cell =[tableView dequeueReusableCellWithIdentifier:@"lastcell"];
                [cell.firstBtn  addTarget:self action:@selector(firstBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.firstBtn.tag=0;
                cell.secondBtn.tag=1;
                cell.ThirdBtn.tag=2;
                cell.fourBtn.tag=3;
                [cell.secondBtn  addTarget:self action:@selector(firstBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.ThirdBtn  addTarget:self action:@selector(firstBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.fourBtn  addTarget:self action:@selector(firstBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;
                
            }
    }
            break;
    }
    
    
    return cell;

}
-(void)firstBtnClick:(UIButton*)sender{

    switch (sender.tag) {
        case 0:
        {
            ChangePartrRecordVC *vc =[[ChangePartrRecordVC alloc]initWithADic:_showDic];
            [self.navigationController pushViewController:vc animated:YES];
        
        }
            break;
        case 1:
        {
            seeWXJLVC *vc =[[seeWXJLVC alloc]initWithDic:_showDic];
            vc.Mcode=self.Mcode;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            repaireViewController *vc =[[repaireViewController alloc]initWithADic:_showDic withTitle:@"保养记录"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            contollerLogVC *vc =[[contollerLogVC alloc]initWithDic:_showDic];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;

}










}




-(void)authorbtnClick:(UIButton*)sender{
    switch (sender.tag) {
        case 0:
        {
            authorVC *vc =[[authorVC alloc]initWithDic:_showDic];
            [self.navigationController pushViewController:vc animated:YES];
           
        }
            break;
        case 1:{
            contollerLogVC *vc =[[contollerLogVC alloc]initWithDic:_showDic];
            [self.navigationController pushViewController:vc animated:YES];

        
        
        }break;
            
        default:
            break;
    }


}


@end
