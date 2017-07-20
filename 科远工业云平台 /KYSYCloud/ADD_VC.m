//
//  ADD_VC.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/3/16.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "ADD_VC.h"
#import "OneTableViewCell.h"
#import "ImgTableViewCell.h"
#import "TextViewTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "GDAddPhotoTableViewCell.h"
#import "PicViewController.h"
#import "SYQRCodeViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface ADD_VC ()<UITableViewDelegate,UITableViewDataSource,VPImageCropperDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,MyRequestDelegate,CLLocationManagerDelegate>{
    UIButton *_plusButton;
    
    UIScrollView *_picScroller;
    //NSMutableArray *addedPicArray;
    int imgRowhight;
    NSMutableArray *_picArray;
    PicViewController *picVC;
    NSString *fileName;
    NSURL *audioUrl;
    CLLocationManager * _locationManager;
    NSString* cityName;
    NSDictionary*_fromDic;
    NSMutableDictionary *  _XMLDic;
    NSMutableArray * _XmlArray;
    NSMutableDictionary *_showDic;
    NSInteger state;
    NSString *myguid;
    NSString *_titleStr;
    CGAffineTransform transform;
    NSString *firsCellString;
    int SNO;
    NSDictionary *_devicePartDic;
    NSMutableArray *_devicePartARR;
    NSString *ERRGUID;
    NSString *DPGUID;
    NSString  *_firstTextString;
    NSDictionary *_dpartDic;
    NSArray *_dpartArray;
    BOOL keep;
   NSDictionary *_Infofic;
    NSArray *_infoArray;
    NSDictionary *_infoDic;
    NSDictionary *_audiofic;
    
    NSDictionary *_audioDic;
    NSString *CUSTOMERINFO;
    NSString *RRDGUID;
    NSString *RRGUID;
    BOOL isOpen;
    BOOL isChoice;
    
    
    NSString *DPCODE;
    NSString *DPCODE1;
    NSTimer *_timer;
   
    



}

@end

@implementation ADD_VC

-(id)initWithADic:(NSDictionary *)aDic withTitle:(NSString *)title
{
    self=[super init];
    if (self) {
        _fromDic=aDic;
        
        NSLog(@"_FROMDIC =======%@",_fromDic);
        _titleStr=title;
        
        
        
    }
    return self;
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSString *path =[NSTemporaryDirectory() stringByAppendingString:@"TmpFile"];
    NSString *path1 =[NSTemporaryDirectory() stringByAppendingString:@"DownTmpFile"];
    NSFileManager *manger =[NSFileManager defaultManager];
    [manger removeItemAtPath:path error:nil];
    [manger removeItemAtPath:path1 error:nil];
    [_timer invalidate];
    _timer=nil;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    SNO=100;
    isOpen=NO;
    isChoice=NO;
    self.title=_titleStr;
//type==1 是查看 type==0是添加
    RRGUID=@"";
        NSLog(@"selftype========%d",self.type);
    
//从添加中来
    switch (self.type) {
        case 0:
        {
            ERRGUID=@"";
            DPGUID=@"";
            _picArray=[NSMutableArray array];
            [self requestDetilwithDuid];
            [self initTableView];
            [self initAudio];
            if (self.tag==100) {
             
                RRGUID=_fromDic[@"RRGUID"];

                [self.downBtn setTitle:@"提交" forState:0];

            }
            

        }
            break;
            //从待确认的维修来
        case 1:{
            [self initTableView];

            ERRGUID=@"";
            DPGUID=@"";
            _picArray=[NSMutableArray array];
            [self initAudio];
            if (self.tag==110) {
                
                self.downBtn.hidden=YES;
                DPGUID=_fromDic[@"DPGUID"];
                [self requestDetilwithDuid];
            }else{
            
                [self initButton];
            
            }
              [self RequestDevicePart];
            [self requestDetilwithDRGUID:_fromDic[@"DRGUID"]];
            
            
        }break;
            //从已处理的登记里面来
        case 2:{
            ERRGUID=@"";
            DPGUID=@"";
            [self initAudio];
            _picArray=[NSMutableArray array];
            [self requestDGUID];
            [self initTableView];
            [self RequestDevicePart];
            self.downBtn.hidden=YES;
        
        
        }break;
            //从被驳回的登记来
        case 3:{
            _picArray=[NSMutableArray array];
            //[self initButton];
            ERRGUID=_fromDic[@"ERRGUID"];
            DPGUID=_fromDic[@"DPGUID"];
            //RRGUID=_fromDic[@"DRGUID"];
            [self.downBtn setTitle:@"提交" forState:0];
            [self requestDetilwithDRGUID:_fromDic[@"DRGUID"]];
            [self initTableView];
            [self RequestDevicePart];
            [self initAudio];
        
        }break;
            
    }
    
}

-(void)initButton{
    int width=100;
    int hangjianju = (LWIDTH-300)/4;
    
    NSArray *array =[[NSArray alloc]initWithObjects:@"确认", @"驳回",@"关闭", nil];
    
    for (int i=0; i<3; i++) {
        
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame =CGRectMake((width+hangjianju)*i+hangjianju, LHIGHT-40,width , 30);
        button.backgroundColor =[CommonTool colorWithHexString:@"#4876FF"];
        button.tag=i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:  UIControlEventTouchUpInside];
        [button setTitle:array[i] forState:0];
        [self.view addSubview:button];
        
    }
        self.myTable.userInteractionEnabled=YES;
    self.downBtn.hidden=YES;
    
}
-(void)buttonClick:(UIButton*)button{
    
    switch (button.tag) {
        case 0:
        {
            [self requestToConfirm];
        }
            break;
        case 1:{
            
            UIAlertController *controler =[UIAlertController alertControllerWithTitle:@"驳回原因" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [controler addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            }];
        
            UIAlertAction *action =[UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *reason =controler.textFields[0].text;
                [self RequestToBackWithReason:reason];

                
            }];
            UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [controler addAction:action];
            [controler addAction:cancel];
            [self presentViewController:controler animated:YES completion:nil];
            
            
        }
        case 2:{
            [self.navigationController popViewControllerAnimated:YES];
        
        }break;
     
    }






}

