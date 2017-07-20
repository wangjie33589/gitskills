//
//  regist_Two_ViewController.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/19.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "regist_Two_ViewController.h"
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
#import "ADD_VC.h"


#define ORIGINAL_MAX_WIDTH 640.0f
#define  PIC_WIDTH 80
#define  PIC_HEIGHT 80
#define  INSETS 10
@interface regist_Two_ViewController ()<UITableViewDelegate,UITableViewDataSource,VPImageCropperDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,MyRequestDelegate,CLLocationManagerDelegate>{
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
    NSString *cityPlace;
    NSDictionary*_fromDic;
    NSMutableDictionary *  _XMLDic;
    NSMutableArray * _XmlArray;
    NSMutableDictionary *_showDic;
    NSInteger state;
    NSString *myguid;
    NSString *_titleStr;
    BOOL iskeeping;
    
    NSString *_firstTextString;
    NSDictionary *_Infofic;
    NSArray *_infoArray;
    NSDictionary *_infoDic;
    NSDictionary *_audiofic;
   
    NSDictionary *_audioDic;
    NSDictionary *_firstDic;
    NSString *CUSTOMERINFO;
    NSString *_keepGuid;
    NSTimer *_timer;
    
    
}

@end

@implementation regist_Two_ViewController
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

    NSString *path =[NSTemporaryDirectory()
                     stringByAppendingString:@"TmpFile"];
      NSString *path1 =[NSTemporaryDirectory() stringByAppendingString:@"DownTmpFile"];
    NSFileManager *manger =[NSFileManager defaultManager];
    [manger removeItemAtPath:path error:nil];
    [manger removeItemAtPath:path1 error:nil];
    [_timer invalidate];
    _timer=nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    iskeeping=NO;
    CUSTOMERINFO=@"";
    cityName=@"";
    cityPlace=@"";
    myguid=@"";
    _keepGuid=@"";
   
    _firstTextString=@"";
    self.title=_titleStr;
    [self initTableView];
    switch ([_fromDic[@"STATECODE"]intValue]) {
        case 0:
        {
            self.downFirstBtn.hidden=YES;
            self.downThirldBtn.hidden=YES;
            [self requestDetil];
               _picArray =[NSMutableArray array];
            [self.DownSecondBtn setTitle:@"查看处理结果" forState:0];
            self.DownSecondBtn.titleLabel.font=[UIFont systemFontOfSize:10];
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
            break;
        case 1:{
        _picArray =[NSMutableArray array];
            [self requestDetil];
           
//            [self.DownSecondBtn setTitle:@"查看处理结果" forState:0];
//            self.DownSecondBtn.titleLabel.font=[UIFont systemFontOfSize:10];
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
            

                }break;
        case 2:{
            self.downFirstBtn.hidden=YES;
            self.downThirldBtn.hidden=YES;
            [self requestDetil];
            _picArray =[NSMutableArray array];
            [self.DownSecondBtn setTitle:@"查看处理结果" forState:0];
            self.DownSecondBtn.titleLabel.font=[UIFont systemFontOfSize:10];
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
            
            
        }break;
            
            
        case 3:{
            
            self.downFirstBtn.hidden=YES;
            self.downThirldBtn.hidden=YES;
            [self requestDetil];
            _picArray =[NSMutableArray array];
            [self.DownSecondBtn setTitle:@"查看处理结果" forState:0];
            self.DownSecondBtn.titleLabel.font=[UIFont systemFontOfSize:10];
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
            
        
        }break;
        case 10:{
            _picArray =[NSMutableArray array];
            [self initAudio];
            [self Location];

        
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
            cityPlace=placemark.subLocality;
           
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
              
             }
    cityName = city;
            
          
             NSLog(@"定位完成:%@==%@==%@==%@==%@",cityName, placemark.subAdministrativeArea,  placemark.subLocality,   placemark.subThoroughfare, placemark.postalCode);
             //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
             [manager stopUpdatingLocation];
              [self.mytable reloadData];
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
    //刚打开的时候录音状态为不录音
    self.isRecoding = NO;
    UIButton *playBtn =(UIButton*)[self.view viewWithTag:10000];
    //播放按钮不能被点击
    [playBtn setEnabled:NO];
    //播放按钮设置成半透明
    playBtn.titleLabel.alpha = 0.5;
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
    
    
    // &nnbsp;
    NSError *playError;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:_tmpFile error:&playError];
    //当播放录音为空, 打印错误信息
    if (self.player == nil) {
        NSLog(@"Error crenting player: %@", [playError description]);
    }
    self.player.delegate = self;

    
}

