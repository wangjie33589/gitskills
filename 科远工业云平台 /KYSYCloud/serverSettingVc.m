//
//  serverSettingVc.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/3/17.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "serverSettingVc.h"
#import "LoginVC.h"

@interface serverSettingVc ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *urlArray;
    BOOL isHindin;

    NSMutableArray *newYrlArray;
    NSDictionary * _chatInfoDic;
    NSMutableDictionary *_dict;
}

@end

@implementation serverSettingVc

- (void)viewDidLoad {
    [super viewDidLoad];
    isHindin=YES;

    self.textField.text=HTTPIP;
    [self initlistTableview];
    urlArray=[NSMutableArray array];
    [urlArray addObject:@"http://221.226.212.74:20085/demo"];
    [urlArray addObject:@"http://10.19.12.3:20085/demo"];
    NSSet *set =[NSSet setWithArray:urlArray];
    newYrlArray =[NSMutableArray arrayWithArray:set.allObjects];
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/chatInfo/server.plist"];
    _chatInfoDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
       if (!_chatInfoDic) {
           
           _chatInfoDic =[NSMutableDictionary dictionaryWithObjectsAndKeys:newYrlArray,@"server" ,nil];
    }

    newYrlArray =_chatInfoDic[@"server"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initlistTableview{
    self.listTableView.dataSource=self;
    self.listTableView.delegate=self;
    self.listTableView.hidden=YES;
    self.listTableView.rowHeight=30;
  }

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return  newYrlArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellider =@"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellider];
    if (!cell ) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellider];
    }
      cell.textLabel.text=newYrlArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     self.textField.text=newYrlArray[indexPath.row];
    self.listTableView.hidden=YES;

}

- (IBAction)dropBtn:(UIButton *)sender {
    if (isHindin) {
        [self.listTableView reloadData];
        self.listTableView.hidden=NO;
        [self.view bringSubviewToFront:self.listTableView];
             isHindin=!isHindin;
    }else{
        [self.listTableView reloadData];
        self.listTableView.hidden=YES;
        isHindin=!isHindin;
                NSString *string=self.textField.text;
        [urlArray addObject:string];
        
        NSSet *set =[NSSet setWithArray:urlArray];
        newYrlArray =[NSMutableArray arrayWithArray:set.allObjects];
        _dict =[NSMutableDictionary dictionaryWithObject:newYrlArray forKey:@"server"];
        [self.listTableView reloadData];
        [CommonTool saveChatDic:_dict];
        
        }
 //不能这写，因为这样在一个线程中同时对array进行读写，容易造成数组崩溃。
 }
- (IBAction)OKBtnclick:(UIButton *)sender {
      NSString *string =[self.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        [[NSUserDefaults standardUserDefaults]setObject:string forKey:@"ip"];

        if (self.type==0) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginVC* loginVC = [story instantiateViewControllerWithIdentifier:@"loginVC"];
        APP_WINOW.rootViewController = loginVC;

    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
     }
    
}
@end