//获取定位信息
-(void)Location{
    if([CLLocationManager locationServicesEnabled]) {
        //定位初始化
        _locationManager=[[CLLocationManager alloc] init];
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.delegate=self;
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        _locationManager.distanceFilter=10;
        [_locationManager startUpdatingLocation];//开启定位
    }else {
        //提示用户无法进行定位操作
        
        
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    // 开始定位
    [_locationManager startUpdatingLocation];
    
    
    
}

#pragma mark 定位
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //NSLog(@%@,placemark.name);//具体位置
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             //NSString* cityName = city;
             //NSLog(@"定位完成:%@",cityName);
             //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
             [manager stopUpdatingLocation];
         }else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
     }];
    
    
    
    
    
    
    
    
}
//配置录音设置
-(void)initAudio{
  
    _picArray =[NSMutableArray array];
        self.isRecoding = NO;
    UIButton *recond =(UIButton*)[self.view viewWithTag:10086];
    //播放按钮不能被点击
    [recond setEnabled:NO];
    //播放按钮设置成半透明
    recond.titleLabel.alpha = 0.5;
    //创建临时文件来存放录音文件
    self.tmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"TmpFile"]];
    //设置后台播放
    
    NSLog(@"sdafhdsjhjkghjkf=====%@",self.tmpFile);
    
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    //判断后台有没有播放
    if (session == nil) {
        
        NSLog(@"Error creating sessing:%@", [sessionError description]);
        
    } else {
        
        [session setActive:YES error:nil];
    }
    
    
}

//初始UI


-(void)initTableView{
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    [self.myTable registerNib:[UINib nibWithNibName:@"OneTableViewCell" bundle:nil] forCellReuseIdentifier:@"ONECELL"];
    [self.myTable registerNib:[UINib nibWithNibName:@"TextViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"TEXTCELL"];
        [self.myTable registerNib:[UINib nibWithNibName:@"ImgTableViewCell" bundle:nil] forCellReuseIdentifier:@"IMGCELL"];
    imgRowhight=100;
    //       [self.mytable registerNib:[UINib nibWithNibName:@"GDAddPhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"GDCELL"];
    [self.myTable registerClass:[GDAddPhotoTableViewCell class] forCellReuseIdentifier:@"GDCELL"];
    // [self.mytable reloadData];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(Opencamera)
                                                 name: @"打开相册"
                                               object: nil];////执行Opencamera方法
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangeTableviewHeight_one) name:@"图片不大于3张"  object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangesTableviewHeight_two) name:@"图片不大于6张" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangeTableviewHeight_three) name:@"图片不大于9张" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangesTableviewHeight_four) name:@"图片大于9张" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alert) name:@"提示" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scanPic:) name:@"查看照片" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchClick:) name:@"tongzhi" object:nil];
    if (self.type==0||self.type==3){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createlertSheet) name:@"创建提示框" object:nil];
        
        
    }
  _timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(second_1) userInfo:nil repeats:YES];
    
    
    
    
}
-(void)second_1{
    
    NSLog(@"11111");
    NSString *AudioPath=[NSTemporaryDirectory() stringByAppendingString:@"DownTmpFile"];

    NSFileManager  *filenamger =[NSFileManager defaultManager];
    if ([filenamger fileExistsAtPath:AudioPath]) {
    [_timer invalidate];
        NSLog(@"22222");
       [self performSelector:@selector(delySomeMinti) withObject:nil afterDelay:1];
        }

}
-(void)createlertSheet{
    
    UIAlertController *conteoller =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action =[UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        
        pickerController.delegate = self;
        
        
        pickerController.allowsEditing = YES;
        [self presentViewController:pickerController animated:YES completion:nil];
        
        
    }];
    UIAlertAction *action_Two =[UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                    NSLog(@"Picker View Controller is presented");
                }];
        }
        
        
        
    }];
    UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [conteoller addAction:action];
    [conteoller addAction:action_Two];
    [conteoller addAction:cancel];
    [self presentViewController:conteoller animated:YES completion:nil];
  }

    
    

//删除完成后传递过来的字典
- (void)switchClick:(NSNotification *)text{
    GDAddPhotoTableViewCell *cell1 = (GDAddPhotoTableViewCell *)[self.myTable viewWithTag:50];
    /////////  14 调用GDAddPhotoTableViewCell的方法  PhotoArrAdd   将图片传过去
    _picArray=text.userInfo[@"array"];
    
    
    
    
    NSLog(@"_picarray====%@",_picArray);
    
    
    
    [cell1 PotoArrArray:text.userInfo[@"array"]];
    
    
    
    
}
//查看图片明细
-(void)scanPic:(NSNotification*)sender{
    
    picVC =[[PicViewController alloc]initWithArray:_picArray withDic:sender.userInfo withTitleStr:_titleStr];
    picVC.type=self.type;
    [self presentViewController:picVC animated:YES completion:nil];
    
}
//提示
-(void)alert{
    UIAlertController *alertcontrol =[UIAlertController alertControllerWithTitle:@"小提示" message:@"最多只能添加9张照片" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertcontrol addAction:cancel];
    [self presentViewController:alertcontrol animated:YES completion:nil];
    
}
-(void)ChangeTableviewHeight_one{
    imgRowhight = 100;
    [self.myTable reloadData];
    
}
-(void)ChangesTableviewHeight_two{
    imgRowhight = 200;
    [self.myTable reloadData];
    
    
}
-(void)ChangeTableviewHeight_three{
    imgRowhight = 300;
    [self.myTable reloadData];
    
}
-(void)ChangesTableviewHeight_four{
    imgRowhight = 400;
    [self.myTable reloadData];
    
}

- (void)Opencamera///// 12 打开相册
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    pickerController.delegate = self;
    
    
    pickerController.allowsEditing = YES;
    [self presentViewController:pickerController animated:YES completion:nil];
}
#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}


