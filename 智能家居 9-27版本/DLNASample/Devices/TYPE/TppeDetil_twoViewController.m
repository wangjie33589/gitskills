//
//  TppeDetil_twoViewController.m
//  SyncSmartHome
//
//  Created by SciyonSoft_WangJie on 16/5/10.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "TppeDetil_twoViewController.h"
#import "TypeRegiterInfoVC.h"
#import "typeallocVC.h"
#import "MBProgressHUD+MJ.h"
#import "pancelCollectviewCell.h"
#import "TypeViewdetilelVC.h"

@interface TppeDetil_twoViewController ()<
UIPopoverPresentationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>{
    NSDictionary *_fromDic;
    BOOL flag[2];
    UIImageView *RightImgView;

    UIImageView *leftImgView;
    NSArray *_showArray;
    int VALUE;
    UICollectionView * collectView;
    
    NSMutableArray *_pancelArray;
    NSMutableArray *_registerArray;
    NSMutableArray *_numberArray;
    NSArray * _listTableArray;
    UITableView * _listTableView;
    BOOL  hiden;
    NSTimer *_timer;
     UIView * _Comments;
    NSArray *_fromArray;
    
    NSString *str2;//接受上个界面传过来的数据
    
}
@property (nonatomic, strong) DropdownMenuController *popoVerMenu;
@property (nonatomic, strong) NSDictionary *dataDic;


@end

@implementation TppeDetil_twoViewController
-(id)initWithDic:(NSDictionary*)aDic andArr:(NSArray *)array{
    
    self =[super init];
    if (self) {
        _fromDic =aDic;
        _fromArray=array;
             
    }
    
    return self;
}
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [_timer invalidate];
    _timer=nil;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestShowData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设备面板";
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    _pancelArray =[NSMutableArray array];
    _registerArray=[NSMutableArray array];
    _numberArray=[NSMutableArray array];
    _timer =[NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(second_500ms) userInfo:nil repeats:YES];
   
    //[self  requestShowData];
    [self initCollectionView];
    [self initListTableView];
     UIBarButtonItem *addBarBtn =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_5_n"] style:UIBarButtonItemStylePlain target:self action:@selector(addbarBtnClick)];
    self.navigationItem.rightBarButtonItem=addBarBtn;
    
}

- (void)sendTrendDatas:(NSString *)datas{
    NSLog(@"传过来的数据---%@",datas);
    str2 = [NSString stringWithFormat:@"%@",datas];
}

//
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //NSSet * 类似于数组  touches 屏幕中点的集合
    
    UITouch *touch  = [touches anyObject];
    //locationInView获取所在屏幕中点的位置
    CGPoint point = [touch locationInView:self.view];
    
    //CGPoint point1 = [touch locationInView:];
    if (!CGRectContainsPoint(_listTableView.frame, point))
    {
        [_Comments removeFromSuperview];
        hiden=0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.2];
        _listTableView.frame=CGRectMake(LWidth, 0, 0,0);
        [UIView  commitAnimations];
        
        
        
        
    }
    
    
    
}

-(void)second_500ms{

    [self  requestShowData];
   // [self initCollectionView];
   // [self initListTableView];



}
//下拉框
-(void)addbarBtnClick{
    [self.view addSubview:_Comments];
    [self.view bringSubviewToFront:_Comments];
    hiden=!hiden;
    if (hiden==1) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.2];
        _listTableView.frame=CGRectMake(LWidth-100, 0, 95, _listTableArray.count*44+10);
        [UIView  commitAnimations];}
    else{
        [_Comments removeFromSuperview];

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.2];
        _listTableView.frame=CGRectMake(LWidth, 0, 0,0);
        [UIView  commitAnimations];
    }
    
    
    
    
}


//初始化下来框
-(void)initListTableView{
    _Comments = [[UIView alloc] init];
    _Comments.frame = CGRectMake(0, 0, LWidth, LHeight);
    _Comments.backgroundColor = [UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:0.3];

    _listTableArray =[[NSArray alloc]initWithObjects:@"编辑",@"配置",@"替换",@"查找",@"删除", nil];
    _listTableView=[[UITableView alloc]initWithFrame:CGRectMake(LWidth, 0, 0, 0) style:UITableViewStylePlain];
     //_listTableView.alpha=0;
    [_Comments addSubview:_listTableView];
    _listTableView.dataSource=self;
    _listTableView.delegate=self;
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _listTableView.scrollEnabled = NO;
    _listTableView.backgroundColor =[CommonTool  colorWithHexString:@"1E90FF"];
    [_listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"sycell"];
    hiden=0;
    //    _listTableView.hidden=YES;
    //    _listTableView.hidden=YES;
    
    
}



