//
//  CommonFunctionVC.m
//  Proxy_ios
//
//  Created by SciyonSoft_WangJie on 17/7/7.
//  Copyright © 2017年 keyuan. All rights reserved.
//

#import "CommonFunctionVC.h"
#import "CommonFunctionCell.h"
#import "FunctionModel.h"
#import "UIImageView+WebCache.h"
#import "LeftViewController.h"
#import "BookViewController.h"
#import "BYMainController.h"
#import "RunLogViewController.h"
#import "WorkLogViewController.h"
#import "NoticeViewController.h"
#import "BaseViewController.h"
#import "HotNewsViewController.h"
#import "AllQueryViewController.h"
#import "registerVC.h"
#import "workTaskVC.h"
#import "VehicAppVC.h"

@interface CommonFunctionVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,MyRequestDelegate,LeftViewControllerRefreshDelegate>{
    UICollectionView *_collectionView;
    NSMutableArray* showArray;
    UIView* popView;

}

@end

@implementation CommonFunctionVC

- (void)viewDidLoad {
    [super viewDidLoad];
      self.title = @"常用功能";
    
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
    
  
  
    [SVProgressHUD showWithStatus:@"努力加载中..."];

    [self requestShowDataFunction];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self requestShowDataFunction];
    
}

- (void)callModalList
{
    AppDelegate *aAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [aAppDelegate.ddMenu showLeftController:YES];
}
- (void)requestShowDataFunction
{
    
    [popView removeFromSuperview];
    [showArray removeAllObjects];
    showArray = [[NSMutableArray alloc] init];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETSHORTCUT",@"Action",USERGUID,@"USERGUID", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/ProxyMobile/MobileFrame.ashx",HTTPIP,SLRD] withParameter:dict];
    manager.delegate = self;
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            [SVProgressHUD dismiss];
            showArray = [NSMutableArray arrayWithArray:[[dictt objectForKey:@"Data"] objectForKey:@"R"]];
            
            NSLog(@"QQQQQ====%@",showArray);
            [self initcolletcionView];
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}
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
    UITapGestureRecognizer* regiontapGestureT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestShowDataFunction)];
    [popView addGestureRecognizer:regiontapGestureT];
}

