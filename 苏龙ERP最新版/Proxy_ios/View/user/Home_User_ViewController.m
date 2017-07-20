//
//  Home_User_ViewController.m
//  Proxy_ios
//
//  Created by E-Bans on 15/11/13.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "Home_User_ViewController.h"
#import "UIImageView+WebCache.h"
#import "VPImageCropperViewController.h"
#import "SBJSON.h"
#import "EWMController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define ORIGINAL_MAX_WIDTH 640.0f

@interface Home_User_ViewController () <MyRequestDelegate,UITextFieldDelegate,UIActionSheetDelegate,VPImageCropperDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIView* popView;
    NSString* sexStr;
    NSDictionary* showDataDict;
    UIImage* userImagUp;
    BOOL sex;
    int oldsex;
    int nowsex;
}
@end

@implementation Home_User_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";

    
    UIBarButtonItem * lefyButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@""
                                    style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(callModalList)];
    
    [lefyButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:15], NSFontAttributeName,
                                        [UIColor whiteColor], NSForegroundColorAttributeName,
                                        nil]
                              forState:UIControlStateNormal];
    lefyButton.image = [UIImage imageNamed:@"leftImag"];
    self.navigationItem.leftBarButtonItem = lefyButton;
  
    
    phone.delegate = self;
    tel.delegate = self;
    email.delegate = self;
    msn.delegate = self;
    place.delegate = self;
    manBTN.hidden=YES;
    womanBtn.hidden=YES;
    manLab.hidden=YES;
    womanLab.hidden=YES;
    
    upUserInfoButton.layer.cornerRadius = 3;
    upUserInfoButton.layer.masksToBounds = YES;
    upUserInfoButton.backgroundColor = [UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1];
    
    UITapGestureRecognizer * tapView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeUserImag)];
    userImag.userInteractionEnabled = YES;
    [userImag addGestureRecognizer:tapView];
    userImag.layer.masksToBounds = YES;
    userImag.layer.cornerRadius = 40;
    
    tel.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    phone.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    msn.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    email.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    tel.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    phone.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    msn.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    email.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    tel.returnKeyType =UIReturnKeyDone;
    phone.returnKeyType =UIReturnKeyDone;
    msn.returnKeyType =UIReturnKeyDone;
    email.returnKeyType =UIReturnKeyDone;
    place.returnKeyType =UIReturnKeyDone;
    sex=NO;
    
    [self requestShowDataUserInfo];
}
- (void)callModalList
{
    AppDelegate *aAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [aAppDelegate.ddMenu showLeftController:YES];
}
- (void)initView
{
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    [userImag sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@/Jsframe/SystemMng/PersonImages/%@",HTTPIP,SLRD,[showDataDict objectForKey:@"PERSONIMAGEPATH"]]] placeholderImage:[UIImage imageNamed:@"imagUserIndex"]];
    userName.text = [NSString stringWithFormat:@"%@【%@】",[showDataDict objectForKey:@"PERSONNAME"],[showDataDict objectForKey:@"USERNAME"]];
    userPerson.text = [NSString stringWithFormat:@"%@ -- %@",[showDataDict objectForKey:@"DEPTNAME"],[showDataDict objectForKey:@"POSITIONNAME"]];
    phone.text = [NSString stringWithFormat:@"%@",[[showDataDict objectForKey:@"MOBILE"] stringByReplacingOccurrencesOfString:@";" withString:@""]];
    tel.text = [NSString stringWithFormat:@"%@",[[showDataDict objectForKey:@"OFFICETELEPHONE"] stringByReplacingOccurrencesOfString:@";" withString:@""]];
    email.text = [NSString stringWithFormat:@"%@",[showDataDict objectForKey:@"EMAIL"]];
    place.text = [NSString stringWithFormat:@"%@",[showDataDict objectForKey:@"DWELLINGPLACE"]];
    msn.text = [NSString stringWithFormat:@"%@",[showDataDict objectForKey:@"MSN"]];
    oldsex=[[showDataDict objectForKey:@"GENDER"]intValue];
    nowsex=oldsex;
    
    switch (oldsex) {
        case 0:{
            [manBTN setBackgroundImage:[UIImage imageNamed:@"home_write_caogao_1"] forState:0];
            [womanBtn setBackgroundImage:[UIImage imageNamed:@"home_write_caogao"] forState:0];
        
        
        }
            
            break;
            
        case 1:{
            [manBTN setBackgroundImage:[UIImage imageNamed:@"home_write_caogao"] forState:0];
            [womanBtn setBackgroundImage:[UIImage imageNamed:@"home_write_caogao_1"] forState:0];
            
        }break;
    }
    
    [SVProgressHUD dismiss];
}
- (void)requestShowDataUserInfo
{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    [popView removeFromSuperview];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETUSERINFO",@"Action",USERGUID,@"GUID", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/ProxyMobile/MobileFrame.ashx",HTTPIP,SLRD] withParameter:dict];
    //    manager.delegate = self;
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        showDataDict = [NSDictionary dictionaryWithDictionary:[[dictt objectForKey:@"Data"] objectForKey:@"R"]];
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            [self initView];
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}
#pragma mark ------------------------- 网络环境不可用时的页面
- (void)RequestErrorViewController
{
    [SVProgressHUD dismiss];
    popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LWidth, LHeight)];
    popView.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    UIImageView* imag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 160)];
    imag.center = popView.center;
    imag.image = [UIImage imageNamed:@"02e9868d724dae529e06525edbaf024e.png"];
    [popView addSubview:imag];
    [self.view addSubview:popView];
    UITapGestureRecognizer* regiontapGestureT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestShowDataUserInfo)];
    [popView addGestureRecognizer:regiontapGestureT];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if (textField.tag >= 2 & IPHONE_5) {
        [self animateWithFrame:-(50*(textField.tag-2))];
    }else if (textField.tag >= 3 & IPHONE_6) {
        [self animateWithFrame:-(50*(textField.tag-3))];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, 64.0f, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    return YES;
}
- (IBAction)upUserInfo:(id)sender {
    //    [SVProgressHUD showWithStatus:@"请稍后..."];
    if (![[NSString stringWithFormat:@"%@;",phone.text] isEqualToString:[showDataDict objectForKey:@"MOBILE"]] || ![[NSString stringWithFormat:@"%@;",tel.text] isEqualToString:[showDataDict objectForKey:@"OFFICETELEPHONE"]] || ![email.text isEqualToString:[showDataDict objectForKey:@"EMAIL"]] || ![place.text isEqualToString:[showDataDict objectForKey:@"DWELLINGPLACE"]] || ![msn.text isEqualToString:[showDataDict objectForKey:@"MSN"]]||nowsex!=oldsex) {
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"UPDATEUSERINFO",@"Action",[showDataDict objectForKey:@"GUID"],@"GUID",[NSString stringWithFormat:@"%d",nowsex],@"GENDER",[NSString stringWithFormat:@"%@;",tel.text],@"OFFICETELEPHONE",[NSString stringWithFormat:@"%@;",phone.text],@"MOBILE",place.text,@"DWELLINGPLACE",email.text,@"EMAIL",msn.text,@"MSN", nil];
        MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/ProxyMobile/MobileFrame.ashx",HTTPIP,SLRD] withParameter:dict];
        manager.delegate = self;
        manager.backSuccess = ^void(NSDictionary *dictt)
        {
            if ([[dictt objectForKey:@"success"] integerValue] == 1) {
                [self requestShowDataUserInfo];
            }else{
                [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
            }
        };
    }else{
        [SVProgressHUD showErrorWithStatus:@"您的信息无变化"];
    }
}

