//
//  SenceViewController.m
//  SyncSmartHome
//
//  Created by SciyonSoft_WangJie on 16/5/3.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "SenceViewController.h"
//#import "SLCoverFlowView.h"`
//#import "SLCoverView.h"
#import "MyTableViewCell.h"
#import "addDeviceSenceVC.h"
#import "SenceEidtVC.h"
#import "SenceRenameVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "VPImageCropperViewController.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "ShareUserCell.h"
#import "MJRefresh.h"
#define ORIGINAL_MAX_WIDTH 640.0f
//static const CGFloat SLCoverViewWidth = 350.0;
//static const CGFloat SLCoverViewHeight = 300.0;
@interface SenceViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,VPImageCropperDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIScrollViewDelegate>{

    //SLCoverFlowView *_coverFlowView;
    NSMutableArray *_colors;
    UISlider *_widthSlider;
    UISlider *_heightSlider;
    UISlider *_spaceSlider;
    UISlider *_angleSlider;
    UISlider *_scaleSlider;
    NSMutableArray *_SenceArray;
    UIView *_Comments;
    UIView *_listComments;
    UIButton *photeImgBtn;
    UITableView *_listTableView;
    NSArray *_listTableArray;
    UIView *_renameView;
    NSArray *_ereaArray;
    NSString *_ereaID;
    UITextField *field;
    int typeCode;
    NSString *EREAID;
    NSArray *_allUserArray;
    NSArray *_hasShareArray;
    NSMutableArray *_shareUserIDArray;
    NSMutableArray *_isChoiceArray;
    UITableView * shaerTable;
    BOOL hiden;
    
     NSInteger startIndex;


}
@property(nonatomic,retain)NSDictionary *nowSenceDic;

@end

@implementation SenceViewController
//- (void)loadView {
//    [super loadView];
//    self.view.backgroundColor = [UIColor whiteColor];
//    CGRect frame = self.view.bounds;
//    //frame.size.height /= 2.0;
//    _coverFlowView = [[SLCoverFlowView alloc] initWithFrame:frame];
//    _coverFlowView.backgroundColor = [UIColor lightGrayColor];
//    _coverFlowView.delegate =self;
//    _coverFlowView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    _coverFlowView.coverSize = CGSizeMake(SLCoverViewWidth, SLCoverViewHeight);
//    _coverFlowView.coverSpace = 0.0;
//    _coverFlowView.coverAngle = -2.0;
//    _coverFlowView.coverScale = 1.0;
//    [self.view addSubview:_coverFlowView];
//    //    _coverFlowView.coverSize = CGSizeMake(SLCoverViewWidth * _widthSlider.value,
//    //                                          _coverFlowView.coverSize.height);
//    //    _coverFlowView.coverSize = CGSizeMake(_coverFlowView.coverSize.width,
//    //                                          SLCoverViewHeight * _heightSlider.value);
//    //     _coverFlowView.coverSpace = _spaceSlider.value * SLCoverViewSpace;
//    
//    
//}
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [_coverFlowView reloadData];
//}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    _ereaID=@"";

    //_EREAID=@"";
    [self requestForsSence];
       [self requestForArea];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
     UIBarButtonItem *leftBtn =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"leftImag"] style:UIBarButtonItemStylePlain target:self action:@selector(callModalList)];
    self.navigationItem.leftBarButtonItem = leftBtn;
        _shareUserIDArray=[NSMutableArray array];
     self.title=@"场景";
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    self.myTable.separatorStyle= UITableViewCellSeparatorStyleNone;
    [self.myTable registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.myTable.rowHeight=60;
    //[self requestForsSence];
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [self.myTable addGestureRecognizer:longPressGr];
    UIBarButtonItem *addBarBtn =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_5_n"] style:UIBarButtonItemStylePlain target:self action:@selector(addbarBtnClick)];
    UIBarButtonItem *searchBtn  =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBtn)];
    NSArray *arr =[[NSArray alloc]initWithObjects:addBarBtn,searchBtn, nil];
    self.navigationItem.rightBarButtonItems=arr;
    [self initListTableView];
    [self requestAllUserData];
    startIndex =1;
    [self.myTable addHeaderWithTarget:self action:@selector(upRefresh:)];
    [self.myTable addFooterWithTarget:self action:@selector(downRefresh:)];
    //[self requestHadShareData];
 
}

#pragma mark ------ 下拉刷新
- (void)upRefresh:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestForsSence];
      startIndex =1;
        [self.myTable headerEndRefreshing];
    });
}
#pragma mark ------ 上拉加载
- (void)downRefresh:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestForsSenceRefresh];
        [self.myTable footerEndRefreshing];
    });
}

- (void)callModalList
{
    AppDelegate *aAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [aAppDelegate.ddMenu showLeftController:YES];
}
// 拖拽让添加按钮 消失
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    hiden=0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    _listTableView.frame=CGRectMake(LWidth-100, 0, 95,0);
    [UIView  commitAnimations];


}



