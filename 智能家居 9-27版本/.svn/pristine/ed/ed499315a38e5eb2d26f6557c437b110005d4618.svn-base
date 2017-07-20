//
//  KYMonitorViewController.m
//  SyncSmartHome
//
//  Created by sciyonSoft on 16/5/5.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "KYMonitorViewController.h"
#import "CollectionViewCell.h"
#import "Monitor_Two_Controller.h"
#import "PlayerDemoViewController.h"
#import "addVideoViewController.h"
@interface KYMonitorViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>{
    UICollectionView * collectView;
    NSArray *_showArray;
    UILongPressGestureRecognizer  * longPressGr;
}

@end

@implementation KYMonitorViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
      [self requestForShowData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *leftBtn =[[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target:self action:@selector(addBtnClick)];
    self.navigationItem.rightBarButtonItem=leftBtn;
  
    self.title = @"查看监控";
    [self initCollectView];
    longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    longPressGr.delegate = self;
    longPressGr.delaysTouchesBegan = YES;
    [collectView addGestureRecognizer:longPressGr];
    [collectView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];

}
-(void)longPressToDo:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint p = [gestureRecognizer locationInView:collectView];
        
        NSIndexPath *indexPath = [collectView indexPathForItemAtPoint:p];
        NSLog(@"afgdsf==%d",indexPath.row);
        //        UICollectionViewCell* cell =
        
        //        [collectView cellForItemAtIndexPath:indexPath];
        if (indexPath.row>=0) {
            UIAlertController *controller =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleAlert];
                       UIAlertAction *eidt=[UIAlertAction actionWithTitle:@"编辑" style:UIAlertActionStyleDestructive     handler:^(UIAlertAction * _Nonnull action) {
                        
                addVideoViewController *vc =[[addVideoViewController alloc]initWithADIc:_showArray[indexPath.row]];
                           vc.type=1;
    
       [self.navigationController pushViewController:vc animated:YES];
            }];
            UIAlertAction *delte=[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive  handler:^(UIAlertAction * _Nonnull action) {
                [self deleteVideoWithAdic:_showArray[indexPath.row]];
                
            }];
          
            [controller addAction:eidt];
            [controller addAction:delte];
           
            [self presentViewController:controller animated:YES completion:nil];
    }
        
        NSLog(@"Whodasfsdfg==");
        return;
    }
}


-(void)addBtnClick{
    addVideoViewController *vc =[[addVideoViewController alloc]init];
    vc.type=0;
    [self.navigationController pushViewController:vc animated:YES];






}
-(void)initCollectView{
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
    layout.itemSize=CGSizeMake(LWidth/2-5,LWidth/2-5);
    //上左下右
    layout.sectionInset=UIEdgeInsetsMake(10,0, 200,0);
    layout.minimumLineSpacing=10;
    collectView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, LWidth, LHeight) collectionViewLayout:layout];

    collectView.backgroundColor=[CommonTool  colorWithHexString:@"f5f5f5"];
    collectView.delegate=self;
    collectView.dataSource=self;
//    _showArray=[[NSArray alloc]initWithObjects:@"摄像头 一",@"厨房",@"大门左",@"大门正中央",@"院子球机",@"二楼阳台",@"摄像头 一",@"摄像头 一",@"摄像头 一",@"摄像头 二", nil];
    [collectView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:collectView];
    

}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _showArray.count;
    
    
    
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionViewCell *cell =[collectionView  dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor whiteColor];
    cell.label.text=_showArray[indexPath.row][@"videoname"];
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@%@",HTTPIP,IMAGE_URL,_showArray[indexPath.row][@"areaimg"]]]
    cell.imageView.image =[UIImage imageNamed:@"video2"];
     
     
     return cell;
    
    
    
    
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    TypeDetilViewController *vc =[[TypeDetilViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    PlayerDemoViewController *vc =[[PlayerDemoViewController alloc]initWithAdic:_showArray[indexPath.row]];;
    [self.navigationController pushViewController:vc  animated:YES];
//
    
    
    
}
-(void)requestForShowData{
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10801\",\"videotypeid\":\"%@\",\"serverid\":\"%@\",\"actuserid\":\"%@\"}",@"10086",SERVERID,USER_ID];
     NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    
    // NSLog(@"sadfsdfhbgh===%@",newurlString);
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
             //[SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            _showArray=dictt[@"DATA"];
            
            
            
//            [self requestForType];
            [collectView reloadData];
NSLog(@"_AreaArray====%@",_showArray);
            
            
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
   
}
-(void)deleteVideoWithAdic:(NSDictionary*)aDic{
      NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];

   NSString * urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10805\",\"id\":\"%@\",\"serverid\":\"%@\",\"actuserid\":\"%@\"}",aDic[@"id"],SERVERID,USER_ID];
       NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
     
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            
            [SVProgressHUD showSuccessWithStatus:[dictt objectForKey:@"MSG"]];
            [self  requestForShowData];
         
            }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
            
        }
    };
    
    
    
    
    
}


@end
