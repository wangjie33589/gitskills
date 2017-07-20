//
//  SenceChoice_erea_device_pancel_VC.m
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/7/18.
//
//

#import "SenceChoice_erea_device_pancel_VC.h"

@interface SenceChoice_erea_device_pancel_VC ()<UITableViewDelegate,UITableViewDataSource>{
   NSMutableArray *_ereaArray;
   NSMutableArray *_deviceArray;
  NSMutableArray *_PancelArray;
    NSDictionary *_fromDic;
    NSString *title_str;
  NSArray *_seekArray;
    NSMutableArray *_bridgeArray;
    

}
@property(nonatomic,assign)int currDeviceRow;
@property(nonatomic,assign)int currPancelRow;

@end

@implementation SenceChoice_erea_device_pancel_VC
-(instancetype)initWithADic:(NSDictionary *)aDic AndTitle:(NSString *)title{


    self=[super init];
    if (self) {
        _fromDic=aDic;
        title_str=title;
        
        NSLog(@"fromFic v=======%@",_fromDic);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=title_str;
    //[self requestSeek];
    _ereaArray =[NSMutableArray array];
      _PancelArray =[NSMutableArray array];
    _deviceArray=[NSMutableArray array];

    UIBarButtonItem *leftBtn =[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(goBackBtnClick)];
    self.navigationItem.leftBarButtonItem=leftBtn;
    [self requestForArea];
    
    self.first_table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.second_table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.Third_table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initTableView];
}
-(void)initTableView{
    self.first_table.delegate=self;
    self.second_table.delegate=self;
    self.Third_table.delegate=self;
    self.first_table.dataSource=self;
    self.second_table.dataSource=self;
    self.Third_table.dataSource=self;
  

}

-(void)goBackBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (tableView==self.first_table) {
        return _ereaArray.count;
    }else if (tableView==self.second_table){
    
        return _deviceArray.count;
    
    
    }else{
        
        if ([title_str isEqualToString:@"添加执行单元"])
             return _PancelArray.count;
        else
       
            return _PancelArray.count;
 
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIder =@"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIder];
    if (cell==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIder];//#BABABA
    }
//    UIColor *color = [[UIColor alloc]initWithCIColor:[CommonTool colorWithHexString:@"#F5F5F5"]];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor =[UIColor whiteColor];
//    cell.backgroundColor = [CommonTool colorWithHexString:@"#F5F5F5"];
       cell.textLabel.font=[UIFont systemFontOfSize:14];
    cell.selectedTextColor = [CommonTool colorWithHexString:@"#39C8FD"];
    if (tableView==self.first_table) {
     
       cell.textLabel.text=_ereaArray[indexPath.row][@"areaname"];
        cell.backgroundColor = [CommonTool colorWithHexString:@"#F5F5F5"];
    }else if (tableView==self.second_table){
        cell.textLabel.text=_deviceArray[indexPath.row][@"devicename"];
        cell.backgroundColor = [CommonTool colorWithHexString:@"#EFEFEF"];
    }else{
//        cell.textLabel.textColor=[CommonTool colorWithHexString:@"#00FFFF"];
        cell.textLabel.text=_PancelArray[indexPath.row][@"name"];
        cell.backgroundColor = [CommonTool colorWithHexString:@"#F5F5F5"];
    
    
    }
 
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    static NSString *cellIder =@"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIder];
    if (cell==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIder];//#BABABA
    }
    
  
    if (tableView==_first_table) {
        //[_deviceArray removeAllObjects];
        [_PancelArray removeAllObjects];
     
        if (_ereaArray.count>0&&indexPath.row<_ereaArray.count) {
            [self requestShowDataWithAdic:_ereaArray[indexPath.row]];

        }
        
        
        
    }else if (tableView==_second_table){
        if (_deviceArray.count>0&&indexPath.row<_deviceArray.count) {
            self.currDeviceRow=indexPath.row;
            
            [self requestShowPancelWithAdic:_deviceArray[indexPath.row]];

        }
      
    
    }else{
        if (indexPath.row<_deviceArray.count&&indexPath.row<_PancelArray.count) {
            self.currPancelRow=indexPath.row;
            if ([title_str isEqualToString:@"添加执行单元"]) {
                [self requestAddExe];
            }else if([title_str isEqualToString:@"添加动作单元"]){
                [self  requestAddAction];
                
            }

        }
        
        //[self requestShowPancelWithAdic:_PancelArray[indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIder =@"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIder];
    if (cell==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIder];//#BABABA
    }
//    [self btnActionForUserSetting1:self];
    cell.textLabel.textColor = [UIColor blackColor];
}