///////// 13 获得照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];///// 相簿dismiss
    //获得选择的图片
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    
    
    //根据tag值找到所在的cell  在此不能alloc新建  要找原来的那个cell
    GDAddPhotoTableViewCell *cell1 = (GDAddPhotoTableViewCell *)[self.myTable viewWithTag:50];
    /////////  14 调用GDAddPhotoTableViewCell的方法  PhotoArrAdd   将图片传过去
    [_picArray insertObject:image atIndex:0];
    
    [cell1 PhotoArrAdd:image];
    
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return 6;
    }else if (section==1){
        if (isOpen) {
            return 1;
        }else{
        
            return 0;
        
        }
        
    }else{
        return 1;
    
    }
    
   }
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==0?0:20;
    
    
    
}
#pragma mark=============表代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    switch (indexPath.section) {
        case 0:
        {
        return 30;
                
            }
            break;
        case 1:{
            return 30;
        
        }break;
        case 2:{
            return imgRowhight;
            
            
        }break;
        default:{
            return 60;
            
            
        }
            break;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    OneTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ONECELL" forIndexPath:indexPath];
        switch (indexPath.section) {
        case 0:
        {
            OneTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ONECELL" forIndexPath:indexPath];

            if (self.type==0) {
                cell.EWMBtn.hidden=YES;
                
                if (indexPath.row==0) {
                    
                    [cell.textfield setEnabled:NO];
                    cell.textfield.text=firsCellString;
                    cell.EWMBtn.hidden=NO;
                    [cell.EWMBtn setImage:[UIImage imageNamed:@"find_down"] forState:0];
                    
                    
                }
                if (indexPath.row==1) {
                    cell.EWMBtn.hidden=NO;
                    [cell.EWMBtn setImage:[UIImage imageNamed:@"find_down"] forState:0];
                    cell.textfield.placeholder=@"请点击右侧按钮选择";
                    
                }
                
                cell.textfield.tag=10000+indexPath.row+1;
            cell.EWMBtn.tag=indexPath.row;
                [cell.EWMBtn addTarget:self action:@selector(ewmbtnClick:) forControlEvents:UIControlEventTouchUpInside];
                NSArray *array =[[NSArray alloc]initWithObjects:@"部件名称:",@"故障名称:",@"故障现象:",@"故障原因:",@"处理方式:",@"维修地点:",nil];
                cell.label.font=[UIFont systemFontOfSize:14];
                cell.label.textAlignment=NSTextAlignmentRight;
                cell.label.text=array[indexPath.row];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                
                return cell;

            }else{
                    cell.EWMBtn.hidden=YES;
                if (self.type==1||self.type==2) {
                    [cell.textfield setEnabled:NO];

                }
               
                
                switch (indexPath.row) {
                    case 0:
                    {
                        
                        
                        if (self.type==3||self.tag==110) {
                            [cell.textfield setEnabled:NO];
                            if (firsCellString==nil) {
                                   cell.textfield.text=[CommonTool returnDpname:_XmlArray withStr:_showDic[@"DPGUID"]];
                                                }else{
                                cell.textfield.text=firsCellString;
                            
                            
                                                    }
                         
                            
                            
                            NSLog(@"firstt=========%@",firsCellString);
                            cell.EWMBtn.hidden=NO;
                            [cell.EWMBtn setImage:[UIImage imageNamed:@"find_down"] forState:0];

                        }else{
                            
                            
                                cell.textfield.text=[CommonTool returnDpname:_XmlArray withStr:_showDic[@"DPGUID"]];
                            
                            
                           
                        
                        }
                        
                      
                    }
                        break;
                    case 1:{
                        
                        if (self.type==3) {
                            cell.EWMBtn.hidden=NO;
                            [cell.EWMBtn setImage:[UIImage imageNamed:@"find_down"] forState:0];
                            cell.textfield.text=_showDic[@"ERRNAME"];

                        }else{
                            cell.textfield.text=_showDic[@"ERRNAME"];
                        
                        }
                     
                    
                    }break;
                    case 2:{
                        
                       
                            cell.textfield.text=_showDic[@"ERRDESC"];
                            
                                             
                    
                    }break;
                    case 3:{
                        
                      
                           cell.textfield.text=_showDic[@"REASON"];
                       
                       
                    
                    }break;
                    case 4:{
                        if (firsCellString==nil) {
                            cell.textfield.text=_showDic[@"HANDLE"];
                            

                            
                        }else{
                            cell.textfield.text=@"";
                            
                            
                        }

                        
                    }break;
                    case 5:{
                        if (firsCellString==nil) {
                            cell.textfield.text=_showDic[@"ADDRESS"];
                            
                        }else{
                            cell.textfield.text=@"";
                            
                        }
                                         }
                       
                                   }
                cell.EWMBtn.tag=indexPath.row;
                 cell.textfield.tag=10000+indexPath.row+1;
                [cell.EWMBtn addTarget:self action:@selector(ewmbtnClick:) forControlEvents:UIControlEventTouchUpInside];
                NSArray *array =[[NSArray alloc]initWithObjects:@"部件名称:",@"故障名称:",@"故障现象:",@"故障原因:",@"处理方式:",@"维修地点:",nil];
                cell.label.font=[UIFont systemFontOfSize:14];
                cell.label.textAlignment=NSTextAlignmentRight;
                cell.label.text=array[indexPath.row];
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                return cell;
                
            }
            
            
        }
            break;
            
    case 1:{
        
            OneTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ONECELL" forIndexPath:indexPath];
            cell.label.font=[UIFont systemFontOfSize:14];
            cell.label.textAlignment=NSTextAlignmentRight;
            cell.label.text=@"新部件编号:";
            cell.EWMBtn.hidden=YES;
        if (self.type==1||self.type==3||self.type==2) {
            cell.textfield.text=DPCODE;
            [cell.textfield setEnabled:NO];
        }

            cell.textfield.tag=10008;
        return cell;
        
        
    }break;
case 2:{
            
            GDAddPhotoTableViewCell*cell =[tableView dequeueReusableCellWithIdentifier:@"GDCELL"];
                       //cell.titleLab.text = @"照片";
            //////////重要   给你那一行cell  写个你知道的tag值
            cell.tag = 50;
            return cell;
        }break;
            
        default:{
            ImgTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"IMGCELL"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [cell.play addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.recoad addTarget:self action:@selector(TouchIn:) forControlEvents:UIControlEventTouchUpInside];
            if (self.type==1||self.type==3||self.type==2) {
                self.isRecoding=YES;
                //cell.play.titleLabel.alpha=0.5;
                //[cell.play setEnabled:NO];
                cell.recoad.userInteractionEnabled=NO;
                cell.recoad.titleLabel.alpha=0.5;
            }
            
//            if (self.isRecoding==NO) {
//                
//                //播放按钮不能被点击
//                [cell.play setEnabled:NO];
//                //播放按钮设置成半透明
//                cell.play.titleLabel.alpha = 0.5;
//                
//            }else{
//                
//                
//                
//            }
            cell.tag=100;
            return cell;

        }
            break;
    }
    
    
    // return cell;
    
    
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, LWIDTH, 20)];
    view.backgroundColor=[UIColor blackColor];
    UILabel *lab =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, LWIDTH, 20)];
    lab.font=[UIFont systemFontOfSize:16];
     lab.tag=61;
    if (section==0) {
      
    }else if (section==1){
        
                 view.backgroundColor=[UIColor whiteColor];
            if (isOpen) {
                lab.frame=CGRectMake(50, 0, LWIDTH-50, 20);
                //lab.textColor=[UIColor blackColor];
                lab.text=@"更换设备部件";
                UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
                button.frame=CGRectMake(0, 0, 50,20);
                [button setImage:[UIImage imageNamed:@"home_write_caogao_1"] forState:0];
                
                [button addTarget:self action:@selector(hiderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
                
                if (self.type==1) {
                    button.userInteractionEnabled=NO;
                }
            }else{
                
                
                lab.frame=CGRectMake(50, 0, LWIDTH-50, 20);
                // lab.textColor=[UIColor blackColor];
                lab.text=@"更换设备部件";
                UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
                button.frame=CGRectMake(0, 0, 50,20);
                [button setImage:[UIImage imageNamed:@"home_write_caogao"] forState:0];
                
                [button addTarget:self action:@selector(hiderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
                if (self.type==1||self.type==3||self.type==2) {
                    button.userInteractionEnabled=NO;
                }
                
            }

        
        
        
        
    }else  if (section==2){
               lab.textColor=[UIColor whiteColor];
               lab.text=@"添加图片";
       

        
    }else{
        lab.text=_audioDic[@"FILENAME"];
        if (_audioDic[@"FILENAME"]==nil) {
            lab.text=@"添加留言" ;
        }else{
        
            lab.text=_audioDic[@"FILENAME"];

        
        }
        NSLog(@"11111111111111111112=====%@",_audioDic[@"FILENAME"]);
        //label.text=_audioDic[@"FILENAME"];

        
        lab.textColor=[UIColor whiteColor];
        UIImageView *imageview =[[UIImageView alloc]initWithFrame:CGRectMake(LWIDTH-40, 0, 20, 20)];
        imageview.image=[UIImage imageNamed:@"speak"];
        [view addSubview:imageview];

    
    
    }
    [view addSubview:lab];
    return view;
}


-(void)hiderBtnClick:(UIButton*)sender{
    
    isOpen=!isOpen;
    if (isOpen) {
        [sender setImage:[UIImage imageNamed:@"home_write_caogao_1"] forState:0];
    }else{
        [sender setImage:[UIImage imageNamed:@"home_write_caogao"] forState:0];

    
    }
    //可变索引集
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    
  
    [set addIndex:1];

    [self.myTable reloadSections:set withRowAnimation:UITableViewRowAnimationFade];


}


//按钮点击事件

-(void)ewmbtnClick:(UIButton *)sender{
    
    switch (sender.tag) {
        case 0:
        {
            if (self.type==0||self.type==3) {
                
                    UIAlertController *alertcontrlooer =[UIAlertController alertControllerWithTitle:@"请选择部件名称" message:nil preferredStyle: UIAlertControllerStyleAlert];
                    for (int i=0; i<_XmlArray.count; i++) {
                        
                        UIAlertAction *action =[UIAlertAction actionWithTitle:_XmlArray[i][@"DPNAME"] style:
                                                UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                            firsCellString=_XmlArray[i][@"DPNAME"];
                            SNO=[_XmlArray[i][@"SNO"]intValue];
                            DPGUID=_XmlArray[i][@"DPGUID"];
                            DPCODE=_XmlArray[i][@"DPCODE"];
                            isChoice=YES;

                            
                            [self.myTable reloadData];
                            
                        }];
                        
                        [alertcontrlooer addAction:action];
                        
                        
                    }
                    UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    
                    [alertcontrlooer addAction:cancel];
                    [self presentViewController:alertcontrlooer animated:YES completion:nil];
                
                
            }
            
            
        }
            break;
        case 1:{
            
            NSLog(@"请选择");
            
            
            [self requestGetDevicePart];
            
        
        }
        case 2:{
            
            
        
        }break;
        case 3:{
           // [self requestGetDevicePart];
        
        }break;
    }

    
    
}
//
-(void)playClick:(UIButton*)sender{
    
    //判断是否正在播放,如果正在播放
    if ([self.player isPlaying]) {
        //暂停播放
        [_player pause];
        
        //按钮显示为播放
        [sender setTitle:@"播放" forState:UIControlStateNormal];
        
    } else {
        
        //开始播放
        [_player play];
        
        //
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
        
    }
    
}
-(void)TouchIn:(UIButton*)sender{
    UIButton *platBtn =(UIButton *)[self.view viewWithTag:10000];
    //判断当录音状态为不录音的时候
    if (!self.isRecoding) {
        //将录音状态变为录音
        self.isRecoding = YES;
        
        //将录音按钮变为停止
        [sender setTitle:@"停止" forState:UIControlStateNormal];
        
        //播放按钮不能被点击
        [platBtn setEnabled:NO];
        platBtn.titleLabel.alpha = 0.5;
        
        //开始录音,将所获取到得录音存到文件里
        
        
        self.recorder = [[AVAudioRecorder alloc]initWithURL:self.tmpFile settings:nil error:nil];
        
        //准备记录录音
        [_recorder prepareToRecord];
        
        //启动或者恢复记录的录音文件
        [_recorder record];
        
        _player = nil;
        
    } else {
        
        //录音状态 点击录音按钮 停止录音
        self.isRecoding = NO;
        [sender setTitle:@"录音" forState:UIControlStateNormal];
        
        //录音停止的时候,播放按钮可以点击
        [platBtn setEnabled:YES];
        [platBtn.titleLabel setAlpha:1];
        
        //停止录音
        [_recorder stop];
        
        _recorder = nil;
        
        // &nnbsp;
        NSError *playError;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:_tmpFile error:&playError];
        //当播放录音为空, 打印错误信息
        if (self.player == nil) {
            NSLog(@"Error crenting player: %@", [playError description]);
        }
        self.player.delegate = self;
        
    }
    
    
}
//当播放结束后调用这个方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    UIButton *playbutton =(UIButton*)[self.view viewWithTag:10000];
    //按钮标题变为播放
    [playbutton setTitle:@"播放" forState:UIControlStateNormal];
}




