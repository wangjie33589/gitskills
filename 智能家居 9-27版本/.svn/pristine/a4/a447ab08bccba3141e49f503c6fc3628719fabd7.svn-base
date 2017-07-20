//
//  modify_roleViewController.m
//  SmartHome
//
//  Created by sciyonSoft on 16/6/22.
//
//
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#import "modify_roleViewController.h"
#import "role_manger_CollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"

#import "MyHeaderView.h"
#import "MyFooterView.h"


@interface modify_roleViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
//    UICollectionView *collectView;
    NSDictionary *_showDic;
    NSMutableArray *_imageArray;
    
    NSArray *recipeImages;
    
    BOOL shareEnabled;
    
    NSMutableArray *selectedRecipes;
    int tag;
    
    UICollectionView *collectView1;
    UICollectionView *collectView0;
}
@property (strong, nonatomic) IBOutlet UITextField *rolename1;
@property (nonatomic, strong) NSMutableArray *selectedMeauId;//用户选择的meauid数组
@property (nonatomic, strong) NSMutableArray *selectedAreaId;//用户选择的areaid数组

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *showArray;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong)NSMutableArray *newdata;
@property (nonatomic, strong)NSMutableArray *tempArr;//被选中cell的数组
@property (nonatomic,strong)UIView *BigView;//蒙板，大View
@property (nonatomic,strong)UIView *view1;//弹出的角色头像视图
@property (nonatomic, strong)UIButton *btn0;
@property (nonatomic, strong)UIButton *btn1;
@property (nonatomic, strong)UIButton *btn2;
@property (nonatomic, strong)UIButton *btn3;
@property (nonatomic, strong)UIButton *btn4;
@property (nonatomic, strong)UIButton *btn5;
@property (nonatomic, strong)UIButton *btn6;
@property (nonatomic, strong)UIButton *btn7;
@property (nonatomic, strong)UIButton *btn8;
@end

@implementation modify_roleViewController
static NSString *headerIdentifier = @"HeaderView";
static NSString *footerIdentifier = @"FooterView";


