//
//  ChangeVC.m
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/6/28.
//
//

#import "ChangeVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "VPImageCropperViewController.h"
#import "UIImageView+WebCache.h"
#import "Area_Detil_ViewController.h"
#define ORIGINAL_MAX_WIDTH 640.0f
@interface ChangeVC ()<VPImageCropperDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>{
    NSDictionary *_showDic;
    NSMutableArray *_imageArray;
   
}

@end

@implementation ChangeVC
-(instancetype)initWithDic:(NSDictionary *)aDic{
    self =[super init];
    if (self) {
        _showDic=aDic;
        
          }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //_imageView =[NSMutableArray array];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@%@",HTTPIP,IMAGE_URL,_showDic[@"areaimg"]]] placeholderImage:[UIImage imageNamed:@"equ_icon_TV"]];
    self.myTextField.text=_showDic[@"areaname"];
    self.myTextField.delegate=self;
    self.myTextField.returnKeyType=UIReturnKeyDone;
    UITapGestureRecognizer * tapView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeUserImag)];
   self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tapView];
    self.imageView.  layer.masksToBounds = YES;
   self.imageView.layer.cornerRadius = 50;
  
}
- (void)changeUserImag
{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    
    
    
    
    
    [choiceSheet showInView:self.view];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.myTextField resignFirstResponder];


    return YES;

}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
         if (buttonIndex == 0) {
        // 拍照
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
        
    } else if (buttonIndex == 1) {
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
    }
}

- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
    
     UIImage *iamge =[self compressImage:editedImage];
    self.imageView.image = iamge;
}
     
- (UIImage *)compressImage:(UIImage *)imgSrc
{
    CGSize size = {170 , 170};
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
         portraitImg = [self imageByScalingToMaxSize:portraitImg];//这个不加的话，拍照上传照片是倒着的
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0 vover:nil];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
            
           // NSLog(@"123456");
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


- (IBAction)btnClick:(id)sender {
    [self requestForKeep];
   
}


//保存修改
-(void)requestForKeep{
    

    if (!self.myTextField.text ) {
        [SVProgressHUD showErrorWithStatus:@"区域名不能为空"];
        return;
    }

    
    NSString *urlstring =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *myrequestStr=[NSString stringWithFormat:@"{\"funcode\":\"10410\",\"areaid\":\"%@\",\"areaname\":\"%@\",\"actuserid\":\"%@\"}",_showDic[@"id"],self.myTextField.text,USER_ID];
        NSString *fileName =@"userimg.png";
    NSData *data =UIImagePNGRepresentation(self.imageView.image);
    
    NSURL* myurl = [NSURL URLWithString:urlstring];
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:myurl];
    request.delegate = self;
    request.tag=1999;
    [request setTimeOutSeconds:8];
    [request setPostValue:myrequestStr forKey:@"jsonrequest"];
    [request setData:data withFileName:fileName andContentType:@"image/png" forKey:@"file"];
    [request startAsynchronous];
    
    
    
    
}

//开始上传
- (void)requestStarted:(ASIHTTPRequest *)request
{
    [SVProgressHUD showWithStatus:@"开始上传..."];
}

//上传完成
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *data = request.responseData;
    NSLog(@"data========%@",data);
    
    NSMutableDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"asdfvadhsgfsd====%@",dict);
    
    if (request.tag == 1999) {
        if ([[dict objectForKey:@"SS"] integerValue]==200) {
            [SVProgressHUD showSuccessWithStatus:dict[@"MSG"]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:dict[@"MSG"]];
            
        }
        
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
@end