//搜索
-(void)searchBtn{
    NSLog(@"erarray====%@",_ereaArray);
    UIAlertController *conter =[UIAlertController  alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
 
    
    for (int  i =0; i<_ereaArray.count; i++) {
        NSString *ereaname=_ereaArray [i][@"areaname"];
        NSLog(@"ereaname===%@",ereaname);
        
        if ([ereaname isEqualToString:@""]) {
            ereaname =@"  ";
             }
        
        UIAlertAction  *action  =[UIAlertAction actionWithTitle:ereaname style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            _ereaID=_ereaArray [i][@"id"];
            [self requestForsSence];
                //[sender setTitle:ereaname forState:0];
            
        }];
        
        [conter addAction:action];
        
    }
    UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [conter addAction:cancel];
    
    [self presentViewController:conter animated:YES completion:nil];
 
}
//下拉框 添加
-(void)addbarBtnClick{
    [self.view addSubview:_listComments];
    [self.view bringSubviewToFront:_listComments];

    hiden=!hiden;
    if (hiden==1) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.2];
        _listTableView.frame=CGRectMake(LWidth-100, 0, 95, _listTableArray.count*44+10);
        [UIView  commitAnimations];}
else{
    [_listComments removeFromSuperview];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    _listTableView.frame=CGRectMake(LWidth, 0, 0,0);
    [UIView  commitAnimations];
}




}

//初始化下来框
-(void)initListTableView{
    _listComments = [[UIView alloc] init];
    _listComments.frame = CGRectMake(0, 0, LWidth, LHeight);
    _listComments.backgroundColor = [UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:0.3];
    

    _listTableArray =[[NSArray alloc]initWithObjects:@"添加", nil];
    _listTableView=[[UITableView alloc]initWithFrame:CGRectMake(LWidth, 0, 0, 0) style:UITableViewStylePlain];
    //_listTableView.alpha=0;
    [_listComments addSubview:_listTableView];
    _listTableView.dataSource=self;
    _listTableView.delegate=self;
    _listTableView.backgroundColor =[CommonTool  colorWithHexString:@"1E90FF"];
    [_listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"sycell"];
    //hiden=0;
//    _listTableView.hidden=YES;
//    _listTableView.hidden=YES;
   

}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{  hiden=0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    _listTableView.frame=CGRectMake(LWidth-100, 0, 95,0);
    [UIView  commitAnimations];

    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.myTable];
        
        NSIndexPath *indexPath = [self.myTable indexPathForRowAtPoint:point];
        MyTableViewCell *cell =(MyTableViewCell*)[self.myTable cellForRowAtIndexPath:indexPath];
         self.photnImage=cell.iView.image;
        
        if(indexPath == nil) return ;
        
        //add your code here
        NSArray *array =[[NSArray alloc]initWithObjects:@"编辑场景", @"重命名场景",@"删除场景",@"共享场景",@"设置常用",nil];
        UIAlertController *Controeller =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        NSLog(@"as大ssadd啊是多福多寿＝＝＝%d",indexPath.row);
        for (int i=0; i<array.count; i++) {
            
            UIAlertAction *action =[UIAlertAction actionWithTitle:array[i] style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                switch (i ) {
                    case 0:
                    {
                        SenceEidtVC *vc =[[SenceEidtVC alloc]initWithaDic:_SenceArray[indexPath.row]];
                        vc.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:vc animated:YES];
                        NSLog(@"0");
                        
                        
                    }
                        break;
                    case 1:
                    {

                        
//                        SenceRenameVC *vc =[[SenceRenameVC alloc]init];
//                        vc.hidesBottomBarWhenPushed=YES;
//                        [self.navigationController pushViewController:vc animated:YES];
                        self.nowSenceDic=_SenceArray[indexPath.row];
                        
                        [self renameView];
                    
                        NSLog(@"1");
                    }
                        break;
                    case 2:
                    {
                        NSLog(@"2");
                         [self requestForDeldteSenceWithDIc:_SenceArray[indexPath.row]];
                    }
                        break;
                    case 3:
                    {NSLog(@"3");
                        self.thisSenceDic=_SenceArray[indexPath.row];
                        [self requestHadShareDataWirhAdic:_SenceArray[indexPath.row]];
                        [self ShareSence];
                        //[self requestForShareWithDIc:_SenceArray[indexPath.row]];
                       
                        
                    }
                        break;

                    case 4:{
                        [self requestForUserOperation:_SenceArray[indexPath.row]];
                    
                    }break;
                    
                }
                
            }];
            
            
            [Controeller addAction:action];
        }
        
        UIAlertAction  *cancel  =[UIAlertAction  actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [Controeller addAction: cancel];
        [self presentViewController:Controeller animated:YES completion:nil];
        
        
    }
}

