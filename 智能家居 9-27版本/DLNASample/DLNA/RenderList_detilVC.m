//
//  RenderList_detilVC.m
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/6/20.
//
//

#import "RenderList_detilVC.h"
#import "upnpSetTableViewCell.h"
#import "AppDelegate.h"
#import <CyberLink/UPnPAV.h>
#import "UPnPDeviceTableViewCell.h"
#import "RenderList_detilVC.h"
#import "infoVc.h"



@interface RenderList_detilVC ()<UITableViewDataSource,UITableViewDelegate>{

     NSMutableArray *_showArray;
    NSDictionary *_firstDic;
    NSDictionary *_secondDic;
    NSDictionary *_infoDic;
    NSTimer *_timer;


}

@end

@implementation RenderList_detilVC
@synthesize dataSource = _dataSource;



- (id)initWithAvController:(CGUpnpAvController*)aController
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.dataSource = [aController renderers];
        
        NSLog(@"seldDataSource======%@",self.dataSource);
    
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_timer invalidate];
    _timer=nil;

}

- (void)viewDidLoad {
    [super viewDidLoad];
      [SVProgressHUD showWithStatus:@"正在搜索设备，请稍后..."];
    
        [self initTableView];
    CGUpnpAvController* avCtrl = [[CGUpnpAvController alloc] init];
    avCtrl.delegate = self;
    [avCtrl search];
    self.avController = avCtrl;

     self.ipArray =[NSMutableArray array];
    self.DeviceNameArr=[NSMutableArray array];
    _showArray=[NSMutableArray array];
    _timer =[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timer) userInfo:nil repeats:YES];
    
   

   
    
   // [self initTableView];
    NSLog(@"iparray====%@",self.ipArray);
    
    NSLog(@"asdsdfsd=====%@",_showArray);
    
}
-(void)timer{
    [self.myTable reloadData];
    
   

}
-(void)initTableView{
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    [self.myTable registerNib:[UINib nibWithNibName:@"upnpSetTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
   self.myTable.rowHeight=100;
   }

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    upnpSetTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    int row = [indexPath indexAtPosition:1];
    
    
    NSLog(@"row=======%d",row);
    if (row < [self.dataSource count]) {
        CGUpnpDevice *device = [self.dataSource objectAtIndex:row];
       
        
        [cell.iconBtn addTarget:self action:@selector(ConnectWifi:) forControlEvents:UIControlEventTouchUpInside];
        cell.iconBtn.tag=indexPath.row;

        cell.mySlider.continuous=YES;
        
       // cell.mySlider.value=[_showArray[indexPath.row][@"vol"]floatValue];
        cell.mySlider.tag=indexPath.row+100;
        cell.mySlider.maximumValue=100;
        cell.mySlider.minimumValue=0;
        
       // NSLog(@"[_showArray[indexPath.row][@"vol"]floatValue]====%f",[_showArray[indexPath.row][@"vol"]floatValue]);
        
        
        [cell.mySlider addTarget:self action:@selector(_actionSliderProgress:) forControlEvents:UIControlEventTouchUpInside];
        cell.setBtn.tag=indexPath.row;
        [cell.setBtn addTarget:self action:@selector(setBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell setDevice:device];
    }
    return cell;
}

//设置按钮
-(void)setBtnClick:(UIButton*)sender{
       NSString *ipAdder =self.ipArray[sender.tag];
        UIAlertController *alertControler =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *renameAction =[UIAlertAction actionWithTitle:@"重命名" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController  *renameControler =[UIAlertController alertControllerWithTitle:@"重命名" message:nil preferredStyle:UIAlertControllerStyleAlert];
       [renameControler addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
           
       }];
        UIAlertAction *confirm =[UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
            
            //给设备重命名
            NSString *string= renameControler.textFields[0].text;
            [self requestForReame:string WithIp:ipAdder];
        }];
        UIAlertAction *cacel =[UIAlertAction actionWithTitle:@"取消" style:1 handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [renameControler addAction:cacel];
        [renameControler addAction:confirm];
        [self presentViewController:renameControler animated:YES completion:nil];
        

        
    }];
UIAlertAction *devicceInfo =[UIAlertAction actionWithTitle:@"设备信息" style:0 handler:^(UIAlertAction * _Nonnull action) {
    infoVc *vc =[[infoVc alloc]initWithIp:ipAdder];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}];
UIAlertAction *cacel =[UIAlertAction actionWithTitle:@"取消" style:1 handler:^(UIAlertAction * _Nonnull action) {
   // [self requestForInfowithIP:ipAdder];
    
}];
    
    [alertControler addAction:renameAction];
    [alertControler addAction:devicceInfo];
    [alertControler addAction:cacel];

    [self presentViewController:alertControler animated:YES completion:nil];
    



}


