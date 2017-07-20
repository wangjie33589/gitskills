//
//  NSViewController.m
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/22.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "NSViewController.h"
#import "WebViewViewController.h"
#import "UIImageView+WebCache.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define ORIGINAL_MAX_WIDTH 640.0f
#define NUM_DOCS 4

@interface NSViewController ()<MyRequestDelegate,VPImageCropperDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSString* guid;
    NSDictionary* showDict;
    NSMutableArray* attachmentArray;
    NSString *title;
    
}
@end

@implementation NSViewController
- (id)initWithUrl:(NSString *)aUrl WithTitleStr:(NSString*)title_Str;
{
    self = [super init];
    if (self) {
        guid = aUrl;
        title=title_Str;
    }
    return self;
}
#pragma mark -
#pragma mark View Controller

- (void)setupDocumentControllerWithURL:(NSURL *)url
{
    if (self.docInteractionController == nil)
    {
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.docInteractionController.delegate = self;
    }
    else
    {
        self.docInteractionController.URL = url;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = title;
    //attachmentArray=[NSMutableArray array];
//   NSString *filrUrl   =[NSTemporaryDirectory() stringByAppendingString:@""];
//    self.docWatcher = [DirectoryWatcher watchFolderWithPath:filrUrl delegate:self];
    
    
    //self.documentURLs = [NSMutableArray array];
    
    // scan for existing documents
    //[self directoryDidChange:self.docWatcher];

    if ([title isEqualToString:@"附件"]){
    
        UIBarButtonItem *rightBtn =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBtn)];
        self.navigationItem.rightBarButtonItem=rightBtn;
    
    }
   
    [self requestShowDataNews];
}
-(void)addBtn{
    UIAlertController *controller =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:  UIAlertControllerStyleAlert];
    UIAlertAction *action =[UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
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
    UIAlertAction *action_two =[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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
    
    [controller addAction:action];
    [controller addAction:action_two];
    [controller addAction:cancel];
    [self presentViewController:controller animated:YES completion:nil];




}
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    
    NSDateFormatter *formater =[[NSDateFormatter alloc]init];
    [formater setDateFormat:@"YYMMDDHHmmss"];
    NSString *aguid=[formater stringFromDate:[NSDate date]];
    NSString *fileName =[NSString stringWithFormat:@"%@.jpg",[formater stringFromDate:[NSDate date]]];
    NSData* data = UIImageJPEGRepresentation([self compressImage:editedImage], 0.1);
    //NSData* data = UIImageJPEGRepresentation(editedImage, 0.1);
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@/ProxyMobile/FileUpload.aspx?GUID=%@&TYPE=file",HTTPIP,SLRD,aguid]];
    
    NSLog(@"url=====%@",url);
    
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.tag = 1999;
    [request setTimeOutSeconds:8];
    [request setData:data withFileName:fileName andContentType:@"image/jpg" forKey:@"path0"];
    [request startAsynchronous];
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
    
}
- (UIImage *)compressImage:(UIImage *)imgSrc
{
    CGSize size = {480 , 320};
    UIGraphicsBeginImageContext(size);
    CGRect rect = {{0,0}, size};
    [imgSrc drawInRect:rect];
    UIImage *compressedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return compressedImg;
}
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0 vover:nil];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
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

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    

}
- (void)requestShowDataNews
{
    //[SVProgressHUD showWithStatus:@"努力加载中..."];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETNOTICEDATABYGUID",@"Action",guid,@"GUID", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/NM/proxyMobile/noticeproxy.ashx",HTTPIP,SLRD] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if ([dictt objectForKey:@"Data"]!=[NSNull null]) {
                showDict= [NSDictionary dictionaryWithDictionary:[[dictt objectForKey:@"Data"] objectForKey:@"R"]];
        }
        [self initView];
        [SVProgressHUD dismiss];
    };
}
- (void)initView
{
    if ([title isEqualToString:@"公告详情"]) {
        nsTitle.text = [showDict objectForKey:@"TITLE"];
        time.text = [NSString stringWithFormat:@"发布时间:%@",[[[showDict objectForKey:@"ADDTIME"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:16]];
        name.text = [NSString stringWithFormat:@"发布人:%@",[showDict objectForKey:@"ADDUSERNAME"]];
        contens.text = [showDict objectForKey:@"CONTENT"];
        UIFont* font = [UIFont systemFontOfSize:15];
        CGSize size = [self sizeWithString:[showDict objectForKey:@"CONTENT"] font:font];
        contens.frame = CGRectMake(8, name.frame.origin.y+30, LWidth-16, size.height+8);

    }
    
       [self requestShowData];
}
- (void)requestShowData
{
    [attachmentArray removeAllObjects];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETMOBILEFILES",@"Action",guid,@"GUID",@"FILE",@"TYPE", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/ProxyMobile/MobileFrame.ashx",HTTPIP,SLRD] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        NSDictionary* isNull = [dictt objectForKey:@"FILES"];
        if (![self isEmpty:isNull]) {
            
            if ([[[dictt objectForKey:@"FILES"]objectForKey:@"FILE"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = [[dictt objectForKey:@"FILES"]objectForKey:@"FILE"]
                ;
                attachmentArray = [NSMutableArray arrayWithObjects:dic, nil];
                
            }else {
                
                attachmentArray = [NSMutableArray arrayWithArray:[[dictt objectForKey:@"FILES"] objectForKey:@"FILE"]];
            
            }
                       [self initViewFile];
        }else{
            
            
            UIAlertController *conttter =[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前单据没有附件！！！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action =[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [conttter addAction:action];
            [self presentViewController:conttter animated:YES completion:nil];
            
        }

        
    };
}
- (BOOL)isEmpty:(NSDictionary *)_dic
{
    if ([_dic isKindOfClass:[NSNull class]])  {
        return YES;
    }
    if (_dic == nil) {
        return YES;
    }
    if (_dic == NULL) {
        return YES;
    }
    if ((NSNull*)_dic == [NSNull null]) {
        return YES;
    }
    return NO;
}
- (void)initViewFile
{
    
    
    UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, LWidth, LHeight)];
    backView.backgroundColor=[UIColor whiteColor];
    backView.tag=10000;
    [self.view  addSubview:backView];

    for (NSInteger index = 0; index < attachmentArray.count; index ++) {
        
        //NSLog(@"atttarrrr=12345=%@",[attachmentArray objectAtIndex:1] );
        NSString* str = [[attachmentArray objectAtIndex:index] objectForKey:@"NAME"];
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(8, 50*index+contens.frame.origin.x+contens.frame.origin.y+30, LWidth-16, 40)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.masksToBounds = YES;
        view.tag=index;
        view.layer.cornerRadius = 6;
        view.layer.borderColor = [[UIColor colorWithRed:0.773 green:0.780 blue:0.776 alpha:1] CGColor];
        view.layer.borderWidth = 1.5f;
        [backView addSubview:view];
        
        UIImageView* imagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fujian"]];
        imagView.frame = CGRectMake(13, 7, 23, 26);
        [view addSubview:imagView];
        
        UILabel* titile = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, LWidth-160, 40)];
        titile.textColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1];
        titile.textAlignment = NSTextAlignmentLeft;
        titile.font = [UIFont systemFontOfSize:14];
        titile.text = str;
        [view addSubview:titile];
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = index;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 6;
       // btn.layer.borderColor = [[UIColor colorWithRed:42/255.0 green:131/255.0 blue:254/255.0 alpha:1] CGColor];
        //btn.layer.borderWidth = 2.f;
        btn.frame = CGRectMake(view.frame.size.width-50, 8, 40, 25);
        [btn setImage:[UIImage imageNamed:@"download"] forState:0];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        //[btn setTitleColor:[UIColor colorWithRed:42/255.0 green:131/255.0 blue:254/255.0 alpha:1] forState:0];
        [btn addTarget:self action:@selector(attachmentClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UIButton* delbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        delbtn.tag = index;
        delbtn.layer.masksToBounds = YES;
        delbtn.layer.cornerRadius = 6;
        //delbtn.layer.borderColor = [[UIColor colorWithRed:42/255.0 green:131/255.0 blue:254/255.0 alpha:1] CGColor];
        //delbtn.layer.borderWidth = 2.f;
        delbtn.frame = CGRectMake(view.frame.size.width-100, 8, 40, 25);
        [delbtn setImage:[UIImage imageNamed:@"delete"] forState:0];
        delbtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [delbtn setTitleColor:[UIColor colorWithRed:42/255.0 green:131/255.0 blue:254/255.0 alpha:1] forState:0];
        [delbtn addTarget:self action:@selector(delteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:delbtn];

    }
}
-(void)delteBtnClick:(UIButton*)sender{

   // NSString* str = [[attachmentArray objectAtIndex:sender.tag]
                    // objectForKey:@"PATH"];
    NSString* FGUID = [[attachmentArray objectAtIndex:sender.tag] objectForKey:@"FGUID"];
    
    NSString *UrlStr =[NSString stringWithFormat:@"http://%@%@/ProxyMobile/MobileFrame.ashx",HTTPIP,SLRD];
    NSLog(@"urlstring====%@",UrlStr);
    
    NSDictionary *Dict =[NSDictionary dictionaryWithObjectsAndKeys:FGUID,@"GUID",@"DELMOBILEFILE",@"Action", nil];
    
    MyRequest *manager =[MyRequest requestWithURL:UrlStr withParameter:Dict];
    manager.delegate=self;
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            UIView *view =(UIView *)[self.view viewWithTag:10000];
            [view removeFromSuperview];
            [self requestShowDataNews];
            //[self requestShowDataList2:[dictt objectForKey:@"serverUrl"]];
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };

//    
//    NSLog(@"attachmentArray objectAtIndex:sender.tag====%@",[attachmentArray objectAtIndex:sender.tag]);
//    NSLog(@"index====%ld",(long)sender.tag);
//  
//



}
- (void)attachmentClick:(UIButton *)sender
{
    NSString* str = [[attachmentArray objectAtIndex:sender.tag] objectForKey:@"PATH"];
     NSString* nameStr = [[attachmentArray objectAtIndex:sender.tag] objectForKey:@"NAME"];
    if ([[[attachmentArray objectAtIndex:sender.tag] objectForKey:@"EXTENSION"] isEqualToString:@".txt"]) {
       
        
//
//        WebViewViewController* VC = [[WebViewViewController alloc] initWithUrl:[NSString stringWithFormat:@"http://%@%@/%@",HTTPIP,SLRD,[str stringByReplacingOccurrencesOfString:@"../" withString:@""]] type:@"txt"];
      
        NSLog(@"nishishui hdsgfhjd===%@",[str stringByReplacingOccurrencesOfString:@"../" withString:@""]);
        NSString *filePath=[NSTemporaryDirectory() stringByAppendingString:nameStr];
        NSLog(@"filepath===%@",filePath);
        //
        
        NSString *url=[NSString stringWithFormat:@"http://%@%@/%@",HTTPIP,SLRD,[str stringByReplacingOccurrencesOfString:@"../" withString:@""]];
          NSString* encodedString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        ASIHTTPRequest* request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:encodedString]];
        request.delegate=self;
        request.tag=100;
        [request setDownloadDestinationPath:filePath];
        [request startAsynchronous];
        
        NSURL *fileURL= [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:nameStr]];
        [self setupDocumentControllerWithURL:fileURL];
        //    [self.docInteractionController presentPreviewAnimated:YES];
        
        CGRect navRect = self.navigationController.navigationBar.frame;
        
        navRect.size = CGSizeMake(1500.0f, 40.0f);
        
        [self.docInteractionController presentPreviewAnimated:YES];

