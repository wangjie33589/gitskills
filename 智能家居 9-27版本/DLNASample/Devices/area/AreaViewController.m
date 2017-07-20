//
//  AreaViewController.m
//  SyncSmartHome
//
//  Created by SciyonSoft_WangJie on 16/5/9.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "AreaViewController.h"
#import "CollectionViewCell.h"
#import "TypeDetilViewController.h"
#import "UIImageView+WebCache.h"
#import "ChangeVC.h"
#import "Area_Detil_ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "VPImageCropperViewController.h"
#import "UIButton+WebCache.h"
#define ORIGINAL_MAX_WIDTH 640.0f
@interface AreaViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,VPImageCropperDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate>{
    
     UICollectionView * collectView;
     NSMutableArray *_showArray;
     UILongPressGestureRecognizer * longPressGr;
    UIView *_eidtView;
    UIView * Comments;
    UIView *_Comments;
    UIView  *_renameView;
    UIButton * photeImgBtn;
    UITextField *field;
    
}
@property(strong,nonnull)UIImage*photnImage;
@property(retain,nonatomic)NSDictionary *eidtDic;
@end

@implementation AreaViewController
-(id)initWithArray:(NSArray *)aRR{
    
    self =[super init];
    if (self) {
        //[_showArray removeAllObjects];
           //  _showArray=(NSMutableArray*)aRR;
        
       // NSLog(@"_Array====%@",_showArray);
        
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self initCollectionView];
    
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self requestForArea];
 
}
-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    //[self initCollectionView];
    
}



-(void)initCollectionView{
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
    layout.itemSize=CGSizeMake(80, 110);
    if (IPHONE_6p) {
        layout.sectionInset=UIEdgeInsetsMake(10,(LWidth-240)/2-30,120, ( LWidth-240)/2-30);

    }else if (IPHONE_6) {
         layout.sectionInset=UIEdgeInsetsMake(10,(LWidth-240)/4,150,(LWidth-240)/4);
    }
    
    else{
        
     layout.sectionInset=UIEdgeInsetsMake(10,(LWidth-240)/4,150,(LWidth-240)/4);
    
    }
   
    layout.minimumLineSpacing=50;
   //layout.minimumInteritemSpacing=30;
    if (collectView==nil) {
          collectView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,LWidth, LHeight) collectionViewLayout:layout];
    }
    
    layout.minimumLineSpacing=5;
    
    //如果有多个区 就可以拉动
    //    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //设置头部并给定大小
//    [layout setHeaderReferenceSize:CGSizeMake(collectView.frame.size.width,44)];
//    [layout setFooterReferenceSize:CGSizeMake(collectView.frame.size.width,20)];
    //collectView.scrollEnabled =NO;
      collectView.backgroundColor=[UIColor clearColor];
    collectView.delegate=self;
    collectView.dataSource=self;

    longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    longPressGr.delegate = self;
    longPressGr.delaysTouchesBegan = YES;
    [collectView addGestureRecognizer:longPressGr];
    [collectView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
//   // _showArray =[[NSArray alloc]initWithObjects:@"厨房",@"客厅",@"卫生间",
//                 @"浴室", @"餐厅",@"卧室",@"书房",@"车库",@"娱乐室",@"花园",@"清洁室",@"添加俄",nil];
           [self.view addSubview:collectView];
 
      
}
-(void)longPressToDo:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint p = [gestureRecognizer locationInView:collectView];
        
        NSIndexPath *indexPath = [collectView indexPathForItemAtPoint:p];
        NSLog(@"afgdsf==%d",indexPath.row);
       CollectionViewCell* cell =(CollectionViewCell*)

        [collectView cellForItemAtIndexPath:indexPath];
           self.photnImage=cell.imageView.image;
        if (indexPath.row>=0&&indexPath.row<_showArray.count) {
            UIAlertController *controller =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *look=[UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                
                Area_Detil_ViewController *vc =[[Area_Detil_ViewController alloc]initWithDic:_showArray[indexPath.row]];
                vc.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            }];
            UIAlertAction *eidt=[UIAlertAction actionWithTitle:@"编辑" style:UIAlertActionStyleDestructive     handler:^(UIAlertAction * _Nonnull action) {
                self.eidtDic=_showArray[indexPath.row];
//                    ChangeVC *vc =[[ChangeVC alloc]initWithDic:_showArray[indexPath.row-1]];
//                    vc.hidesBottomBarWhenPushed=YES;
//                    
//                    [self.navigationController pushViewController:vc animated:YES];
             
                [self EidtEreaWithDic:self.eidtDic];
//                Comments = [[UIView alloc] init];
//                Comments.frame = CGRectMake(0, 0, LWidth, LHeight);
//                Comments.backgroundColor = [UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:0.3];
//                [self.view addSubview:Comments];
//                [self.view bringSubviewToFront:Comments];
//
//                _eidtView =[[UIView alloc]initWithFrame:CGRectMake(0, 100, LWidth, 200)];
//                _eidtView.backgroundColor =[UIColor whiteColor];
//                [Comments addSubview:_eidtView];
                
                
            }];
            UIAlertAction *delte=[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive  handler:^(UIAlertAction * _Nonnull action) {
                [self  requestForDeldteAreaWithDIc:_showArray[indexPath.row]];
                
            }];
            UIAlertAction *common=[UIAlertAction actionWithTitle:@"设置常用" style:UIAlertActionStyleDestructive  handler:^(UIAlertAction * _Nonnull action) {
                [self requestForUserOperation:_showArray[indexPath.row]];
                
            }];
            
            
            UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [controller addAction:look];
            [controller addAction:eidt];
            [controller addAction:delte];
            [controller addAction:common];
            [controller addAction:cancel];
            [self presentViewController:controller animated:YES completion:nil];
            
            

        }
        
               NSLog(@"Whodasfsdfg==");
        return;
    }
  //    if (indexPath == nil){
