//
//  KY_role_manger_ViewController.m
//  SyncSmartHome
//
//  Created by SciyonSoft_WangJie on 16/5/26.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "KY_role_manger_ViewController.h"
#import "role_manger_CollectionViewCell.h"
#import "add_new_roleVC.h"
#import "modify_roleViewController.h"
#import "UIImageView+WebCache.h"
@interface KY_role_manger_ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate>{
    UICollectionView *collectView;
    NSMutableArray *_XmlArray;
    NSMutableArray *_XmlArray1;
    NSMutableArray *_XmlArray2;
    NSDictionary *_SetDic;
    UILongPressGestureRecognizer * longPressGr;
    UIView *_eidtView;
    UIView * Comments;
}

@property (nonatomic, strong)NSMutableArray *tempArray;
@property (nonatomic, strong)NSDictionary *XmDIc;
@end

@implementation KY_role_manger_ViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    NSLog(@"请求了");
    _XmlArray1 = [[NSMutableArray alloc]init];
    _XmlArray2 = [[NSMutableArray alloc]init];
    [self requestShowData];
    [self requestShowData];
    [collectView reloadData];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"角色管理";

    self.tabBarController.tabBar.hidden = YES;
//    _XmlArray =[NSMutableArray array];
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
    layout.itemSize=CGSizeMake(60, 90);
    layout.sectionInset=UIEdgeInsetsMake(50,(LWidth-240)/5, 50, (LWidth-240)/5);
    layout.minimumLineSpacing=5;
    collectView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, LWidth, LHeight) collectionViewLayout:layout];
    [self initColltionView];
    [self requestShowData] ;
   
    UIBarButtonItem *rightBtn =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem=rightBtn;
}

- (void)rightBtnClick{
    add_new_roleVC *vc = [[add_new_roleVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)initColltionView{
    collectView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    collectView.delegate=self;
    collectView.dataSource=self;
    longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    longPressGr.delegate = self;
    longPressGr.delaysTouchesBegan = YES;
    [collectView addGestureRecognizer:longPressGr];
    [collectView registerNib:[UINib nibWithNibName:@"role_manger_CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:collectView];
}


//
-(void)requestShowData{
//    NSLog(@"%@-----888888",SERVERID);
      NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10204\",\"serverid\":\"%@\"}",SERVERID];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    NSLog(@"murl---%@",muUrl);
     NSLog(@"urlstring---%@",urlstring);
    NSLog(@"dict======%@",dict);
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    NSLog(@"manager======%@",manager);
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
//        NSLog(@"角色名====%@",dictt[@"DATA"][1][@"role"][@"rolename"]);
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            _XmlArray=dictt[@"DATA"];
//          NSLog(@"_XmlArray---------%@",_XmlArray);
//            NSLog(@"meau--**************---%@",_XmlArray[0][@"menu"]);
            
            [SVProgressHUD showWithStatus:[dictt objectForKey:@"MSG"]];
            // GCD
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 移除遮盖
                [SVProgressHUD dismiss];
                
            });

                [collectView reloadData];
            NSLog(@"刷新了");
           
        }else{
            [SVProgressHUD showWithStatus:[dictt objectForKey:@"MSG"]];
            // GCD
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 移除遮盖
                [SVProgressHUD dismiss];
                
            });

        
        }
    };
    
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _XmlArray.count;
 
   
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    role_manger_CollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    if (![_XmlArray[indexPath.row][@"menu"][indexPath.row][@"menuid"] isKindOfClass:[NSNull class]]) {
//           NSLog(@"meau--**************---%@",_XmlArray[indexPath.row][@"menu"][indexPath.row][@"menuid"]);
//    }
//    
    
  
    if (![_XmlArray[indexPath.row][@"role"][@"rolename"] isKindOfClass:[NSNull class]]) {
        cell.label.text=_XmlArray[indexPath.row][@"role"][@"rolename"];
    }

//    cell.imageView.layer.masksToBounds = YES;
//    cell.imageView.layer.cornerRadius = 40;
    cell.label.font = [UIFont systemFontOfSize:12];
    cell.label.textAlignment = NSTextAlignmentCenter;
    if ([_XmlArray[indexPath.row][@"role"][@"roleimg"] isKindOfClass:[NSNull class]]) {
         cell.imageView.image = [UIImage imageNamed:@"role"];
    }
    
    else if(![_XmlArray[indexPath.row][@"role"][@"roleimg"] isKindOfClass:[NSNull class]]) {
        if ([_XmlArray[indexPath.row][@"role"][@"roleimg"] isEqualToString:@"1"]) {
            cell.imageView.image = [UIImage imageNamed:@"10-1-角色管理-_03"];
        }else if ([_XmlArray[indexPath.row][@"role"][@"roleimg"] isEqualToString:@"2"]) {
            cell.imageView.image = [UIImage imageNamed:@"10-1-角色管理-_05"];
        }else if ([_XmlArray[indexPath.row][@"role"][@"roleimg"] isEqualToString:@"3"]) {
            cell.imageView.image = [UIImage imageNamed:@"工人"];
        }else if ([_XmlArray[indexPath.row][@"role"][@"roleimg"] isEqualToString:@"4"]) {
            cell.imageView.image = [UIImage imageNamed:@"管家"];
        }else if ([_XmlArray[indexPath.row][@"role"][@"roleimg"] isEqualToString:@"5"]) {
            cell.imageView.image = [UIImage imageNamed:@"秘书"];
        }else if ([_XmlArray[indexPath.row][@"role"][@"roleimg"] isEqualToString:@"6"]) {
            cell.imageView.image = [UIImage imageNamed:@"10-1-角色管理-_07"];
        }else if ([_XmlArray[indexPath.row][@"role"][@"roleimg"] isEqualToString:@"7"]) {
            cell.imageView.image = [UIImage imageNamed:@""];
        }else if ([_XmlArray[indexPath.row][@"role"][@"roleimg"] isEqualToString:@"8"]) {
            cell.imageView.image = [UIImage imageNamed:@""];
        }
        
        
//    
    }


    return cell;
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (![_XmlArray[indexPath.row][@"role"][@"rolename"] isKindOfClass:[NSNull class]]) {
         [[NSUserDefaults standardUserDefaults]setValue:_XmlArray[indexPath.row][@"role"][@"rolename"] forKey:@"rolename1"];
    }
    if (![_XmlArray[indexPath.row][@"role"][@"roleimg"] isKindOfClass:[NSNull class]]) {
        [[NSUserDefaults standardUserDefaults]setValue:_XmlArray[indexPath.row][@"role"][@"roleimg"] forKey:@"roleimg1"];
    }
    
    
    if (![_XmlArray[indexPath.row][@"role"][@"id"] isKindOfClass:[NSNull class]]) {
        [[NSUserDefaults standardUserDefaults] setObject: _XmlArray[indexPath.row][@"role"][@"id"] forKey:@"modifyroleid"];
        NSLog(@"modifyroleid---%@",_XmlArray[indexPath.row][@"role"][@"id"]);
    }
    
    
    _XmlArray1 = [NSMutableArray arrayWithArray:_XmlArray[indexPath.row][@"menu"]];
    NSLog(@"_XmlArray1--*****---%@",_XmlArray1);
    for (int i = 0; i<_XmlArray1.count; i++) {
        [_XmlArray2 addObject:_XmlArray1[i][@"menuid"]];
    }
//  NSLog(@"_XmlArray1-----%@--%@",_XmlArray1[0][@"menuid"],_XmlArray1[1][@"menuid"]);
    _XmlArray2 = [_XmlArray2 valueForKeyPath:@"@distinctUnionOfObjects.self"];
    NSString *str =[_XmlArray2 componentsJoinedByString:@","];
    NSLog(@"str---------%@",str);

    
        modify_roleViewController *vc =[[modify_roleViewController alloc]initWithRoleMenuIds:str];
        [self.navigationController pushViewController:vc animated:YES]; 
}