-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)downBtn:(UIButton *)sender {
    
                [self keepRequestwithGuid];

    
}



//请求部件信息
-(void)requestDGUID{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    NSString *xmlstring =[NSString stringWithFormat:@"<Data><Action>CHECKRESULT</Action><RRGUID>%@</RRGUID></Data>",_fromDic[@"RRGUID"]];
    NSLog(@"xmlstring====%@",xmlstring);
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlstring];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            [self requestDetilwithDRGUID:dictt[@"GUID"]];
            [self.myTable reloadData];
            }else{
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
    };
    
}




#pragma mark 请求明细页面
-(void)requestDetilwithDRGUID:(NSString *)DRGUID{
    NSString
*xmlstring =[NSString stringWithFormat:@"<Data><Action>GETDEVICEREPAIRBYDRGUID</Action><USERID>%@</USERID><PWD>%@</PWD><DRGUID>%@</DRGUID></Data>",USER_NAME,PASSWORD,DRGUID];
      NSLog(@"xmlstring====%@",xmlstring);
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlstring];
    manger.backSuccess=^void(NSDictionary *dictt){
             if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            _XMLDic=(NSMutableDictionary*)[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
                      [CommonTool saveCooiker];
            _showDic=_XMLDic[@"R"];
               
                 if ((NSObject*)dictt[@"CUSTOMERINFO2"]==[NSNull null] ) {
                     
                 }else{
                    DPCODE=dictt[@"CUSTOMERINFO2"];
                     isChoice=YES;
                     isOpen=YES;
                    
                     
                     [self.myTable reloadData];
                 }
                 
        
                 
                 NSLog(@"dpcode======%@",DPCODE);
                 
                 NSLog(@"sdfgdahjsgxhjdf====%@",_showDic);
                 
                 
                 
                                            [self RequestDevicePart];
                 _Infofic=[NSDictionary dictionaryWithXMLString:dictt[@"CUSTOMERINFO"]];
                 _audiofic=[NSDictionary dictionaryWithXMLString:dictt[@"CUSTOMERINFO1"]];
                 if ([_Infofic[@"R"] isKindOfClass:[NSDictionary class]]) _infoDic =_Infofic[@"R"];
                 else{
                     _infoArray =_Infofic[@"R"];
                 }
                 _audioDic=_audiofic[@"R"];
                 
                 
                 NSLog(@"audioc=======%@",_audiofic);
               
                
                 NSLog(@"xmllladskjfhsjkgdghj====%@",_XmlArray);
                 
                 NSLog(@"INFODIC========%@",_Infofic);
                 [self initImageCell];
            
                 
                 
                 
        }else{
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
    };





}
-(void)initImageCell{
    
    //
    //    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HTTPIP,SERVER_URL,_XMLDic[@"R"][@""]]];
    //
    
    
    ASIHTTPRequest *request;
    
    if ([_Infofic[@"R"] isKindOfClass:[NSDictionary class]]) {
        NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HTTPIP,SERVER_URL,_infoDic[@"FILEPATH"]]];
        
        
        NSLog(@"url===================%@",url);
        
        
        request =[ASIHTTPRequest requestWithURL:url];
        request.delegate=self;
        request.tag=100;
        [request startAsynchronous];
        
    }else{
        for (int i=0; i<_infoArray.count; i++) {
            NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HTTPIP,SERVER_URL,_infoArray[i][@"FILEPATH"]]];
            request =[ASIHTTPRequest requestWithURL:url];
            request.delegate=self;
            request.tag=i+100;
            [request startAsynchronous];
            
            
        }
        
    }
    
    NSString *AudioPath=[NSTemporaryDirectory() stringByAppendingString:@"DownTmpFile"];
    NSError *playError;
    self.downloadtmpfile=[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"DownTmpFile"]];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.downloadtmpfile error:&playError];
    
    
    if ([_audiofic[@"R"] isKindOfClass:[NSDictionary class]]) {
        //[SVProgressHUD showWithStatus:@"正在加载音频..."];
        
        NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HTTPIP,SERVER_URL,_audioDic[@"FILEPATH"]]];
        
        NSLog(@"瑞士的均可见到  ===========%@",url);
        request =[ASIHTTPRequest requestWithURL:url];
        
        
        request.tag=1000;
        NSLog(@"audiopath===%@",AudioPath);
        
        [request setDownloadDestinationPath:AudioPath];
        [request startAsynchronous];
        
               //[SVProgressHUD showWithStatus:@"音频加载中..."];
       