//重命名场景
-(void)renameView{
    
    NSLog(@"selfDic====%@",self.nowSenceDic);
    
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
    label.text=@"重命名场景";
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:16];
    label.textColor=[UIColor whiteColor];
    [_renameView addSubview:label];
    UILabel *ereaLab=[[UILabel alloc]init];
    ereaLab.frame=CGRectMake(0, 30, 100, 40);
    ereaLab.font=[UIFont systemFontOfSize:14];
    ereaLab.textAlignment=NSTextAlignmentRight;
    ereaLab.text=@"所属区域:";
    
    UIButton*ereaBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    ereaBtn.backgroundColor=[UIColor whiteColor];
    [ereaBtn setTitleColor:[UIColor blackColor] forState:0];
    ereaBtn.frame=CGRectMake(100, 30, _renameView.frame.size.width-100, 40);
    [ereaBtn  addTarget:self action:@selector(ereaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [ereaBtn setTitle:[self  GetEreanameWithEreaId:self.nowSenceDic[@"areaid"]] forState:0];
    EREAID =self.nowSenceDic[@"areaid"];
    _ereaID=self.nowSenceDic[@"areaid"];
    [_renameView addSubview:ereaBtn];
    
    [_renameView addSubview:ereaLab];
    UIImageView *linImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,70, _renameView.frame.size.width, 1)];
    linImg.image=[UIImage imageNamed:@"dividing-line.png"];
    [_renameView addSubview:linImg];
    
    UIImageView *linImg_two =[[UIImageView alloc]initWithFrame:CGRectMake(0,170, _renameView.frame.size.width, 1)];
    linImg_two.image=[UIImage imageNamed:@"dividing-line.png"];
    [_renameView addSubview:linImg_two];
    photeImgBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [photeImgBtn setBackgroundImage:self.photnImage forState:0];
    
    
    NSLog(@"url======%@",[NSString stringWithFormat:@"http://%@%@%@",HTTPIP,IMAGE_URL,self.nowSenceDic[@"sceneimg"]]);
    
    //[photeImgBtn setBackgroundImage:<#(nullable UIImage *)#> forState:<#(UIControlState)#>]
   photeImgBtn.frame=CGRectMake(10, 70+10, 80, 80);
    photeImgBtn.layer.cornerRadius=40;
    photeImgBtn.layer.masksToBounds=YES;
    [photeImgBtn addTarget:self action:@selector(photeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_renameView addSubview:photeImgBtn];
  field =[[UITextField alloc]initWithFrame:CGRectMake(100, 70+50-15, _renameView.frame.size.width-100, 30)];
    field.borderStyle=UITextBorderStyleNone;
    field.returnKeyType=UIReturnKeyDone;
    field.text=self.nowSenceDic[@"scenename"];
    
    field.delegate=self;
    [_renameView addSubview:field];
    UIImageView *linImg_three =[[UIImageView alloc]initWithFrame:CGRectMake(field.frame.origin.x,field.frame.origin.y+30, field.frame.size.width, 1)];
    linImg_three.image=[UIImage imageNamed:@"dividing-line.png"];
    [_renameView addSubview:linImg_three];
    UIButton  *confirmBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame=CGRectMake(20, 180, 260, 40);
    confirmBtn.backgroundColor=[UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1];
    confirmBtn.layer.cornerRadius=8;
    [confirmBtn setTitle:@"保  存 " forState:0];
    [confirmBtn setTintColor:[UIColor whiteColor]];
    confirmBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    confirmBtn.tag=0;
    confirmBtn.layer.masksToBounds=YES;
    [confirmBtn addTarget:self action:@selector(confirmBtn:) forControlEvents:UIControlEventTouchUpInside];

    [_renameView addSubview:confirmBtn];

 
    
    
}
-(NSString *)GetEreanameWithEreaId:(NSString*)ID{
    
    NSLog(@"ID=====%@",ID);
    if ([ID isEqualToString:@""]) {
        return _ereaArray[0][@"ereaname"];
    }
    
    
    
    NSMutableDictionary *dict =[NSMutableDictionary dictionary];
    for (int i =0;i<_ereaArray.count ; i++) {
        [dict setObject:_ereaArray[i][@"areaname"] forKey:_ereaArray[i][@"id"]];
        
    }

    NSString *ereaName =dict[ID];
    
    return ereaName;



}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    
_renameView.frame=CGRectMake((LWidth-300)/2, 0, 300, 280);
    [UIView commitAnimations];


}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    
    _renameView.frame=CGRectMake((LWidth-300)/2, 100, 300, 280);
    [UIView commitAnimations];

    return YES;
}

-(void)photeBtnClick{

    NSLog(@"头像");
    [field resignFirstResponder];
    [self changeUserImag];



}
-(void)confirmBtn:(UIButton*)sender{
    [self CreateNewSenceWithString:field.text withTag:sender.tag];
    NSLog(@"确定");


}
-(void)ereaBtnClick:(UIButton*)sender{
    
    NSLog(@"erarray====%@",_ereaArray);
    UIAlertController *conter =[UIAlertController  alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    for (int  i =0; i<_ereaArray.count; i++) {
        NSString *ereaname=_ereaArray [i][@"areaname"];
        NSLog(@"ereaname===%@",ereaname);
        
        if ([ereaname isEqualToString:@""]) {
            ereaname =@"  ";
            
            
        }
        
        UIAlertAction  *action  =[UIAlertAction actionWithTitle:ereaname style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
         _ereaID=_ereaArray [i][@"id"];
            EREAID=_ereaArray[i][@"id"];
            [sender setTitle:ereaname forState:0];
            
        }];
        
        [conter addAction:action];
        
    }

    [self presentViewController:conter animated:YES completion:nil];




}