//初始UI


-(void)initTableView{
    self.mytable.dataSource=self;
    self.mytable.delegate=self;
    [self.mytable registerNib:[UINib nibWithNibName:@"OneTableViewCell" bundle:nil] forCellReuseIdentifier:@"ONECELL"];
                                                                                                                                                              [self.mytable registerNib:[UINib nibWithNibName:@"TextViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"TEXTCELL"];
       [self.mytable registerNib:[UINib nibWithNibName:@"ImgTableViewCell" bundle:nil] forCellReuseIdentifier:@"IMGCELL"];
        imgRowhight=100;
   [self.mytable registerClass:[GDAddPhotoTableViewCell class] forCellReuseIdentifier:@"GDCELL"];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangeTableviewHeight_one) name:@"图片不大于3张"  object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangesTableviewHeight_two) name:@"图片不大于6张" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangeTableviewHeight_three) name:@"图片不大于9张" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangesTableviewHeight_four) name:@"图片大于9张" object:nil];
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alert) name:@"提示" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scanPic:) name:@"查看照片" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchClick:) name:@"tongzhi" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ewmClick:) name:@"ewmtongzhi" object:nil];
    if ([_fromDic[@"STATECODE"]intValue]==10||[_fromDic[@"STATECODE"]intValue]==1){
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
//扫描二维码完成之后调用这个方法
-(void)ewmClick:(NSNotification*)text{

    _firstTextString=text.userInfo[@"text"];
               if (![_firstTextString isEqualToString:@""]) {
           [self firstRequest:_firstTextString];
        }
    
}
//删除完成后传递过来的字典
- (void)switchClick:(NSNotification *)text{
       GDAddPhotoTableViewCell *cell1 = (GDAddPhotoTableViewCell *)[self.mytable viewWithTag:50];
    /////////  14 调用GDAddPhotoTableViewCell的方法  PhotoArrAdd   将图片传过去
     _picArray=text.userInfo[@"array"];
       NSLog(@"_picarray====%@",_picArray);
      [cell1 PotoArrArray:text.userInfo[@"array"]];
   
}
//查看图片明细
-(void)scanPic:(NSNotification*)sender {
    
    picVC =[[PicViewController alloc]initWithArray:_picArray withDic:sender.userInfo withTitleStr:_titleStr];
    picVC.type=[_fromDic[@"STATECODE"]intValue];
    
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
    [self.mytable reloadData];

}
-(void)ChangesTableviewHeight_two{
    imgRowhight = 200;
    [self.mytable reloadData];


}
-(void)ChangeTableviewHeight_three{
    imgRowhight = 300;
    [self.mytable reloadData];

}
-(void)ChangesTableviewHeight_four{
    imgRowhight = 400;
    [self.mytable reloadData];

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
    
    
    UIImage *newImage =[CommonTool imageWithImageSimple:image scaledToSize:CGSizeMake(164, 216)];
         //根据tag值找到所在的cell  在此不能alloc新建  要找原来的那个cell
    GDAddPhotoTableViewCell *cell1 = (GDAddPhotoTableViewCell *)[self.mytable viewWithTag:50];
    /////////  14 调用GDAddPhotoTableViewCell的方法  PhotoArrAdd   将图片传过去
    [_picArray insertObject:newImage atIndex:0];

    [cell1 PhotoArrAdd:newImage];
    
}
//将保存到沙盒
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    
    NSLog(@"zhgchjsdhjf=====%@",[self documentFolderPath]);
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
    [self upLoadSalesBigImage:fullPathToFile MidImage:imageName SmallImage:@""];
}
//上传图片
- (void)upLoadSalesBigImage:(NSString *)bigImage MidImage:(NSString *)midImage SmallImage:(NSString *)smallImage
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HTTPIP,UPLOAD_URL]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    //[request setPostValue:@"photo" forKey:@"type"];
    [request setFile:bigImage forKey:@"fileName"];
    //request.tag=1999;
    [request setFile:bigImage withFileName:midImage andContentType:@"image/jpg" forKey:@"path"];
    [request buildPostBody];
    [request setDelegate:self];
    [request setTimeOutSeconds:8];
    [request startAsynchronous];
    
    NSLog(@"path=======%@/1.jpg,", [self documentFolderPath]);
   
}