//
        //[self performSelector:@selector(delySomeMinti) withObject:nil afterDelay:3];
        UILabel *label=(UILabel*)[self.myTable viewWithTag:61];
       // NSLog(@"lab===%@",lab);
        label.text=_audioDic[@"FILENAME"];
        
        //NSLog(@"asfggsdf====%@",lab);
        NSLog(@"audiodic=====%@",_audioDic[@"FILENAME"]);
               
    }
    
    
}
-(void)delySomeMinti{
     [self playAudiowithpath];


}
-(void)playAudiowithpath{
    self.isRecoding = YES;
    //停止录音
    [_recorder stop];
    _recorder = nil;
    // &nnbsp;
    NSError *playError;
    self.downloadtmpfile=[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"DownTmpFile"]];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.downloadtmpfile error:&playError];
    //当播放录音为空, 打印错误信息
    if (self.player == nil) {
        NSLog(@"Error crenting player: %@", [playError description]);
    }
    self.player.delegate = self;
    
    UIButton *playbtn =(UIButton*)[self.myTable viewWithTag:10000];
    playbtn.userInteractionEnabled=YES;
    playbtn.titleLabel.alpha=1;
    //录音状态 点击录音按钮 停止录音}




}

//请求部件信息
-(void)requestDetilwithDuid{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    NSString *xmlstring =[NSString stringWithFormat:@"<Data><Action>GETDEVICEPART</Action><USERID>%@</USERID><PWD>%@</PWD><DGUID>%@</DGUID></Data>",USER_NAME,PASSWORD,_fromDic[@"DGUID"]];
    NSLog(@"xmlstring====%@",xmlstring);
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlstring];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            _XMLDic=(NSMutableDictionary*)[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            _XmlArray=_XMLDic[@"R"];
            [CommonTool saveCooiker];
            NSLog(@"++++++++++++++_xmldic====%@",_XMLDic);
            firsCellString=_XmlArray[0][@"DPNAME"];
           
            SNO=[_XmlArray[0][@"SNO"]intValue];
              DPCODE=_XmlArray[0][@"DPCODE"];
             DPGUID=_XmlArray[0][@"DPGUID"];
            isChoice=YES;
            [self initTableView];

            
            [self.myTable reloadData];
            
            
        }else{
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
       };
    
}




