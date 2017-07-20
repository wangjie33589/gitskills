//
//  modifyRowViewController.m
//  SyncSmartHome
//
//  Created by sciyonSoft on 16/6/12.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//



#import "KYuser_manger_ViewController.h"
#import "modifyRowViewController.h"
#import "ShareUserCell.h"
@interface modifyRowViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>{
    

    NSArray *_showArray;
    NSMutableArray *_XmlArray;
    NSDictionary *_XmDIc;
    NSMutableArray *rolenameArray;
    
    NSDictionary *_showDic;
    NSMutableArray *_imageArray;
    UIView *_Comments;
    UIView *_renameView;
    UITableView * shaerTable;
    NSMutableArray *_isChoiceArray;

}

@end
@implementation modifyRowViewController


-(instancetype)initWithDic:(NSDictionary *)aDic{
    self =[super init];
    if (self) {
        _showDic=aDic;
        
    }
    return self;
}

- (id)initWithUserRoleIds:(NSString *)roleIds{
    self = [super init];
    if (self) {
        _roleIds = roleIds;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=YES;
    self.title=@"修改用户";
    self.imageView.userInteractionEnabled = YES;

    self.imageView.  layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 40;
    rolenameArray=[NSMutableArray array];
    self.fristFiled.returnKeyType=UIReturnKeyDone;
    
    self.thirdField.returnKeyType=UIReturnKeyDone;
    
    self.fristFiled.delegate=self;
    
    self.thirdField.delegate=self;
    
    self.secondFiled.font = [UIFont systemFontOfSize:14];
    _zeroField.text = CURRENTUSERCODE;
    _fristFiled.text = REVISENAME;
    _thirdField.text =USERPHONE;
    _secondFiled.text =_roleIds;
    NSLog(@"_roleIds---%@",_roleIds);
    
    [self requestrole];
    
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    
}





- (IBAction)addBtn:(UIButton *)sender {
    
    [self ShareSence];
}

- (void)requestrole{
    
     _isChoiceArray=[NSMutableArray array];
    
        NSLog(@"%@-----888888",SERVERID);
     NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
        NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10204\",\"serverid\":\"%@\"}",SERVERID];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    NSLog(@"dict======%@",dict);
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
        manager.backSuccess = ^void(NSDictionary *dictt)
       {
           
            NSLog(@"角色名====%@",dictt[@"DATA"][1][@"role"][@"rolename"]);
           
           if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
                   _XmlArray = [[NSMutableArray alloc]init];
             _XmlArray=dictt[@"DATA"];
               for (int i=0; i<_XmlArray.count; i++) {
                    [rolenameArray addObject:_XmlArray[i][@"role"][@"rolename"]];
                   
               }
               for (int i=0; i<_XmlArray.count; i++) {
                   [_isChoiceArray addObject:@"0"];
                   
               }
           }
       };
    

}


- (void)rightBtnClick{
    
    if ([_fristFiled.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"昵称不能为空"];
        return;
    }
    if ([_secondFiled.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"角色不能为空"];
        return;
    }
    if ([_thirdField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
        return;
    }
    NSLog(@"--%@--%@--%@--%@--%@--%@",_zeroField.text,_fristFiled.text,SELIDSTRING,_thirdField.text,ROLEID,SERVERID);
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10203\",\"usercode\":\"%@\",\"username\":\"%@\",\"id\":\"%@\",\"phonenumber\":\"%@\",\"roleid\":\"%@\",\"serverid\":\"%@\"}",_zeroField.text,_fristFiled.text,USERIDS,_thirdField.text,SELIDSTRING,SERVERID];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    NSLog(@"dict======%@",dict);
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {

        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            
            [SVProgressHUD showWithStatus:[dictt objectForKey:@"MSG"]];
            // GCD
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 移除遮盖
                [SVProgressHUD dismiss];
                
            });
            [self.navigationController popViewControllerAnimated:YES];
        }else{
        
            [SVProgressHUD showWithStatus:[dictt objectForKey:@"MSG"]];
            // GCD
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 移除遮盖
                [SVProgressHUD dismiss];
              
            });
        }
        
    };
     
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}

