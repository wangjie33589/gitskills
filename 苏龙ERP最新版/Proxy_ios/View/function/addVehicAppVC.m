//
//  addVehicAppVC.m
//  Proxy_ios
//
//  Created by SciyonSoft_WangJie on 17/7/6.
//  Copyright © 2017年 keyuan. All rights reserved.
//

#import "addVehicAppVC.h"
#import "workFlowupTable.h"
#import "Task_TableViewCell.h"
#import "IGLDropDownMenu.h"
#import "PeopleViewController.h"
#import "PerplelistViewController.h"
#import "PeopleModel.h"
#import "InformationViewController.h"

@interface addVehicAppVC ()<UITextFieldDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,IGLDropDownMenuDelegate,PeopleViewControllerDelegate,PerplelistViewControllerDelegate>{
    BOOL tableisShow;
    workFlowupTable*   table;
    UIView * pView;
    NSString *isEnd;
    UIDatePicker *datePicker;
    NSMutableArray *  buttonsArray ;
    
    UIView *alertView;
    NSString  *datytype;
    UITableView *upTable;
    
    NSString  * isShow;
    
   NSString *   IsAdd ;
   NSString *  DataType;
   NSString*  VIRTUALPATH;
    NSString *userInfoId;
    UIView *Comments;
    UIView *chooseCB;
    NSInteger commIndex;
    UIButton * chooseCom ;
    UITextView  *textview;
    NSDictionary *showDictA;
  
    NSString *dataguid;
    NSString *timeStamp;
    NSString *mAction;
    NSDictionary *_showDic;
    BOOL  flowflag;
    NSString *Bllid;
    
    
}
@property (nonatomic, strong) IGLDropDownMenu *dropDownMenu;
@end