-(void)RequestDevicePart{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    NSString *xmlstring =[NSString stringWithFormat:@"<Data><Action>GETDEVICEPART</Action><USERID>%@</USERID><PWD>%@</PWD><DGUID>%@</DGUID></Data>",USER_NAME,PASSWORD,_fromDic[@"DGUID"]];
    NSLog(@"xmlstring====%@",xmlstring);
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlstring];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            _XMLDic=(NSMutableDictionary*)[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            _XmlArray=_XMLDic[@"R"];
            NSLog(@"ashgdhjfdsfdsf=====%@",_XmlArray);
            [CommonTool saveCooiker];
            [self.myTable reloadData];
            
            
        }else{
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
    };


}

//请求设备故障信息

-(void)requestGetDevicePart{
    if (SNO==100) {
        return;
    }
    NSString *xmlstring =[NSString stringWithFormat:@"<Data><Action>GETREPAIRCFG</Action><USERID>%@</USERID><PWD>%@</PWD><MCODE>%@</MCODE><DPGUID>%@</DPGUID></Data>",USER_NAME,PASSWORD,self.Mcode,_XmlArray[SNO-1][@"DPGUID"]];
    NSLog(@"xmlstring====%@",xmlstring);
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlstring];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            _devicePartDic=[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            
            if ([_devicePartDic[@"R"] isKindOfClass:[NSDictionary class]]) {
                
                _devicePartARR =[NSMutableArray array];
                [_devicePartARR addObject:_devicePartDic[@"R"]];
                }else{
                _devicePartARR=_devicePartDic[@"R"];
            }
            [self initAlertcontroller];
            NSLog(@"_device adday=====%@",_devicePartARR);
        }else{
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
        
        
    };
    
    
}
//初始化controller
-(void)initAlertcontroller{
    UIAlertController *controller =[UIAlertController alertControllerWithTitle:@"请选择故障名称" message:nil preferredStyle:  UIAlertControllerStyleAlert];
    for (int i=0; i<_devicePartARR.count; i++) {
        UIAlertAction *action =[UIAlertAction actionWithTitle:_devicePartARR[i][@"ERRNAME"] style:   UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            UITextField *twotxt =(UITextField*)[self.view viewWithTag:10002];
            UITextField *threeTxt =(UITextField*)[self.view viewWithTag:10003];
            UITextField *fourtxt =(UITextField *)[self.view viewWithTag:10004];
            ERRGUID=_devicePartARR[i][@"ERRGUID"];

            twotxt.text=_devicePartARR[i][@"ERRNAME"];
            threeTxt.text=_devicePartARR[i][@"ERRDESC"];
            fourtxt.text=_devicePartARR[i][@"REASON"];
                     //[self.myTable reloadData];
          
            
        }];
        [controller addAction:action];
        
    }
      UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:cancel];
    [self presentViewController:controller animated:YES completion:nil];
  }