- (IBAction)sexBtnClick:(UIButton *)sender {
   
    
    switch (sender.tag) {
        case 100:
        {NSLog(@"100");
            nowsex=0;
            
            sex=NO;
            [manBTN setBackgroundImage:[UIImage imageNamed:@"home_write_caogao_1"] forState:0];
            [womanBtn setBackgroundImage:[UIImage imageNamed:@"home_write_caogao"] forState:0];
           // sexImagMen.image = ;0
            //sexImagWomen.image =
            
        }
            break;
        case 200:{
            NSLog(@"200");
            nowsex=1;
            [manBTN setBackgroundImage:[UIImage imageNamed:@"home_write_caogao"] forState:0];
            [womanBtn setBackgroundImage:[UIImage imageNamed:@"home_write_caogao_1"] forState:0];
            

        
        }
            break;
    }

}

- (IBAction)sexButtonClick:(id)sender {
    UIButton* btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:
        {
            sexStr = @"0";
            sexImagMen.image = [UIImage imageNamed:@"home_write_caogao_1"];
            sexImagWomen.image = [UIImage imageNamed:@"home_write_caogao"];
            
        }
            break;
        case 1:
        {
            sexStr = @"1";
            sexImagMen.image = [UIImage imageNamed:@"home_write_caogao"];
            sexImagWomen.image = [UIImage imageNamed:@"home_write_caogao_1"];
        }
            break;
            
        default:
            break;
    }
}

- (void)animateWithFrame:(float)frameY
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, frameY, self.view.frame.size.width, self.view.frame.size.height);
    }];
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
    
    
    NSData* data = UIImageJPEGRepresentation([self compressImage:editedImage], 0.1);
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@/ProxyMobile/uploaduserimage.ashx?aguid=%@&imageName=00000000000000000000000000000001.GIF",HTTPIP,SLRD,USERGUID]];
    
    NSLog(@"url=====%@",url);
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.tag = 1999;
    [request setTimeOutSeconds:8];
    [request setData:data withFileName:@"00000000000000000000000000000001.GIF" andContentType:@"image/png" forKey:@"path"];
    [request startAsynchronous];
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
    userImagUp = editedImage;
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
- (void)requestStarted:(ASIHTTPRequest *)request
{
    [SVProgressHUD showWithStatus:@"开始上传..."];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == 1999) {
        NSString *str1 = request.responseString;
        NSString *str = @"上传成功";
        NSLog(@"STR1=====%@",str1);
        if ([str1 rangeOfString:str].location != NSNotFound) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            userImag.image = userImagUp;
        }else{
            [SVProgressHUD showErrorWithStatus:@"上传失败了~再试一次"];
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
@end