//初始化collectionview
-(void)initcolletcionView{
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout  alloc]init];
    
    layout.itemSize=CGSizeMake(80, 100);
    layout.minimumLineSpacing=30;
    layout.minimumInteritemSpacing=30;
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
   _collectionView =[[UICollectionView  alloc]initWithFrame:CGRectMake(0, 0, LWidth, LHeight) collectionViewLayout:layout];
    _collectionView.backgroundColor=[UIColor whiteColor];
    if (IPHONE_5) {
            _collectionView.contentInset=UIEdgeInsetsMake(10, 10, 120, 10);
    }else{
        _collectionView.contentInset=UIEdgeInsetsMake(10, 30, 120, 30);
    }

    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    [_collectionView registerNib:[UINib  nibWithNibName:@"CommonFunctionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    //_collectionView.pagingEnabled=YES;
    [self.view addSubview:_collectionView];
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longHandle:)];
    [_collectionView addGestureRecognizer:longTap];
    

}
//2.长按方法
-(void)longHandle:(UILongPressGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:[gesture locationInView:_collectionView]];
            if (indexPath == nil) {
                break;
            }
           // [_collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            //cell.layer添加抖动手势
            for (CommonFunctionCell *cell in [_collectionView visibleCells]) {
                cell.button.hidden=NO;
                [self starShake:cell];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
           // [_collectionView updateInteractiveMovementTargetPosition:[gesture locationInView:_collectionView]];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            
            //[_collectionView endInteractiveMovement];
            //cell.layer移除抖动手势
//            for (CommonFunctionCell *cell in [_collectionView visibleCells]) {
//                //[self stopShake:cell];
//            }
            break;
        }
            
        default:
           // [_collectionView cancelInteractiveMovement];
            break;
    }
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return showArray.count;


}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CommonFunctionCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (showArray.count>0) {
        
        [cell.imageVIEW sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@/MobileImages/%@",HTTPIP,SLRD,[[showArray[indexPath.row] objectForKey:@"GIFNAME"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]] placeholderImage:[UIImage imageNamed:@"index1"]];
        cell.label.text=[showArray[indexPath.row] objectForKey:@"MNAME"];
        cell.button.tag=indexPath.row;
        [cell.button addTarget:self action:@selector(delcell:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
-(void)delcell:(UIButton*)cellBtn{
    for (CommonFunctionCell *cell in [_collectionView visibleCells]) {
        [self stopShake:cell];
    }
    [SVProgressHUD showWithStatus:@"删除中..."];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"DELSHORTCUT",@"Action",[[showArray objectAtIndex:cellBtn.tag] objectForKey:@"GUID"],@"GUID", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/ProxyMobile/MobileFrame.ashx",HTTPIP,SLRD] withParameter:dict];
    manager.delegate = self;
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"移除成功"];
            [SVProgressHUD showWithStatus:@"请稍后..."];
            [self requestShowDataFunction];
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}
//3.设置可移动
-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//4.移动完成后的方法  －－ 交换数据
-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //[self.list exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CommonFunctionCell  *cell =(CommonFunctionCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([showArray[indexPath.row] objectForKey:@"MURL3"]==nil||[[showArray[indexPath.row] objectForKey:@"MURL3"] isEqual:[NSNull null]]||[[showArray[indexPath.row] objectForKey:@"MURL3"] isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"出错了，此功能没有配置"];
    }else{
        if ([[showArray[indexPath.row] objectForKey:@"MURL3"] isEqualToString:@"oa.ContactsActivity"]) {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            BookViewController* bookVC = [story instantiateViewControllerWithIdentifier:@"BookViewController"];
            bookVC.title_Str = cell.label.text;
            bookVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bookVC animated:YES];
        }else if ([[showArray[indexPath.row] objectForKey:@"MURL3"] isEqualToString:@"oa.NewsCenterActivity"]) {
            BYMainController* newsVC = [BYMainController new];
            newsVC.title_Str =cell.label.text;
            newsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newsVC animated:YES];
        }else if ([[showArray[indexPath.row] objectForKey:@"MURL3"] isEqualToString:@"dm.DutyLogListActivity"]) {
            RunLogViewController* runVC = [RunLogViewController new];
            runVC.hidesBottomBarWhenPushed = YES;
            runVC.title_Str = cell.label.text;
            [self.navigationController pushViewController:runVC animated:YES];
        }else if ([[showArray[indexPath.row] objectForKey:@"MURL3"] isEqualToString:@"dm.WorkLog_NoteListActivity"]) {
            WorkLogViewController* workVC = [WorkLogViewController new];
            workVC.hidesBottomBarWhenPushed = YES;
            workVC.title_Str = cell.label.text;
            [self.navigationController pushViewController:workVC animated:YES];
        }else if ([[showArray[indexPath.row] objectForKey:@"MURL3"] isEqualToString:@"oa.AnnocActivity"]) {
            NoticeViewController* noticeVC = [NoticeViewController new];
            noticeVC.hidesBottomBarWhenPushed = YES;
            noticeVC.title_str = cell.label.text;
            [self.navigationController pushViewController:noticeVC animated:YES];
        }else if ([[showArray[indexPath.row] objectForKey:@"MURL3"] isEqualToString:@"eam.EAM_DefectListActivity"]) {
            BaseViewController* baseVC = [BaseViewController new];
            baseVC.hidesBottomBarWhenPushed = YES;
            baseVC.title_str =cell.label.text;
            [self.navigationController pushViewController:baseVC animated:YES];
        }else if ([[[showArray[indexPath.row] objectForKey:@"MURL3"] substringToIndex:7] isEqualToString:@"http://"]) {
            NSString *url=[showArray[indexPath.row]objectForKey:@"MURL3"] ;
            NSString *NEWurl= [url stringByReplacingOccurrencesOfString:FLAG withString:HTTPIP];
            if ([url rangeOfString:FLAG].location!=NSNotFound ) {
                HotNewsViewController* hotVC = [[HotNewsViewController alloc] initWithUrl:NEWurl  title:cell.label.text];
                hotVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:hotVC animated:YES];
            }
        }else if ([[showArray[indexPath.row] objectForKey:@"MURL3"]  isEqualToString:@"epm.WCListActivity"]) {
            registerVC* vc = [[registerVC alloc] initWithUrl:[showArray[indexPath.row] objectForKey:@"MURL3"] title:cell.label.text];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if([[showArray[indexPath.row] objectForKey:@"MURL3"]  isEqualToString:@"oa.WorkTaskActivity"]){
            workTaskVC*work_taskVC = [[workTaskVC alloc] initWithUrl:[showArray[indexPath.row] objectForKey:@"MURL3"]  title:cell.label.text];
            work_taskVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:work_taskVC animated:YES];
            
        }
        else if ([[[showArray[indexPath.row] objectForKey:@"MURL3"] substringToIndex:23] isEqualToString:@"query.QueryListActivity"]) {
            AllQueryViewController* vc = [[AllQueryViewController alloc] initWithUrl:[showArray[indexPath.row] objectForKey:@"MURL3"] title:cell.label.text];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([[[showArray[indexPath.row] objectForKey:@"MURL3"] substringToIndex:23] isEqualToString:@"oa.CarApplyListActivity"]) {
            VehicAppVC *vc =[[[VehicAppVC alloc]init]initWithUrl:[showArray[indexPath.row] objectForKey:@"MURL3"] title:cell.label.text];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
            

        }
        
    }

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (showArray.count>0) {
        for (CommonFunctionCell *cell in [_collectionView visibleCells]) {
            [self stopShake:cell];
        }
    }
   }

- (void)starShake:(CommonFunctionCell*)cell{
  
    
    CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
    keyAnimaion.keyPath = @"transform.rotation";
    keyAnimaion.values = @[@(-3 / 180.0 * M_PI),@(3 /180.0 * M_PI),@(-3/ 180.0 * M_PI)];//度数转弧度
    keyAnimaion.removedOnCompletion = NO;
    keyAnimaion.fillMode = kCAFillModeForwards;
    keyAnimaion.duration = 0.3;
    keyAnimaion.repeatCount = MAXFLOAT;
    [cell.layer addAnimation:keyAnimaion forKey:@"cellShake"];

    
}
- (void)stopShake:(CommonFunctionCell*)cell{
    cell.button.hidden=YES;
    [cell.layer removeAnimationForKey:@"cellShake"];
}


@end
