//
//  colloctMusicVC.m
//  SyncSmartHome
//
//  Created by SciyonSoft_WangJie on 16/6/2.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "colloctMusicVC.h"

#import "PLAYViewController.h"

@interface colloctMusicVC ()<UITableViewDataSource,UITableViewDelegate,MyRequestDelegate>

@end

@implementation colloctMusicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"收藏的音乐";
    [self initTableView];
}
-(void)initTableView{

    self.myTable.delegate=self;
    self.myTable.dataSource=self;
    self.myTable.rowHeight=30;


}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
      
    }
    cell.imageView.image=[UIImage imageNamed:@"setting_icon_music.png"];
    cell.textLabel.text=@"音乐播放器";
    
    return cell;



}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    PLAYViewController *VC =[[PLAYViewController alloc]init];
//    
//    [self.navigationController pushViewController:VC animated:YES];

    [self PlAYREQUEST];

}

-(void)PlAYREQUEST{
    MyRequest *manager = [MyRequest requestWithURL:@" 　　＝－"];
    
    //NSLog(@"===%@",newurlString);
    manager.delegate = self;
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        
        
    };




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
