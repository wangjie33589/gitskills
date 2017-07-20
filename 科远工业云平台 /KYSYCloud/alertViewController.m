//
//  alertViewController.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/19.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "alertViewController.h"
#import "SixTableViewCell.h"

@interface alertViewController ()<UITableViewDataSource,UITableViewDelegate>{


    NSString *_dataStr;
    NSString *_NumberStr;
    NSString *_PersonStr;
    NSDictionary *_XMLDic;
    NSArray * _XmlArray;
    NSDictionary *_dpArray;
    
}

@end

@implementation alertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"报警提醒" ;
    UIBarButtonItem *rightBtn =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"leftImag"] style:UIBarButtonItemStylePlain target:self action:@selector(btnClick)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    [self initTableView];
    
}
-(void)initTableView{
    self.myTabel.delegate=self;
    self.myTabel.dataSource=self;
    [self.myTabel registerNib:[UINib nibWithNibName:@"SixTableViewCell" bundle:nil] forCellReuseIdentifier:@"CELL"];

    self.myTabel .rowHeight=150;
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    
    //实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
    _dataStr=[dateFormat stringFromDate:[NSDate date]];
    NSLog(@"_DataStr===%@",_dataStr);
    _PersonStr=@"";
    _NumberStr=@"";
    
    [self Search];



}
#pragma mark====表代理
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return  _XmlArray.count;


}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    SixTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"CELL"];
    cell.firstLab.text=[NSString stringWithFormat:@"故障时间:%@~%@",[CommonTool DataFormart:_XmlArray[indexPath.row][@"BTIME"]],[CommonTool DataFormart:_XmlArray[indexPath.row][@"ETIME"]]];
    cell.secondlab.text=[NSString stringWithFormat:@"持续时间:%@",_XmlArray[indexPath.row][@"TOTALSECONDS"]];
    cell.ThirldLab.text=[NSString stringWithFormat:@"故障代码:%@",_XmlArray[indexPath.row][@"ERRCODE"]];
    cell.fourLab.text=[NSString stringWithFormat:@"故障描述:%@",_XmlArray[indexPath.row][@"ALARMDESC"]];
    cell.fivelab.text=[NSString stringWithFormat:@"设备编号:%@",_XmlArray[indexPath.row][@"TAGNAME"]];
    
    return cell;


}
    

    
-(void)btnClick{
 
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:@"结束日期" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert.view addSubview:datePicker];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"设备编号";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"客户名称";
        
    }];
    
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"查询" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        
        //实例化一个NSDateFormatter对象
        
        [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
        
        NSString *dateString = [dateFormat stringFromDate:datePicker.date];
        
        //求出当天的时间字符串
        _dataStr=dateString;
        _PersonStr=alert.textFields[1].text;
        _NumberStr=alert.textFields[0].text;
        [self Search];
        
        
    }];
    
       [alert addAction:ok];
    
     [self presentViewController:alert animated:YES completion:^{ }];

}

-(void)Search{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    
    NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETALARM</Action><USERID>%@</USERID><PWD>%@</PWD><ETIME>%@</ETIME><DID>%@</DID><CNAME>%@</CNAME></Data>",USER_NAME,PASSWORD,_dataStr,_NumberStr,_PersonStr];
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlString];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            _XMLDic=[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            _XmlArray=_XMLDic[@"R"];
            [self.myTabel reloadData];
            
            
            NSLog(@"_XMLDic======%@",_XMLDic);
            
            
            
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
        
        
    };

    
}
-(void)requestShowDiviceItem{
    NSString *xmlString=@"";
    
    for (int i=0; i<_XmlArray.count; i++) {
     xmlString=[NSString stringWithFormat:@"<Data><Action>GETDEVICEPART</Action><USERID>%@</USERID><PWD>%@</PWD><DGUID>%@</DGUID></Data>",USER_NAME,PASSWORD,_XmlArray[i][@"DGUID"]];
        
    }
  
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlString];
    manger.backSuccess=^void(NSDictionary *dictt){
        
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            _XMLDic=[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            
            
            
            _dpArray=_XMLDic[@"R"];
            //     [_XmlArray addObject:_SetDic];
            //            [self initMenu];
            NSLog(@"dpAyyau;+++%@",_dpArray);
            [self.myTabel reloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
        
        
    };
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   }


@end