//        [self.docInteractionController presentOptionsMenuFromRect:navRect inView:self.view  animated:YES];
//
//
//
//        NSLog(@"asdfgghfsdgj====%@",[NSString stringWithFormat:@"http://%@%@/%@",HTTPIP,SLRD,[str stringByReplacingOccurrencesOfString:@"../" withString:@""]]);
//        
//        NSLog(@"____%@",[NSString stringWithFormat:@"http://%@%@/%@",HTTPIP,SLRD,[str stringByReplacingOccurrencesOfString:@"../" withString:@""]]);
//        VC.hidesBottomBarWhenPushed=YES;
//        
//        [self presentViewController:VC animated:YES completion:nil];
     
    }else{
       WebViewViewController* VC = [[WebViewViewController alloc] initWithUrl:[NSString stringWithFormat:@"http://%@%@/%@",HTTPIP,SLRD,[str stringByReplacingOccurrencesOfString:@"../" withString:@""]] type:nil];
        VC.hidesBottomBarWhenPushed=YES;
        NSString *Path=[NSTemporaryDirectory() stringByAppendingString:@"adc.xlsx"];
      NSLog(@"filepath===%@",Path);
//
        
 
//               ASIHTTPRequest* request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://221.226.212.74:65532/UploadFiles/BDF644BD9F0E4F2FB5D47B4AEA278C98_file_201607/160704155852373_app通信功能码V3.0(场景).xlsx"]];
//        
//        
//                request.delegate=self;
//                request.tag=100;
//                [request setDownloadDestinationPath:Path];
//        [request startSynchronous];
//     
//                //[request startAsynchronous];
        

        
        NSLog(@"http:=====%@",[NSString stringWithFormat:@"http://%@%@/%@",HTTPIP,SLRD,[str stringByReplacingOccurrencesOfString:@"../" withString:@""]]);
        [self presentViewController:VC animated:YES completion:nil];
        //[self.navigationController pushViewController:VC animated:YES];
    }
}
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(LWidth-16, LHeight)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  | NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    
    return rect.size;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//下载txt 的代理