// 请求区域
-(void)requestForArea{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10408\",\"serverid\":\"%@\",\"userid\":\"%@\",\"isadmin\":\"%@\"}",SERVERID,USER_ID,@"1"];
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            
            //[_ereaArray addObject:dictt[@"DATA"]];
              _ereaArray=[NSMutableArray arrayWithArray:dictt[@"DATA"]];
            NSDictionary *DIC =[NSDictionary dictionaryWithObjectsAndKeys:@"",@"id",@"未分区",@"areaname",@"",@"areaimg",@"1",@"serverid", nil];
            [_ereaArray insertObject:DIC atIndex:0];

            [self.first_table reloadData];
            
                      }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
    
    
}
//请求设备
-(void)requestShowDataWithAdic:(NSDictionary*)myDic{
      NSString *myUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10405\",\"serverid\":\"%@\",\"areaid\":\"%@\",\"userid\":\"%@\",\"isadmin\":\"1\"}",SERVERID,myDic[@"id"],USER_ID];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:myUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            //_AreaArray=dictt[@"DATA"];
           _deviceArray=[NSMutableArray arrayWithArray:dictt[@"DATA"]];
            
           // [self requestSeek];
        NSLog(@"_AreaArray====%@",_deviceArray);
            [self.second_table reloadData];
            [self.Third_table reloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
}

//请求设备开关相关数据
-(void)requestShowPancelWithAdic:(NSDictionary*)myDic{
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10400\",\"deviceid\":\"%@\"}",myDic[@"id"]];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            //_AreaArray=dictt[@"DATA"];
            //_showArray=dictt[@"DATA"];
            //NSLog(@"_AreaArray====%@",_AreaArray);
            //[self.myTable reloadData];
            _bridgeArray=dictt[@"DATA"];
           
            [_PancelArray removeAllObjects];
            
            
            
            for (int i=0; i<_bridgeArray.count; i++) {
                
                if ([_bridgeArray[i][@"type"]integerValue]==1) {
                    
                    [_PancelArray  addObject:_bridgeArray[i]];
                   // [_numberArray addObject:_showArray[i][@"value"]];
                    
                }
                
                
            }
            
//            
//            NSLog(@"_pancellarray====%@",_pancelArray);
//            NSLog(@"_regidterArry====%@",_registerArray);
            
            [self.Third_table reloadData];
            
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
    
    
}
//添加执行单元
-(void)requestAddExe{
    
    //    NSString *urlstring=[NSString stringWithFormat:@"http://%@/?jsonrequest={\"funcode\":\"10400\",\"deviceid\":\"%@\"}",HTTPIP,_fromDic[@"id"]];
    
    // NSLog(@"urlstring======%@",urlstring);
    //    NSString *newurlString=[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10507\",\"sceneid\":\"%@\",\"hostsceneid\":\"%@\",\"scenetype\":\"%@\",\"deviceid\":\"%@\",\"addr\":\"%@\",\"onstatus\":\"%@\",\"delaytime\":\"%@\",\"typecode\":\"%@\",\"actuserid\":\"%@\",\"serverid\":\"%@\"}",_fromDic[@"id"],@"",_fromDic[@"typecode"],_deviceArray[_currDeviceRow][@"id"],_PancelArray[_currPancelRow][@"addr"],@"1",@"0",@"1",USER_ID,_fromDic[@"serverid"]];
    
    NSLog(@"urlstr====%@",urlstring);
    
    
    
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            [SVProgressHUD showSuccessWithStatus:dictt[@"MSG"]];
            if ([title_str isEqualToString:@"添加执行单元"]) {
                [_PancelArray removeObjectAtIndex:self.currPancelRow];
                [self.Third_table reloadData];
                
            }            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            //_AreaArray=dictt[@"DATA"];
            //_showArray=dictt[@"DATA"];
            //NSLog(@"_AreaArray====%@",_AreaArray);
            //[self.myTable reloadData];
//            _PancelArray=[NSMutableArray arrayWithArray:dictt[@"DATA"]];
            //[self.Third_table reloadData];
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
    
    
}