//        NSLog(@"couldn't find index path====%d",indexPath.row);
//    } else {
//        // get the cell at indexPath (the one you long pressed)
//UICollectionViewCell* cell =
//        [collectView cellForItemAtIndexPath:indexPath];
//        
//        
//        NSLog(@"%@===",cell);
//        // do stuff with the cell
//    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _showArray.count+2;
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 38;
    //cell.backgroundColor=[UIColor redColor];
    if (indexPath.row<_showArray.count) {
        cell.label.text=_showArray[indexPath.row][@"areaname"];
        cell.imageView.image=[UIImage imageNamed:@"equ_icon_TV"];
        //        [[SDImageCache sharedImageCache] clearDisk];
        //        [[SDImageCache sharedImageCache] clearMemory];
        NSString *imageUrlStr =_showArray[indexPath.row][@"areaimg"];
        //NSString *NewImgUrlStr =[imageUrlStr stringByReplacingOccurrencesOfString:@"." withString:@"/"];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@%@",HTTPIP,IMAGE_URL,imageUrlStr]] placeholderImage:[UIImage imageNamed:@"devices_area"]];
        
        NSLog(@"asfghf====%@",[NSString stringWithFormat:@"http://%@/%@",HTTPIP,imageUrlStr]);

      
    }else if (indexPath.row==_showArray.count){
        cell.label.text=@"未识别区域";
        cell.label.font=[UIFont systemFontOfSize:12];
        cell.imageView.image=[UIImage imageNamed:@"unrecognizedArea"];

     
    
    
    }
    else{
        cell.label.text=@"添加";
        cell.label.font=[UIFont systemFontOfSize:12];
        cell.imageView.image=[UIImage imageNamed:@"equ_icon_add"];

        
        
    }
  
    return cell;
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<_showArray.count) {
        Area_Detil_ViewController *vc =[[Area_Detil_ViewController alloc]initWithDic:_showArray[indexPath.row]];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];

       
    }else if (indexPath.row==_showArray.count){
        
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:@"",@"id", nil];
        
        Area_Detil_ViewController *vc =[[Area_Detil_ViewController alloc]initWithDic:dict];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];

      
    
    }
    else{
        
        if (_showArray.count<51) {
             [self AddErea];
        }else {
            [SVProgressHUD showWithStatus:@"区域最多添加50个"];
        }
       
        
    }

    


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
            
            _showArray=dictt[@"DATA"];
            [collectView reloadData];
            
                       NSLog(@"_AreaArray====%@",_showArray);
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
    
    
}

//删除区域
-(void)requestForDeldteAreaWithDIc:(NSDictionary*)myDic{
    
     [SVProgressHUD showWithStatus:@"正在删除..."];
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10411\",\"areaid\":\"%@\",\"actuserid\":\"%@\"}",myDic[@"id"],USER_ID];
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];

    
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            [SVProgressHUD showSuccessWithStatus:dict[@"MSG"]];
         
            [self requestForArea];
            
            
            NSLog(@"_AreaArray====%@",_showArray);
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };

     
}
//设置常用操作
-(void)requestForUserOperation:(NSDictionary*)myDic{
    
    [SVProgressHUD showWithStatus:@"正在删除..."];
    
    NSLog(@"mdic===%@",myDic);
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10412\",\"areaid\":\"%@\",\"shortcutname\":\"%@\",\"shortcuttype\":\"%@\",\"userid\":\"%@\",\"actuserid\":\"%@\"}",myDic[@"id"],myDic[@"areaname"],@"1",USER_ID,USER_ID];
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    
    
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            [SVProgressHUD showSuccessWithStatus:dictt[@"MSG"]];
            
                  }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
    
    
    
    
}