//
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //NSSet * 类似于数组  touches 屏幕中点的集合
    
    UITouch *touch  = [touches anyObject];
    //locationInView获取所在屏幕中点的位置
    CGPoint point = [touch locationInView:self.view];
    
     //CGPoint point1 = [touch locationInView:self.myTable];
    if (!CGRectContainsPoint(_renameView.frame, point))
    {
        [_Comments removeFromSuperview];
      
      
        
        
    }else if (!CGRectContainsPoint(_listTableView.frame, point)){
        [_listComments removeFromSuperview];
        hiden=0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.2];
        _listTableView.frame=CGRectMake(LWidth, 0, 0,0);
        [UIView  commitAnimations];

    
    
    
    
    
    }
    




}

//- (NSInteger)numberOfCovers:(SLCoverFlowView *)coverFlowView {
//    return _colors.count;
//}
//
//- (SLCoverView *)coverFlowView:(SLCoverFlowView *)coverFlowView coverViewAtIndex:(NSInteger)index {
//    SLCoverView *view = [[SLCoverView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
//    view.backgroundColor = [_colors objectAtIndex:index];
//    return view;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_listTableView) {
        return _listTableArray.count;
    }else if (tableView==self.myTable){
        return _SenceArray.count;
    
    }else {
        return _allUserArray.count;
        
    
    
    }



}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (tableView==_listTableView) {
        UITableViewCell *cell =[tableView  dequeueReusableCellWithIdentifier:@"sycell"];
        cell.backgroundColor=[CommonTool colorWithHexString:@"1E90FF"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        cell.textLabel.text=_listTableArray[indexPath.row];
        return cell;
        
    }else if (tableView==_myTable){
        MyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyTableViewCell" owner:self options:nil] lastObject];
        }
//        MyTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
        [cell.iView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@%@",HTTPIP,IMAGE_URL,_SenceArray[indexPath.row][@"sceneimg"]]]];
        
        [cell.iView  sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@%@",HTTPIP,IMAGE_URL,_SenceArray[indexPath.row][@"sceneimg"]]] placeholderImage:[UIImage imageNamed:@"setting_icon_cloudserver"]];
        cell.iView.layer.masksToBounds = YES;
        cell.iView.layer.cornerRadius =27;
        NSLog(@"开始开＝＝＝＝%@",[NSString stringWithFormat:@"http://%@/%@",HTTPIP,_SenceArray[indexPath.row][@"sceneimg"]]);
        cell.firstLab.text=[NSString stringWithFormat:@"   %@",_SenceArray[indexPath.row][@"scenename"]];
        if (!(_SenceArray[indexPath.row][@"typecode"]==[NSNull null])) {
            if ([_SenceArray[indexPath.row][@"typecode"]intValue]==1) {
                cell.secondLab.text=@"   普通场景";
                cell.selectedImagView.hidden=YES;
                
            }else if ([_SenceArray[indexPath.row][@"typecode"]intValue]==2){cell.secondLab.text=@"  高级场景";
                cell.selectedImagView.hidden=YES;
            
            }else{
                cell.secondLab.text=@"   多联开关组";
            
            if ([_SenceArray[indexPath.row][@"scenestatus"] isEqualToString:@"1"]) {
                [cell.glowView setImage:[UIImage imageNamed:@"glow"]];
                
            }if ([_SenceArray[indexPath.row][@"scenestatus"] isEqualToString:@"0"]) {
                [cell.glowView setImage:[UIImage imageNamed:@"glow1"]];
            }
            }
        }
        if ([_SenceArray[indexPath.row][@"scenestatus"]integerValue]==1) {
            cell.selectedImagView.image=[UIImage imageNamed:@"checkbox_on"];
            
        }else{
        
            cell.selectedImagView.image=[UIImage imageNamed:@"checkbox_off"];
        
        }
       
        return cell;
    }else{
        ShareUserCell *cell =[tableView dequeueReusableCellWithIdentifier:@"scell"];
        cell.label.text=_allUserArray[indexPath.row][@"user"][@"username"];
        
        
        if ([_isChoiceArray[indexPath.row] isEqualToString:@"1"]) {
            
            cell.imView.image=[UIImage imageNamed:@"checkbox_on"];
            
        }else{
            cell.imView.image=[UIImage imageNamed:@"checkbox_off"];
        
        }
        
                return cell;
        
    
    
    
    
    }

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView==_listTableView){
        hiden=0;
         [_listComments removeFromSuperview];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.2];
        _listTableView.frame=CGRectMake(LWidth, 0, 0,0);
        [UIView  commitAnimations];

        [self addNewView];
    }else if (tableView==self.myTable){
        
    
    
        [self requestForSwitchSenceWithADic:_SenceArray[indexPath.row]];
//        hiden=0;
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:.2];
//        _listTableView.frame=CGRectMake(LWidth, 0, 0,0);
//        [UIView  commitAnimations];

    }else{
        
        
        
    ShareUserCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([_isChoiceArray[indexPath.row] isEqualToString:@"0"]) {
            [_isChoiceArray setObject:@"1" atIndexedSubscript:indexPath.row];
            cell.imView.image=[UIImage imageNamed:@"checkbox_on"];
            
            
        }else{
            [_isChoiceArray setObject:@"0" atIndexedSubscript:indexPath.row];
            cell.imView.image=[UIImage imageNamed:@"checkbox_off"];

        
        }
        
       
    }
   // [tableView reloadData];
}
//添加新建新场景
-(void)addNewView{
    _Comments = [[UIView alloc] init];
    _Comments.frame = CGRectMake(0, 0, LWidth, LHeight);
    _Comments.backgroundColor = [UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:0.3];
    [self.view addSubview:_Comments];
    [self.view bringSubviewToFront:_Comments];
    
  _renameView =[[UIView alloc]init];
    _renameView.frame=CGRectMake((LWidth-300)/2, 100, 300, 280);
    _renameView.backgroundColor=[UIColor whiteColor];
    [_Comments addSubview:_renameView];
    //标题label
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _renameView.frame.size.width, 30)];
    label.backgroundColor=[CommonTool colorWithHexString:@"1E90FF"];
    label.text=@"添加场景";
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:16];
    label.textColor=[UIColor whiteColor];
    [_renameView addSubview:label];
    
    //所属区域
    UILabel *ereaLab=[[UILabel alloc]init];
    ereaLab.frame=CGRectMake(0, 30, 100, 40);
    ereaLab.font=[UIFont systemFontOfSize:14];
    ereaLab.textAlignment=NSTextAlignmentRight;
    ereaLab.text=@"所属区域:";
    [_renameView addSubview:ereaLab];
    
    
    UIButton*ereaBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    ereaBtn.backgroundColor=[UIColor whiteColor];
    [ereaBtn setTitleColor:[UIColor blackColor] forState:0];
    
    ereaBtn.frame=CGRectMake(100, 30, _renameView.frame.size.width-100, 40);
     [ereaBtn  addTarget:self action:@selector(ereaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    NSString *ereaname=_ereaArray [0][@"areaname"];
     _ereaID=_ereaArray [0][@"id"];
    // {scenename,areaid,sceneimg,typecode,serverid,actuserid}
      if ([ereaname isEqualToString:@""]) {
        ereaname =@"  ";
    }

    [ereaBtn setTitle:ereaname forState:0];
    _ereaID=_ereaArray[0][@"id"];
    [_renameView addSubview:ereaBtn];
    
    UIImageView *linImg_top =[[UIImageView alloc]initWithFrame:CGRectMake(0,70, 300, 1)];
   linImg_top.image=[UIImage imageNamed:@"dividing-line.png"];
   
    [_renameView addSubview:linImg_top];
   
    //场景类型
    UILabel *ereatype=[[UILabel alloc]init];
    ereatype.frame=CGRectMake(0, 70, 100, 40);
    ereatype.font=[UIFont systemFontOfSize:14];
    ereatype.textAlignment=NSTextAlignmentRight;
    ereatype.text=@"场景类型:";
    [_renameView addSubview:ereatype];
    
    UIButton*ereatypeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    ereatypeBtn.backgroundColor=[UIColor whiteColor];
    [ereatypeBtn setTitleColor:[UIColor blackColor] forState:0];
    ereatypeBtn.frame=CGRectMake(100, 30+40, _renameView.frame.size.width-100, 40);
    
    [ereatypeBtn setTitle:@"普通场景" forState:0];
    typeCode=1;
    [ereatypeBtn addTarget:self action:@selector(ereaTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_renameView addSubview:ereatypeBtn];
    [linImg_top bringSubviewToFront:ereatypeBtn];
  
    UIImageView *linImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,70+40, _renameView.frame.size.width, 1)];
    linImg.image=[UIImage imageNamed:@"dividing-line.png"];
    [_renameView addSubview:linImg];
    //添加 区域 名字
    UIImageView *linImg_two =[[UIImageView alloc]initWithFrame:CGRectMake(0,170+40, _renameView.frame.size.width, 1)];
    linImg_two.image=[UIImage imageNamed:@"dividing-line.png"];
    [_renameView addSubview:linImg_two];
    photeImgBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    //photeImgBtn.backgroundColor=[UIColor lightGrayColor];
    photeImgBtn.frame=CGRectMake(10, 70+10+40, 80, 80);
    photeImgBtn.layer.cornerRadius=40;
    photeImgBtn.layer.masksToBounds=YES;
    [photeImgBtn setBackgroundImage:[UIImage imageNamed:@"user_role_add"] forState:0];
    [photeImgBtn addTarget:self action:@selector(photeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_renameView addSubview:photeImgBtn];
   field =[[UITextField alloc]initWithFrame:CGRectMake(100, 70+50-15+40, _renameView.frame.size.width-100, 30)];
    field.borderStyle=UITextBorderStyleNone;
    field.returnKeyType=UIReturnKeyDone;
    field.delegate=self;
    [_renameView addSubview:field];
    UIImageView *linImg_three =[[UIImageView alloc]initWithFrame:CGRectMake(field.frame.origin.x,field.frame.origin.y+30, field.frame.size.width, 1)];
    linImg_three.image=[UIImage imageNamed:@"dividing-line.png"];
    [_renameView addSubview:linImg_three];
    
    //确定按钮
    UIButton  *confirmBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame=CGRectMake(20, 180+40, 260, 40);
    confirmBtn.backgroundColor=[CommonTool colorWithHexString:@"1E90FF"];
    confirmBtn.layer.cornerRadius=8;
    [confirmBtn setTitle:@"保  存" forState:0];
    [confirmBtn setTintColor:[UIColor whiteColor]];
    confirmBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    
    confirmBtn.layer.masksToBounds=YES;
    confirmBtn.tag=1;
    [confirmBtn addTarget:self action:@selector(confirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [_renameView addSubview:confirmBtn];
    
    
}


//场景类型按钮
-(void)ereaTypeBtnClick:(UIButton*)sender{

    UIAlertController *controler =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *oneAction =[UIAlertAction actionWithTitle:@"普通场景" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        typeCode=1;
        [sender setTitle:@"普通场景" forState:0];
        
        
    }];
    UIAlertAction *TwoAction =[UIAlertAction actionWithTitle:@"高级场景" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        typeCode=2;
        [sender setTitle:@"高级场景" forState:0];
        
    }];
    UIAlertAction *threeAction =[UIAlertAction actionWithTitle:@"多联开关组" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        typeCode=3;
        [sender setTitle:@"多联开关组" forState:0];
        
    }];
    [controler addAction:oneAction];
    [controler addAction:TwoAction];
    [controler addAction:threeAction];
    [self presentViewController:controler animated:YES completion:nil];

}