//给设备重命名

-(void)requestForReame:(NSString*)rename WithIp:(NSString*)ipAddress{
    NSString *newname =[rename stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@setDeviceName:%@",ipAddress,AUDIO_IP,newname]];
    
    NSLog(@"rename=====%@",[NSString stringWithFormat:@"http://%@%@setDeviceName:%@",ipAddress,AUDIO_IP,newname]);
    
    
    
    
    manger.backSuccess=^void(NSDictionary *dictt){
        
        
        
        [SVProgressHUD  showSuccessWithStatus:@"操作成功"];
               [self.myTable reloadData];
        
    };







}
-(void)requestForPlayStstus{
   //__block NSString *backStr=@"";
    for (int i =0; i<self.ipArray.count; i++) {
        MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@getPlayerStatus",self.ipArray[i],AUDIO_IP]];
        
        manger.backSuccess=^void(NSDictionary *dictt){
            //for (int i =0; i<self.ipArray.count; i++) {
                UISlider *slider =(UISlider *)[self.view viewWithTag:i+100];
                slider.value =[dictt[@"vol"]floatValue];
            //}
            [SVProgressHUD dismiss];
               // [self.myTable reloadData];
        };
        
        
    }
    
    
    
}
//调节音量
- (void)_actionSliderProgress:(UISlider*)sender
{
    
    NSLog(@"value=======%f",sender.value);
    NSString *iparrderssss=self.ipArray[sender.tag-100];
    
    
    [self  requestToChangeValue:sender.value withIpAddress:iparrderssss];
    
    //[_audioPlayer seekToTime:_audioPlayer.duration * _progressSlider.value];
}

//获取当前播放状态
//调节音量
-(void)requestToChangeValue:(NSInteger)value withIpAddress:(NSString*)ipAdderss{
    
    //http://10.10.10.254/httpapi.asp?command=setPlayerCmd:vol:value
    
    NSLog(@"http========%@",[NSString stringWithFormat:@"http://%@%@setPlayerCmd:vol:%d",ipAdderss,AUDIO_IP,value]);
    
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@setPlayerCmd:vol:%d",ipAdderss,AUDIO_IP,value]];
    
    
    
    // NSLog(@"fhsgdhfd====%@",[NSString stringWithFormat:@"http://%@%@%@",iparrderssss,AUDIO_IP,@"wlanGetConnectState"]);
    //        MyRequest *manger =[MyRequest requestWithURL:@"http://%@/httpapi.asp?command=setPlayerCmd:playlist:http://192.168.1.103/WebFrame/TempImages/GoTime.mp3:%3c0%3e"];
    manger.backSuccess=^void(NSDictionary *dictt){
        
        //
        //        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"已成功连接%@!", self.DeviceNameArr[row]]];
        //        //chongdian  chongdjain  chongdjain  chongdjain
        //
        //
        //        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:iparrderssss,@"nowIP", nil];
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"连接设备" object:nil userInfo:dict];
        
        
    };
    
    
    
    
}

//连接设备