-(void)longPressToDo:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint p = [gestureRecognizer locationInView:collectView];
        NSIndexPath *indexPath = [collectView indexPathForItemAtPoint:p];
        
        NSLog(@"long press on table view at row%d-- %d",indexPath.section, indexPath.row);
        if (![_XmlArray[indexPath.row][@"role"][@"id"] isKindOfClass:[NSNull class]]) {
             [[NSUserDefaults standardUserDefaults] setObject: _XmlArray[indexPath.row][@"role"][@"id"] forKey:@"modifyroleid"];
        }
       
        if (indexPath.row>=0) {
            UIAlertController *controller =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleAlert];
            
            UIAlertAction *remove=[UIAlertAction actionWithTitle:@"删除角色" style:0 handler:^(UIAlertAction * _Nonnull action) {
                [self removeRole];
            }];
            UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:0 handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            

            
            [controller addAction:remove];
            [controller addAction:cancel];
//            NSLog(@"点击删除按钮---");
            
            [self presentViewController:controller animated:YES completion:nil];
            
        }
        if (indexPath.row==0) {
            UIAlertController *controller =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleAlert];
            
            UIAlertAction *remove=[UIAlertAction actionWithTitle:@"删除角色" style:0 handler:^(UIAlertAction * _Nonnull action) {
                [self removeRole];
            }];
            UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:0 handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            
            
            [controller addAction:remove];
            [controller addAction:cancel];
            //            NSLog(@"点击删除按钮---");
            
            [self presentViewController:controller animated:YES completion:nil];
        }
        return;
    }
    
}

- (void)removeRole{

//    NSLog(@"%@__",MODIFYROLEID);
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10209\",\"roleid\":\"%@\"}",MODIFYROLEID];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    NSLog(@"dict======%@",dict);
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        if  ([[dictt objectForKey:@"SS"] integerValue]==200) {
//            NSLog(@"这是删除操作----%@",MODIFYROLEID);
            [self requestShowData];
            [SVProgressHUD showWithStatus:[dictt objectForKey:@"MSG"]];
            // GCD
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 移除遮盖
                [SVProgressHUD dismiss];
                
            });

            [collectView reloadData];
        }else {
        [SVProgressHUD showWithStatus:[dictt objectForKey:@"MSG"]];
            // GCD
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 移除遮盖
                [SVProgressHUD dismiss];
                
            });
        }
        
    };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