//获取场景的请求
-(void)requestForsSence{
//    _SenceArray=nil;
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    
    NSString *urlstring;
    if ([_ereaID isEqualToString:@""]) {
        urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10501\",\"serverid\":\"%@\",\"userid\":\"%@\",\"pageno\":\"%@\",\"pagesize\":\"%@\"}",SERVERID,USER_ID,@"1",@"10"];

    }else{
        urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10501\",\"areaid\":\"%@\",\"serverid\":\"%@\",\"userid\":\"%@\",\"pagesize\":\"%@\",\"pageno\":\"%@\"}",_ereaID,SERVERID,USER_ID,@"1",@"10"];

    }
    
    NSLog(@"myurl=====%@",muUrl);
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    NSLog(@"dict======%@",dict);
    
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];

        manager.backSuccess = ^void(NSDictionary *dictt)
        {
          
            if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
//                _SenceArray=dictt[@"DATA"];
                _SenceArray = [NSMutableArray arrayWithArray:dictt[@"DATA"]];
//                NSLog(@"_AreaArray====%@",_SenceArray);
                
                
                [self.myTable reloadData];
                
            }else{
                
                [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
                
            }
        };
}

- (void)requestForsSenceRefresh{
//    _SenceArray=nil;
//    _SenceArray = [NSMutableArray array];
    startIndex = startIndex + 1;
    NSString *pageStr = [NSString stringWithFormat:@"%d",startIndex];
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring;
    if ([_ereaID isEqualToString:@""]) {
        urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10501\",\"serverid\":\"%@\",\"userid\":\"%@\",\"pageno\":\"%@\",\"pagesize\":\"%@\"}",SERVERID,USER_ID,pageStr,@"10"];
        
    }else{
        urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10501\",\"areaid\":\"%@\",\"serverid\":\"%@\",\"userid\":\"%@\",\"pagesize\":\"%@\",\"pageno\":\"%@\"}",_ereaID,SERVERID,USER_ID,pageStr,@"10"];
        
    }
    
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    NSLog(@"dict======%@",dict);
    
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
           
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:dictt[@"DATA"]];
            if (array.count < 5) {
                [SVProgressHUD showSuccessWithStatus:@"加载到底了"];
                for (NSUInteger i = 0; i < array.count; i ++) {
                    [_SenceArray addObject:[array objectAtIndex:i]];
                }
                [self.myTable reloadData];
            }else{
                for (NSUInteger i = 0; i < array.count; i ++) {
                    [_SenceArray addObject:[array objectAtIndex:i]];
                }
            [self.myTable reloadData];
            }
        }