//编辑区域
-(void)EidtEreaWithDic:(NSDictionary*)dict{
    
    //NSLog(@"selfDic====%@",self.nowSenceDic);
    
    _Comments = [[UIView alloc] init];
    _Comments.frame = CGRectMake(0, 0, LWidth, LHeight);
    _Comments.backgroundColor = [UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:0.3];
    [self.view addSubview:_Comments];
    [self.view bringSubviewToFront:_Comments];
    
    _renameView =[[UIView alloc]init];
    _renameView.frame=CGRectMake((LWidth-300)/2, 100, 300, 240);
    _renameView.backgroundColor=[UIColor whiteColor];
    [_Comments addSubview:_renameView];
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _renameView.frame.size.width, 30)];
    label.backgroundColor=[UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1];
    label.text=@"编辑";
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:16];
    label.textColor=[UIColor whiteColor];
    [_renameView addSubview:label];

    UIImageView *linImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,70, _renameView.frame.size.width, 1)];
    linImg.image=[UIImage imageNamed:@"dividing-line.png"];
    [_renameView addSubview:linImg];
    
    UIImageView *linImg_two =[[UIImageView alloc]initWithFrame:CGRectMake(0,170, _renameView.frame.size.width, 1)];
    linImg_two.image=[UIImage imageNamed:@"dividing-line.png"];
    [_renameView addSubview:linImg_two];
    photeImgBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    // [photeImgBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@%@",HTTPIP,IMAGE_URL,dict[@"areaimg"]]] forState:UIControlStateNormal];
     //[photeImgBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@%@",HTTPIP,IMAGE_URL,dict[@"areaimg"]]] placeholderImage:[UIImage imageNamed:@"main_navi_sence_normal"]];
    
    
    
    //    NSLog(@"url======%@",[NSString stringWithFormat:@"http://%@%@%@",HTTPIP,IMAGE_URL,self.nowSenceDic[@"sceneimg"]]);
    
    //[photeImgBtn setBackgroundImage:[UIImage imageNamed:@"sence_name_add"] forState:0];
    [photeImgBtn setImage:self.photnImage forState:0];
    photeImgBtn.frame=CGRectMake(10, 70+10, 80, 80);
    photeImgBtn.layer.cornerRadius=40;
    photeImgBtn.layer.masksToBounds=YES;
    [photeImgBtn addTarget:self action:@selector(photeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_renameView addSubview:photeImgBtn];
    field =[[UITextField alloc]initWithFrame:CGRectMake(100, 70+50-15, _renameView.frame.size.width-100, 30)];
    field.borderStyle=UITextBorderStyleNone;
    field.returnKeyType=UIReturnKeyDone;
    field.text=dict[@"areaname"];
    
    field.delegate=self;
    [_renameView addSubview:field];
    UIImageView *linImg_three =[[UIImageView alloc]initWithFrame:CGRectMake(field.frame.origin.x,field.frame.origin.y+30, field.frame.size.width, 1)];
    linImg_three.image=[UIImage imageNamed:@"dividing-line.png"];
    [_renameView addSubview:linImg_three];
    UIButton  *confirmBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame=CGRectMake(20, 180, 260, 40);
    confirmBtn.backgroundColor=[UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1];
    confirmBtn.layer.cornerRadius=8;
    [confirmBtn setTitle:@"保  存" forState:0];
    [confirmBtn setTintColor:[UIColor whiteColor]];
    confirmBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    confirmBtn.tag=0;
    confirmBtn.layer.masksToBounds=YES;
    [confirmBtn addTarget:self action:@selector(confirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [_renameView addSubview:confirmBtn];
    
    
    
    
}

//添加区域
-(void)AddErea{
    
    //NSLog(@"selfDic====%@",self.nowSenceDic);
    
    _Comments = [[UIView alloc] init];
    _Comments.frame = CGRectMake(0, 0, LWidth, LHeight);
    _Comments.backgroundColor = [UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:0.3];
    [self.view addSubview:_Comments];
    [self.view bringSubviewToFront:_Comments];
    
    _renameView =[[UIView alloc]init];
    _renameView.frame=CGRectMake((LWidth-300)/2, 100, 300, 240);
    _renameView.backgroundColor=[UIColor whiteColor];
    [_Comments addSubview:_renameView];
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _renameView.frame.size.width, 30)];
    label.backgroundColor=[UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1];
    label.text=@"科远慧家";
    label.font=[UIFont systemFontOfSize:16];
    label.textColor=[UIColor whiteColor];
    [_renameView addSubview:label];
    UIImageView *linImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,70, _renameView.frame.size.width, 1)];
    linImg.image=[UIImage imageNamed:@"dividing-line.png"];
    [_renameView addSubview:linImg];
    
    UIImageView *linImg_two =[[UIImageView alloc]initWithFrame:CGRectMake(0,170, _renameView.frame.size.width, 1)];
    linImg_two.image=[UIImage imageNamed:@"dividing-line.png"];
    [_renameView addSubview:linImg_two];
    photeImgBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [photeImgBtn setBackgroundImage:[UIImage imageNamed:@"sence_name_add"] forState:0];
    photeImgBtn.frame=CGRectMake(10, 70+10, 80, 80);
    photeImgBtn.layer.cornerRadius=40;
    photeImgBtn.layer.masksToBounds=YES;
    [photeImgBtn addTarget:self action:@selector(photeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_renameView addSubview:photeImgBtn];
    field =[[UITextField alloc]initWithFrame:CGRectMake(100, 70+50-15, _renameView.frame.size.width-100, 30)];
    field.borderStyle=UITextBorderStyleNone;
    field.returnKeyType=UIReturnKeyDone;
    //field.text=self.nowSenceDic[@"scenename"];
    
    field.delegate=self;
    [_renameView addSubview:field];
    UIImageView *linImg_three =[[UIImageView alloc]initWithFrame:CGRectMake(field.frame.origin.x,field.frame.origin.y+30, field.frame.size.width, 1)];
    linImg_three.image=[UIImage imageNamed:@"dividing-line.png"];
    [_renameView addSubview:linImg_three];
    UIButton  *confirmBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame=CGRectMake(20, 180, 260, 40);
    confirmBtn.backgroundColor=[UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1];
    confirmBtn.layer.cornerRadius=8;
    [confirmBtn setTitle:@"保  存" forState:0];
    [confirmBtn setTintColor:[UIColor whiteColor]];
    confirmBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    confirmBtn.tag=1;
    confirmBtn.layer.masksToBounds=YES;
    [confirmBtn addTarget:self action:@selector(confirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [_renameView addSubview:confirmBtn];
}
#pragma MARK======DATESOYRCE DELEGETE
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    _renameView.frame=CGRectMake((LWidth-300)/2, 0, 300, 240);
    [UIView commitAnimations];
    
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    _renameView.frame=CGRectMake((LWidth-300)/2, 100, 300, 240);
    [UIView commitAnimations];
    

    [textField resignFirstResponder];
    return YES;
}
-(void)photeBtnClick{
    [field resignFirstResponder];
    [self changeUserImag];
}

//****************** 添加图片方法

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
    
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
    
    UIImage *iamge =[self compressImage:editedImage];
    self.photnImage=iamge;
    [photeImgBtn setImage:iamge forState:0];
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


//****************添加图片方法

-(void)confirmBtn:(UIButton*)sender{
    [self CreateNewSenceWithString:field.text withTag:sender.tag];
    NSLog(@"确定");
    
    
}

// 添加区域区域
-(void)CreateNewSenceWithString:(NSString*)text withTag:(int)senderTag{
    
    if (!field.text ) {
        [SVProgressHUD showErrorWithStatus:@"区域名不能为空"];
        return;
    }
    NSString *myrequestStr;
    if (senderTag) {
         myrequestStr=[NSString stringWithFormat:@"{\"funcode\":\"10409\",\"areaname\":\"%@\",\"serverid\":\"%@\",\"actuserid\":\"%@\"}",field.text,SERVERID,USER_ID];
    }else{
       myrequestStr=[NSString stringWithFormat:@"{\"funcode\":\"10410\",\"areaid\":\"%@\",\"areaname\":\"%@\",\"actuserid\":\"%@\"}",_eidtDic[@"id"],field.text,USER_ID];
        
    }
    
    NSString *urlstring =[NSString stringWithFormat:@"http://%@",HTTPIP];
      NSData *data =UIImagePNGRepresentation(self.photnImage);
    NSString *fileName =@"userimg.png";
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
    [SVProgressHUD showWithStatus:@"正在保存..."];
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
            self.photnImage=[UIImage imageNamed:@""];
            [_Comments removeFromSuperview];
            [self requestForArea];
            
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
//
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //NSSet * 类似于数组  touches 屏幕中点的集合
    
    UITouch *touch  = [touches anyObject];
    //locationInView获取所在屏幕中点的位置
    CGPoint point = [touch locationInView:self.view];
    if (!CGRectContainsPoint(_renameView.frame, point))
    {
        [_Comments removeFromSuperview];
        
        
    }
    
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
