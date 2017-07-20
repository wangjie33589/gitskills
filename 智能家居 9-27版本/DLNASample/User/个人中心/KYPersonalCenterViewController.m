//
//  KYPersonalCenterViewController.m
//  SmartHome
//
//  Created by sciyonSoft on 16/7/11.
//
//

#import "KYPersonalCenterViewController.h"
#import "KYPersonalCenterViewCell.h"
#import "KYRevisePwdViewController.h"
#import "KYBindPhoneViewController.h"
#import "KYBindWeCharViewController.h"
#import "KYBindUserNameViewController.h"
#import "KYQuestionViewController.h"
#import "KYResetQuestionViewController.h"
@interface KYPersonalCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    NSMutableArray *_TypeArray;
    NSMutableDictionary *_TypeDic;
    NSMutableDictionary *_myDic;
    NSMutableArray *_myArray;
    
    
}
@property (strong, nonatomic) IBOutlet UITableView *myTable;

@end

@implementation KYPersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"个人中心";
    self.tabBarController.tabBar.hidden = YES;
    self.myTable.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initTableview];
    
    if (![_myDic[@"id"] isEqualToString:USER_ID]) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"accredquestion"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"accredreply"];
    }
    
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //seconds  设置响应时间
    lpgr.delegate = self;
    [_myTable addGestureRecognizer:lpgr]; //启用长按事件
    // Do any additional setup after loading the view from its nib.
}

- (void)initTableview{
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    self.myTable.rowHeight=50;
    self.myTable.scrollEnabled=NO;
    [self.myTable registerNib:[UINib nibWithNibName:@"KYPersonalCenterViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    [self requestShowData];
    [self.myTable reloadData];
}

//获取登录用户信息
- (void)requestShowData{
     NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10214\",\"userid\":\"%@\",\"serverid\":\"%@\"}",USER_ID,SERVERID];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            _myDic=dictt[@"DATA"];
            [[NSUserDefaults standardUserDefaults] setObject:_myDic[@"usercode"] forKey:@"usercode"];
            [[NSUserDefaults standardUserDefaults] setObject:_myDic[@"username"] forKey:@"username"];
            
            if (![_myDic[@"phonenumber"] isKindOfClass:[NSNull class]]) {
                [[NSUserDefaults standardUserDefaults] setObject:_myDic[@"phonenumber"] forKey:@"phonenumber"];
            }
            
            if (![_myDic[@"wechat"] isKindOfClass:[NSNull class]]) {
                [[NSUserDefaults standardUserDefaults] setObject:_myDic[@"wechat"] forKey:@"wechat"];
                NSLog(@"wechat---%@",_myDic[@"wechat"]);
            }
            
            if (![_myDic[@"accredquestion"] isKindOfClass:[NSNull class]]) {
                [[NSUserDefaults standardUserDefaults] setObject:_myDic[@"accredquestion"] forKey:@"accredquestion"];
            }
            if (![_myDic[@"accredreply"] isKindOfClass:[NSNull class]]) {
                [[NSUserDefaults standardUserDefaults] setObject:_myDic[@"accredreply"] forKey:@"accredreply"];
            }
            [self.myTable reloadData];
            
        }
    };

}


 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
        
        return 5;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KYPersonalCenterViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row ==0) {
        cell.lab1.text = @"修改密码";
        [cell.image1 setImage:[UIImage imageNamed:@"person_pwd"]];
    } if (indexPath.row ==1) {
        if ([_myDic[@"phonenumber"] isEqualToString:@""]||[_myDic[@"phonenumber"] isKindOfClass:[NSNull class]]){
//            if ()         {
            cell.lab2.text = @"未绑定";
        }else{
            cell.lab2.text = _myDic[@"phonenumber"];
        }
        cell.lab1.text = @"绑定手机号";
        [cell.image1 setImage:[UIImage imageNamed:@"person_phone"]];
     
    } if (indexPath.row ==2) {
        if ([_myDic[@"wechat"] isKindOfClass:[NSNull class]]||[_myDic[@"wechat"] isEqualToString:@""])
        {
            cell.lab2.text = @"未绑定";
        }else {
             cell.lab2.text =_myDic[@"wechat"];
        }
        cell.lab1.text = @"绑定微信号";
        [cell.image1 setImage:[UIImage imageNamed:@"person_wechat"]];
    }if (indexPath.row ==4) {
        if ([_myDic[@"username"] isKindOfClass:[NSNull class]]||[_myDic[@"username"] isEqualToString:@""])
        {
            cell.lab2.text = @"未绑定";
        }else{
            cell.lab2.text = _myDic[@"username"];
        }
        cell.lab1.text =@"昵称";
        [cell.image1 setImage:[UIImage imageNamed:@"person_name"]];
    }if (indexPath.row==3) {
        if ([_myDic[@"accredquestion"] isKindOfClass:[NSNull class]]||[_myDic[@"accredquestion"] isEqualToString:@""])
        {
            cell.lab2.text = @"未设置";
        }else{
            cell.lab2.text =@"已绑定";
        }
        cell.lab1.text = @"认证问题";
        [cell.image1 setImage:[UIImage imageNamed:@"person_bind"]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KYPersonalCenterViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row ==0 ) {
        
        
        KYRevisePwdViewController *vc = [[KYRevisePwdViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row ==1) {
        KYBindPhoneViewController *vc1 = [[KYBindPhoneViewController alloc]init];
        [self.navigationController pushViewController:vc1 animated:YES];
        
    }else if (indexPath.row==2){
        KYBindWeCharViewController *vc2 = [[KYBindWeCharViewController alloc]init];
        [self.navigationController pushViewController:vc2 animated:YES];
    }else if (indexPath.row ==4){
        
        KYBindUserNameViewController *vc4 = [[KYBindUserNameViewController alloc]init];
        [self.navigationController pushViewController:vc4 animated:YES];
      
    }else if (indexPath.row ==3){
        if (ACCREDQUESTION==nil&&ACCREDREPLY==nil) {
            KYQuestionViewController *vc3 =[[KYQuestionViewController alloc]init];
            [self.navigationController pushViewController:vc3 animated:YES];
        }else
        {
            [SVProgressHUD showSuccessWithStatus:@"已绑定，长按可修改！"];
    }
}
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer  //长按响应函数
{

    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
        
        
    {
        KYResetQuestionViewController *vc3 =[[KYResetQuestionViewController alloc]init];
        [self.navigationController pushViewController:vc3 animated:YES];
    }   

    
}


@end