@implementation addVehicAppVC
-(id)initWithAdic:(NSDictionary *)aDic{
   self=[super init];
    if (self) {
        _showDic=aDic;
        
        NSLog(@"showdic=====%@",_showDic);
    }

    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"用车申请" ;
    

    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@" "
                                     style:UIBarButtonItemStyleDone
                                     target:self
                                     action:@selector(callModalList)];
    
    [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont systemFontOfSize:15], NSFontAttributeName,
                                         [UIColor whiteColor], NSForegroundColorAttributeName,
                                         nil]
                               forState:UIControlStateNormal];
    rightButton.image = [UIImage imageNamed:@"icon_5_n"];
    flowflag=0;
    self.navigationItem.rightBarButtonItem = rightButton;
    if ([_type isEqualToString:@"添加"]) {
        self.smallSave.hidden=YES;
        self.smallDel.hidden=YES;
        mAction=@"0";
        Bllid=@"";
        NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        timeStamp=[formatter stringFromDate:[NSDate date]];
        [[NSUserDefaults standardUserDefaults]setObject:timeStamp forKey:@"timeStamp"];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSString *nowtime =[formatter stringFromDate:[NSDate date]];
        self.applyDateTexxtField.text=nowtime;
        dataguid =[MyTool stringWithUUID];
        self.applyOrg.text=DEPTNAME;
        self.applyPerson.text=USERNAME;
        
              self.applyDateTexxtField.returnKeyType=UIReturnKeyDone;
        self.applypersonCountfield.returnKeyType=UIReturnKeyDone;
        self.applypersonCountfield.keyboardType=UIReturnKeyDone;
        self.applypersonCountfield.placeholder=@"请输入...";
        self.indeedCityField.returnKeyType=UIReturnKeyDone;
        self.indeedCityField.placeholder=@"请输入...";
        self.uesrCreRensonTview.returnKeyType=UIReturnKeyDone;
        self.remarkTview.returnKeyType=UIReturnKeyDone;
        self.uesrCreRensonTview.text=@"请输入...";
        self.remarkTview.text=@"请输入...";
        self.uesrCreRensonTview.textColor=[UIColor lightGrayColor];
        self.remarkTview.textColor=[UIColor lightGrayColor];
        self.applyDateTexxtField.delegate=self;
        self.applypersonCountfield.delegate=self;
        self.indeedCityField.delegate=self;
        self.remarkTview.delegate=self;
        self.uesrCreRensonTview.delegate=self;
        [self.beginTimeBtn setTitle:@"请选择..." forState:UIControlStateNormal];
        [self.beginTimeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.endTime setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.endTime setTitle:@"请选择..." forState:UIControlStateNormal];
    }else if([_type isEqualToString:@"编辑"]){
        dataguid=_showDic[@"CFID"];
        mAction=@"1";
        Bllid=_showDic[@"BILLID"];
        [self requestFortimeStamp];
        self.bigSave.hidden=YES;
        self.applyOrg.text=_showDic[@"APPLYDEPT"];
        self.applyPerson.text=_showDic[@"APPLYPERSON"];
        self.applyDateTexxtField.text=[MyTool daFormatByComment:_showDic[@"APPLYDATE"]];
        self.applypersonCountfield.text=_showDic[@"LOADINGNUM"];
        self.indeedCityField.text=_showDic[@"CITY"];
        self.uesrCreRensonTview.text=_showDic[@"REASON"];
        self.remarkTview.text=_showDic[@"TEXT1"];
        [self.beginTimeBtn setTitle:[MyTool DataFormart:_showDic[@"SBDATE"]] forState:0];
        [self.endTime setTitle:[MyTool  DataFormart:_showDic[@"SEDATE"]] forState:0];
   

    
    }else{
        dataguid=_showDic[@"CFID"];
        mAction=@"1";
        Bllid=_showDic[@"BILLID"];
        self.smallDel.hidden=YES;
        self.smallSave.hidden=YES;
        self.bigSave.hidden=YES;
        self.applyDateTexxtField.userInteractionEnabled=NO;
        self.applypersonCountfield.userInteractionEnabled=NO;
        self.applypersonCountfield.userInteractionEnabled=NO;
        self.indeedCityField.userInteractionEnabled=NO;
        self.uesrCreRensonTview.userInteractionEnabled=NO;
        self.remarkTview.userInteractionEnabled=NO;
        self.beginTimeBtn.userInteractionEnabled=NO;
        self.endTime.userInteractionEnabled=NO;
        self.applyOrg.text=_showDic[@"APPLYDEPT"];
        self.applyPerson.text=_showDic[@"APPLYPERSON"];
        self.applyDateTexxtField.text=[MyTool daFormatByComment:_showDic[@"APPLYDATE"]];
        self.applypersonCountfield.text=_showDic[@"LOADINGNUM"];
        self.indeedCityField.text=_showDic[@"CITY"];
        self.uesrCreRensonTview.text=_showDic[@"REASON"];
        self.remarkTview.text=_showDic[@"TEXT1"];
        [self.beginTimeBtn setTitle:[MyTool DataFormart:_showDic[@"SBDATE"]] forState:0];
        [self.endTime setTitle:[MyTool DataFormart:_showDic[@"SEDATE"]] forState:0];



    
    }
    
        tableisShow=YES;
    
    self.applyOrg.userInteractionEnabled=NO;
    self.applyPerson.userInteractionEnabled=NO;
    self.applyDateTexxtField.userInteractionEnabled=NO;
    self.applypersonCountfield.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    self.beginTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.beginTimeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.endTime.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.endTime.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
  
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
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, LWidth, 160)];
    datePicker.datePickerMode =  UIDatePickerModeDateAndTime;
    [datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    datePicker.minuteInterval = 5;
    datePicker.backgroundColor = [UIColor whiteColor];
    [pView addSubview:datePicker];
    [self requestShowDataList];
     
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField==self.applypersonCountfield) {
    return [self validateNumber:string];
    }else{
    
        return YES;
    
    }
    
  
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@"请输入..."]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }

}
-(void)textViewDidEndEditing:(UITextView *)textView{
  
    if(textView.text.length < 1){
        textView.text = @"请输入...";
        textView.textColor = [UIColor lightGrayColor];
    }

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;

}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView!=textview) {
         [self animateWithFrame:-150];
    }
   
    return YES;

}
- (void)animateWithFrame:(float)frameY
{
    
    pView.backgroundColor=[MyTool colorWithHexString:@"#EFEFEF" ];
  
    [UIView animateWithDuration:0.25 animations:^{
        pView.frame = CGRectMake(0, LHeight+255, LWidth, 190);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, frameY, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (void)textViewDidChangeSelection:(UITextView *)textView{

}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        pView.backgroundColor=[UIColor  whiteColor];
        [UIView animateWithDuration:0.25 animations:^{
            pView.frame = CGRectMake(0, LHeight, LWidth, 190);
        }];
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, 64.0f, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }

    return YES;

}


-(void)callModalList{
    alertView.hidden = !alertView.hidden;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)begintime:(UIButton *)sender {
    
    isEnd = @"开始";
    [UIView animateWithDuration:0.25 animations:^{
        pView.frame = CGRectMake(0, LHeight-255, LWidth, 190);
    }];
}
- (IBAction)endTimeBtn:(id)sender {
    isEnd = @"结束";
    [UIView animateWithDuration:0.25 animations:^{
        pView.frame = CGRectMake(0, LHeight-255, LWidth, 190);
    }];
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
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
    if ([isEnd isEqualToString:@"开始"]){
        [self.beginTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    
        [self.beginTimeBtn setTitle:dateAndTime forState:UIControlStateNormal];
    }
        
    if ([isEnd isEqualToString:@"结束"]) {
        [self.endTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.endTime setTitle:dateAndTime forState:UIControlStateNormal];
    }
}
//保存

- (IBAction)bigsavebtn:(UIButton *)sender {
    
         [self requestToSave];
    
  
}
- (IBAction)smallsavebtn:(UIButton *)sender {
    
        [self requestToSave];
   
}
- (IBAction)smalldelbtn:(UIButton *)sender {
    
    NSLog(@"smalldel");
    [self requestToDel];
}
-(NSString*)XMLstring{
    
    
    if (![MyTool compairTimeA:_beginTimeBtn.titleLabel.text timeB:_endTime.titleLabel.text]) {
        [SVProgressHUD showErrorWithStatus:@"申请用车结束时间应大于开始时间"];
        return  @"" ;
    }
    
    if (_applyDateTexxtField.text.length==0||_applypersonCountfield.text.length==0||_indeedCityField.text.length==0|| [_uesrCreRensonTview.text isEqualToString:@"请输入..."]||[_uesrCreRensonTview.text isEqualToString:@"请输入..."]|| [_endTime.titleLabel.text isEqualToString:@"请选择..."]||[_beginTimeBtn.titleLabel.text isEqualToString:@"请选择..."]) {
        [SVProgressHUD showErrorWithStatus:@"必填项不能为空"];
        return @"";
        
    }
    

    NSString  *xmlstring=@"";
    xmlstring=[NSString stringWithFormat:@"<Data><Action>SAVEDATA</Action><DATAGUID>%@</DATAGUID><FLAG>%@</FLAG><FLOWNAME>申请</FLOWNAME><FUNID>DesignerFiles\\WebForms\\CAR\\UseCarApply</FUNID><UPDATESTAMP>%@</UPDATESTAMP><STORE><MAINSTORE>1</MAINSTORE><NAME>s01</NAME><FIELDS><APPLYPERSONGUID type=\"string\">%@</APPLYPERSONGUID><APPLYPERSON type=\"string\">%@</APPLYPERSON><APPLYDEPTGUID type=\"string\">%@</APPLYDEPTGUID><APPLYDEPT type=\"string\">%@</APPLYDEPT><APPLYDATE type=\"date\">%@</APPLYDATE><LOADINGNUM type=\"string\">%@</LOADINGNUM><CITY type=\"string\">%@</CITY><SBDATE type=\"date\">%@</SBDATE><SEDATE type=\"date\">%@</SEDATE><REASON type=\"string\">%@</REASON><TEXT1 type=\"string\">%@</TEXT1><BILLID type=\"string\">%@</BILLID><REPAIRPERSONGUID type=\"string\"></REPAIRPERSONGUID><CARNUMGUID type=\"string\"></CARNUMGUID><CARNUM type=\"string\"></CARNUM><HWJS type=\"string\"></HWJS><TEXT2 type=\"string\"></TEXT2><DRIVER type=\"string\"></DRIVER><DRIVERGUID type=\"string\"></DRIVERGUID><XCLC type=\"string\"></XCLC><DRIVERGUID type=\"string\"></DRIVERGUID><BTIME type=\"date\"></BTIME><ETIME type=\"date\"></ETIME><CARBRAND type=\"string\"></CARBRAND><KSBM type=\"string\"></KSBM><JSBM type=\"string\"></JSBM><PZR type=\"string\"></PZR></FIELDS></STORE></Data>",dataguid,mAction, [[NSUserDefaults standardUserDefaults]objectForKey:@"timeStamp"],USERID,USERNAME,DEPTGUID,DEPTNAME,_applyDateTexxtField.text,_applypersonCountfield.text,_indeedCityField.text, _beginTimeBtn.titleLabel.text, _endTime.titleLabel.text, _uesrCreRensonTview.text,_remarkTview.text,Bllid];
    return xmlstring;

}
    //  保存
-(void)requestToSave{
    
    if (![[self XMLstring] isEqualToString:@""]) {
        
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[self XMLstring],@"FormInfo",@"SAVEFORM",@"Action",datytype,@"DataType", nil];
        
        
        
        MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/%@",HTTPIP,SLRD,MOBILE_URL] withParameter:dict];
        manager.backSuccess = ^void(NSDictionary *dictt)
        {
            if ([[dictt objectForKey:@"success"] integerValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                mAction=@"1";
                self.bigSave.hidden=YES;
                self.smallSave.hidden=NO;
                self.smallDel.hidden=NO;
            

                [self requestFortimeStamp];
                
            }else{
                [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
            }
        };

    }
}

//获取时间戳
-(void)requestFortimeStamp{
    
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:@"GETTIMESTAMP",@"Action",dataguid ,@"CFID", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@%@",HTTPIP,SLRD,OA_CAR_APPLY_URL]  withParameter:dict];
    
    NSLog(@"FDGSF====%@",dict);
    NSLog(@"URL=====%@",[NSString stringWithFormat:@"http://%@%@%@",HTTPIP,SLRD,OA_CAR_APPLY_URL]);
    
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            
            timeStamp=dictt[@"UPDATESTAMP"];
            Bllid=dictt[@"CUSTOMERINFO1"];
            [[NSUserDefaults standardUserDefaults]setObject:timeStamp forKey:@"timeStamp"]
            ;
            
            
            
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
        
    };
    
}

//删除单据

-(void)requestToDel{
    
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:@"DELCARAPPLY",@"Action",dataguid ,@"CFID", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@%@",HTTPIP,SLRD,OA_CAR_APPLY_URL]  withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
        
    };
    


}


- (void)requestShowDataList//右上角按钮
{
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:@"INITWFCONTROL",@"Action",dataguid,@"DATAGUID",self.FLOWGUID,@"FLOWGUID",@"",@"FLOWINSTANCEGUID",@"",@"FLOWVERSION",@"",@"HGUID",@"",@"PROCESSGUID",@"normal",@"SHOWSTATUS", nil];
    NSLog(@"ashgdfgsad===%@",dict);
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/%@",HTTPIP,SLRD,MOBILE_URL] withParameter:dict];
    
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            showDictA =[dictt objectForKey:@"Data"];
            datytype=dictt[@"Data"][@"DATATYPE"];

            
            if ([dictt objectForKey:@"Data"]==[NSNull null]) {
                return;
            }
            if ([[[dictt objectForKey:@"Data"] objectForKey:@"BUTTONS"] isKindOfClass:[NSDictionary class]]||[[[dictt objectForKey:@"Data"] objectForKey:@"BUTTONS"] isKindOfClass:[NSArray class]]) {
                
                NSMutableArray* butt = [[NSMutableArray alloc] init];
                if ([[[[dictt objectForKey:@"Data"] objectForKey:@"BUTTONS"] objectForKey:@"Button"] isKindOfClass:[NSDictionary class]]) {
                    [butt addObject:[[[dictt objectForKey:@"Data"] objectForKey:@"BUTTONS"] objectForKey:@"Button"]];
                }else{
                    butt = [NSMutableArray arrayWithArray:[[[dictt objectForKey:@"Data"] objectForKey:@"BUTTONS"] objectForKey:@"Button"]];
                }
                buttonsArray = [[NSMutableArray alloc] init];
                for (NSInteger index = 0; index < butt.count; index ++) {
                    NSString* type = [[butt objectAtIndex:index] objectForKey:@"@Type"];
                    if ([self.type isEqualToString:@"添加"]||[self.type isEqualToString:@"编辑"]) {
                        if ([type isEqualToString:@"0"]||[type isEqualToString:@"1"]||[type isEqualToString:@"2"]||[type isEqualToString:@"3"]||[type isEqualToString:@"4"]||[type isEqualToString:@"6"]||[type isEqualToString:@"8"]||[type isEqualToString:@"9"]||[type isEqualToString:@"11"]||[type isEqualToString:@"20"]||[type isEqualToString:@"12"]) {
                            [buttonsArray addObject:[butt objectAtIndex:index]];
                        }

                        
                    }
                  if (index==butt.count-1) {
                        
                        NSDictionary* processBtn = [NSDictionary dictionaryWithObjectsAndKeys:@"-2",@"@Type",@"流程信息",@"Name", nil];
                        
                        [buttonsArray addObject:processBtn];
                        
                    }
                }
                NSLog(@"DATA+=======%@",[dictt objectForKey:@"Data"]);
                IsAdd = [[dictt objectForKey:@"Data"] objectForKey:@"ISADD"];
                DataType = [[dictt objectForKey:@"Data"] objectForKey:@"DATATYPE"];
                VIRTUALPATH = [[dictt objectForKey:@"Data"] objectForKey:@"VIRTUALPATH"];
                [upTable reloadData];
                [self inituptable];
              
            }else{
                if ([[dictt objectForKey:@"Data"] objectForKey:@"BUTTONS"]==nil||[[[dictt objectForKey:@"Data"] objectForKey:@"BUTTONS"] isEqual:[NSNull null]]||[[[dictt objectForKey:@"Data"] objectForKey:@"BUTTONS"] isEqualToString:@""]) {
                    [SVProgressHUD showErrorWithStatus:@"数据已不存在"];
                }
            }
        }else{
            buttonsArray = [[NSMutableArray alloc] init];
            NSDictionary* processBtn = [NSDictionary dictionaryWithObjectsAndKeys:@"-2",@"@Type",@"流程信息",@"Name", nil];
            
            [buttonsArray addObject:processBtn];
            [self inituptable];
            //            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}
-(void)inituptable{
    alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LWidth, LHeight)];
    alertView.hidden = YES;
    alertView.backgroundColor = [UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:0.3];
    [self.view addSubview:alertView];
    upTable = [[UITableView alloc] initWithFrame:CGRectMake(30, 5, LWidth-60, LHeight-104)];
    upTable.delegate = self;
    upTable.dataSource = self;
    upTable.sectionHeaderHeight = 30.0f;
    upTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [upTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    upTable.frame = CGRectMake(upTable.frame.origin.x, upTable.frame.origin.y, upTable.frame.size.width, buttonsArray.count*44);
    [alertView addSubview:upTable];
    [self.view bringSubviewToFront:alertView];


}
#pragma mark=== 右上角按钮的表代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [buttonsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"CellIdentifier";
    Task_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Task_TableViewCell" owner:nil options:nil];
        for (id oneObject in nib)
        {
            if ([oneObject isKindOfClass:[Task_TableViewCell class]])
            {
                cell = (Task_TableViewCell *)oneObject;
            }
        }
    }
    cell.title.text = [[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"Name"];
    return cell;
}
//右上角表代理进入流程
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   if ([[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"@Type"] isEqualToString:@"2"]) {
        commIndex = indexPath.row;
        [self editComments:@""];
   }else if ([[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"@Type"] isEqualToString:@"4"]){
       commIndex = indexPath.row;
       if ([[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"OrgExpression"]==nil||[[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"OrgExpression"] isEqualToString:@""]||[[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"OrgExpression"] isEqual:[NSNull null]]) {
           [self alertActionPeople:nil data:nil userId:nil type:@"4"];
       }else{
           NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"PARSEORGEXPRESSION",@"Action",[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"OrgExpression"],@"EXPRESSION",[showDictA objectForKey:@"HGUID"],@"HGUID",dataguid,@"DATAGUID", nil];
           
           NSLog(@"dict=======%@",dict);
           
           
           [self alertActionPeople:nil data:dict userId:nil type:@"4"];
       }
   }else  if ([[[buttonsArray objectAtIndex:indexPath.row] objectForKey:@"@Type"] isEqualToString:@"-2"]) {
                     NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETOPINIONLISTBYDATAGUID",@"Action",dataguid,@"DATAGUID", nil];
           NSString* url = [NSString stringWithFormat:@"http://%@%@/WorkFlowWebDesigner/Mobile/FlowInfo/WorkFlowGraph.aspx?FlowGuid=%@&FlowVersion=%@&FlowInstance=%@",HTTPIP,SLRD,self.FLOWGUID,[showDictA objectForKey:@"FLOWVERSION"],[showDictA objectForKey:@"FLOWINSTANCEGUID"]];
           InformationViewController* vc =[[InformationViewController alloc] initWithUrl:url list:dict];
       
           [self.navigationController pushViewController:vc animated:YES];
      
       }

   
   
}

