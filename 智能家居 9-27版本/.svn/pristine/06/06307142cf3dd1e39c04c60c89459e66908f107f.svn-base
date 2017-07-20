//
//  typeallocVC.m
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/6/25.
//
//

#import "typeallocVC.h"
#import "LiuXSlider.h"
#import "progressCell.h"
#import "switchCell.h"


@interface typeallocVC ()<UITableViewDelegate,UITableViewDataSource>{


    NSMutableArray *_numberArray;
    
    NSArray *_showArray;
   NSDictionary *_fromDic;
    NSArray *_UIArray;
    NSMutableArray *_newUIArray;
}

@end

@implementation typeallocVC
-(id)initWithArray:(NSArray*)aArray WithADic:(NSDictionary *)dic{
    self=[super init];
    if (self) {
        _showArray=aArray;
        NSLog(@"fromArray=======%@",_showArray);
        
        
        _fromDic=dic;

    }

    return self;


}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTable.dataSource=self;
    self.myTable.delegate=self;

    self.title=@"编辑";
    _newUIArray=[NSMutableArray array];
    [self.myTable registerNib:[UINib nibWithNibName:@"switchCell" bundle:nil] forCellReuseIdentifier:@"scell"];
    [self.myTable registerNib:[UINib nibWithNibName:@"progressCell" bundle:nil] forCellReuseIdentifier:@"pcell"];
//    _numberArray =[[NSMutableArray alloc]initWithCapacity:0];
//    for (int i=0; i<101; i++) {
//        [_numberArray addObject:[NSString stringWithFormat:@"%d",i]];
//    }
//       //_showArray[i+2]
//    for (int i=0; i<5; i++) {
//        LiuXSlider *slider=[[LiuXSlider alloc] initWithFrame:CGRectMake(100, i*50, LWidth-100, 50) titles:_numberArray firstAndLastTitles:@[@"0",@"100"] defaultIndex:[_showArray[i+2][@"value"]intValue] sliderImage:[UIImage imageNamed:@"logo_loading_1"]];
    [self requestToGetUIInfo];
//        slider.tag=i;
//        slider.block=^(int index){
//            NSLog(@"当前index==%d===%d",index,i);
//            [self requestWithValue:index withValue:i];
//        };
//       
//    }
//

    self.title=@"编辑";
    [self requestToGetValue];
    [self.myTable registerNib:[UINib nibWithNibName:@"switchCell" bundle:nil] forCellReuseIdentifier:@"scell"];
    [self.myTable registerNib:[UINib nibWithNibName:@"progressCell" bundle:nil] forCellReuseIdentifier:@"pcell"];