//        else{
//            
//            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
//            
//        }
    };
    
}


//删除场景
-(void)requestForDeldteSenceWithDIc:(NSDictionary*)myDic{
    
    [SVProgressHUD showWithStatus:@"正在删除..."];
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10502\",\"sceneid\":\"%@\",\"actuserid\":\"%@\",\"serverid\":\"%@\"}",myDic[@"id"],USER_ID,SERVERID];
    NSLog(@"UserAstin====%@",urlstring);
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    
    
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            [SVProgressHUD showSuccessWithStatus:dict[@"MSG"]];
            
            //[self requestForArea];
            
                [self requestForsSence];
           // NSLog(@"_AreaArray====%@",_showArray);
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
    
    
}

//设置常用
-(void)requestForUserOperation:(NSDictionary*)myDic{
    NSLog(@"myDIc===%@",myDic);
    
    [SVProgressHUD showWithStatus:@"正在设置..."];
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10504\",\"sceneid\":\"%@\",\"shortcutname\":\"%@\",\"shortcuttype\":\"%@\",\"actuserid\":\"%@\",\"serverid\":\"%@\"}",myDic[@"id"],myDic[@"scenename"],@"2",USER_ID,SERVERID];
    
    
    NSLog(@"urlstring==%@",urlstring);
    
    
    
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
    [photeImgBtn setBackgroundImage:editedImage forState:0];
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

