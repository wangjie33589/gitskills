//
//  Area_Detil_ViewController.m
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/6/29.
//
//

#import "Area_Detil_ViewController.h"
#import "TypeDetilTableViewCell.h"
#import "TppeDetil_twoViewController.h"
@interface Area_Detil_ViewController ()<UITableViewDelegate,UITableViewDataSource>{

    NSDictionary *_fromDic;
    NSArray *_showArray;

}

@end

@implementation Area_Detil_ViewController
-(id)initWithDic:(NSDictionary*)aDic{
    
    self =[super init];
    if (self) {
        _fromDic =aDic;
        
        
        
        NSLog(@"_fromDic=====%@",_fromDic);
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
         self.navigationController.navigationBarHidden=NO;
    [self requestShowData];
    [self initTableView];
//    [Singleton sharedInstance].socketHost = @"10.1.48.53";// host设定
//    [Singleton sharedInstance].socketPort = 9999;// port设定
//    
//    // 在连接前先进行手动断开
//    [Singleton sharedInstance].socket.userData = SocketOfflineByUser;
//    [[Singleton sharedInstance] cutOffSocket];
//    
//    // 确保断开后再连，如果对一个正处于连接状态的socket进行连接，会出现崩溃
//    [Singleton sharedInstance].socket.userData = SocketOfflineByServer;
//    [[Singleton sharedInstance] socketConnectHost];
   
}
-(void)initTableView{

    self.myTable.delegate=self;
    self.myTable.dataSource=self;
     [self.myTable registerNib:[UINib nibWithNibName:@"TypeDetilTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    


}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _showArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TypeDetilTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    //    cell.img.image=[UIImage imageNamed:@"2"];
    //    cell.firstLab.text=_titleArray[indexPath.row];
    //    cell.secondLab.text=[NSString stringWithFormat:@"六键开关      大厅"];
    //    ／／lamp_on lamp_off
    
    cell.titleLab.text=_showArray[indexPath.row][@"devicename"];
    
    if ([_showArray[indexPath.row][@"status"]integerValue]==1) {
        cell.imgView.image=[UIImage imageNamed:@"lamp_off"];
    }else{
        cell.imgView.image=[UIImage imageNamed:@"lamp_on"];
    }
    
    NSString *areaname ;
    if (_showArray[indexPath.row][@"areaname"] ==[NSNull null]) {
        areaname=@"未分区";
        
    }else{
        areaname=_showArray[indexPath.row][@"areaname"];
    
    }
    cell.rightlab.text =[NSString stringWithFormat:@"%@  %@  ",_showArray[indexPath.row][@"typename"],areaname];
    
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TppeDetil_twoViewController *vc =[[TppeDetil_twoViewController alloc]initWithDic:_showArray[indexPath.row] andArr:_showArray];
    self.sectionDeledate = vc;//设置了代理
    [self.sectionDeledate sendTrendDatas:_showArray[indexPath.row][@"status"]];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    
}

-(void)requestShowData{
    
    NSString *myUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring;
    if ([[_fromDic allKeys]containsObject:@"shortcutid"]) {
       urlstring =[NSString stringWithFormat:@"{\"funcode\":\"10405\",\"serverid\":\"%@\",\"areaid\":\"%@\",\"userid\":\"%@\",\"isadmin\":\"1\"}",SERVERID,_fromDic[@"shortcutid"],USER_ID];
    }else{
    
  
     urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10405\",\"serverid\":\"%@\",\"areaid\":\"%@\",\"userid\":\"%@\",\"isadmin\":\"1\"}",SERVERID,_fromDic[@"id"],USER_ID];

    }
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:myUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            //_AreaArray=dictt[@"DATA"];
            _showArray=dictt[@"DATA"];
            
            
            //NSLog(@"_AreaArray====%@",_AreaArray);
            [self.myTable reloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
 }




@end