-(void)initCollectionView{
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
    layout.itemSize=CGSizeMake(150,80);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    //上左下右
    layout.sectionInset=UIEdgeInsetsMake(30,(LWidth-300)/2,LHeight-30-80*3,(LWidth-300)/2);
    layout.minimumLineSpacing=0;
    layout.minimumInteritemSpacing=0;
    collectView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, LWidth, LHeight) collectionViewLayout:layout];
    collectView.backgroundColor=[UIColor clearColor];
    collectView.delegate=self;
    collectView.dataSource=self;
    //_showArray=[[NSArray alloc]initWithObjects:@"电视",@"空调",@"冰箱",@"监控",@"洗衣机",@"添加", nil];
    [collectView registerNib:[UINib nibWithNibName:@"pancelCollectviewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:collectView];
    
    
    
    
    
    
    
    
}
#pragma mark=====tableDelgete tableviewDatasoure
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listTableArray.count;



}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"sycell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
     cell.textLabel.text=_listTableArray[indexPath.row];
    cell.backgroundColor=[CommonTool  colorWithHexString:@"1E90FF"];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
       [_Comments removeFromSuperview];
    hiden=0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    _listTableView.frame=CGRectMake(LWidth, 0, 0,0);
    [UIView  commitAnimations];
    if (indexPath.row==0) {
        TypeRegiterInfoVC *vc =[[TypeRegiterInfoVC alloc]initWithArray:_pancelArray WithDic:_fromDic];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    

 else if (indexPath.row==1){
        typeallocVC *vc =[[typeallocVC alloc]initWithArray:_registerArray WithADic:_fromDic];
        [self.navigationController pushViewController:vc animated:YES];
    
       
    }else if (indexPath.row==2){
        if ([_fromDic[@"status"]integerValue]==0) {
            TypeViewdetilelVC *vc= [[TypeViewdetilelVC alloc]initWithDic:_fromDic andArr:_fromArray];
            [self.navigationController pushViewController:vc animated:YES];

        }else{
            
            UIAlertController  *conter=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"只能替换离线设备" preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [conter addAction:cancel];
            [self presentViewController:conter animated:YES completion:nil];
            
        
        
        
        }
        
    }else if (indexPath.row==3){
        [self requestYoSeek];
    
    
    }else if (indexPath.row==4){
    
        UIAlertController *conter =[UIAlertController alertControllerWithTitle:@"确认" message:@"确认删除该设备？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm =[UIAlertAction actionWithTitle:@"确认" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self requestToDelteDevice];
        }];
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [conter addAction:confirm];
        [conter addAction:cancel];
        [self presentViewController:conter animated:YES completion:nil];
        
    
    
    
    }



}
#pragma mark=====collectviewDataSource CollectViewdelege

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _pancelArray.count;


}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    pancelCollectviewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if ([_pancelArray[indexPath.row][@"value"]integerValue]==0) {
            cell.imview.image= [UIImage imageNamed:@"panel_btn_off"];
        
    }else{
        cell.imview.image= [UIImage imageNamed:@"panel_btn_on"];
    }
       cell.label.text=_pancelArray[indexPath.row][@"name"];
    
    return cell;
    


}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //pancelCollectviewCell *cell =(pancelCollectviewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if ([str2 isEqualToString:@"1"]) {
        [MBProgressHUD showMessage:@"提示:离线设备，不能操作！"];
        // 模拟网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 移除遮盖
            [MBProgressHUD hideHUD];
        });

        

    }else {
    
    if ([_numberArray[indexPath.row]integerValue]==0) {
        [_numberArray setObject:@"1" atIndexedSubscript:indexPath.row];
       // cell.imview.image=[UIImage imageNamed:@"panel_btn_on"];
        [self requestOpertionPanelWith:indexPath.row];
    }else{
        [_numberArray setObject:@"0" atIndexedSubscript:indexPath.row];

        //cell.imview.image=[UIImage imageNamed:@"panel_btn_off"];
        [self requestOpertionPanelWith:indexPath.row];

        
    }
    
    }
   
}
//请求设备相关数据
-(void)requestShowData{
   // _showArray=nil;
  
    
//    NSString *urlstring=[NSString stringWithFormat:@"http://%@/?jsonrequest={\"funcode\":\"10400\",\"deviceid\":\"%@\"}",HTTPIP,_fromDic[@"id"]];
    
   // NSLog(@"urlstring======%@",urlstring);
//    NSString *newurlString=[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10400\",\"deviceid\":\"%@\"}",_fromDic[@"id"]];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            //_AreaArray=dictt[@"DATA"];
            //_showArray=dictt[@"DATA"];
            //NSLog(@"_AreaArray====%@",_AreaArray);
            //[self.myTable reloadData];
            
            [_numberArray removeAllObjects ];
            [_pancelArray removeAllObjects];
            [_registerArray removeAllObjects];
            _showArray=dictt[@"DATA"];
            
            
            for (int i=0; i<_showArray.count; i++) {
                
                if ([_showArray[i][@"type"]integerValue]==1) {
                    
                    [_pancelArray addObject:_showArray[i]];
                    [_numberArray addObject:_showArray[i][@"value"]];
                    
                }else if ([_showArray[i][@"type"]integerValue]==2) {
                    [_registerArray addObject:_showArray[i]];
                
                }
                
                
            }
            
            
            NSLog(@"_pancellarray====%@",_pancelArray);
            NSLog(@"_regidterArry====%@",_registerArray);
            
            [collectView reloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
    
    
}
//对设备开关进行操控
-(void)requestOpertionPanelWith:(int)Type{
//    if (Type>0&&Type<_pancelArray.count) {
//        <#statements#>
//    }
    if (_numberArray.count==0||_pancelArray.count==0) {
        return;
    }
    
    NSDictionary *nowDict;
    int value;
    if (Type<_numberArray.count&&Type<_pancelArray.count) {
       nowDict =_pancelArray[Type];
         value=[_numberArray[Type]integerValue];

    }
 
    
    
    NSLog(@"nowDict====%@",nowDict);
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10414\",\"pointid\":\"%@\",\"deviceid\":\"%@\",\"value\":\"%d\",\"actuserid\":\"%@\"}",nowDict[@"addr"],nowDict[@"deviceid"],value,USER_ID];
    
    
    NSLog(@"urlstrin=[==%@",urlstring);
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        //[SVProgressHUD dismiss];
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            [SVProgressHUD  showSuccessWithStatus:[dictt objectForKey:@"MSG"]];
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
            
        }
    };
    
    
}