#pragma mark 从文档目录下获取Documents路径
- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return section==0?6:1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==0?0:20;



}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==1) {
                return 80;
            }else{
                return 30;
            
            
            }
        
            
        }
            break;
        case 1:{
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
            if (indexPath.row==1) {
                TextViewTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"TEXTCELL"];
               cell.txtView.tag=10002;
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;

                if ([_fromDic[@"STATECODE"]intValue]==0||[_fromDic[@"STATECODE"]intValue]==1|[_fromDic[@"STATECODE"]intValue]==3||[_fromDic[@"STATECODE"]intValue]==2) {
                   cell.txtView.text=_fromDic[@"CONTENT"];                    if ([_fromDic[@"STATECODE"]intValue]==0
                        ||[_fromDic[@"STATECODE"]intValue]==3||[_fromDic[@"STATECODE"]intValue]==2) {
                            [cell.txtView setEditable:NO];
                                            }
                                   }
               
                return cell;
            }else{
                OneTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ONECELL" forIndexPath:indexPath];
                
                if ([_fromDic[@"STATECODE"]intValue]==0||[_fromDic[@"STATECODE"]intValue]==1||[_fromDic[@"STATECODE"]intValue]==3||[_fromDic[@"STATECODE"]intValue]==2) {
                    //1是从草稿箱进入，2是从未处理登记你进入，0是从未处理进入，未分配进入，3是从已处理进入
                    //只有1和10比较特殊，其中1更加特殊
                    if ([_fromDic[@"STATECODE"]intValue]==0||[_fromDic[@"STATECODE"]intValue]==3) {
                           [cell.textfield setEnabled:NO];
                         cell.EWMBtn.userInteractionEnabled=NO;
                        if (indexPath.row==0) {
                            cell.textfield.text=_fromDic[@"DID"];
                        }
                        
                    }else{
                        if (indexPath.row==0) {
                            cell.textfield.text=_fromDic[@"DID"];

                            [cell.textfield setEnabled:NO];
                            
                        }
                    
                    }
                   if (indexPath.row==2){
                        cell.textfield.text=[CommonTool DataFormart:_fromDic[@"OPERATEDATE"] ];
                                  }
                    if (indexPath.row==3){
                        cell.textfield.text=_fromDic[@"REPORTER"];
                                      
                    }
                    if (indexPath.row==4){
                        cell.textfield.text=_fromDic[@"PHONE"];
                                        }
                    if (indexPath.row==5){
                        cell.textfield.text=_fromDic[@"ADDRESS"];
                    }
               
                } // 判断二维码扫描
                else if ([_fromDic[@"STATECODE"]intValue]==10) {
                    if (indexPath.row==0) {
                        cell.textfield.text=CUSTOMERINFO;

                    }
                        if (indexPath.row==2 ) {
                            NSDateFormatter *formater =[[NSDateFormatter alloc]init];
                            [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                            NSString *datastring =[formater stringFromDate:[NSDate date]];
                            cell.textfield.text=datastring;
                            cell.textfield.enabled=NO;

                        }
                    if (indexPath.row==5) {
                        cell.textfield.text=[NSString stringWithFormat:@"%@%@",cityName,cityPlace];
                                       
                        }


                }
                cell.textfield.tag=indexPath.row+10000;
                
        [cell.textfield addTarget:self action:@selector(textFieldBeginEide:) forControlEvents: UIControlEventEditingDidEnd];
            cell.textfield.tag=10000+indexPath.row+1;
            cell.EWMBtn.hidden=indexPath.row==0?NO:YES;
            [cell.EWMBtn addTarget:self action:@selector(ewmbtnClick) forControlEvents:UIControlEventTouchUpInside];
            NSArray *array =[[NSArray alloc]initWithObjects:@"设备编号:",@"报修内容:",@"登记时间:",@"报修人员:",@"联系方式:",@"报修地点:", nil];
            cell.label.font=[UIFont systemFontOfSize:14];
            cell.label.textAlignment=UITextAlignmentRight;
            cell.label.text=array[indexPath.row];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

            return cell;
                
            }
            
           
        }
            break;
        case 1:{
            
           GDAddPhotoTableViewCell*cell =[tableView dequeueReusableCellWithIdentifier:@"GDCELL"];
            
            if ([_fromDic[@"STATECODE"]intValue]==0||[_fromDic[@"STATECODE"]intValue]==1||[_fromDic[@"STATECODE"]intValue]==3) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"禁止打开相册" object:nil];
            
     
            }
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
            if ([_fromDic[@"STATECODE"]intValue]==0||[_fromDic[@"STATECODE"]intValue]==1||[_fromDic[@"STATECODE"]intValue]==3) {
                self.isRecoding=YES;
                cell.play.titleLabel.alpha=0.5;
                [cell.play setEnabled:NO];
                cell.recoad.userInteractionEnabled=NO;
                cell.recoad.titleLabel.alpha=0.5;
                      }
            
            if (self.isRecoding==NO) {
                
                //播放按钮不能被点击
                [cell.play setEnabled:NO];
                //播放按钮设置成半透明
                cell.play.titleLabel.alpha = 0.5;

            }else{
            
            
            
            }
                     cell.tag=100;
                     return cell;
                 }
            break;
    }
    
    
   // return cell;



}