#pragma mark=======ASIHTTPRequest代理
- (void)requestStarted:(ASIHTTPRequest *)request
{
    
    //[SVProgressHUD showWithStatus:@"开始上传..."];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    //GDAddPhotoTableViewCell *cell1 = (GDAddPhotoTableViewCell *)[self.myTable viewWithTag:50];
        if (request.tag==100) {
            
            //[SVProgressHUD  showSuccessWithStatus:@"下载成功"];
        
        
        
    }else if (request.tag==1999){
        NSData *data = request.responseData;
        NSLog(@"data========%@",data);
        
        NSMutableDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"asdfvadhsgfsd====%@",dict);

    if ([dict[@"success"]integerValue]==1) {
        [self requestToConnecwithDic:dict[@"data"][0]];
        
    }
    }
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"小提示" message:@"您的网络情况不太好~😰" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    alert.tag = 7788;
    [alert show];
}
//将当前单据关联起来

-(void)requestToConnecwithDic:(NSDictionary*)dic{
    NSString *xmlString =[NSString stringWithFormat:@"<FILES><FILE><FGUID>%@</FGUID><FKGUID>%@</FKGUID><TYPE>file</TYPE><EXTENSION>%@</EXTENSION><NAME>%@</NAME><PATH>%@</PATH><FULLPATH>%@</FULLPATH><CONTENTTYPE>%@</CONTENTTYPE><CONTENTLENGTH>%@</CONTENTLENGTH><REMARK></REMARK><UPLOADDATE>%@</UPLOADDATE><UPLOADERID>%@</UPLOADERID><UPLOADERNAME>%@</UPLOADERNAME><ACTIVITYGUID></ACTIVITYGUID><ORDERTYPE>1</ORDERTYPE><ISTEMP>0</ISTEMP><OPTYPE>append</OPTYPE></FILE></FILES>",dic[@"FGUID"],guid,dic[@"EXTENSION"],dic[@"NAME"],dic[@"PATH"],dic[@"FULLPATH"],dic[@"CONTENTTYPE"],dic[@"CONTENTLENGTH"],dic[@"UPLOADDATE"],dic[@"UPLOADERID"],dic[@"UPLOADERNAME"]];
    
    NSLog(@"XMLstr===%@",xmlString);
    NSString *UrlStr =[NSString stringWithFormat:@"http://%@%@/ProxyMobile/MobileFrame.ashx",HTTPIP,SLRD];
    NSLog(@"urlstring====%@",UrlStr);
    
    NSDictionary *Dict =[NSDictionary dictionaryWithObjectsAndKeys:xmlString,@"FILES",@"ADDMOBILEFILE",@"Action", nil];
   
    MyRequest *manager =[MyRequest requestWithURL:UrlStr withParameter:Dict];
    manager.delegate=self;
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            UIView *view =(UIView *)[self.view viewWithTag:10000];
            [view removeFromSuperview];
            [self requestShowDataNews];
            //[self requestShowDataList2:[dictt objectForKey:@"serverUrl"]];
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };

 

}
#pragma mark -
#pragma mark UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}





@end