//添加新建新场景
-(void)ShareSence{
    _Comments = [[UIView alloc] init];
    _Comments.frame = CGRectMake(0, 0, LWidth, LHeight);
    _Comments.backgroundColor = [UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:0.3];
    [self.view addSubview:_Comments];
    [self.view bringSubviewToFront:_Comments];
    
    _renameView =[[UIView alloc]init];
    _renameView.frame=CGRectMake((LWidth-300)/2, 20, 300,420);
    _renameView.backgroundColor=[UIColor whiteColor];
    [_Comments addSubview:_renameView];
    //标题label
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _renameView.frame.size.width, 30)];
    label.text=@"角色列表";
    label.backgroundColor=[CommonTool colorWithHexString:@"1E90FF"];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:16];
    label.textColor=[UIColor whiteColor];
    [_renameView addSubview:label];
    
    shaerTable =[[UITableView alloc]initWithFrame:CGRectMake(0, 30, _renameView.frame.size.width, 420-30-50) style:UITableViewStylePlain];
    shaerTable.delegate=self;
    shaerTable.dataSource=self;
    [shaerTable registerNib:[UINib nibWithNibName:@"ShareUserCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [_renameView addSubview:shaerTable];
    
    
    //确定按钮
    UIButton  *confirmBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame=CGRectMake(5, _renameView.frame.size.height-50, 140, 40);
    confirmBtn.backgroundColor=[CommonTool colorWithHexString:@"1E90FF"];
    confirmBtn.layer.cornerRadius=8;
    [confirmBtn setTitle:@"确  定" forState:0];
    [confirmBtn setTintColor:[UIColor whiteColor]];
    confirmBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    confirmBtn.layer.masksToBounds=YES;
    confirmBtn.tag=1;
    [confirmBtn addTarget:self action:@selector(ShareConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [_renameView addSubview:confirmBtn];
    //确定按钮
    UIButton  *cancelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame=CGRectMake(150, _renameView.frame.size.height-50, 140, 40);
    cancelBtn.backgroundColor=[CommonTool colorWithHexString:@"1E90FF"];
    cancelBtn.layer.cornerRadius=8;
    [cancelBtn setTitle:@"取  消" forState:0];
    [cancelBtn setTintColor:[UIColor whiteColor]];
    cancelBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    
    cancelBtn.layer.masksToBounds=YES;
    cancelBtn.tag=1;
    [cancelBtn addTarget:self action:@selector(cancelBtnCLICK) forControlEvents:UIControlEventTouchUpInside];
    
    [_renameView addSubview:cancelBtn];
    
    
    
}

//取消
-(void)cancelBtnCLICK{
    [_Comments removeFromSuperview];
    
}
//保存
-(void)ShareConfirmBtn{
    
    NSLog(@"确定-----");
    NSMutableArray *selidArray =[NSMutableArray array];
    NSMutableArray *selnameArray =[NSMutableArray array];
    for (int i=0; i<_XmlArray.count; i++) {
        
        if ([_isChoiceArray[i] isEqualToString:@"1"]) {
            [selidArray addObject:_XmlArray[i][@"role"][@"id"]];
            [selnameArray addObject:_XmlArray[i][@"role"][@"rolename"]];
        }
        
    }
    
    NSString *selidstring=[selidArray componentsJoinedByString:@","];
    NSString *selnamestring=[selnameArray componentsJoinedByString:@","];
    [[NSUserDefaults standardUserDefaults] setObject:selidstring forKey:@"selidstring"];
    
    self.secondFiled.text =selnamestring;
    NSLog(@"selidstring-----%@,selnamestring--------%@",selidstring,selnamestring);
    [_Comments removeFromSuperview];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return rolenameArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShareUserCell *cell =[tableView  dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.label.text =rolenameArray[indexPath.row];
    
    //    cell.textLabel.text=rolenameArray[indexPath.row];
    if ([_isChoiceArray[indexPath.row] isEqualToString:@"1"]) {
        
        cell.imView.image=[UIImage imageNamed:@"checkbox_on"];
        
    }else{
        cell.imView.image=[UIImage imageNamed:@"checkbox_off"];
        
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShareUserCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([_isChoiceArray[indexPath.row] isEqualToString:@"0"]) {
        [_isChoiceArray setObject:@"1" atIndexedSubscript:indexPath.row];
        cell.imView.image=[UIImage imageNamed:@"checkbox_on"];
        
        
    }else{
        [_isChoiceArray setObject:@"0" atIndexedSubscript:indexPath.row];
        cell.imView.image=[UIImage imageNamed:@"checkbox_off"];
        
        
        
    }
    
    NSLog(@"-----");
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    _roleIds=@"";
}
@end
