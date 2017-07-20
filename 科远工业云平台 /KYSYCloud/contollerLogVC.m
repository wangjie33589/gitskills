//
//  contollerLogVC.m
//  KYSYCloud
//
//  Created by SciyonSoft_WangJie on 16/4/11.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "contollerLogVC.h"
#import "equipCheckCell.h"

@interface contollerLogVC ()<UITableViewDataSource,UITableViewDelegate>{

    NSDictionary *_fromDic;
    NSMutableDictionary *  _XMLDic;
    NSMutableArray * _XmlArray;
    NSMutableDictionary *_showDic;
    NSInteger state;
    NSDictionary *_detilDic;
    
    BOOL firstBool;
    BOOL secondboll;
    NSString *_begintime;
    NSString *_endtime;
    int type;
    

}

@end


@implementation contollerLogVC
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
    firstBool=NO;
    secondboll=NO;
    type=0;
  self.title=@"操作日志";
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    [self.myTable registerNib:[UINib nibWithNibName:@"equipCheckCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    self.myTable.rowHeight=125;
}
- (IBAction)btnClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:
        {
            type=0;
            [self.dayBtn setBackgroundImage:[UIImage imageNamed:@"home_write_caogao_1.png"] forState:0];
            
             [self.mounthbtn setBackgroundImage:[UIImage imageNamed:@"home_write_caogao.png"] forState:0];
            [self.firstBtn setTitle:@"上一天" forState:0];
            [self.secondbtn setTitle:@"当天" forState:0];
            [self.ThirdBtn setTitle:@"下一天" forState:0];
        
        }
            break;
        case 1:{
            type=1;
            [self.mounthbtn setBackgroundImage:[UIImage imageNamed:@"home_write_caogao_1.png"] forState:0];
            [self.dayBtn setBackgroundImage:[UIImage imageNamed:@"home_write_caogao.png"] forState:0];
            [self.firstBtn setTitle:@"上一月" forState:0];
            [self.secondbtn setTitle:@"当月" forState:0];
            [self.ThirdBtn setTitle:@"下一月" forState:0];
        
        }break;
        case 2:{
            if (type==0) {
            
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *now = [NSDate date];
                NSCalendar *cal = [NSCalendar currentCalendar];
//                NSRange range =[cal  rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]];
               // NSInteger numberOfDaysInMonth=range.length;
                NSDateComponents *comps = [cal
                                           components:NSYearCalendarUnit | NSMonthCalendarUnit|NSCalendarUnitDay
                                           fromDate:now];

                NSDateFormatter* dayformoter = [[NSDateFormatter alloc] init];
                [dayformoter setDateFormat:@"dd"];
                int i =[[formatter stringFromDate:[NSDate date]]intValue];
                
                comps.day = i;
            NSDate *nowDay =[cal dateFromComponents:comps];
            _begintime = [formatter stringFromDate:nowDay];
                _endtime=[formatter stringFromDate:nowDay];
                        i++;

               
            //以上这个是获取当前时间差的date的 其中 year=1表示1年后的时间 year=-1为1年前的日期 month day 类推

                
                
                
                
            }else{
                
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *now = [NSDate date];
                NSCalendar *cal = [NSCalendar currentCalendar];
                NSRange range =[cal  rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]];
                NSInteger numberOfDaysInMonth=range.length;
                NSDateComponents *comps = [cal
                                           components:NSYearCalendarUnit | NSMonthCalendarUnit
                                           fromDate:now];
                NSDateFormatter* dayformoter = [[NSDateFormatter alloc] init];
                [dayformoter setDateFormat:@"dd"];
                int i =[[formatter stringFromDate:[NSDate date]]intValue];
                comps.month = i;
                i++;
                comps.day = 1;
                NSDate *firstDay = [cal dateFromComponents:comps];
              _begintime=[formatter stringFromDate:firstDay];
                comps.day=numberOfDaysInMonth;
             _endtime = [formatter stringFromDate:[NSDate date]];
                
            }
            
            
            [self requestInfo];
            
            
             }break;
        case 3:{
            if (type==0) {
                
                NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                _begintime =[formatter stringFromDate:[NSDate date]];
                _endtime =[formatter stringFromDate:[NSDate date]];
         

            }else{
                
                NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                _begintime =[formatter stringFromDate:[NSDate date]];
                _endtime =[formatter stringFromDate:[NSDate date]];

            }

            
                   [self requestInfo];
             
             }break;
        case 4:{
            if (type==0) {
                NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                _begintime =[formatter stringFromDate:[NSDate date]];
                _endtime =[formatter stringFromDate:[NSDate date]];

            }else{
                NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                _begintime =[formatter stringFromDate:[NSDate date]];
                _endtime =[formatter stringFromDate:[NSDate date]];

                
            }

                   [self requestInfo];
            
             
             }break;
        case 5:{
            UIAlertController *controller =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action =[UIAlertAction actionWithTitle:@"所有" style:0 handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [controller addAction:action];
            
            [self presentViewController:controller animated:YES completion:nil];
            
            
        }break;
            
    }
}


-(void)requestInfo{
    
  
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    
    NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETCMDLOG</Action><USERID>%@</USERID><PWD>%@</PWD><DGUID>%@</DGUID><DCGUID>%@</DCGUID><BTIME>%@</BTIME><ETIME>%@</ETIME></Data>",USER_NAME,PASSWORD,_fromDic[@"DGUID"],_fromDic[@"DCGUID"],_begintime,_endtime];
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlString];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            _XMLDic=(NSMutableDictionary*)[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            _XmlArray=_XMLDic[@"R"];
        
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
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    equipCheckCell *cell =[tableView dequeueReusableCellWithIdentifier:@"CELL"];
    cell.firstLab.text =[NSString stringWithFormat:@"操作时间:%@",@""]
    ;
    cell.secondLab.text=[NSString stringWithFormat:@"操作命令:%@",@""];
     cell.ThirdLab.text=[NSString stringWithFormat:@"操作命令:%@",@""];
     cell.fourLab.text=[NSString stringWithFormat:@"操作命令:%@",@""];
    
    return cell;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