-(void)textFieldBeginEide:(UITextField*)textField{
    
    
    if (textField.tag==10001) {
        
        if (![textField.text isEqualToString:@""]) {
            [self firstRequest:textField.text];
        }

    }
        

}

-(void)ewmbtnClick{
    
    SYQRCodeViewController *vc= [[SYQRCodeViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];



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
        self.recorder = [[AVAudioRecorder alloc]initWithURL:_tmpFile settings:nil error:nil];
        
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
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:_tmpFile error:&playError];
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


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, LWIDTH, 20)];
    view.backgroundColor=[UIColor blackColor];
        UILabel *lab =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, LWIDTH, 20)];
    lab.font=[UIFont systemFontOfSize:16];
        if (section==0) {
            lab.text=@"";
        }else if (section==1){
            lab.textColor=[UIColor whiteColor];
        lab.text=@"添加图片";
            }else{
                
                
                  lab.text=@"添加留言";
                lab.tag=6666;
                lab.textColor=[UIColor whiteColor];
            UIImageView *imageview =[[UIImageView alloc]initWithFrame:CGRectMake(LWIDTH-40, 0, 20, 20)];
            imageview.image=[UIImage imageNamed:@"speak"];
                [view addSubview:imageview];
          
    
           }
    [view addSubview:lab];
    return view;
}

- (IBAction)keewping:(UIButton *)sender {
    
    
    if ([_fromDic[@"STATECODE"]intValue]==1) {
        CUSTOMERINFO=_fromDic[@"DID"];
         [self keepRequestwithGuid:_fromDic[@"DGUID"] withcmdType:@"UPDATE"];
        
        
    }else{
        if (iskeeping==NO) {
            [self keepRequestwithGuid:myguid withcmdType:@"APPEND"];
        }else{
            [self keepRequestwithGuid:myguid withcmdType:@"UPDATE"];

            
            
        }

    
    
    
    }
    
    

}

