//
//  KYMessageTableViewController.m
//  SyncSmartHome
//
//  Created by sciyonSoft on 16/5/6.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "KYMessageTableViewController.h"
//

#import "OtherBubbleCell.h"
#import "SelfBubbleCell.h"
#import "MJRefresh.h"

@interface KYMessageTableViewController ()<UITextFieldDelegate,UIScrollViewDelegate>{
    NSArray *_chatArray;
    UIView *_inputView;
    UITextField *textfield;
    NSTimer * _timer;
    int pageno;


}

@end

@implementation KYMessageTableViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_timer  invalidate];
    _timer=nil;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    pageno=1;
    self.tabBarController.tabBar.hidden=YES;
    [self initView];
    [self requestForMassege];
              [self  tableMoveToEnd];
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(requestForMassege) userInfo:nil repeats:YES];

    
    [self.myTable registerNib:[UINib nibWithNibName:@"OtherBubbleCell" bundle:nil] forCellReuseIdentifier:@"othercell"];
    [self.myTable registerNib:[UINib nibWithNibName:@"SelfBubbleCell" bundle:nil] forCellReuseIdentifier:@"selfcell"];
    self.title = @"消息";
        }
-(void)initView {
self.myTable.frame=CGRectMake(0, 0, LWidth, LHeight-60);
    self.myTable.separatorColor=[UIColor clearColor];
   self.myTable.sectionHeaderHeight = 35.0f;
    //list_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.myTable addHeaderWithTarget:self action:@selector(upRefresh:)];

    UIImageView *bgimageview =[[UIImageView alloc]initWithFrame:self.myTable.bounds];
    
    bgimageview.image=[UIImage imageNamed:@"bg4"];
    self.myTable.backgroundView=bgimageview;

    _inputView=[[UIView alloc]init];
    _inputView.frame =CGRectMake(0, LHeight-124, LWidth, 60);
    [self.view  addSubview:_inputView];
    _inputView.backgroundColor=[UIColor redColor];
    //[_inputView bringSubviewToFront:self.tableView];
//    self.myTable.bounces = NO;
    UIImageView *iamgeView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chatinputbg"]];
    iamgeView.frame =CGRectMake(0, 0,LWidth , 60);
    [_inputView addSubview:iamgeView];
    textfield =[[UITextField alloc]initWithFrame:CGRectMake(10, 10, LWidth-80, 40)];
    textfield.delegate=self;
    //当输入内容为空时候return键不可点击
    textfield.enablesReturnKeyAutomatically=YES;
    textfield.returnKeyType=UIReturnKeySend;
    textfield.backgroundColor=[UIColor whiteColor];
    [_inputView addSubview:textfield];
    UIButton *sendbutton =[UIButton buttonWithType:UIButtonTypeCustom];
    [sendbutton setTitleColor:[UIColor blackColor] forState:0];
    [sendbutton setTitle:@"发送" forState:0];
    [sendbutton addTarget:self action:@selector(requestSendMassege) forControlEvents:UIControlEventTouchUpInside];
    sendbutton.frame=CGRectMake(LWidth-70,0 , 60, 60);
    [_inputView addSubview:sendbutton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];


}
#pragma mark ------ 下拉刷新
- (void)upRefresh:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //[self requestShowDataList];
       
        [self requestForMassege];
        [self.myTable headerEndRefreshing];
    });
}

#pragma mark- notiMethod
- (void)keyboardChangeFrame:(NSNotification *)noti{
    NSLog(@"%@",noti.userInfo);
    
    //从通知中取出动画速率
    int curve = [[noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    //取出动画时间
    float duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //取出键盘动画结束后键盘的frame
    CGRect endFrame = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationCurve:curve];
      _inputView.frame = CGRectMake(0, endFrame.origin.y-124, self.view.bounds.size.width, 60);
        self.myTable.frame = CGRectMake(0, 0, LWidth,_inputView.frame.origin.y);
        [self  tableMoveToEnd];
    }];
    
}

- (void)tableMoveToEnd{
    if (_chatArray.count>0) {
        [self.myTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_chatArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
    
}


//将要开始拖拽键盘失去响应
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //[textfield resignFirstResponder];
}
#pragma mark- textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //点击键盘上德return键之后，手动调用发送按钮的方法，就相当于点击了发送
    [self requestSendMassege];
    return YES;
}