#pragma mark 设备GUID请求
//保存
-(void)keepRequestwithGuid{
    
    if (self.tag==100) {
         [SVProgressHUD showWithStatus:@"正在提交..."];
    }else{
      [SVProgressHUD showWithStatus:@"正在保存..."];
    
    }
   
    //时间戳
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *dataString =[formatter stringFromDate:[NSDate date]];
    NSString *NewDataString =[dataString stringByReplacingOccurrencesOfString:@"-"
                                                                   withString:@""];
    //录音文件
    NSMutableArray *picXmlStringArray=[NSMutableArray array];
    NSString *AudioPath=[NSHomeDirectory() stringByAppendingPathComponent:@"tmp/TmpFile"];
    NSLog(@"auhdsakjghfjsfdkjhgksjfghjkghfgjkhjkf============%@",AudioPath);
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *audioStr;
    if ([manager fileExistsAtPath:AudioPath]) {
        
        NSString *myfileName=[NSString stringWithFormat:@"%@audio.mp3" ,NewDataString];
        audioStr =[NSString stringWithFormat:@"<FILE><FILENAME>%@</FILENAME><FILETYPE>1</FILETYPE><FILEPATH>%@%@</FILEPATH><FILEEXISTENION>.mp3</FILEEXISTENION></FILE>",myfileName,SRVER_FILE_LOGINCARTION,myfileName];
        
        NSLog(@"录音文件存在");
    }else{
        NSLog(@"录音文件不存在");
        audioStr=@"";
    }
    for (int i=0; i<_picArray.count; i++) {
        NSString *myfileName=[NSString stringWithFormat:@"%@%d.jpg" ,NewDataString,i];
        NSString *picstr=[NSString stringWithFormat:@"<FILE><FILENAME>%@</FILENAME><FILETYPE>0</FILETYPE><FILEPATH>%@%@</FILEPATH><FILEEXISTENION>.jpg</FILEEXISTENION></FILE>",myfileName,SRVER_FILE_LOGINCARTION,myfileName];
        [picXmlStringArray addObject:picstr];
    }
    
    NSString *newString=[picXmlStringArray componentsJoinedByString:@","];
    NSString *picxmstring ;
    
    
    if (_picArray.count>0) {
        picxmstring =[newString stringByReplacingOccurrencesOfString:@"," withString:@""];
    }else{
        picxmstring=@"";
    }
    
    
    NSLog(@"picstr=============%@",picxmstring);
    
    
    //UITextField *onetxt =(UITextField*)[self.view viewWithTag:10001];
    UITextField *twotxt =(UITextField*)[self.view viewWithTag:10002];
    UITextField *threeTxt =(UITextField*)[self.view viewWithTag:10003];
    UITextField *fourtxt =(UITextField *)[self.view viewWithTag:10004];
    UITextField *fivetxt =(UITextField *)[self.view viewWithTag:10005];
    UITextField *sixtxt =(UITextField *)[self.view viewWithTag:10006];
    UITextField *partNumber =(UITextField *)[self.view viewWithTag:10008];
    
    NSString *partnumberStriong;
    if (isOpen) {
        if (isChoice) {
            partnumberStriong=[NSString stringWithFormat:@"<PARTREPLACE>1</PARTREPLACE><PART><DPCODE>%@</DPCODE><DPCODE1>%@</DPCODE1><DPGUID>%@</DPGUID></PART>",partNumber.text,DPCODE,DPGUID];
        }else{
            
            partnumberStriong=@"<PARTREPLACE>0</PARTREPLACE>";
        }
    }
    
    NSLog(@"asdsadfsadf====%@",partnumberStriong);
    NSString *xmlstring;
    if (self.type==3) {
    xmlstring =[NSString stringWithFormat:@"<Data><Action>UPDATEREPAIR</Action><USERID>%@</USERID><PWD>%@</PWD><DGUID>%@</DGUID><DRGUID>%@</DRGUID><ERRGUID>%@</ERRGUID><ERRNAME>%@</ERRNAME><ERRDESC>%@</ERRDESC><REASON>%@</REASON><HANDLE>%@</HANDLE><ADDRESS>%@</ADDRESS>%@%@%@</Data>",USER_NAME,PASSWORD,_fromDic[@"DGUID"],_fromDic[@"DRGUID"],ERRGUID,twotxt.text,threeTxt.text,fourtxt.text,fivetxt.text,sixtxt.text,partnumberStriong,audioStr,picxmstring];
    }else{
 xmlstring =[NSString stringWithFormat:@"<Data><Action>ADDDEVICEREPAIR</Action><RRGUID>%@</RRGUID><DPGUID>%@</DPGUID><USERID>%@</USERID><PWD>%@</PWD><DGUID>%@</DGUID><ERRGUID>%@</ERRGUID><ERRNAME>%@</ERRNAME><ERRDESC>%@</ERRDESC><REASON>%@</REASON><HANDLE>%@</HANDLE><ADDRESS>%@</ADDRESS>%@%@%@</Data>",RRGUID,DPGUID,USER_NAME,PASSWORD,_fromDic[@"DGUID"],ERRGUID,twotxt.text,threeTxt.text,fourtxt.text,fivetxt.text,sixtxt.text,partnumberStriong,audioStr,picxmstring];

      
    }
    
       MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlstring withPath:AudioPath withPicArray:_picArray] ;
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            //[self.navigationController popViewControllerAnimated:YES];
        }else{
            
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
    };
    for (int i=0; i<_picArray.count; i++) {
        NSString *myfileName=[NSString stringWithFormat:@"%@%d.jpg" ,NewDataString,i];
        NSData* data = UIImageJPEGRepresentation([self compressImage:_picArray[i]], 0);
        NSURL* myurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?fileName=%@",HTTPIP,UPLOAD_URL,myfileName]];
        ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:myurl];
        request.delegate = self;
        [request setTimeOutSeconds:8];
        [request setData:data withFileName:myfileName andContentType:@"image/jpg" forKey:@"path"];
        [request startAsynchronous];
        
    }
    
    if ([manager fileExistsAtPath:AudioPath]) {
        
        NSString *myfileName=[NSString stringWithFormat:@"%@audio.mp3" ,NewDataString];
        NSData* data = [NSData dataWithContentsOfURL:audioUrl];
        
        NSLog(@"data======%@",data);
        NSURL* myurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?fileName=%@",HTTPIP,UPLOAD_URL,myfileName]];
        ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:myurl];
        request.delegate = self;
        [request setTimeOutSeconds:8];
        request.tag=9999;
        [request setFile:AudioPath withFileName:myfileName andContentType:@"audio/mpeg" forKey:@"path"];
        
        NSLog(@"audiopath====%@",AudioPath);
        //[request setData:data withFileName:myfileName andContentType:@"audio/mpeg" forKey:@"path"];
        [request startAsynchronous];
        NSLog(@"录音文件存在");
    }
    

    //[self.navigationController popViewControllerAnimated:YES];

}
//修剪图片
- (UIImage *)compressImage:(UIImage *)imgSrc
{
    CGSize size = {164 , 218};
    UIGraphicsBeginImageContext(size);
    CGRect rect = {{0,0}, size};
    [imgSrc drawInRect:rect];
    UIImage *compressedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return compressedImg;
}


