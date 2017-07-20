//
//  infoVc.m
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/8/12.
//
//

#import "infoVc.h"

@interface infoVc ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *_ipString;
    NSDictionary *_InfoDic;
    NSArray *_infoTitleArray;
    NSArray *_setArray;
    NSArray *allArray;
    NSMutableArray *_infoarray;

}

@end

@implementation infoVc
-(id)initWithIp:(NSString *)ipString{
    self=[super init];
    if (self) {
        _ipString=ipString;
    }


    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title=@"设备信息";
    [self requestForInfowithIP:_ipString];
    _infoTitleArray=[[NSArray alloc]initWithObjects:@"音响名称：",@"SSID",@"局域网Ip地址",@"WIFI连接状态",@"Internet访问",@"固件版本",@"发布日期",@"音响提示语言",@"UUID",@"MAC地址", nil
    ];
    _setArray=[[NSArray alloc]initWithObjects:@"无线音响密码",@"恢复出厂日期", nil];
    
    allArray =[[NSArray alloc]initWithObjects:_infoTitleArray,_setArray, nil];
    _infoarray=[NSMutableArray array];
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr=allArray[section];
    if (section==0) {
        return _infoarray.count;
    }else{
        
        
        return arr.count;

    
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell ) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    if (indexPath.section==0) {
        if (allArray.count==_infoarray.count) {
            cell.textLabel.text=[NSString stringWithFormat:@"%@:%@",allArray[indexPath.section][indexPath.row],_infoarray[indexPath.row]];
        }
        
    }else{
    
        cell.textLabel.text=allArray[indexPath.section][indexPath.row];;
    }
    

    return cell;



}

-(void)requestForInfowithIP:(NSString*)ipString{
    
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@getStatus",ipString,AUDIO_IP]];
    NSLog(@"sdgdfff===%@",[NSString stringWithFormat:@"http://%@%@getStatus",ipString,AUDIO_IP]);
    //http://10.1.47.94/httpapi.asp?command=getStatus
    
    //    NSLog(@"rename=====%@",[NSString stringWithFormat:@"http://%@%@setSSID:%@",ipAddress,AUDIO_IP,rename]);
    
    
    
    
    manger.backSuccess=^void(NSDictionary *dictt){
        
        NSLog(@"dictttt====%@",dictt);
        if (dictt!=nil) {
            _InfoDic=dictt;
            
            //[self.myTable reloadData];
            [_infoarray addObject:dictt[@"DeviceName"]];
            [_infoarray addObject:dictt[@"ssid"]];
            [_infoarray addObject:dictt[@"apcli0"]];
            [_infoarray addObject:@"已连接"];
            [_infoarray addObject:@"不能访问"];
            [_infoarray addObject:dictt[@"firmware"]];
            [_infoarray addObject:dictt[@"Release"]];
            [_infoarray addObject:dictt[@"language"]];
            [_infoarray addObject:dictt[@"uuid"]];
            [_infoarray addObject:dictt[@"MAC"]];
            [self.myTable reloadData];

        }
        
    };
    
    
    
    
    
    
    
}

@end
