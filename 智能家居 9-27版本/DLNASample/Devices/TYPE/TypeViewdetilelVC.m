//
//  TypeViewdetilelVC.m
//  SyncSmartHome
//
//  Created by SciyonSoft_WangJie on 16/5/6.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "TypeViewdetilelVC.h"

#import "ShareUserCell.h"

@interface TypeViewdetilelVC ()<UITableViewDelegate,UITableViewDataSource>{

    NSDictionary *_fromDic;
    NSArray *_fromArray;
    NSMutableArray *_numberarray;
    int _currentRow;

}

@end

@implementation TypeViewdetilelVC
-(id)initWithDic:(NSDictionary*)aDic andArr:(NSArray *)array{
    
    self =[super init];
    if (self) {
        _fromDic =aDic;
        _fromArray=array;
        NSLog(@"_Dromndic====%@",_fromDic);
        NSLog(@"_fromDIc===%@",_fromArray);
        

    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"替换设备";
    _currentRow=10086;
    UIBarButtonItem *rightBtn =[[UIBarButtonItem alloc]initWithTitle:@"替换" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    

    [self initTableview];
}
-(void)rightBtnClick{
    if (_currentRow==10086) {
        
        UIAlertController *controller =[UIAlertController alertControllerWithTitle:@"提示" message:@"请选择要替换的新设备" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel  =[UIAlertAction actionWithTitle:@"好的" style:  UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }] ;
        [controller addAction:cancel];
        [self presentViewController:controller animated:YES completion:nil];
        
    }else{
        [self reuqestToReplacceNewDevice];
    
    
    }
}

-(void)initTableview{
    
    self.typeTable .delegate=self;
    self.typeTable.dataSource=self;
    self.itemTable.dataSource=self;
    self.itemTable.delegate=self;
  
    [self.typeTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.itemTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"icell"];
    self.typeTable.separatorColor=[UIColor clearColor];
    self.itemTable.separatorColor=[UIColor  clearColor];
    self.typeTable.rowHeight=60;
          _numberarray =[NSMutableArray array];
    
    for (int i=0; i<_fromArray.count; i++) {
        [_numberarray addObject:@"0"];
  
    }
    
//    [self.itemTable registerNib:[UINib nibWithNibName:@"ShareUserCell" bundle:nil] forCellReuseIdentifier:@"icell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.typeTable) {
        return 1;
        
    }else{
      return _fromArray.count;
    
    
    }
  

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if (tableView==self.typeTable) {
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UIView *view =[[UIView alloc]init];
        UIImageView *imView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        imView.image =[UIImage imageNamed:@"dividing-line.png"];
        cell.backgroundView=view;
        
        cell.textLabel.text=_fromDic[@"typename"];
        cell.textLabel.font=[UIFont systemFontOfSize:16];
        NSLog(@"_fromDic====%@",_fromDic);
        return cell;
        

    }else{
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"icell"];
          cell.selectionStyle=UITableViewCellSelectionStyleNone;

        
        cell.imageView.image=[UIImage imageNamed:@"lamp"];
        cell.textLabel.text=_fromArray[indexPath.row][@"devicename"];
        
        UIImageView *choiceIMG =[[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width-25-10, 10, 25, 25)];
        if ([_numberarray[indexPath.row] isEqualToString:@"0"]) {
            choiceIMG.image =[UIImage imageNamed:@"checkbox_off"];

            
        }else{
               choiceIMG.image =[UIImage imageNamed:@"checkbox_on"];
        
        }
             choiceIMG.tag=indexPath.row+100;
        [cell addSubview:choiceIMG];
        
        
        
        return cell;
    
    
    }
   
  }
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
       if (tableView==self.itemTable){
           _currentRow=indexPath.row;
        [_numberarray removeAllObjects];
        for (int i=0; i<_fromArray.count; i++) {
            [_numberarray addObject:@"0"];
            
        }

    [_numberarray setObject:@"1" atIndexedSubscript:indexPath.row];
    [tableView reloadData];
        
    }

}

//替换新设备
-(void)reuqestToReplacceNewDevice{
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10403\",\"olddeviceid\":\"%@\",\"newdeviceid\":\"%@\",\"oldpointid\":\"%@\",\"newpointid\":\"%@\",\"serverid\":\"%@\",\"actuserid\":\"%@\"}",_fromDic[@"id"],_fromArray[_currentRow][@"id"],_fromDic[@"pointid"],_fromArray[_currentRow][@"pointid"],SERVERID,USER_ID];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        
        if ( [[dictt objectForKey:@"SS"] integerValue]==200) {
            [SVProgressHUD showSuccessWithStatus:[dictt objectForKey:@"MSG"]];
             [self.navigationController popViewControllerAnimated:YES ];
            //[self requestShowData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
    

    





}

@end