- (id)initWithRoleMenuIds:(NSString *)menuIds{
    self = [super init];
    if (self) {
        _menuIds = menuIds;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"修改角色";
    
    
    NSLog(@"--------*********-------修改角色界面---%@",_menuIds);
    _selectedMeauId = [[NSMutableArray alloc]init];//给selectedMeauId分配空间
    _selectedAreaId = [[NSMutableArray alloc]init];//给selectedAreaId分配空间
    selectedRecipes = [NSMutableArray array];
    [self initcollectView0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(SaveBtnClick1)];

    //取存储的照片的id
//    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//    tag = [userDefaultes integerForKey:@"myInteger"];
//    if (tag==1) {
//        [_headerImg setBackgroundImage:[UIImage imageNamed:@"10-1-角色管理-_03"] forState:UIControlStateNormal];
//    } if (tag==2) {
//        [_headerImg setBackgroundImage:[UIImage imageNamed:@"10-1-角色管理-_05"]  forState:UIControlStateNormal];
//    }if (tag==3) {
//        [_headerImg setBackgroundImage:[UIImage imageNamed:@"10-1-角色管理-_03"]  forState:UIControlStateNormal];
//    }if (tag==4) {
//        NSLog(@"tag---%d",tag);
//        [_headerImg setBackgroundImage:[UIImage imageNamed:@"10-1-角色管理-_05"]  forState:UIControlStateNormal];
//    }if (tag==5) {
//        [_headerImg setBackgroundImage:[UIImage imageNamed:@"10-1-角色管理-_03"]  forState:UIControlStateNormal];
//    }if (tag==6) {
//        [_headerImg setBackgroundImage:[UIImage imageNamed:@"10-1-角色管理-_07"]  forState:UIControlStateNormal];
//    }
//    if (tag==7) {
//        [_headerImg setBackgroundImage:[UIImage imageNamed:@"10-1-角色管理-_03"]  forState:UIControlStateNormal];
//    }if (tag==8) {
//        [_headerImg setBackgroundImage:[UIImage imageNamed:@"10-1-角色管理-_07"]  forState:UIControlStateNormal];
//    }

//    _headerImg.layer.masksToBounds = YES;
//    self.headerImg.layer.cornerRadius = 40;
    _rolename1.text = ROLE_NAME;
    if ([ROLE_IMG isEqualToString:@"1"]) {
        [_headerImg setBackgroundImage:[UIImage imageNamed:@"10-1-角色管理-_03"] forState:UIControlStateNormal];
    }else if ([ROLE_IMG isEqualToString:@"2"]) {
        [_headerImg setBackgroundImage:[UIImage imageNamed:@"10-1-角色管理-_05"] forState:UIControlStateNormal];
    }else if ([ROLE_IMG isEqualToString:@"3"]) {
        [_headerImg setBackgroundImage:[UIImage imageNamed:@"工人"] forState:UIControlStateNormal];
    }else if ([ROLE_IMG isEqualToString:@"4"]) {
            [_headerImg setBackgroundImage:[UIImage imageNamed:@"管家"] forState:UIControlStateNormal];
    }else if ([ROLE_IMG isEqualToString:@"5"]) {
        [_headerImg setBackgroundImage:[UIImage imageNamed:@"秘书"] forState:UIControlStateNormal];
    }else if ([ROLE_IMG isEqualToString:@"6"]) {
    [_headerImg setBackgroundImage:[UIImage imageNamed:@"10-1-角色管理-_07"] forState:UIControlStateNormal];
    }else {
         [_headerImg setBackgroundImage:[UIImage imageNamed:@"10-1-角色管理-_03"] forState:UIControlStateNormal];
    }
    
    [self deviceRequest];
    _data = [NSMutableArray arrayWithArray:@[@"场景",@"监控",@"语音助手",@"背景音乐",@"日志",@"家庭留言",@"门禁"]];

}

//角色头像
- (IBAction)headerImg:(id)sender {
    
    _BigView = [[UIView alloc] init];
    _BigView.frame = CGRectMake(0, 0, LWidth, LHeight);
    _BigView.backgroundColor = [UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:0.3];
    [self.view addSubview:_BigView];
    [self.view bringSubviewToFront:_BigView];
    
    _view1 =[[UIView alloc]init];
    _view1.frame=CGRectMake((LWidth-300)/2, 100, 300,240);
    _view1.backgroundColor=[UIColor whiteColor];
    [_BigView addSubview:_view1];
    //标题label
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _view1.frame.size.width, 30)];
    label.backgroundColor=[UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1];
    label.text=@"科远惠家";
    label.font=[UIFont systemFontOfSize:16];
    label.textColor=[UIColor whiteColor];
    [_view1 addSubview:label];
    
    _btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn1.frame = CGRectMake(10, 35, 60, 60);
    [_btn1 setBackgroundImage:[UIImage imageNamed:@"10-1-角色管理-_03"]  forState:UIControlStateNormal];
    [_btn1 setTag:1];
    [_view1 addSubview:_btn1];
    [_btn1 addTarget:self action:@selector(Click1Event:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn2.frame = CGRectMake(75, 35, 60, 60);
    [_btn2 setBackgroundImage:[UIImage imageNamed:@"10-1-角色管理-_05"]  forState:UIControlStateNormal];
    [_btn2 setTag:2];
    [_view1 addSubview:_btn2];
    [_btn2 addTarget:self action:@selector(Click2Event:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn3.frame = CGRectMake(140, 35, 60, 60);
    [_btn3 setBackgroundImage:[UIImage imageNamed:@"工人"]  forState:UIControlStateNormal];
    [_btn3 setTag:3];
    [_view1 addSubview:_btn3];
    [_btn3 addTarget:self action:@selector(Click3Event:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn4.frame = CGRectMake(205,35, 60, 60);
    [_btn4 setBackgroundImage:[UIImage imageNamed:@"管家"]  forState:UIControlStateNormal];
    [_btn4 setTag:4];
    [_view1 addSubview:_btn4];
    [_btn4 addTarget:self action:@selector(Click4Event:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn5.frame = CGRectMake(10, 100, 60, 60);
    [_btn5 setBackgroundImage:[UIImage imageNamed:@"秘书"]  forState:UIControlStateNormal];
    [_btn5 setTag:5];
    [_view1 addSubview:_btn5];
    [_btn5 addTarget:self action:@selector(Click5Event:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn6 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn6.frame = CGRectMake(75, 100, 60, 60);
    [_btn6 setBackgroundImage:[UIImage imageNamed:@"10-1-角色管理-_07"]  forState:UIControlStateNormal];
    [_btn6 setTag:6];
    [_view1 addSubview:_btn6];
    [_btn6 addTarget:self action:@selector(Click6Event:) forControlEvents:UIControlEventTouchUpInside];
    
//    _btn7 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    _btn7.frame = CGRectMake(140, 100, 60, 60);
//    [_btn7 setBackgroundImage:[UIImage imageNamed:@""]  forState:UIControlStateNormal];
//    [_btn7 setTag:7];
//    [_view1 addSubview:_btn7];
//    [_btn7 addTarget:self action:@selector(Click7Event:) forControlEvents:UIControlEventTouchUpInside];
//    
//    _btn8 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    _btn8.frame = CGRectMake(205, 100, 60, 60);
//    [_btn8 setBackgroundImage:[UIImage imageNamed:@""]  forState:UIControlStateNormal];
//    [_btn8 setTag:8];
//    [_view1 addSubview:_btn8];
//    [_btn8 addTarget:self action:@selector(Click8Event:) forControlEvents:UIControlEventTouchUpInside];
    
    //确定按钮
    UIButton  *confirmBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    confirmBtn.frame=CGRectMake(5, _view1.frame.size.height-50, 140, 40);
    confirmBtn.frame = CGRectMake(70, _view1.frame.size.height-50, 135, 40);
    confirmBtn.backgroundColor=[UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1];
    confirmBtn.layer.cornerRadius=8;
    [confirmBtn setTitle:@"确  定" forState:0];
    [confirmBtn setTintColor:[UIColor whiteColor]];
    confirmBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    confirmBtn.layer.masksToBounds=YES;
    confirmBtn.tag=1;
    [confirmBtn addTarget:self action:@selector(ShareConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [_view1 addSubview:confirmBtn];
    //取消按钮
//    UIButton  *cancelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    cancelBtn.frame=CGRectMake(150, _view1.frame.size.height-50, 140, 40);
//    cancelBtn.backgroundColor=[CommonTool colorWithHexString:@"1E90FF"];
//    cancelBtn.layer.cornerRadius=8;
//    [cancelBtn setTitle:@"取  消" forState:0];
//    [cancelBtn setTintColor:[UIColor whiteColor]];
//    cancelBtn.titleLabel.font=[UIFont systemFontOfSize:16];
//    
//    cancelBtn.layer.masksToBounds=YES;
//    cancelBtn.tag=1;
//    [cancelBtn addTarget:self action:@selector(cancelBtnCLICK) forControlEvents:UIControlEventTouchUpInside];
//    
//    [_view1 addSubview:cancelBtn];

}

//取消
//-(void)cancelBtnCLICK{
//    
//    [_BigView removeFromSuperview];
//}
//确定
- (void)ShareConfirmBtn{
    NSLog(@"这是保存");
    [_BigView removeFromSuperview];
}



- (void) Click1Event:(UIButton *) button
{
    NSUInteger BtnTag = [button tag];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(BtnTag == 1)
    {
        [_headerImg setBackgroundImage:[UIImage imageNamed:@"10-1-角色管理-_03"] forState:UIControlStateNormal];
        NSString *str1= [NSString stringWithFormat:@"%d",button.tag];
        [userDefaults setObject:str1 forKey:@"myInteger"];
        NSLog(@"-----%d",button.tag);
    }
}
-(void)Click2Event:(UIButton *) button{
    NSUInteger BtnTag = [button tag];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(BtnTag ==2)
    {
        [_headerImg setBackgroundImage:[UIImage imageNamed:@"10-1-角色管理-_05"]  forState:UIControlStateNormal];
        NSString *str2= [NSString stringWithFormat:@"%d",button.tag];
        [userDefaults setObject:str2 forKey:@"myInteger"];
        NSLog(@"-----%d",button.tag);
    }
}
-(void)Click3Event:(UIButton *) button{
    NSUInteger BtnTag = [button tag];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(BtnTag ==3)
    {
        [_headerImg setBackgroundImage:[UIImage imageNamed:@"工人"]  forState:UIControlStateNormal];
        NSString *str3= [NSString stringWithFormat:@"%d",button.tag];
        [userDefaults setObject:str3 forKey:@"myInteger"];
        NSLog(@"-----%d",button.tag);
    }
}
-(void)Click4Event:(UIButton *) button{
    NSUInteger BtnTag = [button tag];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(BtnTag ==4)
    {
        [_headerImg setBackgroundImage:[UIImage imageNamed:@"管家"]  forState:UIControlStateNormal];
        NSString *str4= [NSString stringWithFormat:@"%d",button.tag];
        [userDefaults setObject:str4 forKey:@"myInteger"];
        NSLog(@"-----%d",button.tag);
    }
}
-(void)Click5Event:(UIButton *) button{
    NSUInteger BtnTag = [button tag];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(BtnTag ==5)
    {
        [_headerImg setBackgroundImage:[UIImage imageNamed:@"秘书"]  forState:UIControlStateNormal];
        NSString *str5= [NSString stringWithFormat:@"%d",button.tag];
        [userDefaults setObject:str5 forKey:@"myInteger"];
        NSLog(@"-----%d",button.tag);
    }
}
-(void)Click6Event:(UIButton *) button{
    NSUInteger BtnTag = [button tag];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(BtnTag ==6)
    {
        [_headerImg setBackgroundImage:[UIImage imageNamed:@"10-1-角色管理-_07"]  forState:UIControlStateNormal];
        NSString *str6= [NSString stringWithFormat:@"%d",button.tag];
        [userDefaults setObject:str6 forKey:@"myInteger"];
        NSLog(@"-----%d",button.tag);
    }
}
//-(void)Click7Event:(UIButton *) button{
//    NSUInteger BtnTag = [button tag];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    if(BtnTag ==7)
//    {
//        [_headerImg setBackgroundImage:[UIImage imageNamed:@""]  forState:UIControlStateNormal];
//        NSString *str7= [NSString stringWithFormat:@"%d",button.tag];
//        [userDefaults setObject:str7 forKey:@"myInteger"];
//        NSLog(@"-----%d",button.tag);
//    }
//}
//-(void)Click8Event:(UIButton *) button{
//    NSUInteger BtnTag = [button tag];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    if(BtnTag ==8)
//    {
//        [_headerImg setBackgroundImage:[UIImage imageNamed:@""]  forState:UIControlStateNormal];
//        NSString *str8= [NSString stringWithFormat:@"%d",button.tag];
//        [userDefaults setObject:str8 forKey:@"myInteger"];
//        NSLog(@"-----%d",button.tag);
//    }
//}


//修改角色
- (void)SaveBtnClick1{
     NSLog(@"%d-----",_tempArr.count);
    NSString *meauidstring = [_selectedMeauId componentsJoinedByString:@","];
    NSLog(@"用户选择的meauid字符串--%@",meauidstring);
    NSString *areaidstring = [_selectedAreaId componentsJoinedByString:@","];
    NSLog(@"用户选择的areaid字符串--%@",areaidstring);
    NSLog(@"修改角色传的数据--%@--%@--%@--%@--%@--%@",SERVERID,_rolename1.text,TAG,meauidstring,areaidstring,MODIFYROLEID);
    if ([_rolename1.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"昵称不能为空"];
        return;
    }
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];

    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10208\",\"serverid\":\"%@\",\"rolename\":\"%@\",\"roleimg\":\"%@\",\"menuid\":\"%@\",\"areaid\":\"%@\",\"id\":\"%@\"}",SERVERID,_rolename1.text,TAG,meauidstring,areaidstring,MODIFYROLEID];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    NSLog(@"dict======%@",dict);
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {

        if ([[dictt objectForKey:@"SS"] integerValue]==200) {
             [MBProgressHUD showMessage:@"保存成功！"];
            // GCD
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 移除遮盖
                [MBProgressHUD hideHUD];
//                [self.navigationController popViewControllerAnimated:YES];
            });
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    
   
}

//请求设备列表
- (void)deviceRequest
{
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];

    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10206\",\"serverid\":\"%@\"}",SERVERID];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    NSLog(@"dict======%@",dict);
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if ([[dictt objectForKey:@"SS"] integerValue]==200) {
            _showArray=dictt[@"DATA"];
            [collectView1 reloadData];
            [self initColltionView];
            NSLog(@"%d---123456789---%@",_showArray.count,SERVERID);
        }
};}

- (void)initcollectView0{
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
    layout.itemSize=CGSizeMake(60, 80);
    layout.sectionInset=UIEdgeInsetsMake(0, 25, 5, 25);
    layout.minimumLineSpacing=5;
    //    self.headerImg.layer.masksToBounds = YES;
    //    self.headerImg.layer.cornerRadius = 35;
    [layout setHeaderReferenceSize:CGSizeMake(collectView1.frame.size.width,40)];
    
    
    //collectionView0
    collectView0 =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 110, LWidth, 215) collectionViewLayout:layout];
    collectView0.backgroundColor=[UIColor whiteColor];
     collectView0.delegate=self;
     collectView0.dataSource=self;
    [ collectView0 registerNib:[UINib nibWithNibName:@"role_manger_CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"namecell1"];
    [ collectView0 registerClass:[MyHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
     collectView0.allowsMultipleSelection = YES;
     collectView0.scrollEnabled =NO;//设置不能滚动
    [self.view addSubview: collectView0];
}

-(void)initColltionView{
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
    layout.itemSize=CGSizeMake(60, 80);
    layout.sectionInset=UIEdgeInsetsMake(10,(LWidth-240)/5, 10, (LWidth-240)/5);
    layout.minimumLineSpacing=5;
    [layout setHeaderReferenceSize:CGSizeMake(collectView1.frame.size.width,40)];
     collectView1 =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 325, LWidth, LHeight-378) collectionViewLayout:layout];
    collectView1.backgroundColor=[UIColor whiteColor];
    collectView1.delegate=self;
    collectView1.dataSource=self;
    self.headerImg.layer.masksToBounds = YES;
    self.headerImg.layer.cornerRadius = 30;
    
    [collectView1 registerNib:[UINib nibWithNibName:@"role_manger_CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"namecell"];
        [collectView1 registerClass:[MyHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    [collectView1 registerClass:[MyFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier];
     collectView1.allowsMultipleSelection = YES;
    [self.view addSubview:collectView1];

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (collectionView==collectView0) {
        return 1;
    }else if(collectionView==collectView1){
        return 1;
    }else return 0;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView==collectView0) {
        return 7;
    }
    if (collectionView==collectView1) {
        return _showArray.count;
    }else
        return 0;
    
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==collectView0) {
        role_manger_CollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"namecell1" forIndexPath:indexPath];
        cell.label.text = _data[indexPath.row];
        cell.label.font = [UIFont systemFontOfSize:13];
        cell.label.textAlignment = NSTextAlignmentCenter;
        
        if (indexPath.row==0) {
            if ([_menuIds rangeOfString:@"1"].location !=NSNotFound) {
            cell.imageView.image = [UIImage imageNamed:@"role_sence_on"];
            cell.imageView.highlightedImage =[UIImage imageNamed:@"role_sence_un"];
            }else{
            cell.imageView.image = [UIImage imageNamed:@"role_sence_un"];
            cell.imageView.highlightedImage =[UIImage imageNamed:@"role_sence_on"];
            }
        } if (indexPath.row==1) {
           
            
            if ([_menuIds rangeOfString:@"2"].location !=NSNotFound) {
            cell.imageView.image = [UIImage imageNamed:@"role_video_on"];
            cell.imageView.highlightedImage =[UIImage imageNamed:@"role_video_un"];
          
            }else{
            cell.imageView.image = [UIImage imageNamed:@"role_video_un"];
            cell.imageView.highlightedImage =[UIImage imageNamed:@"role_video_on"];
            }
            
        } if (indexPath.row==2) {
            if ([_menuIds rangeOfString:@"3"].location !=NSNotFound) {
                cell.imageView.image = [UIImage imageNamed:@"role_devices_on"];
                cell.imageView.highlightedImage =[UIImage imageNamed:@"role_devices_un"];
            }else{
                cell.imageView.image = [UIImage imageNamed:@"role_devices_un"];
                cell.imageView.highlightedImage =[UIImage imageNamed:@"role_devices_on"];
            }
        } if (indexPath.row==3) {
            if ([_menuIds rangeOfString:@"4"].location !=NSNotFound) {
            cell.imageView.highlightedImage =[UIImage imageNamed:@"role_music_un"];
            cell.imageView.image = [UIImage imageNamed:@"role_music_on"];
            }else{
               cell.imageView.image = [UIImage imageNamed:@"role_music_un"];
                cell.imageView.highlightedImage =[UIImage imageNamed:@"role_music_on"];
            }
        } if (indexPath.row==4) {
            if ([_menuIds rangeOfString:@"5"].location !=NSNotFound) {
                cell.imageView.highlightedImage =[UIImage imageNamed:@"role_log_un"];
                cell.imageView.image = [UIImage imageNamed:@"role_log_on"];
            }else{
                    cell.imageView.image = [UIImage imageNamed:@"role_log_un"];
                cell.imageView.highlightedImage =[UIImage imageNamed:@"role_log_on"];
            }

            
        } if (indexPath.row==5) {
            if ([_menuIds rangeOfString:@"6"].location !=NSNotFound) {
                cell.imageView.highlightedImage =[UIImage imageNamed:@"role_bbs_un"];
                cell.imageView.image = [UIImage imageNamed:@"role_bbs_on"];
            }else{
                cell.imageView.image = [UIImage imageNamed:@"role_bbs_un"];
                cell.imageView.highlightedImage =[UIImage imageNamed:@"role_bbs_on"];
            }
        } if (indexPath.row==6) {
            if ([_menuIds rangeOfString:@"7"].location !=NSNotFound) {
                cell.imageView.highlightedImage =[UIImage imageNamed:@"menjin"];
                cell.imageView.image = [UIImage imageNamed:@"门禁"];
                NSLog(@"7");
            }else{
                  cell.imageView.image = [UIImage imageNamed:@"menjin"];
                cell.imageView.highlightedImage =[UIImage imageNamed:@"门禁"];
            }
        }
        


        
        
        
        return cell;
    }
    if (collectionView==collectView1) {
        role_manger_CollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"namecell" forIndexPath:indexPath];
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.cornerRadius = 30;
        //cell.imageView.highlightedImage = [UIImage imageNamed:@"user_role_add"];
        cell.icon.highlightedImage = [UIImage imageNamed:@"SelIcon@2x"];
        if (![_showArray[indexPath.row] isKindOfClass:[NSNull class]]) {
            cell.label.text = _showArray[indexPath.row][@"areaname"];
        }
        cell.label.font = [UIFont systemFontOfSize:13];
        cell.label.textAlignment = NSTextAlignmentCenter;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@%@",HTTPIP,IMAGE_URL,_showArray[indexPath.row][@"areaimg"]]] placeholderImage:[UIImage imageNamed:@"area"]];
        return cell;
    }
}

//设置头尾部内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *reusableView =nil;
    if (kind ==UICollectionElementKindSectionHeader) {
        //定制头部视图的内容
        MyHeaderView *headerV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        
        if (collectionView==collectView0) {
            headerV.titleLab.text = @"版块授权";
        }
        if (collectionView==collectView1) {
            headerV.titleLab.text = @"设备授权";
        }
        
        reusableView = headerV;
    }
    if (kind ==UICollectionElementKindSectionFooter) {
        MyFooterView *footerV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerIdentifier forIndexPath:indexPath];
        if (collectionView==collectView1) {
            footerV.titleLab1.text = @"";
        }
        reusableView = footerV;
    }
    
    return reusableView;
}


#pragma mark <UICollectionViewDelegate>

/**
 * Cell是否可以高亮
 */
- (BOOL)collectionView: (UICollectionView *)collectionView
shouldHighlightItemAtIndexPath: (NSIndexPath *)indexPath{
    
    return YES;
    
}


/**
 * 如果Cell可以高亮，Cell变为高亮后调用该方法
 */
- (void)collectionView: (UICollectionView *)collectionView
didHighlightItemAtIndexPath: (NSIndexPath *)indexPath{
    
    [self changeHighlightCellWithIndexPath:indexPath];
}


/**
 * 如果Cell可以高亮，Cell从高亮变为非高亮调用该方法
 */
- (void)collectionView: (UICollectionView *)collectionView
didUnhighlightItemAtIndexPath: (NSIndexPath *)indexPath{
    
    [self changeHighlightCellWithIndexPath:indexPath];
    
}

/**
 * 根据高亮状态修改背景图片
 */
- (void) changeHighlightCellWithIndexPath: (NSIndexPath *) indexPath{
    //获取当前变化的Cell
   role_manger_CollectionViewCell *currentHighlightCell = (role_manger_CollectionViewCell *)[collectView1 cellForItemAtIndexPath:indexPath];
    
//    currentHighlightCell.imageViewSelect.highlighted = currentHighlightCell.highlighted;
    currentHighlightCell.selIcon.highlighted = currentHighlightCell.highlighted;
//    currentHighlightCell.selsignIcon.highlighted = currentHighlightCell.highlighted;
    if (currentHighlightCell.highlighted == YES){
        return;
    }
    
    if (currentHighlightCell.highlighted == NO){
    }

}

/**
 * Cell是否可以选中
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


/**
 * Cell多选时是否支持取消功能
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

/**
 * Cell选中调用该方法
 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    role_manger_CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (![_rolename1 isExclusiveTouch]) {
        [_rolename1 resignFirstResponder];
    }
//    if (cell.imageView.highlighted==YES) {
//    }
    if (collectionView==collectView0) {
        NSString *meauid = [NSString stringWithFormat:@"%d",(indexPath.row+1)];
        _selectedMeauId = [NSMutableArray arrayWithArray:[_menuIds componentsSeparatedByString:@","]];
        [_selectedMeauId addObject:meauid];
        NSLog(@"用户选择的meauid数组1--%@",_selectedMeauId);
    }
    if (collectionView==collectView1) {
        [_selectedAreaId addObject:_showArray[indexPath.row][@"id"]];
        NSLog(@"用户选择的areaid数组1--%@",_selectedAreaId);
    }
  
}

/**
 * Cell取消选中调用该方法
 */
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    

    NSLog(@"第%d个section上第%d个cell被取消选中---",indexPath.section,indexPath.row);
    if (![_rolename1 isExclusiveTouch]) {
        [_rolename1 resignFirstResponder];
    }
    
    
    if (collectionView==collectView0) {
        NSString *meauid = [NSString stringWithFormat:@"%d",(indexPath.row+1)];
        [_selectedMeauId removeObject:meauid];
        NSLog(@"用户选择的meauid数组2--%@",_selectedMeauId);
    }
    if (collectionView==collectView1) {
        [_selectedAreaId removeObject:_showArray[indexPath.row][@"id"]];
        NSLog(@"用户选择的areaid数组2--%@",_selectedAreaId);
    }
}



@end
