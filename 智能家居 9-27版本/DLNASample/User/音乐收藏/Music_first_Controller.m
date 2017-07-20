//
//  Music_first_Controller.m
//  SyncSmartHome
//
//  Created by SciyonSoft_WangJie on 16/6/13.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "Music_first_Controller.h"
#import "KYMusicCollectionViewController.h"

#import "KYMusicCollectionTableViewController.h"

@interface Music_first_Controller ()

@end

@implementation Music_first_Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    NSArray *arr =[[NSArray alloc]initWithObjects:@"共享的音乐", @"收藏的音乐",nil];
    
    cell.imageView.image=[UIImage imageNamed:@"setup_music.png"];
    cell.textLabel.text=arr[indexPath.row];
    
    // Configure the cell...
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

 KYMusicCollectionTableViewController *vc =[[KYMusicCollectionTableViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}


@end
