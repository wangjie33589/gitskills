//
//  KeepSenceViewController.m
//  SyncSmartHome
//
//  Created by SciyonSoft_WangJie on 16/5/12.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "KeepSenceViewController.h"

#import "TableViewCell.h"

@interface KeepSenceViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *_leftArray;
    NSMutableArray *_rightArray;
    int _currentRow;
    int _leftCurrentRow;
    BOOL isChoice;


}

@end

@implementation KeepSenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"保存场景";
    isChoice=YES;
    self.leftTable.delegate=self;
    self.leftTable.dataSource=self;
    //self.leftTable.rowHeight=50;
    self.rightTable.delegate=self;
    self.rightTable.dataSource=self;
    self.leftTable.tag=0;
    self.rightTable.tag=1;
    [self.leftTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"uicell"];
    [self.rightTable registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"tablecell"];
    _leftArray =[[NSArray alloc]initWithObjects:@"空调", @"照明",@"冰箱",nil];
    _rightArray=[NSMutableArray  array];
    NSArray *arr1=[[NSArray alloc]initWithObjects:@"空调1",@"空调2",@"空调3",
                  @"空调4",nil];
    NSArray *arr2 =[[NSArray alloc]initWithObjects:@"照明1",@"照明2",@"照明3", nil];
    NSArray *arr3 =[[NSArray alloc]initWithObjects:@"冰箱1",@"冰箱2" ,@"冰箱3",nil];
    _currentRow=0;
    
    [_rightArray addObject:arr1];
    [_rightArray addObject:arr2];
    [_rightArray addObject:arr3];
    UIBarButtonItem *barBtn =[[UIBarButtonItem alloc]initWithTitle:@"保存" style: UIBarButtonItemStylePlain target:self action:@selector(keepClick)];
    self.navigationItem.rightBarButtonItem=barBtn;
    
    
}
-(void)keepClick{



}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag==0) {
        return _leftArray.count;
    }else{
        NSArray *array=_rightArray[_currentRow];
    
        return array.count;
    
    }
    

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"uicell"];
    switch (tableView.tag) {
        case 0:
        {
            cell.textLabel.text=_leftArray[indexPath.row];
            return cell;
            
        
        }
            break;
            
        case 1:{
        
            TableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"tablecell"];
            cell.label.text=_rightArray[_currentRow][indexPath.row];
            [cell.button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.button.tag=indexPath.row;
            return cell;
        
        
        
        }break;
    }
    
    
    return cell;
    
    

}
-(void)btnClick:(UIButton*)btn{
    

    _leftCurrentRow=(int)btn.tag;
    isChoice=!isChoice;
    if (isChoice) {
         [btn setImage:[UIImage imageNamed:@"home_write_caogao.png"] forState:0];
    }else{
        [btn setImage:[UIImage imageNamed:@"home_write_caogao_1.png"] forState:0];

   
    }






}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case 0:
        {
            
            _currentRow=(int)indexPath.row;
            NSLog(@"_currrow====%d",_currentRow);

         [self.rightTable reloadData];
        }
            break;
            
        case 1:{
            
        
        
        
        }
    }
   
    


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
