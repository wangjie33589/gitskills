//
//  DeviceViewController.m
//  SyncSmartHome
//
//  Created by SciyonSoft_WangJie on 16/5/3.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "DeviceViewController.h"
#import "TopView.h"
#import "TypeViewController.h"
#import "AreaViewController.h"
#import "addViewController.h"
#import "KeepSenceViewController.h"
#import "DropdownMenuController.h"
#import "SearchViewController.h"

@interface DeviceViewController ()<TopViewDelegate,UITableViewDelegate,UITableViewDataSource,DropdownMenuControllerDelegate,
UIPopoverPresentationControllerDelegate>{

    UIScrollView *totalScrollView;
    NSArray *titleArray;
    TopView* vc;
    UITableView *_listTable;
    NSArray *_litstTableArray;
    BOOL isHiden;
    
    
    NSArray *_TypeArray;
    NSArray *_AreaArray;


}
@property (nonatomic, strong) DropdownMenuController *popoVerMenu;
@property (nonatomic, strong) NSDictionary *dataDic;


@end


@implementation DeviceViewController

- (DropdownMenuController *)popoVerMenu {
    if (!_popoVerMenu) {
        _popoVerMenu = [[DropdownMenuController alloc] init];
        _popoVerMenu.delegate = self;
    }
    return _popoVerMenu;
}
- (NSDictionary *)dataDic {
    if (!_dataDic) {
        _dataDic = @{@"保存为场景":[UIImage imageNamed:@"equ_icon_fridge.png"],
                     @"添加":[UIImage imageNamed:@"equ_icon_add.png"]
                     
                     };
    }
    return _dataDic;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
      isHiden=YES;
   // [self requestForArea];
 


}

- (void)viewDidLoad {
    [super viewDidLoad];
       self.title=@"设备";
    
     UIBarButtonItem *leftBtn =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"leftImag"] style:UIBarButtonItemStylePlain target:self action:@selector(callModalList)];
    self.navigationItem.leftBarButtonItem = leftBtn;

    
  
    isHiden=YES;
   titleArray=[[NSArray alloc]initWithObjects:@"区域",@"类型" ,nil];
    totalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, LWidth, LHeight-104)];//总scrollView
        totalScrollView.pagingEnabled = YES;
    totalScrollView.delegate = self;
    [self.view addSubview:totalScrollView];
    [self initViewXml];
  
    _litstTableArray =[[NSArray alloc]initWithObjects:@"添加", @"保存为场景",nil];
    //[UIImage imageNamed:@"icon_5_n"]
    UIBarButtonItem *rightBtn =[[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(rightBtmClick)];
    
    rightBtn.accessibilityElementsHidden=YES;
    UIBarButtonItem *searchBtn =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBtnClick)];
        self.navigationItem.rightBarButtonItems=@[rightBtn,searchBtn];
         [self initViewController];
    //[self initListTableView];
}
- (void)callModalList
{
    AppDelegate *aAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [aAppDelegate.ddMenu showLeftController:YES];
}


-(void)rightBtmClick{
//    NSLog(@"右边");
//    isHiden=!isHiden;
//    if (isHiden) {
      _listTable.hidden=YES;
//    }else{
//       _listTable.hidden=NO;
//    }
//
    
    
    self.popoVerMenu.modalPresentationStyle = UIModalPresentationPopover;
    self.popoVerMenu.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;//箭头方向指向
    self.popoVerMenu.dataDic =self.dataDic;
    
    self.popoVerMenu.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUnknown;//箭头方向,如果是baritem不设置方向，会默认up，up的效果也是最理想的
    self.popoVerMenu.popoverPresentationController.delegate = self;
    [self presentViewController:self.popoVerMenu animated:YES completion:nil];

}
-(void)searchBtnClick{
    NSLog(@"搜素");
    SearchViewController *searchVC=[[SearchViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:searchVC];
    [self presentViewController:nav animated:YES completion:nil];
    
    
}
-(void)initListTableView{
    
    _listTable =[[UITableView alloc]initWithFrame:CGRectMake( LWidth-100,0, 100,100) style:UITableViewStylePlain];
        _listTable.hidden=YES;
    _listTable.dataSource=self;
    _listTable.delegate=self;
    [self.view addSubview:_listTable];
}

- (void)initViewXml                {
    totalScrollView.contentSize = CGSizeMake(LWidth*2, 40);
    /// [self requestShowDataList4];
    vc = [[TopView alloc] initWithFrame:CGRectMake(0, 0, LWidth, 40)];
    vc.array = titleArray;
    vc.delegate = self;
    vc.backgroundColor = [UIColor blackColor];
    [self.view addSubview:vc];
}
-(void)initViewController{
    
    TypeViewController *typeVC =[[TypeViewController alloc]init];
    typeVC.view.frame=CGRectMake(LWidth, 0, LWidth, totalScrollView.frame.size.height);
    [totalScrollView addSubview:typeVC.view];
    [self addChildViewController:typeVC
     ];
    //确认信息
    AreaViewController *areaVC =[[AreaViewController alloc]init];
    areaVC.view.frame=CGRectMake(0, 0,LWidth, totalScrollView.frame.size.height);
    [totalScrollView addSubview:areaVC.view];
    [self addChildViewController:areaVC];

}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(unsigned long)(scrollView.contentOffset.x / scrollView.frame.size.width)],@"indexpage", nil];
    //通知原来也可以传递字典
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
- (void)pushNewsViewController:(NSInteger)page
{
    [totalScrollView setContentOffset:CGPointMake(LWidth*page, 0) animated:YES];
}
- (void)popoVerMenu:(UIBarButtonItem *)sender {
    //    self.popoVerMenu = [[DropdownMenuController alloc]init];
    //    self.popoVerMenu.delegate = self;
    self.popoVerMenu.modalPresentationStyle = UIModalPresentationPopover;
    self.popoVerMenu.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;//箭头方向指向
    self.popoVerMenu.dataDic =self.dataDic;
    self.popoVerMenu.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUnknown;//箭头方向,如果是baritem不设置方向，会默认up，up的效果也是最理想的
    self.popoVerMenu.popoverPresentationController.delegate = self;
    [self presentViewController:self.popoVerMenu animated:YES completion:nil];
    
}
- (void)DropdownMenuController:(DropdownMenuController *)dropdownMenuVC withIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
              addViewController  *addvc =[[addViewController  alloc]init];
                [self.navigationController pushViewController:addvc animated:YES];
        
            }else{
                KeepSenceViewController *keepvc =[[KeepSenceViewController alloc]init];
             [self.navigationController pushViewController:keepvc animated:YES];
              
           }

    NSLog(@"－-> %li",(long)indexPath.row);
}
//popover样式
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;   //点击蒙版popover不消失， 默认yes
}



@end
