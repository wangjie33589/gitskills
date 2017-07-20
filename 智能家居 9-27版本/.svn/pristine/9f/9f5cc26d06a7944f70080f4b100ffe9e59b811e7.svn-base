//
//  TypeViewController.m
//  SyncSmartHome
//
//  Created by SciyonSoft_WangJie on 16/5/9.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "TypeViewController.h"
#import "CollectionViewCell.h"
#import "TypeDetilViewController.h"

@interface TypeViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>{
    UICollectionView * collectView;
    NSMutableArray *_TypeArray;


    

}

@end

@implementation TypeViewController
-(id)initWithArray:(NSArray *)aRR{

    self =[super init];
    if (self) {
          //_showArray =[NSMuta 9bleArray array];
        //_showArray=[NSMutableArray arrayWithArray:aRR];
    
       
    
    }
    return self;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
   // _TypeArray =[NSMutableArray array];
    [self requestForType];

 
   
}
-(void)initCollectionView{
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
    layout.itemSize=CGSizeMake(120,150);
//    layout.sectionInset=UIEdgeInsetsMake(0,(LWidth-240)/2-10,3, ( LWidth-240)/2-10);
//    layout.minimumLineSpacing=5;
//
    //上左下右
    layout.sectionInset=UIEdgeInsetsMake(20,(LWidth-240)/4, 200,(LWidth-240)/4);
    layout.minimumLineSpacing=10;
    collectView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, LWidth, LHeight) collectionViewLayout:layout];
    collectView.backgroundColor=[UIColor whiteColor];
    collectView.delegate=self;
    collectView.dataSource=self;
    //collectView.scrollEnabled=NO;
    //_showArray=[[NSArray alloc]initWithObjects:@"电视",@"空调",@"冰箱",@"监控",@"洗衣机",@"添加", nil];
    [collectView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        [self.view addSubview:collectView];
    







}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   return _TypeArray.count+1;
   // return 3;


}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

  CollectionViewCell *cell =[collectionView  dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageView.layer.cornerRadius=cell.imageView.frame.size.height/2;
    cell.imageView.layer.masksToBounds=YES;
    cell.backgroundColor=[UIColor whiteColor];
    //if (indexPath.row<_TypeArray.count) {
        if (indexPath.row==0) {
            cell.label.text=_TypeArray[indexPath.row][@"typename"];
            cell.imageView.image=[UIImage imageNamed:@"twopancel"];
        }
        else if (indexPath.row==1){
            cell.label.text=_TypeArray[indexPath.row][@"typename"];
            cell.imageView.image=[UIImage imageNamed:@"twopancel"];
        }
        else if (indexPath.row==2){
            cell.label.text=_TypeArray[indexPath.row][@"typename"];
            cell.imageView.image=[UIImage imageNamed:@"twopancel"];
        } else if (indexPath.row==3){
            cell.label.text=_TypeArray[indexPath.row][@"typename"];
            cell.imageView.image=[UIImage imageNamed:@"twopancel"];
        } else if (indexPath.row==4){
            cell.label.text=_TypeArray[indexPath.row][@"typename"];
            cell.imageView.image=[UIImage imageNamed:@"Six"];
        }
        else{
        cell.label.text=@"未识别类型";
        cell.imageView.image=[UIImage imageNamed:@"Unrecognized"];
    }
     return cell;






}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row<_TypeArray.count) {
        TypeDetilViewController *vc =[[TypeDetilViewController alloc]initWithDic:_TypeArray[indexPath.row]];
                vc.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:vc animated:YES];
        
    
        
        
    }else{
        NSDictionary  *dict =[NSDictionary dictionaryWithObjectsAndKeys:@"",@"id", nil];
        
                TypeDetilViewController *vc =[[TypeDetilViewController alloc]initWithDic:dict];
                vc.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:vc animated:YES];
    
    }

    
}
//获取类型列表
-(void)requestForType{
    
      NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
      NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10406\",\"serverid\":\"%@\"}",SERVERID];
       NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
       MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
        manager.backSuccess = ^void(NSDictionary *dictt)
    {
        //[SVProgressHUD dismiss];
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            _TypeArray=dictt[@"DATA"];
          NSLog(@"_TypeArray====%@",_TypeArray);
            
            
            [self initCollectionView];
        }else{
                 [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
            
        }
    };
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
