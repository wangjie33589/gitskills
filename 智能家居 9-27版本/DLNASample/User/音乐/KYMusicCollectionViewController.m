//
//  KYMusicCollectionViewController.m
//  SyncSmartHome
//
//  Created by sciyonSoft on 16/5/6.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "KYMusicCollectionViewController.h"
#import "ShareMusicVC.h"
#import "colloctMusicVC.h"
@interface KYMusicCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation KYMusicCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"音乐";
    self.tabBarController.tabBar.hidden=YES;
    [self initTableViwew];
    

}
-(void)initTableViwew{
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    self.myTable.rowHeight=30;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIder =@"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIder];
    if (!cell) {
        
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIder];
           }
    cell.imageView.image=[UIImage imageNamed:@"分享.png"];
    
    NSArray *arr =[[NSArray alloc]initWithObjects:@"共享的音乐", @"收藏的音乐",nil];
    cell.textLabel.text=arr[indexPath.row];


    return cell;


}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        ShareMusicVC  *vc =[[ShareMusicVC alloc]init];
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController: vc animated:YES];
    }else{
    
        colloctMusicVC*vc =[[colloctMusicVC alloc]init];
              self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    
    }



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)back{
    
    [self.navigationController dismissViewControllerAnimated:NO completion:^{
        
    }];
}


@end