//删除设备
-(void)requestToDelteDevice{
    
    //    NSString *urlstring=[NSString stringWithFormat:@"http://%@/?jsonrequest={\"funcode\":\"10400\",\"deviceid\":\"%@\"}",HTTPIP,_fromDic[@"id"]];
    
    // NSLog(@"urlstring======%@",urlstring);
    //    NSString *newurlString=[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10404\",\"deviceid\":\"%@\",\"actuserid\":\"%@\"}",_fromDic[@"id"],USER_ID];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            [SVProgressHUD showSuccessWithStatus:[dictt objectForKey:@"MSG"]];
            [self.navigationController popViewControllerAnimated:YES ];
            //[self requestShowData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
    
    
}
//查找

-(void)requestYoSeek{
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10404\",\"deviceid\":\"%@\",\"actuserid\":\"%@\"}",_fromDic[@"id"],USER_ID];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
{
        [SVProgressHUD dismiss];
        
        if ( [[dictt objectForKey:@"SS"] integerValue]==200) {
            [SVProgressHUD showSuccessWithStatus:[dictt objectForKey:@"MSG"]];
           // [self.navigationController popViewControllerAnimated:YES ];
            //[self requestShowData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
    



}

//删除

-(void)requestYoDete{
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10404\",\"deviceid\":\"%@\",\"actuserid\":\"%@\"}",_fromDic[@"id"],USER_ID];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        
        if ( [[dictt objectForKey:@"SS"] integerValue]==200) {
            [SVProgressHUD showSuccessWithStatus:[dictt objectForKey:@"MSG"]];
            // [self.navigationController popViewControllerAnimated:YES ];
            //[self requestShowData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
    
    
    
    
}

@end