-(void)ConnectWifi:(UIButton*)btn{
    
    [self requestWithRow:(NSInteger)btn.tag];
    


}
-(void)requestWithRow:(NSInteger)row{
    NSString *iparrderssss=@"";
    
    if (self.ipArray.count>0&&self.ipArray.count<row+1) {
        iparrderssss=self.ipArray[row];
    }
   
    

               MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@%@",iparrderssss,AUDIO_IP,@"wlanGetConnectState"]];
    
    
    
    NSLog(@"fhsgdhfd====%@",[NSString stringWithFormat:@"http://%@%@%@",iparrderssss,AUDIO_IP,@"wlanGetConnectState"]);
//        MyRequest *manger =[MyRequest requestWithURL:@"http://%@/httpapi.asp?command=setPlayerCmd:playlist:http://192.168.1.103/WebFrame/TempImages/GoTime.mp3:%3c0%3e"];
        manger.backSuccess=^void(NSDictionary *dictt){
           
            if (_DeviceNameArr.count>0&&_DeviceNameArr.count<row+1) {
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"已成功连接%@!", self.DeviceNameArr[row]]];
                

                
            }
            
            
            NSLog(@"yijingchenggong;iangjie=====%@",[NSString stringWithFormat:@"已成功连接%@!", self.DeviceNameArr[row]]);
            //chongdian  chongdjain  chongdjain  chongdjain
            
            
            NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:iparrderssss,@"nowIP", nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"连接设备" object:nil userInfo:dict];
        
        
        };
    



}
#pragma mark CGUpnpControlPointDelegate
-  (void) controlPoint: (CGUpnpControlPoint *) controlPoint deviceAdded: (NSString *) deviceUdn;{


}
- (void)controlPoint:(CGUpnpControlPoint *)controlPoint deviceUpdated:(NSString *)deviceUdn {
    NSLog(@"%@", deviceUdn);
    //[SVProgressHUD showWithStatus:@"正在搜索设备，请稍后..."];
    self.avController = (CGUpnpAvController*)controlPoint;
    
    //self.dataSource = [controlPoint devices];
    
    // self.renderers =  [((CGUpnpAvController*)controlPoint) servers];
    //self.renderers=[self.avController servers];
    //    NSArray* renderers = [((CGUpnpAvController*)controlPoint) renderers];
    //    if ([renderers count] > 0) {
    //        for (CGUpnpAvRenderer* renderer in renderers) {
    //            NSLog(@"avRendererUDN:%@", [renderer udn]);
    //        }
    //    }
    //[SVProgressHUD showWithStatus:@"正在搜索设备，请稍后..."];
    self.dataSource=[self.avController renderers];
    for (int row=0; row < [self.dataSource count]; row++) {
        CGUpnpDevice *device = [self.dataSource objectAtIndex:row];
        
        [self.ipArray addObject:device.ipaddress];
        
        NSLog(@"device.ipAddress====%@",device.ipaddress);
        
        
        [self.DeviceNameArr addObject:device.friendlyName];
    }
    
    if (self.ipArray.count>0) {
        //[SVProgressHUD dismiss];
        [self requestForPlayStstus];
    }
    //[SVProgressHUD dismiss];

        //self.dataSource = [((CGUpnpAvController*)controlPoint) renderers];
    
    
    
    //    NSLog(@"selfDatta========%@",self.dataSource);
    //    NSLog(@"shdhfhjdf=====%@",self.renderers);
    //int dmsNum = 0;
    //    for (CGUpnpDevice *dev in [controlPoint devices]) {
    //        //NSLog(@"%@:%@", [dev friendlyName], [dev ipaddress]);
    //        if ([dev isDeviceType:@"urn:schemas-upnp-org:device:MediaServer:1"]) {
    ////			PrintDmsInfo(dev, ++dmsNum);
    //            //NSLog(@"#Server:%@", [dev deviceType]);
    //
    //        }
    //        else if([dev isDeviceType:@"urn:schemas-upnp-org:device:MediaRenderer:1"]) {
    //            NSLog(@"#Renderer%@", [dev deviceType]);
    //        }
    //    }
    // [self.tableView reloadData];
}



- (void)controlPoint:(CGUpnpControlPoint *)controlPoint deviceRemoved:(NSString *)deviceUdn
{
    //    NSLog(@"device removed udn %@", deviceUdn);
    //    self.dataSource = [controlPoint devices];
    //    [self.tableView reloa
}

- (IBAction)btnClick:(UIButton *)sender{
    
    
    
    
    
}
@end
