//
//  KYMusicCollectionTableViewController.m
//  SyncSmartHome
//
//  Created by SciyonSoft_WangJie on 16/6/8.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "KYMusicCollectionTableViewController.h"
#import "DemoViewController.h"
#import "RendererTableViewController.h"


@interface KYMusicCollectionTableViewController ()<UITableViewDataSource,UITableViewDelegate,DropdownMenuControllerDelegate,UIPopoverPresentationControllerDelegate
>
@property (nonatomic, strong) DropdownMenuController *popoVerMenu;
@property (nonatomic, strong) NSDictionary *dataDic;
@end

@implementation KYMusicCollectionTableViewController


- (DropdownMenuController *)popoVerMenu {
    if (!_popoVerMenu) {
        _popoVerMenu = [[DropdownMenuController alloc] init];
        _popoVerMenu.delegate = self;
    }
    return _popoVerMenu;
}
- (NSDictionary *)dataDic {
    if (!_dataDic) {
        _dataDic = @{ @"手机":[UIImage imageNamed:@"person_phone.png"],@"DLNA播放1":[UIImage imageNamed:@"person_phone.png"]
                  
                     
                     };
    }
    return _dataDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"音乐收藏";
    self.navigationItem.title = @"音乐收藏";
   // [self requestForMusicList];
    //icon_5_n
     UIBarButtonItem *rightBtn =[[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(rightBtmClick)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    [self initTableView];
    
    
    
    CGUpnpAvController* avCtrl = [[CGUpnpAvController alloc] init];
    avCtrl.delegate = self;
    [avCtrl search];
    self.avController = avCtrl;
   
}
#pragma mark CGUpnpControlPointDelegate
- (void)controlPoint:(CGUpnpControlPoint *)controlPoint deviceUpdated:(NSString *)deviceUdn {
    NSLog(@"%@", deviceUdn);
    self.avController = (CGUpnpAvController*)controlPoint;
    
    self.dataSource = [controlPoint devices];
    
    // self.renderers =  [((CGUpnpAvController*)controlPoint) servers];
    //self.renderers=[self.avController servers];
    //    NSArray* renderers = [((CGUpnpAvController*)controlPoint) renderers];
    //    if ([renderers count] > 0) {
    //        for (CGUpnpAvRenderer* renderer in renderers) {
    //            NSLog(@"avRendererUDN:%@", [renderer udn]);
    //        }
    //    }
    
    
    self.dataSource=[self.avController renderers];
    //self.dataSource = [((CGUpnpAvController*)controlPoint) renderers];
    
    
    
        NSLog(@"selfDatta========%@",self.dataSource);
        NSLog(@"shdhfhjdf=====%@",self.renderers);
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

- (void)controlPoint:(CGUpnpControlPoint *)controlPoint deviceAdded:(NSString *)deviceUdn
{
    NSLog(@"device added udn %@", deviceUdn);
}

- (void)controlPoint:(CGUpnpControlPoint *)controlPoint deviceRemoved:(NSString *)deviceUdn
{
    //    NSLog(@"device removed udn %@", deviceUdn);
    //    self.dataSource = [controlPoint devices];
    //    [self.tableView reloadData];
}

-(void)rightBtmClick{
    self.popoVerMenu.modalPresentationStyle = UIModalPresentationPopover;
    self.popoVerMenu.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;//箭头方向指向
    self.popoVerMenu.dataDic =self.dataDic;
    
    self.popoVerMenu.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUnknown;//箭头方向,如果是baritem不设置方向，会默认up，up的效果也是最理想的
    self.popoVerMenu.popoverPresentationController.delegate = self;
    [self presentViewController:self.popoVerMenu animated:YES completion:nil];
    
}

-(void)initTableView{

    self.myTable.dataSource=self;
    self.myTable.delegate=self;
  
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
       static NSString *cellider =@"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellider];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellider];
    }
    cell.imageView.image=[UIImage imageNamed:@"role_music_on.png"];
    cell.textLabel.text=@"天空之城";
    
    return cell;



}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DemoViewController *vc =[[DemoViewController alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark doupViewDelegete


- (void)DropdownMenuController:(DropdownMenuController *)dropdownMenuVC withIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
       
    }else{
        
        RendererTableViewController* viewController = [[RendererTableViewController alloc] initWithAvController:self.avController];
        
        [self.navigationController pushViewController:viewController animated:YES];
        
        
        
    }
    
   // NSLog(@"－-> %li",indexPath.row);
}
//popover样式
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;   //点击蒙版popover不消失， 默认yes
}
-(void)requestControlData{
    //       MyRequest *manger =[MyRequest requestWithURL:@"http://10.1.41.38/httpapi.asp?command=getStatus"];
    MyRequest *manger =[MyRequest requestWithURL:@"http://192.168.1.101/httpapi.asp?command=setPlayerCmd:playlist:http://192.168.1.103/WebFrame/TempImages/GoTime.mp3:%3c0%3e"];
    manger.backSuccess=^void(NSDictionary *dictt){
        //chongdian  chongdjain  chongdjain  chongdjain
        
        //        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
        //            _XMLDic=[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
        //            NSLog(@"ghdsgajgjhdfg=====%@",_XMLDic);
        //
        //
        //
        
        //
        //            if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
        //                _PartDic=_XMLDic[@"R"];
        //
        //                [self initSegment];
        //            }else{
        //
        //                _showArray=_XMLDic[@"R"];
        //
        //                [self initSegment];
        //
        //
        //
        //
        //            }
        //            
        //        }else{
        //            
        //            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        //        }
    };
}

-(void)requestForMusicList{


    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"11006\",\"musicfileid\":\"%@\",\"serverid\":\"%@\",\"actuserid\":\"%@\"}",@"",SERVERID,USER_ID];
    NSLog(@"urlstr====%@",urlstring);
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            //[SVProgressHUD showSuccessWithStatus:@"操作成功!"];
            
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


@end