//添加为动作单元
-(void)requestAddAction{
    
    //    NSString *urlstring=[NSString stringWithFormat:@"http://%@/?jsonrequest={\"funcode\":\"10400\",\"deviceid\":\"%@\"}",HTTPIP,_fromDic[@"id"]];
    
    // NSLog(@"urlstring======%@",urlstring);
    //    NSString *newurlString=[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10509\",\"sceneid\":\"%@\",\"hostsceneid\":\"%@\",\"scenetype\":\"%@\",\"deviceid\":\"%@\",\"addr\":\"%@\",\"onstatus\":\"%@\",\"delaytime\":\"%@\",\"typecode\":\"%@\",\"actuserid\":\"%@\",\"serverid\":\"%@\"}",_fromDic[@"id"],@"",_fromDic[@"typecode"],_deviceArray[_currDeviceRow][@"id"],_PancelArray[_currPancelRow][@"addr"],@"1",@"0",@"2",USER_ID,_fromDic[@"serverid"]];
       NSLog(@"urlstr====%@",urlstring);
    
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
          [SVProgressHUD showSuccessWithStatus:dictt[@"MSG"]];
            
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            //_AreaArray=dictt[@"DATA"];
            //_showArray=dictt[@"DATA"];
            //NSLog(@"_AreaArray====%@",_AreaArray);
            //[self.myTable reloadData];
//            _PancelArray=[NSMutableArray arrayWithArray:dictt[@"DATA"]];
//            [self.Third_table reloadData];
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
    
    
}
//查询执行单元已关联场景开关(过滤已经关联了场景的开关)
-(void)requestSeek{
    
    //    NSString *urlstring=[NSString stringWithFormat:@"http://%@/?jsonrequest={\"funcode\":\"10400\",\"deviceid\":\"%@\"}",HTTPIP,_fromDic[@"id"]];
    
    // NSLog(@"urlstring======%@",urlstring);
    
    
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10512\",\"sceneid\":\"%@\",\"typecode\":\"%@\"}",_fromDic[@"id"],@"1"];
    
    NSLog(@"urlstr====%@",urlstring);
    
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            //[SVProgressHUD showSuccessWithStatus:@"操作成功!"];
            _seekArray =dictt[@"DATA"];
            NSLog(@"seekArray====%@",_seekArray);
            NSLog(@"devicearray====%@",_deviceArray);
            
            for (int i=0; i<_seekArray.count; i++) {
                
                if ([_seekArray[i][@"type"]integerValue]==1) {
                    
                    [_PancelArray addObject:_seekArray[i]];
                    //[_numberArray addObject:_seekArray[i][@"value"]];
                    
                }
                
            }
            

            
            
            _PancelArray =[self filerateWithArray:_bridgeArray andArray:(NSArray*)_seekArray];
//            [self.second_table reloadData];
//            [self.Third_table reloadData];
            
            NSLog(@"lastArray===%@",_PancelArray);
            
            [self.Third_table reloadData];
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            //_AreaArray=dictt[@"DATA"];
            //_showArray=dictt[@"DATA"];
            //NSLog(@"_AreaArray====%@",_AreaArray);
            //[self.myTable reloadData];
            //            _PancelArray=[NSMutableArray arrayWithArray:dictt[@"DATA"]];
            //[self.Third_table reloadData];
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
    
    
}
//过滤数组
-(NSMutableArray*)filerateWithArray:(NSArray*)arr1 andArray:(NSArray*)arr2{
    if (arr1.count==0) {
        return (NSMutableArray*)arr1;
    }
        NSString *deviceid =arr1[0][@"deviceid"];
    NSMutableArray *deviceIDArray =[NSMutableArray array];
    for (int i=0; i<arr2.count; i++) {
        [deviceIDArray addObject:arr2[i][@"deviceid"]];
    }
    
    if ([deviceIDArray containsObject:deviceid]) {
        NSMutableDictionary *Arr1dict=[NSMutableDictionary dictionary];
        
        for (int i=0; i<arr1.count-5; i++) {
            //        NSDictionary *dict =[NSDictionary dictionaryWithObject:arr1[i] forKey:arr1[i][@"deviceid"]];
            
            NSString *key =[NSString stringWithFormat:@"%@/%@",arr1[i][@"deviceid"],arr1[i][@"addr"]];
            [Arr1dict setObject:arr1[i] forKey:key];
                    }
        NSArray *keyarray= [Arr1dict allKeys];
        
        
        NSMutableArray *deviceidAarray=[NSMutableArray array];
        for (int i=0; i<arr2.count; i++) {
            NSString *key=[NSString stringWithFormat:@"%@/%@",arr2[i][@"deviceid"],arr2[i][@"addr"]];
            
            [deviceidAarray addObject:key];
        }
        
        NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",deviceidAarray];
        
        NSArray * filter = [keyarray filteredArrayUsingPredicate:filterPredicate];
        NSLog(@"%@",filter);
        
        NSMutableArray *lastArray =[NSMutableArray array];
        for (int i=0; i<filter.count; i++) {
            NSDictionary *dict =[Arr1dict objectForKey:filter[i]];
            [lastArray addObject:dict];
        }
        
        return lastArray;

    }else{
        NSMutableArray *lastArray =[NSMutableArray array];

        for (int i =0; i<arr1.count-5; i++) {
            [lastArray addObject:arr1[i]];
            
        }
        
        return  lastArray;
      }
   
}


@end
