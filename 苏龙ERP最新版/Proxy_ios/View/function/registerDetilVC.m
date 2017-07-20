//
//  registerDetilVC.m
//  Proxy_ios
//
//  Created by sciyonSoft on 16/1/14.
//  Copyright © 2016年 keyuan. All rights reserved.
//

#import "registerDetilVC.h"

@interface registerDetilVC ()<UITextFieldDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSDictionary* showData;
    NSString *FPSTIME;
    NSString *FRSNNAME;
    NSDictionary * showDataDict;
    UITableView *listTableView;
    UIDatePicker* datePicker;
    UIView * pView;
    NSString* isEnd;
    NSString *BeginTime;
    NSString *currentTime;
    NSDictionary *dict1;
    NSString *FCODE;
    NSString *SAVETYPE;
    NSString *FGUID;
    BOOL isFindShow;
    CGAffineTransform transform;
    
    
  


}

@end

@implementation registerDetilVC
- (id)initWithShowData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        showData = [NSDictionary dictionaryWithDictionary:data];
       
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

   
    self.title=@"外出登记";
    self.reason.delegate=self;
    self.reason.returnKeyType= UIReturnKeyDone;
    //self.reason.keyboardType=UIKeyboardTypeEmailAddress;
    [self initdropDownMenu];
   
    [self.NumTex setEnabled:NO];
    [self.appPerson  setEnabled:NO];
    [self.agency setEnabled:NO];
 
    
    [self initPikerView];
    switch (self.type) {
        case 1:
        {
            
            self.appPerson.text=USERNAME;
            self.agency.text=DEPTNAME;
            
            self.NumTex.text=showData[@"FCODE"];
            self.appPerson.text=showData[@"FAPPLYPERNAME"];
            self.agency.text=showData[@"FAPPDEPT"];
            [self .beginTime setTitle:[self replecString:showData[@"FAPPSDATE"]] forState:0];
            [self.endTime setTitle:[self  replecString:showData[@"FAPPEDATE"]] forState:0];
            self.button.tag=[showData[@"FTYPEGUID"]integerValue];
            self.reason.text=showData[@"FREASON"];
            [self.button setTitle:showData[@"FTYPE"] forState:UIControlStateNormal];
            
        }
        break;
        
        case 2:{
            [self initView];
            
        }
    }
    
    
    
    
    
    
    
}


-(void)initPikerView{
    
    
    
    
    
      UITapGestureRecognizer * time = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(timeClick)];
    [self.beginTime addGestureRecognizer:time];
    
    
    UITapGestureRecognizer * end = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endTimeClick)];
    [self.endTime addGestureRecognizer:end];
    
    
    
    
    pView = [[UIView alloc] initWithFrame:CGRectMake(0, LHeight, LWidth, 190)];
    pView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pView];
    [self.view bringSubviewToFront:pView];
    
    //    取消按钮
    UIButton* returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(10, 0, 50, 30);
    returnBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [returnBtn setTitle:@"取消" forState:0];
    [returnBtn setTitleColor:[UIColor colorWithRed:0.000 green:0.800 blue:0.600 alpha:1] forState:0];
    [returnBtn addTarget:self action:@selector(returnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [pView addSubview:returnBtn];
    
    //    确定按钮
    UIButton* endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    endBtn.frame = CGRectMake(LWidth-60, 0, 50, 30);
    endBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [endBtn setTitle:@"完成" forState:0];
    [endBtn setTitleColor:[UIColor colorWithRed:0.000 green:0.800 blue:0.600 alpha:1] forState:0];
    [endBtn addTarget:self action:@selector(endBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [pView addSubview:endBtn];
    
    //    横线
    UIImageView* bgimagViewA = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
    bgimagViewA.frame = CGRectMake(0, 0, LWidth, 2);
    [pView addSubview:bgimagViewA];
    UIImageView* bgimagViewB = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
    bgimagViewB.frame = CGRectMake(0, 28, LWidth, 2);
    [pView addSubview:bgimagViewB];
    
    
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, LWidth, 160)];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    datePicker.minuteInterval = 5;
    datePicker.backgroundColor = [UIColor whiteColor];
    [pView addSubview:datePicker];





}


- (void)returnBtnClick:(UIButton *)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        pView.frame = CGRectMake(0, LHeight, LWidth, 190);
    }];
}
- (void)endBtnClick:(UIButton *)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        pView.frame = CGRectMake(0, LHeight, LWidth, 190);
    }];
    NSDate *select = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
    if ([isEnd isEqualToString:@"开始"])[self.beginTime  setTitle:dateAndTime forState:0];;   if ([isEnd isEqualToString:@"结束"] )[self.endTime  setTitle:dateAndTime forState:0];
}
- (void)timeClick
{
    NSLog(@"enddddddd=kaisgiu");
    isEnd = @"开始";
    [UIView animateWithDuration:0.25 animations:^{
        pView.frame = CGRectMake(0, LHeight-255, LWidth, 190);
    }];
}
- (void)endTimeClick
{
    NSLog(@"enddddddd=jieshu");
    isEnd = @"结束";
    [UIView animateWithDuration:0.25 animations:^{
        pView.frame = CGRectMake(0, LHeight-255, LWidth, 190);
    }];
}