#pragma mark ---------------------------------- 选择执行人
- (void)alertActionPeople:(NSString *)aStr data:(NSDictionary *)dict userId:(NSString *)userStr type:(NSString *)aType
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"选择执行者"] message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* determine = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //提交
        if (alert.textFields[0].text==nil||[alert.textFields[0].text isEqualToString:@""]||[alert.textFields[0].text isEqual:[NSNull null]]) {
            [SVProgressHUD showErrorWithStatus:@"请选择执行者"];
        }else{
            if ([aType isEqualToString:@"4"]) {
                [self editComments:userStr];
            }
        }
    }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction* push = [UIAlertAction actionWithTitle:@"选择执行者" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (dict == nil) {
            PeopleViewController* peopleVC =[[PeopleViewController alloc] initWithType:aType];
            peopleVC.delegate = self;
            [self.navigationController pushViewController:peopleVC animated:YES];
        }else{
            PerplelistViewController* peropleVC = [[PerplelistViewController alloc] initWithDict:dict type:aType];
            peropleVC.delegate = self;
            [self.navigationController pushViewController:peropleVC animated:YES];
        }
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor blueColor];
        textField.text = aStr;
        textField.userInteractionEnabled = NO;
    }];
    [self presentViewController:alert animated:YES completion:nil];
    [alert addAction:push];
    [alert addAction:determine];
    [alert addAction:cancel];
}
- (void)backUpDataViewController:(NSArray *)array data:(NSDictionary *)dict type:(NSString *)aType
{
    NSString* name = @"";
    NSString* userid = @"";
    for (NSInteger index = 0; index < array.count; index ++) {
        PeopleModel* model = array[index];
        if (index==0) {
            name = [model.data objectForKey:@"FDISPLAYNAME"];
            userid = [NSString stringWithFormat:@"1|%@||",[model.data objectForKey:@"FGUID"]];
        }else{
            name = [NSString stringWithFormat:@"%@,%@",name,[model.data objectForKey:@"FDISPLAYNAME"]];
            userid = [NSString stringWithFormat:@"%@,%@",userid,[NSString stringWithFormat:@"1|%@||",[model.data objectForKey:@"FGUID"]]];
        }
    }
    [self alertActionPeople:name data:dict userId:userid type:aType];
}
- (void)All_backUpDataViewController:(NSArray *)array data:(NSDictionary *)dict type:(NSString *)aType
{
    NSString* name = @"";
    NSString* userid = @"";
    for (NSInteger index = 0; index < array.count; index ++) {
        if (index==0) {
            name = [array[index] objectForKey:@"FDISPLAYNAME"];
            if ([aType isEqualToString:@"12"]) {
                userid = [NSString stringWithFormat:@"%@",[array[index] objectForKey:@"FGUID"]];
            }else{
                userid = [NSString stringWithFormat:@"1|%@||",[array[index] objectForKey:@"FGUID"]];
            }
        }else{
            name = [NSString stringWithFormat:@"%@,%@",name,[array[index] objectForKey:@"FDISPLAYNAME"]];
            if ([aType isEqualToString:@"12"]) {
                userid = [NSString stringWithFormat:@"%@,%@",userid,[NSString stringWithFormat:@"%@",[array[index] objectForKey:@"FGUID"]]];
            }else{
                userid = [NSString stringWithFormat:@"%@,%@",userid,[NSString stringWithFormat:@"1|%@||",[array[index] objectForKey:@"FGUID"]]];
            }
        }
    }
    [self alertActionPeople:name data:dict userId:userid type:aType];
}