- (IBAction)delele:(UIButton *)sender {
    
    if ([_fromDic[@"STATECODE"]intValue]==0||[_fromDic[@"STATECODE"]intValue]==2) {
        
        [self SeeRelutWithguid:_fromDic[@"RRGUID"]];
        
    }else if([_fromDic[@"STATECODE"]intValue]==1){
        [self deleteRequest:_fromDic[@"RRGUID"]];
        
    }else if ([_fromDic[@"STATECODE"]intValue]==3){
        
        
        ADD_VC *vc =[[ADD_VC alloc]initWithADic:_fromDic withTitle:@"维修记录"];
        vc.type=2;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    }else{
        [self deleteRequest:_keepGuid];
    }

 
   }

- (IBAction)confirm:(UIButton *)sender {
    
    if ([_fromDic[@"STATECODE"]intValue]==10) {
//        if ([_keepGuid isEqualToString:@""]) {
//            [SVProgressHUD showErrorWithStatus:@"请先保存单据，在提交。"];
//            return;
//        }

            [self commitRequest:_keepGuid];
    }else{
    
        [self commitRequest:_fromDic[@"RRGUID"]];
    
    }

}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark
-(void)requestDetil{
    NSString *xmlstring =[NSString stringWithFormat:@"<Data><Action>GETREPAIRRECORDDETAIL</Action><RRGUID>%@</RRGUID></Data>",_fromDic[@"RRGUID"]];
    NSLog(@"xmlstring====%@",xmlstring);
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlstring];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
                _XMLDic=(NSMutableDictionary*)[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            _XmlArray=_XMLDic[@"R"];
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
    //下载文件在沙盒中的存储位置
    NSString *AudioPath=[NSTemporaryDirectory() stringByAppendingString:@"DownTmpFile"];
    NSLog(@"asgjhggjhhasggsdg===%@",AudioPath);
    NSError *playError;
    self.downloadtmpfile=[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"DownTmpFile"]];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.downloadtmpfile error:&playError];
      if ([_audiofic[@"R"] isKindOfClass:[NSDictionary class]]) {
          
          //下载的url
             NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HTTPIP,SERVER_URL,_audioDic[@"FILEPATH"]]];
                   request =[ASIHTTPRequest requestWithURL:url];
         // 设置tag值
             request.tag=1000;
          //下载的目的地
             [request setDownloadDestinationPath:AudioPath];
        [request startAsynchronous];
           UILabel *lab=(UILabel*)[self.view viewWithTag:6666];
              lab.text=_audioDic[@"FILENAME"];
        }
}

-(void)delySomeMinti{
    [SVProgressHUD dismiss];
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
    
    UIButton *playbtn =(UIButton*)[self.mytable viewWithTag:10000];
    [playbtn setEnabled:YES];
    playbtn.titleLabel.alpha=1;
       //录音状态 点击录音按钮 停止录音
   
}