-(void)initView{
    
    listTableView.hidden=YES;
    
    //self.NumTex.text=showData[@"FCODE"];
    self.appPerson.text=USERNAME;
    self.agency.text=DEPTNAME;
    
    self.button.tag=1;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal
                               components:NSYearCalendarUnit | NSMonthCalendarUnit|NSCalendarUnitDay|kCFCalendarUnitHour
                               fromDate:now];
    comps.hour = 8;
    NSDate *firstDay = [cal dateFromComponents:comps];
    BeginTime = [formatter stringFromDate:firstDay];
    [self.beginTime setTitle:BeginTime forState:0];
    comps.hour=17;
    
    
    NSDate *lasDAta =[cal  dateFromComponents:comps];
    
    currentTime = [formatter stringFromDate:lasDAta];
    [self.endTime setTitle:currentTime forState:0];
}
#pragma mark - UITextView Delegate Methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if (textField.tag >= 2 & IPHONE_5) {
        [self animateWithFrame:-(50*(textField.tag-2))];
    }else if (textField.tag >= 3 & IPHONE_6) {
        [self animateWithFrame:-(50*(textField.tag-3))];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, 64.0f, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    return YES;
}- (void)animateWithFrame:(float)frameY
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, frameY, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

-(NSString *)replecString:(NSString *)string{
    
    NSString *newBtime =[string stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSString *nowStr =[newBtime stringByReplacingOccurrencesOfString:@"+08:00" withString:@""];
    return nowStr;
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)typeBtn:(id)sender {
  transform= CGAffineTransformMakeRotation(-M_PI/2);
    self.finfDownImg.transform = transform;//旋转
    
       listTableView.hidden=NO;
}

- (void)initdropDownMenu;//班组
{
    
    listTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.button.center.x-30, self.button.center.y+15, LWidth/3+20, 100)];
    listTableView.hidden = YES;
    listTableView.delegate = self;
    listTableView.dataSource = self;
    listTableView.rowHeight = 20;
    listTableView.tag = 0;
    listTableView.backgroundColor = [UIColor whiteColor];
    listTableView.layer.borderColor = [[UIColor colorWithRed:0.773 green:0.780 blue:0.776 alpha:1] CGColor];
    listTableView.layer.borderWidth = .5f;
    [listTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:listTableView];
}



- (IBAction)upDataBTN:(id)sender {
    
    
    if (self.type==1) {
        if ([showData[@"FAPPLYPERNAME"] isEqualToString:USERNAME]&[showData[@"FAPPDEPT"] isEqualToString:DEPTNAME]) {
            self.beginTime.userInteractionEnabled=NO;
            self.endTime.userInteractionEnabled=NO;
            [self.reason setEditable:NO];
             SAVETYPE=@"UDP";
            FCODE=showData[@"FCODE"];
            FGUID=showData[@"FGUID"];
            
        }else{
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"修改无效,您只能修改自己的记录！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
            [alert show];
            return;
        
        }
        
        
    }else{
        SAVETYPE=@"ADD";
        FCODE=@"";
        FGUID=@"";
    }

     dict1 =[NSDictionary dictionaryWithObjectsAndKeys:@"SAVEGETOUTREG",@"Action",FCODE,@"FCODE",SAVETYPE,@"SAVETYPE",FGUID,@"FGUID",USERORGGUID,@"FAPPLYPERORGGUID",USERNAME,@"FAPPLYPERNAME",USERID,@"FAPPLYPERID",DEPTGUID,@"FAPPDEPTGUID",DEPTNAME,@"FAPPDEPT",self.beginTime.titleLabel.text,@"FAPPSDATE",self.endTime.titleLabel.text,@"FAPPEDATE",self.button.titleLabel.text,@"FTYPE",[NSString stringWithFormat:@"%ld",(long)self.button.tag],@"FTYPEGUID",self.reason.text,@"FREASON",nil];
               MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/EPM/ProxyMobile/OutReg.ashx",HTTPIP,SLRD] withParameter:dict1];
       //manager.delegate = self;
       manager.backSuccess = ^void(NSDictionary *dictt)
       {
           if ([[dictt objectForKey:@"success"] integerValue] == 1) {
               [self.navigationController popViewControllerAnimated:YES];
             
           }else{
               [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
           }
       };
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idfer=@"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:idfer];
    if (!cell) {
      cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idfer];
    }
    cell.backgroundColor=[UIColor lightGrayColor];
    NSArray *arr =[[NSArray alloc]initWithObjects:@"请假",@"公出", nil];
    cell.textLabel.text=arr[indexPath.row];
    


    return cell;



}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   transform= CGAffineTransformMakeRotation(0);
    self.finfDownImg.transform = transform;//旋转
    if (indexPath.row==0) {
        [self.button setTitle:@"请假" forState:UIControlStateNormal];
        listTableView.hidden=YES;
        self.button.tag=1;
         self.finfDownImg.transform = transform;//旋转
        
    }else{
          [self.button setTitle:@"公出" forState:UIControlStateNormal];
    
        listTableView.hidden=YES;
        self.button.tag=2;
    
    
    
    
    }




}




- (IBAction)buttonClick:(UIButton *)sender {
    
    
    switch (sender.tag) {
        case 100:{
            
            [self timeClick];
        
        }
        
        break;
        
        case  200:{
            [self endTimeClick];
        
        
        
        }
        break;
    }
    
}
@end
