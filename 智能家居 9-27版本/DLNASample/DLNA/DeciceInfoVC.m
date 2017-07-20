//
//  DeciceInfoVC.m
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/6/22.
//
//

#import "DeciceInfoVC.h"

@interface DeciceInfoVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_showArray;
}




@end

@implementation DeciceInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
}


-(void)initTableView{
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
  
    

}
#pragma mark ===TableViewDataSource TableViewDelegte
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return section==0?_showArray.count:2;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
  
    return cell;


}




@end
