//
//  addVideoViewController.m
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/8/1.
//
//

#import "addVideoViewController.h"

#import "addVideoCell.h"

@interface addVideoViewController ()<UITableViewDataSource,UITableViewDelegate>{

    NSArray *_titleArray;
    NSArray *_playHoderArray;
    NSString *videotypeid;
    NSDictionary *_fromDic;

}

@end

@implementation addVideoViewController
-(instancetype)initWithADIc:(NSDictionary *)dict{

    self =[super init];
    if (self) {
        _fromDic=dict;
        
        
        
        NSLog(@"_fromDIc======%@",_fromDic);
    }

    return self;


}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加监控设备";
    videotypeid=@"10086";
    NSLog(@"selfType=======%d",self.type);
    
    UIBarButtonItem *rightBtn =[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    _titleArray =[[NSArray alloc]initWithObjects:@"名称:",@"类别:",@"地址IP:",@"端口:",@"用户名:",@"密码:", nil];
    _playHoderArray=[[NSArray alloc]initWithObjects:@"请输入监控名称",@"",@"请输入访问ip",@"请输入访问端口",@"请输入用户名",@"请输入密码",nil];
    [self initTableView];
}
-(void)initTableView{
  self.myTable.rowHeight=30;
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    
    [self.myTable registerNib:[UINib nibWithNibName:@"addVideoCell" bundle:nil] forCellReuseIdentifier:@"cell"];
   

}
-(void)rightBtnClick{

//    NSLog(@"保存");
    [self requestToKeepAudio];
    
    


}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;


}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    addVideoCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    //cell.accessoryType=UITableViewCellAccessoryNone;
   cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.titlelable.text=_titleArray[indexPath.row];
    cell.textField.placeholder=_playHoderArray[indexPath.row];
    cell.textField.tag=100+indexPath.row;
    if (indexPath.row==1) {
        [cell.textField setEnabled:NO];
        cell.textField.text=@"监控";
        UIButton *button =[[UIButton alloc]initWithFrame:CGRectMake(LWidth-50, 0, 40, 30)];
       // button.backgroundColor=[UIColor redColor];
        [button setBackgroundImage:[UIImage imageNamed:@"find_down@3x"] forState:0];
       [button addTarget:self action:@selector(buttonClick) forControlEvents: UIControlEventTouchUpInside];
        [cell addSubview:button];
    }
    
    if (self.type) {
        
        if (indexPath.row==0) {
            cell.textField.text=_fromDic[@"videoname"];
            
        }else if (indexPath.row==1){
        
            if ([_fromDic[@"videoname"] isEqualToString:@"10010"]) {
                cell.textField.text=@"门禁";
                videotypeid=@"10010";
                
            }else{
            cell.textField.text=@"监控";
                videotypeid=@"10086";
            
            }
            
        }else if (indexPath.row==2){
            cell.textField.text=_fromDic[@"videoip"];
           
        }
        
    }
    return cell;



}
-(void)buttonClick{
    
    UITextField *field =(UITextField *)[self.view viewWithTag:101];
    UIAlertController *conter =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action =[UIAlertAction actionWithTitle:@"监控" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        videotypeid=@"10086";
        field.text=@"监控";
        
    }];
    UIAlertAction *door=[UIAlertAction actionWithTitle:@"门禁" style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        videotypeid=@"10010";
        field.text=@"门禁";
        
    }];
    [conter addAction:action];
    [conter addAction:door];
    [self presentViewController:conter animated:YES completion:nil];




}


-(void)requestToKeepAudio{
    UITextField *name_field=(UITextField*)[self.view viewWithTag:100];
    UITextField *ip_field =(UITextField*)[self.view viewWithTag:102];
    UITextField*port_field =(UITextField*)[self.view viewWithTag:103];
    UITextField *user_field =(UITextField*)[self.view viewWithTag:104];
    UITextField*pwd_field =(UITextField*)[self.view viewWithTag:105];
    
    if (name_field.text.length==0||ip_field.text.length==0 ||ip_field.text.length==0||port_field.text.length==0||user_field.text.length==0||pwd_field.text.length==0 ) {
        [SVProgressHUD showErrorWithStatus:@"名称，类别，地址ip，端口，用户名，密码不能为空!!!"];
        return;
        
    }
      NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring;
    if (self.type==0) {
  urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10803\",\"videotypeid\":\"%@\",\"videoname\":\"%@\",\"videoip\":\"%@\",\"loginname\":\"%@\",\"loginpwd\":\"%@\",\"port\":\"%@\",\"serverid\":\"%@\",\"actoruserid\":\"%@\"}",videotypeid,name_field.text,ip_field.text,user_field.text,pwd_field.text,port_field.text,SERVERID,user_field];

    }else{
     urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10804\",\"videotypeid\":\"%@\",\"videoname\":\"%@\",\"videoip\":\"%@\",\"loginname\":\"%@\",\"loginpwd\":\"%@\",\"port\":\"%@\",\"serverid\":\"%@\",\"actoruserid\":\"%@\"}",videotypeid,name_field.text,ip_field.text,user_field.text,pwd_field.text,port_field.text,SERVERID,user_field];

    
    }
    
    NSLog(@"urlString====%@",urlstring);
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        //[SVProgressHUD dismiss];
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            
            [SVProgressHUD showSuccessWithStatus:[dictt objectForKey:@"MSG"]];
            NSLog(@"");
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
//            _TypeArray=dictt[@"DATA"];
//            NSLog(@"_TypeArray====%@",_TypeArray);
            //[self initCollectionView];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
            
        }
    };





}

@end