#pragma mark 设备GUID请求
-(void)firstRequest:(NSString*)string{
    
     NSString *xmlstring =[NSString stringWithFormat:@"<Data><Action>SCANBARCODE</Action><BARCODE>%@</BARCODE></Data>",string];
    NSLog(@"xmlstring====%@",xmlstring);
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlstring];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            myguid=dictt[@"GUID"];
            
            CUSTOMERINFO=dictt[@"CUSTOMERINFO"];
            [self.mytable reloadData];
            
        }else{
            CUSTOMERINFO=string;
            [self.mytable reloadData];
            myguid=@"";
            
            
            UIAlertController *controler =[UIAlertController alertControllerWithTitle:@"温馨提示" message:dictt[@"ERROR"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [controler addAction:cancel];
            [self presentViewController:controler animated:YES completion:nil];

            //[SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
    };
    
}
//保存
-(void)keepRequestwithGuid:(NSString*)guid withcmdType:(NSString*)cmdtype{
    [SVProgressHUD showWithStatus:@"正在保存..."];
    NSLog(@"myguif=====%@",myguid);
       
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
    UITextView *textView =(UITextView*)[self.view viewWithTag:10002];
    UITextField *timetxt =(UITextField*)[self.view viewWithTag:10003];
    //UITextField *persion =(UITextField *)[self.view viewWithTag:10004];
    
    UITextField *phoneNumber =(UITextField *)[self.view viewWithTag:10005];
    
    UITextField *place =(UITextField *)[self.view viewWithTag:10006];
    NSString *xmlstring =[NSString stringWithFormat:@"<Data><Action>SAVEREPAIRRECORD</Action><CMDTYPE>%@</CMDTYPE><USERID>%@</USERID><PWD>%@</PWD><RRGUID>%@</RRGUID><DGUID>%@</DGUID><ADDRESS>%@</ADDRESS><DID>%@</DID><PHONE>%@</PHONE><CONTENT>%@</CONTENT><OPERATEDATE>%@</OPERATEDATE><SIMNO>%@</SIMNO><REPORTER>%@</REPORTER>%@%@</Data>",cmdtype,USER_NAME,PASSWORD,_fromDic[@"RRGUID"],guid,place.text,CUSTOMERINFO,phoneNumber.text,textView.text,timetxt.text,SIM_CODE,XML_STR,audioStr,picxmstring];
    
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlstring];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            _keepGuid=dictt[@"GUID"];
            iskeeping=YES;
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
    };
    
    //
    //    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlstring withPath:AudioPath withPicArray:_picArray];
    //    manger.backSuccess=^void(NSDictionary *dictt){
    //        [SVProgressHUD dismiss];
    //        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
    //            _keepGuid=dictt[@"GUID"];
    //            iskeeping=YES;
    //           [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    //                    }else{
    //                   [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
    //              }
    //       };
    
    
    
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
    
    
    
    
}
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




//删除
-(void)deleteRequest:(NSString *)Guid{
           NSString *xmlstring =[NSString stringWithFormat:@"<Data><Action>DELREPAIRRECORD</Action><RRGUID>%@</RRGUID></Data>",Guid];
    NSLog(@"xmlstring====%@",xmlstring);
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlstring];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [self.navigationController popViewControllerAnimated:YES];
                 }else{
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
        
        
    };

    [self.navigationController popViewControllerAnimated:YES];

}

-(void)commitRequest:(NSString *)guid{
       NSString *xmlstring =[NSString stringWithFormat:@"<Data><Action>REFERORCLOSE</Action><RRGUID>%@</RRGUID><STATECODE>0</STATECODE></Data>",guid];
    NSLog(@"xmlstring====%@",xmlstring);
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlstring];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
        
        
    };
    [self.navigationController popViewControllerAnimated:YES];


}
// 查看处理结果

-(void)SeeRelutWithguid:(NSString*)guid{
    
    NSString *xmlstring =[NSString stringWithFormat:@"<Data><Action>CHECKRESULT</Action><RRGUID>%@</RRGUID></Data>",guid];
    NSLog(@"xmlstring====%@",xmlstring);
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlstring];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
     };
    


}



#pragma mark========ASIHTTPRequest 代理
//开始上传
- (void)requestStarted:(ASIHTTPRequest *)request
{
    if (request.tag==9999) {
        [SVProgressHUD showWithStatus:@"开始上传..."];

    }
  }
//上传结束
- (void)requestFinished:(ASIHTTPRequest *)request
{
    GDAddPhotoTableViewCell *cell1 = (GDAddPhotoTableViewCell *)[self.mytable viewWithTag:50];
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

//上传失败
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"小提示" message:@"您的网络情况不太好~😰" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    alert.tag = 7788;
    [alert show];
}






@end
