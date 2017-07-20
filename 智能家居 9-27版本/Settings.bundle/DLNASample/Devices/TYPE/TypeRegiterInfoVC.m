//
//  TypeRegiterInfoVC.m
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/6/24.
//
//

#import "TypeRegiterInfoVC.h"
#import "regiterCell.h"


@interface TypeRegiterInfoVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{

    NSMutableArray *_numberArray;
    NSArray *_ereaArray;
    NSArray *_typeArray;
    NSArray *_pancelArry;
    
    NSArray *_fromArray;
    NSDictionary *_fromDic;
    NSArray *_PArray;
    int row;
    int ereraIDRow;
}

@end

@implementation TypeRegiterInfoVC
-(id)initWithArray:(NSArray*)aArray WithDic:(NSDictionary*)dic{
    self=[super init];
    if (self) {
        _fromArray=aArray;
        _fromDic=dic;
        
        NSLog(@"dromDic===%@",_fromDic);
        
        NSLog(@"fromArray=======%@",_fromArray);
        
        
        
    }
    
    return self;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //_ereaArray =[[NSArray alloc]initWithObjects:@"",@"",@"",@"",@"", @"",nil];
    [self requestForArea];
    [self requestToGetPancel];
    self.deviceText.delegate=self;
    self.deviceText.returnKeyType=UIReturnKeyDone;
    //self.deviceText.text=_fromArray[0][@"name"];
    UIBarButtonItem *rightBtn =[[UIBarButtonItem alloc]initWithTitle:@"保存" style: UIBarButtonItemStylePlain target:self action:@selector(keepBtnClick)];
    self.navigationItem.rightBarButtonItem=rightBtn;
       self.myTable.dataSource=self;
    self.myTable.delegate=self;
    [self.myTable registerNib:[UINib nibWithNibName:@"regiterCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self.typeBtn setTitle:_fromDic[@"typename"] forState:0];
    [self.PanelBtn setTitle:_fromDic[@"typename"] forState:0];
    self.deviceText.text=_fromDic[@"devicename"];
    row=0;
    ereraIDRow=0;
    
    
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    [self.myTable registerNib:[UINib nibWithNibName:@"regiterCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
}
-(void)keepBtnClick{
    [self requestToKeep];



}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;

}
#pragma mark- notiMethod
- (void)keyboardChangeFrame:(NSNotification *)noti{
    NSLog(@"%@",noti.userInfo);
    
    //从通知中取出动画速率
    int curve = [[noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    //取出动画时间
    float duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //取出键盘动画结束后键盘的frame
    //CGRect endFrame = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationCurve:curve];
       // _inputView.frame = CGRectMake(0, endFrame.origin.y-124, self.view.bounds.size.width, 60);
        //self.myTable.frame = CGRectMake(0, self.myImageview.frame.origin.y+3, LWidth,LHeight-endFrame.origin.y);
        [self  tableMoveToEnd];
    }];
    
}

- (void)tableMoveToEnd{
    if (_fromArray.count>0) {
        [self.myTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_fromArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _fromArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   // NSArray *arr=[[NSArray alloc]initWithObjects:@"一", @"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",nil];
    
    regiterCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    cell.label.text =[NSString stringWithFormat:@"端点%d:",indexPath.row+1];
    cell.textfield.text=_fromArray[indexPath.row][@"name"];
    [cell.button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.button.tag=indexPath.row;
    cell.textfield.tag=indexPath.row+100;
    
    return cell;
    

    

}
-(void)btnClick:(UIButton*)sender{
    
    UITextField *field=(UITextField*)[self.view viewWithTag:sender.tag+100];
    
    [self requestChangeDeviceName:field.text with:sender.tag];





}

- (IBAction)ereaBtnClick:(id)sender {
    
    UIAlertController *controler=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleAlert];
    for (int i=0; i<_ereaArray.count; i++) {
        
        UIAlertAction *action =[UIAlertAction actionWithTitle:_ereaArray[i][@"areaname"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.ereaBtn setTitle:_ereaArray[i][@"areaname"] forState:0];
            ereraIDRow=i;
        }];
        [controler addAction:action];
    }
    [self presentViewController:controler animated:YES completion:nil];
}

- (IBAction)TypeBtnClick:(id)sender {
}

- (IBAction)PancelBtnClick:(id)sender {
    
    UIAlertController *controler=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleAlert];
    
    for (int i=0; i<_PArray.count; i++) {
        
        
        UIAlertAction *action =[UIAlertAction actionWithTitle:_PArray[i][@"panelname"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.PanelBtn setTitle:_PArray[i][@"panelname"] forState:0];
            row=i;
            
            
        }];
        [controler addAction:action];
    }
    [self presentViewController:controler animated:YES completion:nil];

    
}


- (IBAction)deldeBtnClick:(id)sender {
}


// 请求区域
-(void)requestForArea{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10408\",\"serverid\":\"%@\",\"userid\":\"%@\",\"isadmin\":\"%@\"}",SERVERID,USER_ID,@"1"];
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            
            _ereaArray=dictt[@"DATA"];
            //[collectView reloadData];
            [self.ereaBtn setTitle:_ereaArray[0][@"areaname"] forState:0];
            
            
            NSLog(@"_AreaArray====%@",_ereaArray);
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
    
    
}
//修改设备名称
-(void)requestChangeDeviceName:(NSString*)text with:(int)index{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10417\",\"id\":\"%@\",\"name\":\"%@\",\"actuserid\":\"%@\"}",_fromArray[index][@"id"],text,USER_ID];
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            
//            _ereaArray=dictt[@"DATA"];
//            //[collectView reloadData];
//            [self.ereaBtn setTitle:_ereaArray[0][@"areaname"] forState:0];
            
            [SVProgressHUD showSuccessWithStatus:dictt[@"MSG"]];
            
            
            //NSLog(@"_AreaArray====%@",_ereaArray);
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };

   
}

-(void)requestToGetPancel{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10407\",\"typeid\":\"%@\",\"actuserid\":\"%@\"}",_fromDic[@"typeid"],USER_ID];
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            
            //            _ereaArray=dictt[@"DATA"];
            //            //[collectView reloadData];
            //            [self.ereaBtn setTitle:_ereaArray[0][@"areaname"] forState:0];
            
            _PArray =dictt[@"DATA"];
            
            
           // [SVProgressHUD showSuccessWithStatus:dictt[@"MSG"]];
            
            
            NSLog(@"_pancelArray====%@",_PArray);
            
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };






}

-(void)requestToKeep{
    
    
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10402\",\"deviceid\":\"%@\",\"areaid\":\"%@\",\"panelid\":\"%@\",\"devicename\":\"%@\",\"actuserid\":\"%@\"}",_fromDic[@"id"],_ereaArray[ereraIDRow][@"id"],_PArray[row][@"id"],self.deviceText.text,USER_ID];
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            
            //            _ereaArray=dictt[@"DATA"];
            //            //[collectView reloadData];
            //            [self.ereaBtn setTitle:_ereaArray[0][@"areaname"] forState:0];
            
            [SVProgressHUD showSuccessWithStatus:dictt[@"MSG"]];
            
            
            //NSLog(@"_AreaArray====%@",_ereaArray);
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };

    
    





}
@end
