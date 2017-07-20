//
//  home_ViewController.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/4.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "home_ViewController.h"
#import "CollectionViewCell.h"
#import "firstViewController.h"
#import "CheckController.h"
#import "PositionViewController.h"
#import "alertViewController.h"
#import "reportQuiryViewController.h"
#import "repaireViewController.h"
#import "repaireConfirmViewController.h"
#import "analyseViewController.h"
#import "settingViewController.h"
#import "UIImageView+WebCache.h"
#import "MaintainRecondVC.h"
#import "registerViewController.h"

@interface home_ViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>{
    NSArray *_titleArray;
    NSDictionary *_XMLDic;
  NSMutableArray *_XmlArray;
    NSDictionary *_SetDic;
    NSTimer *timer ;
    UICollectionView *collectView;
    NSDictionary *_ceshiDic;
    int BJTXNuumber;
    int BXDJNumber;
    int WBQRNumber;
    int BJTXROW;
    int BXDJROW;
    int WBQRROW;
    
}

@end

@implementation home_ViewController
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [timer invalidate];
    timer=nil;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"功能菜单" ; 
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
    layout.itemSize=CGSizeMake(60, 90);
    layout.sectionInset=UIEdgeInsetsMake(100, LWIDTH/6, LWIDTH/6, LWIDTH/5);
    layout.minimumLineSpacing=LWIDTH/6;
  collectView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, LWIDTH, LHIGHT) collectionViewLayout:layout];
    collectView.backgroundColor=[UIColor clearColor];
    collectView.delegate=self;
    collectView.dataSource=self;
    [collectView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
[self performSelector:@selector(dely) withObject:nil afterDelay:1];
        _XmlArray =[NSMutableArray array];
    _SetDic =[[NSDictionary alloc]initWithObjectsAndKeys:@"系统设置",@"MNAME",@"sysset",@"MRNAME",@"SET",@"APPADDR",nil];
    [_XmlArray addObject:_SetDic];
     [self.view addSubview:collectView];
    
}
-(void)dely{
  [self requestMainInfo];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     [self requestMainInfo];
     timer =[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(second_5) userInfo:nil repeats:YES];
    

}
-(void)second_5{
    NSLog(@"dsfsdf");
    
    [self requestMainInfo];

}
-(void)viewWillDisappear:(BOOL)animated{
    [timer invalidate];

}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _XmlArray.count;

}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    
   CollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.label.textColor=[UIColor whiteColor];
    cell.AlertLab.hidden=YES;
    cell.imageview.image=[UIImage imageNamed:_XmlArray[indexPath.row][@"MRNAME"]];
        NSLog(@"jdsafsgfd===%d===asgdfghasd====ahsfdgjhsdgf===%d===%d",BJTXNuumber,BXDJNumber,WBQRNumber);
    cell.label.font=[UIFont systemFontOfSize:12];
    if ([_XmlArray[indexPath.row][@"APPADDR"] isEqualToString:@"WRcdView"]) {
       
        if (BXDJNumber>0) {
            cell.AlertLab.hidden=NO;
            cell.AlertLab.text=[NSString stringWithFormat:@"%d",BXDJNumber];
        }else{
            cell.AlertLab.hidden=YES;
        
        
        }
        
    }
    if ([_XmlArray[indexPath.row][@"APPADDR"] isEqualToString:@"AlarmView"]) {
        
        if (BJTXNuumber>0) {
            cell.AlertLab.hidden=NO;
            cell.AlertLab.text=[NSString stringWithFormat:@"%d",BJTXNuumber];
        }else{
            cell.AlertLab.hidden=YES;
               }
        
    }
    if ([_XmlArray[indexPath.row][@"APPADDR"] isEqualToString:@"WMSureView"]) {
        
        if (WBQRNumber>0) {
            cell.AlertLab.hidden=NO;
            cell.AlertLab.text=[NSString stringWithFormat:@"%d",WBQRNumber];
        }else{
            cell.AlertLab.hidden=YES;
            
            
        }
        
    }


    
    cell.label.text=_XmlArray[indexPath.row][@"MNAME"];
    
    return cell;


}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([_XmlArray[indexPath.row][@"APPADDR"] isEqualToString:@"DeviceBookView"]||[_XmlArray[indexPath.row][@"APPADDR"] isEqualToString:@"RealWatchView"]||[_XmlArray[indexPath.row][@"APPADDR"] isEqualToString:@"DeviceOpeView"]) {
        CheckController *vc =[[CheckController alloc]initWithADic:_XmlArray[indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([_XmlArray[indexPath.row][@"APPADDR"] isEqualToString:@"DeviceLocationView"]){
        PositionViewController *vc =[[PositionViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
        
    }else if ([_XmlArray[indexPath.row][@"APPADDR"] isEqualToString:@"AlarmView"]){
    
        alertViewController *vc=[[alertViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([_XmlArray[indexPath.row][@"APPADDR"] isEqualToString:@"GdListView"]){
        firstViewController *vc=[[firstViewController alloc]initWithADic:_XmlArray[indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
    
    
    }else if ([_XmlArray[indexPath.row][@"APPADDR"] isEqualToString:@"MaintainView"]){
        repaireViewController *vc =[[repaireViewController alloc]initWithADic:_XmlArray[indexPath.row]withTitle:_XmlArray[indexPath.row][@"MNAME"]];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([_XmlArray[indexPath.row][@"APPADDR"] isEqualToString:@"WRcdView"]){
        MaintainRecondVC *vc =[[MaintainRecondVC alloc]initWithADic:_XmlArray[indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if ([_XmlArray[indexPath.row][@"APPADDR"] isEqualToString:@"WMSureView"]){
        repaireConfirmViewController *vc =[[repaireConfirmViewController alloc]initWithADic:_XmlArray[indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([_XmlArray[indexPath.row][@"APPADDR"] isEqualToString:@"DeviceReportListView"]){
        registerViewController *vc =[[registerViewController alloc]initWithADic:_XmlArray[indexPath.row] ] ;
        [self.navigationController pushViewController:vc animated:YES];
            
    }else if ([_XmlArray[indexPath.row][@"APPADDR"] isEqualToString:@"DeviceReportQueryListView"]){
      reportQuiryViewController *vc =[[reportQuiryViewController alloc]initWithADic:_XmlArray[indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([_XmlArray[indexPath.row][@"APPADDR"] isEqualToString:@"WRcdView"]){
       repaireConfirmViewController *vc =[[repaireConfirmViewController alloc]initWithADic:_XmlArray[indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([_XmlArray[indexPath.row][@"APPADDR"] isEqualToString:@"WMSureView"]){
        repaireViewController *vc =[[repaireViewController alloc]initWithADic:_XmlArray[indexPath.row] withTitle:_XmlArray[indexPath.row][@"MNAME"]];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([_XmlArray[indexPath.row][@"APPADDR"] isEqualToString:@"StatiView"]){
        analyseViewController *vc =[[analyseViewController alloc]initWithADic:_XmlArray[indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([_XmlArray[indexPath.row][@"APPADDR"] isEqualToString:@"SET"]){
       settingViewController *vc =[[settingViewController alloc]initWithADic:_XmlArray[indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
        
    }

    


}

-(void)requestMainInfo{
    
    NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETMODULE</Action><USERID>%@</USERID><PWD>%@</PWD></Data>",USER_NAME,PASSWORD];
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlString];
    manger.backSuccess=^void(NSDictionary *dictt){
        
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            [_XmlArray removeAllObjects];
            _XMLDic=[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            _XmlArray=_XMLDic[@"R"];
            [CommonTool saveCooiker];
            NSLog(@"_xmlArray====%@",_XmlArray);
          
            NSMutableDictionary  *dict =[NSMutableDictionary dictionary];
            
            for (int i =0; i<_XmlArray.count; i++) {
                NSString *string =_XmlArray[i][@"APPADDR"];
                NSString *obj =_XmlArray[i][@"MCODE"];
                
                [dict setObject:obj forKey:string];
                
            }
            
            [self requestBudgeNumberwithMcode:[self returnMcode:@"AlarmView" withdict:dict] withAction:@"GETALCOUNT"];
            [self requestBudgeNumberwithMcode:[self returnMcode:@"WRcdView" withdict:dict] withAction:@"GETRRCOUNT"];
            [self requestBudgeNumberwithMcode:[self returnMcode:@"WMSureView" withdict:dict] withAction:@"GETMRCOUNT"];
            [_XmlArray addObject:_SetDic];

       
            [self initMenu];

          
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
    }
        
       
    };

}


-(void)requestBudgeNumberwithMcode:(NSString*)mcode withAction:(NSString*)action{
    
    
      NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>%@</Action><MCODE>%@</MCODE><USERID>%@</USERID><PWD>%@</PWD><PREDAYS>5</PREDAYS><DID></DID><CNAME></CNAME></Data>",action,mcode,USER_NAME,PASSWORD];
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlString];
    manger.backSuccess=^void(NSDictionary *dictt){
        
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
          
            
            if ([action isEqualToString:@"GETALCOUNT"])BJTXNuumber=[dictt[@"CUSTOMERINFO"]intValue];
                else if ([action isEqualToString:@"GETRRCOUNT"])BXDJNumber=[dictt[@"CUSTOMERINFO"]intValue];
                else if ([action isEqualToString:@"GETMRCOUNT"])WBQRNumber=[dictt[@"CUSTOMERINFO"]intValue];
    
            
            [self initMenu];
        }else{
            
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
        
        
    };
    

}

-(NSString *)returnMcode:(NSString *)appaddr withdict:(NSDictionary*)dict{

    
    NSString *mcode =[dict objectForKey:[NSString stringWithFormat:@"%@",appaddr]];
    
    
    return mcode;





}

-(void)initMenu{
    [collectView reloadData];
   

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
