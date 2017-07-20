//
//  RealWatchController.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/3/1.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "RealWatchController.h"
#import "ReanWathcell.h"

@interface RealWatchController ()<UITableViewDataSource,UITableViewDelegate>{
    NSDictionary *_showDic;
    NSDictionary * _XMLDic;
    NSArray *_showArray;
   NSMutableDictionary*_tableViewDic;
    NSMutableArray*_tableViewArray;
    NSArray *_tableTitleArray;
    NSTimer *timer;
    NSDictionary *_PartDic;
    UISegmentedControl*segentment;

}

@end

@implementation RealWatchController
-(id)initWithDic:(NSDictionary *)aDic{
    self=[super init];
    if (self) {
             _showDic=aDic;
        
    }
    return self;


}
-(void)viewDidDisappear:(BOOL)animated{

    [super viewWillAppear:animated];
    [timer invalidate];
    timer=nil;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestControlData];
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    self.myTable.rowHeight=20;
    [self.myTable registerNib:[UINib nibWithNibName:@"ReanWathcell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    timer =[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(second_2) userInfo:nil repeats:YES];
}
-(void)second_2{
    [self requestControlData];
}


-(void)requestControlData{
    NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETDEVICECTLS</Action><USERID>%@</USERID><PWD>%@</PWD><DGUID>%@</DGUID></Data>",USER_NAME,PASSWORD,_showDic[@"DGUID"]];
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlString];
    manger.backSuccess=^void(NSDictionary *dictt){
        
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
           _XMLDic=[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            NSLog(@"ghdsgajgjhdfg=====%@",_XMLDic);
            
            if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
                _PartDic=_XMLDic[@"R"];
                
                [self initSegment];
            }else{
            
                _showArray=_XMLDic[@"R"];
                
                                [self initSegment];
                
                
            }
            
                       }else{
            
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
      };
 }
-(void)initSegment{
    
    
    if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
        
        NSArray *array =[[NSArray alloc]initWithObjects:_PartDic[@"CONTRONAME"], nil];
        //segentment=nil;
    

     
        
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
            //内部代码只会执行一次
        if ( !segentment) {
            segentment =[CommonTool creatSegWithArray:array];

        }
        
        //});

        //[segentment setTitle:_PartDic[@"CONTRONAME"] forSegmentAtIndex:0];
        
              segentment.frame=CGRectMake(10, 64, LWIDTH-20, 30);
        segentment.selectedSegmentIndex=0;
        [segentment addTarget:self action:@selector(changeIndex:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:segentment];
        [self requestTableShowDataWithIndex:(int)segentment.selectedSegmentIndex];
    }else{
        //segentment=nil;
        
        NSMutableArray *itemarray =[NSMutableArray array];
       
        for (int i=0;i<_showArray.count;i++) {
            [itemarray addObject:_showArray[i][@"CONTRONAME"]];
        }
       // static dispatch_once_t onceToken;
       // dispatch_once(&onceToken, ^{
            //内部代码只会执行一次
        if (!segentment) {
            segentment =[CommonTool creatSegWithArray:itemarray];

        }
             // });

        
      
        segentment.frame=CGRectMake(10, 64, LWIDTH-20, 30);
        segentment.selectedSegmentIndex=0;
         [segentment addTarget:self action:@selector(changeIndex:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:segentment];
        [self requestTableShowDataWithIndex:(int)segentment.selectedSegmentIndex];
    
    }
  
 }

-(void)changeIndex:(UISegmentedControl*)seg{
      [self requestTableShowDataWithIndex:(int)seg.selectedSegmentIndex];
 }


-(void)requestTableShowDataWithIndex:(int)index{
  //    [_tableViewDic removeAllObjects];
//    [_tableViewArray removeAllObjects];
    
    NSString *_dguid=nil;
    NSString *_dcguid=nil;
    if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]) {
        _dguid=_PartDic[@"DGUID"];
        _dcguid=_PartDic[@"DCGUID"];

    }else{
        _dguid=_showArray[index][@"DGUID"];
    
   _dcguid=_showArray[index][@"DCGUID"];
        }
    NSString *xmlString=[NSString stringWithFormat:@"<Data><Action>GETREALDATA</Action><USERID>%@</USERID><PWD>%@</PWD><DGUID>%@</DGUID><DCGUID>%@</DCGUID></Data>",USER_NAME,PASSWORD,_dguid,_dcguid];
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SERVER_URL] withString:xmlString];
    manger.backSuccess=^void(NSDictionary *dictt){
        [SVProgressHUD dismiss];
       
        if ((NSObject*)dictt[@"ERROR"]==[NSNull null] ) {
            _tableViewDic=(NSMutableDictionary*)[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            
                _tableViewArray=_tableViewDic[@"R"];
            NSLog(@"asgdfghsdfghjfgs====%@",_tableTitleArray);
                 [self.myTable reloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:dictt[@"ERROR"]];
        }
     };
}


#pragma mark 表代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _tableViewArray.count;


}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReanWathcell *cell =[tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    cell.label.text=[NSString stringWithFormat:@"       %@",_tableViewArray[indexPath.row][@"TAGDESC"]];
    cell.labelTwo.text=_tableViewArray[indexPath.row][@"VALUE"];
    cell.labelTwo.textAlignment=NSTextAlignmentCenter;
    return cell;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