//    [self requestToGetUIInfo];
//    [self requestToGetValue];
    
    
    

}
#pragma UItableViewDatasource UItableViewDelgete

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return  _newUIArray.count;


}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if ([_newUIArray[indexPath.row][@"typecode"] isEqualToString:@"3"]) {
        switchCell *cell =[tableView dequeueReusableCellWithIdentifier:@"scell"];
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        cell.label.text = [NSString stringWithFormat:@"%@:",_newUIArray[indexPath.row][@"name"]];
        [cell.slider addTarget:self action:@selector(Switch:) forControlEvents:UIControlEventValueChanged];
        cell.label.tag=indexPath.row+100;
          for ( int i=0;i<_showArray.count; i++) {
    if ([_showArray[i][@"addr"] isEqualToString:_newUIArray[indexPath.row][@"addr"]]){
               [_showArray[i][@"value"]integerValue];
                
                
            }
            
            
        }
        cell.slider.tag=indexPath.row;
        
        
        
        return cell;
        
    }else if ([_newUIArray[indexPath.row][@"typecode"] isEqualToString:@"4"]){
    
        progressCell *cell =[tableView dequeueReusableCellWithIdentifier:@"pcell"];
        cell.firstLabel.text=[NSString stringWithFormat:@"%@:",_newUIArray[indexPath.row][@"name"]];
        
        for ( int i=0;i<_showArray.count; i++) {
            
            
            if ([_showArray[i][@"addr"] isEqualToString:_newUIArray[indexPath.row][@"addr"]]){
                cell.slider.value=[_showArray[i][@"value"]integerValue];
                [cell.slider addTarget:self action:@selector(slider:) forControlEvents:UIControlEventTouchUpInside];
                
                
                
             }
        }

        

//        cell.slider.minimumValue=[_showArray[indexPath.row][@"value"]floatValue];
//        cell.slider.maximumValue=[_showArray[indexPath.row][@"value"]floatValue];
        cell.slider.minimumValue=0;
        cell.slider.maximumValue=100;


        cell.slider.tag=indexPath.row;
        cell.secondlab.tag=indexPath.row+100;
       
        cell.secondlab.text=[NSString stringWithFormat:@"%.0f",cell.slider.value];
        
        return cell;
    
    
    }else{
        return nil;
    
    
    }
    
    
}
-(void)Switch:(UISwitch*)sender{
    
    
    NSInteger index;
    if (sender.isOn) {
        index=1;
    }else{
    
        index=0;
    }


    [self requestWithValue:index  withValue:sender.tag];



}
-(void)slider:(UISlider*)slider{
    
    UILabel *label =[self.view viewWithTag:slider.tag+100];

//    label.text=[NSString stringWithFormat:@"%@:",_newUIArray[slider.tag][@"name"]];
    label.text=[NSString stringWithFormat:@"%.0f",slider.value];
    

    [self requestWithValue:slider.value withValue:slider.tag];


}
//请求获得UI界面数据
-(void)requestToGetUIInfo{
    
       NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10401\",\"typeid\":\"%@\",\"actuserid\":\"%@\"}",_fromDic[@"typeid"],USER_ID];
    
    NSLog(@"urlstring====%@",urlstring);
    
    

    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        //[SVProgressHUD dismiss];
        
        if ( [[dictt objectForKey:@"SS"] integerValue]==200) {
            _UIArray=dictt[@"DATA"];
            //NSLog(@"_AreaArray====%@",_AreaArray);
            for (int i =0;i<_UIArray.count;i++) {
                
                if ([_UIArray[i][@"typecode"]intValue]==3||[_UIArray[i][@"typecode"]intValue]==4) {
                    
                    [_newUIArray addObject:_UIArray[i]];
                    
                    
                }
                
              }
                 NSLog(@"newUIArray====%@",_newUIArray);
             [self.myTable reloadData];
            
 
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
            
        }
    };
    
    
}
//请求获得Value
-(void)requestToGetValue{
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10400\",\"deviceid\":\"%@\",\"actuserid\":\"%@\"}",_fromDic[@"id"],USER_ID];
    
    NSLog(@"urlstring====%@",urlstring);
    
    
    
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        //[SVProgressHUD dismiss];
        
        if ( [[dictt objectForKey:@"SS"] integerValue]==200) {
            _UIArray=dictt[@"DATA"];
            //NSLog(@"_AreaArray====%@",_AreaArray);
            for (int i =0;i<_UIArray.count;i++) {
                
                if ([_UIArray[i][@"typecode"]intValue]==3||[_UIArray[i][@"typecode"]intValue]==4) {
                    
                    [_newUIArray addObject:_UIArray[i]];
                   
                }
               
            }
            
            NSLog(@"newUIArray====%@",_newUIArray);
            
            [self.myTable reloadData];
      
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
        
            
        }
    };
    
    
}

//对参数进行操控调节
-(void)requestWithValue:(NSInteger)index withValue:(NSInteger)i{
    if (i>=_newUIArray.count||i>=_showArray.count) {
        return;
    }
     NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10415\",\"addr\":\"%@\",\"value\":\"%d\",\"deviceid\":\"%@\",\"actuserid\":\"%@\"}",_newUIArray[i][@"addr"],index,_showArray[i][@"deviceid"],USER_ID];
      NSLog(@"urlstring======%@",urlstring);
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            //_AreaArray=dictt[@"DATA"];
            [SVProgressHUD showSuccessWithStatus:[dictt objectForKey:@"MSG"]];
          
            //[self.myTable reloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
  
}


@end