- (BOOL)doesCameraSupportTakingPhotos {
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
            
            _ereaArray=dictt[@"DATA"];
            //[collectView reloadData];
            
            
            
            NSLog(@"_AreaArray====%@",_ereaArray);
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
    
    
}

// 请求区域
-(void)CreateNewSenceWithString:(NSString*)text withTag:(int)senderTag{
   
   // {scenename,areaid,sceneimg,typecode,serverid,actuserid}
    
    
        if ([text isEqualToString:@""]) {
        //[SVProgressHUD showErrorWithStatus:@"请选择所属区域和场景类型并选择场景名!"];
        UIAlertController *alertconter =[UIAlertController alertControllerWithTitle:@"小提示" message:@"请选择所属区域和场景类型并填写场景名!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action =[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertconter addAction:action];
        [self presentViewController:alertconter animated:YES completion:nil];
        return;
    }
    
     [SVProgressHUD showWithStatus:@"努力加载中..."];
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *myRequestStr;
    
    if (senderTag==0) {
        myRequestStr=[NSString stringWithFormat:@"{\"funcode\":\"10506\",\"scenename\":\"%@\",\"areaid\":\"%@\",\"sceneid\":\"%@\",\"serverid\":\"%@\",\"actuserid\":\"%@\"}",text,EREAID,self.nowSenceDic[@"id"],SERVERID,USER_ID];
        
    }else{
        
        myRequestStr=[NSString stringWithFormat:@"{\"funcode\":\"10505\",\"scenename\":\"%@\",\"areaid\":\"%@\",\"typecode\":\"%d\",\"serverid\":\"%@\",\"actuserid\":\"%@\"}",text,_ereaID,typeCode,SERVERID,USER_ID];
        _ereaID=@"";
    }

    
  
    
    NSLog(@"myrequest====%@",myRequestStr);
    
    
    NSString *fileName =@"userimg.png";
    NSData *data =UIImagePNGRepresentation(self.photnImage);
       NSURL* myurl = [NSURL URLWithString:muUrl];
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:myurl];
    request.delegate = self;
    request.tag=1999;
    [request setTimeOutSeconds:8];
    [request setPostValue:myRequestStr forKey:@"jsonrequest"];
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
            [_Comments removeFromSuperview];
            self.photnImage=[UIImage imageNamed:@""];

            [self requestForsSence];
            
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
//触发场景开关状态
-(void)requestForSwitchSenceWithADic:(NSDictionary*)DIC{
  NSLog(@"diuctt==%@",DIC);
    
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10520\",\"serverid\":\"%@\",\"actuserid\":\"%@\",\"typecode\":\"%@\",\"sceneid\":\"%@\",\"hostsceneid\":\"%@\",\"scenestatus\":\"%d\"}",SERVERID,USER_ID,DIC[@"typecode"],DIC[@"id"],DIC[@"hostsceneid"],![DIC[@"scenestatus"]integerValue]];
    
    NSLog(@"userstring====%@",urlstring);
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            
            //_ereaArray=dictt[@"DATA"];
            
            
//            [self requestForArea]
            //[collectView reloadData];
            [self requestForsSence];
            [SVProgressHUD  showSuccessWithStatus:[dictt  objectForKey:@"MSG"]];
            
            
           // NSLog(@"_AreaArray====%@",_ereaArray);
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };



}
//共享场景
-(void)ShareSence{
    _Comments = [[UIView alloc] init];
    _Comments.frame = CGRectMake(0, 0, LWidth, LHeight);
    _Comments.backgroundColor = [UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:0.3];
    [self.view addSubview:_Comments];
    [self.view bringSubviewToFront:_Comments];
    
    _renameView =[[UIView alloc]init];
    _renameView.frame=CGRectMake((LWidth-300)/2, 20, 300,420);
    _renameView.backgroundColor=[UIColor whiteColor];
    [_Comments addSubview:_renameView];
    //标题label
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _renameView.frame.size.width, 30)];
    label.backgroundColor=[CommonTool colorWithHexString:@"1E90FF"];
    label.text=@"共享场景";
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:16];
    label.textColor=[UIColor whiteColor];
    [_renameView addSubview:label];
    
   shaerTable =[[UITableView alloc]initWithFrame:CGRectMake(0, 30, _renameView.frame.size.width, 420-30-50) style:UITableViewStylePlain];
    shaerTable.delegate=self;
    shaerTable.dataSource=self;
    [shaerTable registerNib:[UINib nibWithNibName:@"ShareUserCell" bundle:nil] forCellReuseIdentifier:@"scell"];
    [_renameView addSubview:shaerTable];
    
    
    //确定按钮
    UIButton  *confirmBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame=CGRectMake(5, _renameView.frame.size.height-50, 140, 40);
    confirmBtn.backgroundColor=[CommonTool colorWithHexString:@"1E90FF"];
    confirmBtn.layer.cornerRadius=8;
    [confirmBtn setTitle:@"保  存" forState:0];
    [confirmBtn setTintColor:[UIColor whiteColor]];
    confirmBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    confirmBtn.layer.masksToBounds=YES;
    confirmBtn.tag=1;
    [confirmBtn addTarget:self action:@selector(ShareConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [_renameView addSubview:confirmBtn];
    //确定按钮
    UIButton  *cancelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
   cancelBtn.frame=CGRectMake(150, _renameView.frame.size.height-50, 140, 40);
    cancelBtn.backgroundColor=[CommonTool colorWithHexString:@"1E90FF"];
    cancelBtn.layer.cornerRadius=8;
    [cancelBtn setTitle:@"取  消" forState:0];
    [cancelBtn setTintColor:[UIColor whiteColor]];
    cancelBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    
    cancelBtn.layer.masksToBounds=YES;
    cancelBtn.tag=1;
    [cancelBtn addTarget:self action:@selector(cancelBtnCLICK) forControlEvents:UIControlEventTouchUpInside];
    
    [_renameView addSubview:cancelBtn];

    
    
}
//取消
-(void)cancelBtnCLICK{

    [_Comments removeFromSuperview];
}
//保存
-(void)ShareConfirmBtn{
    

[self requestForShareWithDIc:self.thisSenceDic];

}


//共享场景
-(void)requestForShareWithDIc:(NSDictionary*)myDic{
    
    NSMutableArray *needIDArray =[NSMutableArray array];
    for (int i=0;i<_isChoiceArray.count;i++) {
        if ([_isChoiceArray[i] isEqualToString:@"1"]) {
           [ needIDArray addObject:_allUserArray[i][@"user"][@"id"]] ;
            
        }
}
    NSString *idString;

    if (needIDArray.count>0) {
        idString =[needIDArray  componentsJoinedByString:@","];
        
        
    }
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    
    
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10503\",\"sceneid\":\"%@\",\"actuserid\":\"%@\", \"shareuserids\":\"%@\",\"serverid\":\"%@\"}",myDic[@"id"],USER_ID,idString,
                         SERVERID];
    NSLog(@"UserAstin====%@",urlstring);
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    
    
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            [SVProgressHUD showSuccessWithStatus:dict[@"MSG"]];
            [_Comments removeFromSuperview];
            
            //[self requestForArea];
            
            [self requestForsSence];
            // NSLog(@"_AreaArray====%@",_showArray);
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
    
}