#pragma mark ---------------------------------- 填写意见并提交
- (void)editComments:(NSString *)user
{
    userInfoId = user;
    Comments = [[UIView alloc] init];
    Comments.frame = CGRectMake(0, 0, LWidth, LHeight);
    Comments.backgroundColor = [UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:0.3];
    [self.view addSubview:Comments];
    [self.view bringSubviewToFront:Comments];
    
    chooseCB = [[UIView alloc] initWithFrame:CGRectMake(30, 50, LWidth-60, 260)];
    chooseCB.backgroundColor = [UIColor whiteColor];
    chooseCB.layer.masksToBounds = YES;
    chooseCB.layer.cornerRadius = 6;
    chooseCB.layer.borderColor = [[UIColor colorWithRed:0.773 green:0.780 blue:0.776 alpha:1] CGColor];
    chooseCB.layer.borderWidth = .5f;
    [Comments addSubview:chooseCB];
    
    UILabel* titleD = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, chooseCB.frame.size.width, 30)];
    titleD.textAlignment = NSTextAlignmentCenter;
    titleD.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    titleD.text = @"填写意见";
    titleD.font = [UIFont systemFontOfSize:15];
    [chooseCB addSubview:titleD];
    
    chooseCom = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseCom.frame = CGRectMake(30, chooseCB.frame.origin.y+30, chooseCB.frame.size.width, 30);
    chooseCom.backgroundColor = [UIColor whiteColor];
    chooseCom.userInteractionEnabled = NO;
    [Comments addSubview:chooseCom];
    
    textview = [[UITextView alloc] initWithFrame:CGRectMake(5, 70, chooseCB.frame.size.width-10, 150)];
    textview.layer.masksToBounds = YES;
    textview.layer.cornerRadius = 6;
    textview.text = @"同意";
    textview.delegate = self;
    textview.layer.borderColor = [[UIColor colorWithRed:0.773 green:0.780 blue:0.776 alpha:1] CGColor];
    textview.layer.borderWidth = 1;
    [chooseCB addSubview:textview];
    
    UIButton* left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(0, 225, chooseCB.frame.size.width/2, 30);
    left.backgroundColor = [UIColor whiteColor];
    left.titleLabel.font = [UIFont systemFontOfSize:15];
    [left setTitle:@"确定" forState:0];
    left.tag = 0;
    [left setTitleColor:[UIColor blueColor] forState:0];
    
    [left addTarget:self action:@selector(upDataCom:) forControlEvents:UIControlEventTouchUpInside];
    
    [chooseCB addSubview:left];
    
    UIButton* right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(chooseCB.frame.size.width/2, 225, chooseCB.frame.size.width/2, 30);
    right.backgroundColor = [UIColor whiteColor];
    right.titleLabel.font = [UIFont systemFontOfSize:15];
    right.tag = 1;
    [right setTitle:@"取消" forState:0];
    [right setTitleColor:[UIColor blueColor] forState:0];
    [right addTarget:self action:@selector(upDataCom:) forControlEvents:UIControlEventTouchUpInside];
    [chooseCB addSubview:right];
    
    [self initdropDownMenu];
}
- (void)initdropDownMenu
{
    NSMutableArray *dropdownItems = [[NSMutableArray alloc] init];
    NSArray* array = @[@"同意",@"阅",@"请领导阅示",@"照此办理",@"请领导批示",@"打回",@"先放着",@"不同意"];
    for (int i = 0; i < array.count; i++) {
        IGLDropDownItem *item = [[IGLDropDownItem alloc] init];
        [item setText:array[i]];
        [dropdownItems addObject:item];
    }
    
    self.dropDownMenu = [[IGLDropDownMenu alloc] init];
    self.dropDownMenu.menuText = @"【选择意见】";
    self.dropDownMenu.dropDownItems = dropdownItems;
    self.dropDownMenu.paddingLeft = 15;
    [self.dropDownMenu setFrame:chooseCom.frame];
    self.dropDownMenu.delegate = self;
    [self setUpParamsForDemo];
    [self.dropDownMenu reloadView];
    [Comments addSubview:self.dropDownMenu];
    [Comments bringSubviewToFront:self.dropDownMenu];
}
- (void)setUpParamsForDemo
{
    self.dropDownMenu.type = IGLDropDownMenuTypeNormal;
    self.dropDownMenu.flipWhenToggleView = YES;
}
#pragma mark - IGLDropDownMenuDelegate
- (void)selectedItemAtIndex:(NSInteger)index
{
    IGLDropDownItem *item = self.dropDownMenu.dropDownItems[index];
    textview.text = item.text;
}
- (void)upDataCom:(UIButton *)sender
{
    
    switch (sender.tag) {
        case 0:
        {
            [self commit];

        }
            break;
        case 1:
        {
            [self.view endEditing:YES];
            [Comments removeFromSuperview];
        }
            break;
            
        default:
            break;
    }
}
//提交
-(void)commit{
    
    if (![[self XMLstring] isEqualToString:@""]) {
        NSString* nullStr = @"";
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setObject:textview.text forKey:@"OpinionInfo"];
        [dict setObject:@"RUNFLOW" forKey:@"Action"];
        [dict setObject:[self XMLstring] forKey:@"FormInfo"];
        [dict setObject:dataguid forKey:@"DataGuid"];
        [dict setObject:[showDictA objectForKey:@"HGUID"] forKey:@"HGuid"];
        [dict setObject:[showDictA objectForKey:@"PROCESSGUID"] forKey:@"ProcessGuid"];
        [dict setObject:IsAdd forKey:@"IsAdd"];
        [dict setObject:[[buttonsArray objectAtIndex:commIndex] objectForKey:@"RouteId"] forKey:@"RouteId"];
        [dict setObject:[showDictA objectForKey:@"VIRTUALPATH"] forKey:@"VIRTUALPATH"];
        [dict setObject:[showDictA objectForKey:@"DATATYPE"]  forKey:@"DataType"];
        [dict setObject:[showDictA objectForKey:@"FLOWGUID"] forKey:@"FlowGuid"];
        [dict setObject:nullStr forKey:@"TaskRemark"];
        [dict setObject:nullStr forKey:@"AddInfo"];
        [dict setObject:nullStr forKey:@"TaskTitle"];
        [dict setObject:userInfoId forKey:@"SendToUsers"];
        [dict setObject:nullStr forKey:@"WorkFlowApprove"];
        [dict setObject:nullStr forKey:@"LimitTime"];
        [self request:[NSDictionary dictionaryWithDictionary:dict]];
        [self.view endEditing:YES];
        [Comments removeFromSuperview];
      }

}
- (void)request:(NSDictionary *)dict
{
    [SVProgressHUD showWithStatus:@"提交中..."];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/%@",HTTPIP,SLRD,MOBILE_URL] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
            if ([self.delegate respondsToSelector:@selector(pushVehicAppVC)]) {
                [self.delegate pushVehicAppVC];
            }
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}


@end