//确认
-(void)requestToConfirm{
     [SVProgressHUD showWithStatus:@"正在确认...."];
    
   NSString *xmlstring =[NSString stringWithFormat:@"<Data><Action>CONFIRMREPAIR</Action><USERID>%@</USERID><PWD>%@</PWD><DRGUID>%@</DRGUID></Data>",USER_NAME,PASSWORD,_fromDic[@"DRGUID"]];
    NSLog(@"xmlstring====%@",xmlstring);
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlstring];
    manger.backSuccess=^void(NSDictionary *dictt){
        
        [SVProgressHUD dismiss];
          [self.navigationController popViewControllerAnimated:YES];
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            [SVProgressHUD showSuccessWithStatus:@"已确认"];
           
        }else{
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
        
    };
    
    [self.navigationController popViewControllerAnimated:YES];

}
//驳回
-(void)RequestToBackWithReason:(NSString*)reason{
    [SVProgressHUD showWithStatus:@"正在驳回...."];
    NSString *xmlstring =[NSString stringWithFormat:@"<Data><Action>REJECTREPAIR</Action><USERID>%@</USERID><PWD>%@</PWD><REJECTREASON>%@</REJECTREASON><DRGUID>%@</DRGUID></Data>",USER_NAME,PASSWORD,reason,_showDic[@"DRGUID"]];
    NSLog(@"xmlstring====%@",xmlstring);
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlstring];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
            if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            [SVProgressHUD showSuccessWithStatus:@"已驳回"];
          
        }else{
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
       };
     [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark=======ASIHTTPRequest代理
- (void)requestStarted:(ASIHTTPRequest *)request
{
    
    [SVProgressHUD showWithStatus:@"开始上传..."];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    GDAddPhotoTableViewCell *cell1 = (GDAddPhotoTableViewCell *)[self.myTable viewWithTag:50];
    NSData *data = request.responseData;
        NSLog(@"data========%@",data);
    
    NSMutableDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"asdfvadhsgfsd====%@",dict);
    if (request.tag==1000){
        [SVProgressHUD dismiss];
        [self playAudiowithpath];
    }
    
    
    if (request.tag == 1999) {
        
        [SVProgressHUD showErrorWithStatus:dict[@"ERROR"]];
        
    }else if (request.tag==20000){
        if ( (NSObject*)dict[@"ERROR"]==[NSNull null]) {
            [SVProgressHUD showSuccessWithStatus:@"图片上传成功"];
            
        }else{
            [SVProgressHUD showErrorWithStatus:dict[@"ERROR"]];
        }
        
        
    }else if (request.tag==100){
        UIImage *image=[UIImage imageWithData:[request responseData]];
        
        NSLog(@"agsfdghsgf====%@",image);
        if (image !=nil) {
            [_picArray insertObject:image atIndex:0];
            
            [cell1 PhotoArrAdd:image];
            
        }
        
        NSLog(@"asfhgasdhf====%@",[request responseData]);
        /////////  14 调用GDAddPhotoTableViewCell的方法  PhotoArrAdd   将图片传过去
        NSLog(@"_picarray====%@",_picArray);
        
        
        
    }else if (request.tag==100+1){
        UIImage *image=[UIImage imageWithData:[request responseData]];
        
        /////////  14 调用GDAddPhotoTableViewCell的方法  PhotoArrAdd   将图片传过去
        NSLog(@"_picarray====%@",_picArray);
        if (image !=nil) {
            [_picArray insertObject:image atIndex:0];
            
            [cell1 PhotoArrAdd:image];
            
        }
        
        
        
    }else if (request.tag==100+2){
        UIImage *image=[UIImage imageWithData:[request responseData]];
        
        /////////  14 调用GDAddPhotoTableViewCell的方法  PhotoArrAdd   将图片传过去
        NSLog(@"_picarray====%@",_picArray);
        if (image !=nil) {
            [_picArray insertObject:image atIndex:0];
            
            [cell1 PhotoArrAdd:image];
            
        }
    }else if (request.tag==100+3){
        UIImage *image=[UIImage imageWithData:[request responseData]];
        
        /////////  14 调用GDAddPhotoTableViewCell的方法  PhotoArrAdd   将图片传过去
        NSLog(@"_picarray====%@",_picArray);
        if (image !=nil) {
            [_picArray insertObject:image atIndex:0];
            
            [cell1 PhotoArrAdd:image];
            
        }
    }else if (request.tag==100+4){
        UIImage *image=[UIImage imageWithData:[request responseData]];
        
        /////////  14 调用GDAddPhotoTableViewCell的方法  PhotoArrAdd   将图片传过去
        NSLog(@"_picarray====%@",_picArray);
        if (image !=nil) {
            [_picArray insertObject:image atIndex:0];
            
            [cell1 PhotoArrAdd:image];
            
        }
        
        
        
        
    }else if (request.tag==100+5){
        UIImage *image=[UIImage imageWithData:[request responseData]];
        
        /////////  14 调用GDAddPhotoTableViewCell的方法  PhotoArrAdd   将图片传过去
        NSLog(@"_picarray====%@",_picArray);
        if (image !=nil) {
            [_picArray insertObject:image atIndex:0];
            
            [cell1 PhotoArrAdd:image];
            
        }
    }else if (request.tag==100+6){
        UIImage *image=[UIImage imageWithData:[request responseData]];
        
        if (image !=nil) {
            [_picArray insertObject:image atIndex:0];
            
            [cell1 PhotoArrAdd:image];
            
        }
        
    }else if (request.tag==100+7){
        UIImage *image=[UIImage imageWithData:[request responseData]];
        
        /////////  14 调用GDAddPhotoTableViewCell的方法  PhotoArrAdd   将图片传过去
        NSLog(@"_picarray====%@",_picArray);
        if (image !=nil) {
            [_picArray insertObject:image atIndex:0];
            
            [cell1 PhotoArrAdd:image];
            
        }
    }else if (request.tag==100+8){
        UIImage *image=[UIImage imageWithData:[request responseData]];
        
        /////////  14 调用GDAddPhotoTableViewCell的方法  PhotoArrAdd   将图片传过去
        if (image !=nil) {
            [_picArray insertObject:image atIndex:0];
            
            [cell1 PhotoArrAdd:image];
            
        }
    }else if (request.tag==1000){
        [SVProgressHUD dismiss];
        [self playAudiowithpath];
    }
    
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"小提示" message:@"您的网络情况不太好~😰" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    alert.tag = 7788;
    [alert show];
}





@end