#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _chatArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
      NSDictionary *dic = [_chatArray objectAtIndex:indexPath.row];
    if ([_chatArray[indexPath.row][@"userid"] isEqualToString:USER_ID]) {
        SelfBubbleCell *cell =[tableView dequeueReusableCellWithIdentifier:@"selfcell"];
        NSString *text = [NSString stringWithFormat:@"%@:%@",USERNAME,[dic objectForKey:@"messagecontent"]];
        
        cell.messageLabel.text = text;
      [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@%@",HTTPIP,IMAGE_URL,USERIMG]] placeholderImage:[UIImage imageNamed:@"user_role_mng_bookroom_on"]];

        cell.backgroundColor =[
                               UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        //根据显示的文本，计算出文本的高度。
        CGRect rect = [text boundingRectWithSize:CGSizeMake(170, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        cell.timeLab.text=[NSString stringWithFormat:@"%@:%@",USERNAME,dic[@"sendtime"]];
       
        
        //设置气泡的高度
        cell.bubbleImageView.frame = CGRectMake(80, 8, 200, rect.size.height+20);
        //设置label的高度
        cell.messageLabel.frame = CGRectMake(90, 18, 170, rect.size.height);
        cell.timeLab.frame=CGRectMake(0, cell.messageLabel.frame.origin.y-30, LWidth, 30);
        cell.headImageView.frame=CGRectMake(LWidth-80, cell.bubbleImageView.frame.origin.y, 60, 60);
        

        
        return cell;
    
        
    }else{
        
        OtherBubbleCell *cell =[tableView dequeueReusableCellWithIdentifier:@"othercell"];
        NSString *text = [NSString stringWithFormat:@"%@:%@",dic[@"username"],[dic objectForKey:@"messagecontent"]];
        cell.messageLabel.text = text;
        cell.backgroundColor =[UIColor clearColor];
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.timeLab.text=dic[@"sendtime"];
        //cell.OtherNme.text =[NSString stringWithFormat:@"%@:%@",dic[@"username"],dic[@"sendtime"]];
        //根据显示的文本，计算出文本的高度。
        CGRect rect = [text boundingRectWithSize:CGSizeMake(170, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        
        //设置气泡的高度
        cell.bubbleImageView.frame = CGRectMake(70, 8, 200, rect.size.height+20);
        //设置label的高度
        cell.messageLabel.frame = CGRectMake(80, 18, 170, rect.size.height);
        cell.timeLab.frame=CGRectMake(0, cell.messageLabel.frame.origin.y-30, LWidth, 30);
 cell.headImageView.frame=CGRectMake(10,0, 60, 60);
        
        return cell;
    }


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [_chatArray objectAtIndex:indexPath.row];
    NSString *text = [dic objectForKey:@"messagecontent"];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(170, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    if (rect.size.height+30<80) {
        return 80;
    }else{
        return rect.size.height+80;
    }
    
    
    
}

//查看信息
-(void)requestForMassege{
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10704\",\"serverid\":\"%@\",\"userid\":\"%@\",\"actuserid\":\"%@\"}",SERVERID,USER_ID,USER_ID];
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
             NSLog(@"dict:==%@",dictt[@"DATA"]);
            
            _chatArray=dictt[@"DATA"];
            [self.myTable reloadData];
 

             }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };

    
}
//发送信息
-(void)requestSendMassege{
    if (textfield.text.length<=0) {
        return;
    }
       NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSDateFormatter *formart =[[NSDateFormatter alloc]init];
    [formart setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dataString =[formart stringFromDate:[NSDate date]];
   
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10703\",\"messagecontent\":\"%@\",\"userid\":\"%@\",\"username\":\"%@\",\"sendtime\":\"%@\",\"serverid\":\"%@\",\"actuserid\":\"%@\"}",textfield.text,USER_ID,USERNAME,dataString,SERVERID,USER_ID];
    NSLog(@"urlstring=====%@",urlstring);
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        [SVProgressHUD dismiss];
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            NSLog(@"dict:==%@",dictt[@"DATA"]);
            //[SVProgressHUD showSuccessWithStatus:[dictt objectForKey:@"MSG"]];
              self.myTable.frame = CGRectMake(0, 0, LWidth,_inputView.frame.origin.y);
            [self  tableMoveToEnd];
            textfield.text=@"";
                  [self  requestForMassege];
                      [self  tableMoveToEnd];
     
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
    
    
}


@end
