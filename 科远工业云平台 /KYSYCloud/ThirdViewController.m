//
//  ThirdViewController.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/19.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "ThirdViewController.h"
#import "fourLabViewCell.h"
#import "nineLabViewCell.h"
#import "equipCheckDetilVC.h"
#import "RealWatchController.h"
#import "alertViewController.h"
#import "Maintain_detil_VC.h"
#import "Maintain_detil_VC.h"

@interface ThirdViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSDictionary *_fromDic;
    NSDictionary*_XMLDic;
  NSDictionary*_XmlArray;
  }

@end

@implementation ThirdViewController
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
    self.title=@"工地查询";
      UIBarButtonItem *rightBtn =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_5_n"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    
    [self initTableview];
    [self requestShowData];
}
-(void)leftBtnClick{
    
    UIAlertController *conter =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 =[UIAlertAction actionWithTitle:@"设备台账" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          equipCheckDetilVC *vc =[[equipCheckDetilVC alloc]initWithDic:_fromDic withTitle:@"设备台账"];
        vc.type=0;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    UIAlertAction *action2 =[UIAlertAction actionWithTitle:@"实时监控" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        RealWatchController *vc =[[RealWatchController alloc]initWithDic:_fromDic];
        [self.navigationController pushViewController:vc animated:YES];

        
    }];
    UIAlertAction *action3 =[UIAlertAction actionWithTitle:@"设备操控" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
              equipCheckDetilVC *vc =[[equipCheckDetilVC alloc]initWithDic:_fromDic withTitle:@"设备操控"];
        vc.type=1;

        [self.navigationController pushViewController:vc animated:YES];
        
    }]; UIAlertAction *action4 =[UIAlertAction actionWithTitle:@"报警提醒" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        alertViewController *vc=[[alertViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];

        
    }];
    UIAlertAction *action5 =[UIAlertAction actionWithTitle:@"维修登记" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        Maintain_detil_VC *vc =[[Maintain_detil_VC alloc]initWithDic:_fromDic];
        vc.Mcode =_fromDic[@"MCODE"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    UIAlertAction *canccel =[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [conter addAction:action1];
    [conter addAction:action2];
    [conter addAction:action3];
    [conter addAction:action4];
    [conter addAction:action5];
    [conter addAction:canccel];
    [self presentViewController:conter animated:YES completion:nil];

}
-(void)initTableview{
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    [self.myTable registerNib:[UINib nibWithNibName:@"fourLabViewCell" bundle:nil] forCellReuseIdentifier:@"fourcell"];
    [self.myTable registerNib:[UINib nibWithNibName:@"nineLabViewCell" bundle:nil] forCellReuseIdentifier:@"ninecell"];

}
-(void)requestShowData{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    
    NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETDEVICEOPT</Action><USERID>%@</USERID><PWD>%@</PWD><DGUID>%@</DGUID></Data>",USER_NAME,PASSWORD,_fromDic[@"DGUID"]];
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlString];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            _XMLDic=[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            _XmlArray=_XMLDic[@"R"];
            [self.myTable reloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
        
        
    };


}
#pragma mark====表代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    fourLabViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"fourcell"];
    cell.selectionStyle= UITableViewCellSelectionStyleNone;

    
    if (indexPath.row==0) {
      
        cell.firstLab.text=[NSString stringWithFormat:@"设备编号：%@", [CommonTool cleanNULL:_XmlArray[@"DID"]]];
        cell.secondLab.text=[NSString stringWithFormat:@"设备名称: %@",[CommonTool cleanNULL:_XmlArray[@"PNAME"]]];
        
        cell.ThirdLab.text=[NSString stringWithFormat:@"出厂日期： %@",[CommonTool daFormatByComment:_XmlArray[@"FACTROYDATE"]]];
        cell.fourLab.text=[NSString stringWithFormat:@"当前位置：%@",  [CommonTool cleanNULL:_XmlArray[@"USEPLACE"]]];
        return cell;
  //[CommonTool cleanNULL:_XmlArray[@"PERSONNAME"]]
        
    }else{
        nineLabViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ninecell"];
        cell.selectionStyle= UITableViewCellSelectionStyleNone;

        cell.firstLab.text=[NSString stringWithFormat:@"客户：%@",[CommonTool cleanNULL:_XmlArray[@"CNAME"]]];
        cell.secondLab.text=[NSString stringWithFormat:@"电话：%@",  [CommonTool cleanNULL:_XmlArray[@"PHONE"]]];
        cell.ThirdLab.text=[NSString stringWithFormat:@"传真： %@",  [CommonTool cleanNULL:_XmlArray[@"FAX"]]];
        cell.fourLab.text=[NSString stringWithFormat:@"邮编: %@", [CommonTool cleanNULL:_XmlArray[@"ZIPCODE"]]];
        cell.fiveLab.text=[NSString stringWithFormat:@"地址：%@",[CommonTool cleanNULL:_XmlArray[@"ADDR"]]];
        cell.sixLab.text=[NSString stringWithFormat:@"现场联系人：%@",[CommonTool cleanNULL:_XmlArray[@"LINKER"]]];
        cell.sevenLab.text=[NSString stringWithFormat:@"联系电话：%@",  [CommonTool cleanNULL:_XmlArray[@"LINKPHONE"]]];
       
        cell.aintinLab.text=[NSString stringWithFormat:@"售出日期：%@", [CommonTool daFormatByComment:_XmlArray[@"SALETIME"]]];
        cell.nineLab.text=[NSString stringWithFormat:@"销售人员：%@", [CommonTool cleanNULL:_XmlArray[@"PERSONNAME"]]];
        return cell;
    
        
    
    }
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.row==0?100:225;



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