//查询所有用户
-(void)requestAllUserData{
    NSLog(@"%@---000",SERVERID);
    _isChoiceArray=[NSMutableArray array];
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10201\",\"serverid\":\"%@\"}",SERVERID];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        if ([[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            //showArray = [NSMutableArray arrayWithArray:dictt[@"DATA"]];
            //            showArray=dictt[@"DATA"];
            _allUserArray=dictt[@"DATA"];
            NSLog(@"alluserAray===%@",_allUserArray);
            
            for (int i=0; i<_allUserArray.count; i++) {
                
                
                    [_isChoiceArray addObject:@"0"];
                    
                    // cell.imView.image=[UIImage imageNamed:@"checkbox_off"];
                    
                }

            
            
            
            [shaerTable reloadData];
            
            
        }
    };
}
//请求已经共享的用户
-(void)requestHadShareDataWirhAdic:(NSDictionary*)dic{
     [_shareUserIDArray removeAllObjects];
    NSLog(@"dic==========%@",dic);
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10511\",\"sceneid\":\"%@\",\"serverid\":\"%@\",\"actuserid\":\"%@\"}",dic[@"id"],SERVERID,USER_ID];
    
    NSLog(@"urlstring====%@",urlstring);
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        if ([[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            //showArray = [NSMutableArray arrayWithArray:dictt[@"DATA"]];
            //            showArray=dictt[@"DATA"];
            
           // [SVProgressHUD showSuccessWithStatus:dictt[@"MSG"]];
            _hasShareArray=dictt[@"DATA"];
           
            
            for (int i=0;i<_hasShareArray.count;i++) {
                [_shareUserIDArray addObject:_hasShareArray[i][@"userid"]];
            }
            NSLog(@"sharidArray=====%@",_shareUserIDArray);
            
            for (int i=0; i<_allUserArray.count; i++) {
                
                
                
                
                if ([_shareUserIDArray containsObject:_allUserArray[i][@"user"][@"id"] ]) {
               
                    
                    //cell.imView.image=[UIImage imageNamed:@"checkbox_on"];
                       [_isChoiceArray setObject:@"1" atIndexedSubscript:i];
                    
                    
                }

                
                
            }
            NSLog(@"hasSharArray====%@",_hasShareArray);
            NSLog(@"chocearray====%@",_isChoiceArray);
            

            [shaerTable reloadData];
            
            
        }
    };
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
