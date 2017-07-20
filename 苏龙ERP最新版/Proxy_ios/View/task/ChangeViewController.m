//
//  ChangeViewController.m
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/30.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "ChangeViewController.h"

@interface ChangeViewController () <UIPickerViewDataSource,UIPickerViewDelegate>
{
    CGRect xmlContens;
    UILabel* contens;
    NSArray* dataArray;
    NSInteger timeIndex;
    NSInteger dateTimeIndex;
    UIView* pView;
    UIView* pDView;
    UIView* pDTView;
    UIDatePicker* datePicker;
    UIDatePicker* dateTimePicker;
    UIPickerView* pickView;
    NSString* timeStr;
    NSArray* whenArray;
    NSMutableArray* pointsArray;
    NSString* titleStr;
}
@end

@implementation ChangeViewController
- (id)initWithXmlStr:(NSString *)xml data:(NSDictionary *)aData type:(NSArray *)aType title:(NSString *)aTitle
{
    self = [super init];
    if (self) {
        xmlStr = xml;
        data = aData;
        dataArray = aType;
        titleStr = aTitle;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[App ddMenu] setEnableGesture:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = titleStr;
    
    [self timeView];
    whenArray = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
    pointsArray = [[NSMutableArray alloc] init];
    for (NSInteger index = 01; index < 60; index ++) {
        NSString* time = [NSString stringWithFormat:@"%ld",(long)index];
        if (index<10) {
            time = [NSString stringWithFormat:@"0%@",time];
        }
        [pointsArray addObject:time];
    }
    [self dateTimeView];
    
    [self initView];
}
- (void)initView
{
//    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc]
//                                    initWithTitle:@"返回"
//                                    style:UIBarButtonItemStyleDone
//                                    target:self
//                                    action:@selector(go_back)];
//    
//    [leftButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                        [UIFont systemFontOfSize:15], NSFontAttributeName,
//                                        [UIColor whiteColor], NSForegroundColorAttributeName,
//                                        nil]
//                              forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem = leftButton;
    
    typeArray = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < dataArray.count; index ++) {
        if ([[dataArray[index] objectForKey:@"APPDBFIELDSHOW"] isEqualToString:@"true"]) {
            [typeArray addObject:dataArray[index]];
        }
    }
    
    //    xml控件
    for (NSInteger m = 0; m < typeArray.count; m ++) {
        UIButton* xmlView = [UIButton buttonWithType:UIButtonTypeCustom];
        xmlView.tag = m+1000;
        NSString* isEdit = [[NSString stringWithFormat:@"%@",[typeArray[m] objectForKey:@"APPDBFIELDEDIT"]] stringByReplacingOccurrencesOfString:@"_" withString:@""];
        xmlView.userInteractionEnabled = [isEdit isEqual:@"true"]?YES:NO;
        [xmlView addTarget:self action:@selector(editDataClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:xmlView];
        if ([titleStr isEqualToString:@"查看"]) {
            xmlView.userInteractionEnabled = NO;
        }
        
        UILabel* title = [[UILabel alloc] init];
        title.textAlignment = NSTextAlignmentLeft;
        title.tag = 1008611;
        title.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        title.text = [NSString stringWithFormat:@"%@:",[typeArray[m] objectForKey:@"APPDBFIELDLABEL"]];
        title.font = [UIFont systemFontOfSize:14];
        CGSize titleSize = [self sizeWithStringTitle:[NSString stringWithFormat:@"%@:",[typeArray[m] objectForKey:@"APPDBFIELDLABEL"]] font:title.font sizwLwidth:LWidth/2];
        title.frame = CGRectMake(5, 8, titleSize.width, titleSize.height);
        [xmlView addSubview:title];
        
        contens = [[UILabel alloc] init];
        contens.textAlignment = NSTextAlignmentLeft;
        contens.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
        contens.numberOfLines = 0;
        contens.font = [UIFont systemFontOfSize:14];
        contens.tag = m+101;
        if ([[typeArray[m] objectForKey:@"APPDBFIELDCONTROL"] isEqualToString:@"4"]) {
            if ([[data objectForKey:[typeArray[m] objectForKey:@"APPDBFIELDNAME"]] length]>10) {
                contens.text = [[[data objectForKey:[typeArray[m] objectForKey:@"APPDBFIELDNAME"]] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringWithRange:NSMakeRange(0,10)];
            }else{
                contens.text = [data objectForKey:[typeArray[m] objectForKey:@"APPDBFIELDNAME"]];
            }
        }else if ([[typeArray[m] objectForKey:@"APPDBFIELDCONTROL"] isEqualToString:@"5"]) {
            if ([[data objectForKey:[typeArray[m] objectForKey:@"APPDBFIELDNAME"]] length]>19) {
                contens.text = [[[data objectForKey:[typeArray[m] objectForKey:@"APPDBFIELDNAME"]] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringWithRange:NSMakeRange(0,19)];
            }else{
                contens.text = [data objectForKey:[typeArray[m] objectForKey:@"APPDBFIELDNAME"]];
            }
        }else if([[typeArray[m] objectForKey:@"APPDBFIELDCONTROL"] isEqualToString:@"2"]){
          
            NSString *str=[data objectForKey:[typeArray[m] objectForKey:@"APPDBFIELDNAME"]];
            if ([str containsString:@"."]) {
                //  格式化
                NSInteger a=[[typeArray[m] objectForKey:@"APPDBFIELDFORMAT"]length]-2;
                
                float b =[str floatValue];
                switch (a) {
                    case 1:
                    {
                        contens.text =[NSString stringWithFormat:@"%.1f",b];
                        
                    }
                        
                    case 2:
                    {
                        contens.text =[NSString stringWithFormat:@"%.2f",b];
                        
                    }
                        break;
                    case 3:
                    {
                        contens.text =[NSString stringWithFormat:@"%.3f",b];
                    }
                        break;
                    case 4:
                    {
                        contens.text =[NSString stringWithFormat:@"%.4f",b];
                        
                    }
                        break;
                        
                    case 5:
                    { contens.text =[NSString stringWithFormat:@"%.5f",b];
                        
                    }
                        break;
                        
                        
                }
                
                
            }
            else{
                contens.text=str;
            }
        }
        else{
            
            contens.text = [data objectForKey:[typeArray[m]objectForKey:@"APPDBFIELDNAME"]];
            
            
        }
        NSString* strMR = [NSString stringWithFormat:@"%@",[typeArray[m] objectForKey:@"APPDBFIELDDEFAULT"]==nil||[[typeArray[m] objectForKey:@"APPDBFIELDDEFAULT"] isEqual:[NSNull null]]?@"0":[typeArray[m] objectForKey:@"APPDBFIELDDEFAULT"]];
        if ([strMR isEqualToString:@"0"]) {
        }else if ([strMR isEqualToString:@"1"]) {
            contens.text = USERNAME;
        }else if ([strMR isEqualToString:@"2"]) {
            contens.text = USERGUID;
        }else if ([strMR isEqualToString:@"3"]) {
            NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSString *currentTime = [formatter stringFromDate:[NSDate date]];
            contens.text = [NSString stringWithFormat:@"%@",currentTime];
        }else if ([strMR isEqualToString:@"4"]) {
            contens.text = @"同意";
        }
        if ([isEdit isEqual:@"true"]) {
            contens.textColor = [UIColor blackColor];
        }
        CGSize btnSize = [self sizeWithStringTitle:contens.text font:title.font sizwLwidth:LWidth-15-(title.frame.size.width+title.frame.origin.x)];
        contens.frame = CGRectMake(title.frame.size.width+10, 8, btnSize.width, btnSize.height);
        
        [xmlView addSubview:contens];
        
        float y = title.frame.size.height>contens.frame.size.height?title.frame.size.height+title.frame.origin.y:contens.frame.size.height+contens.frame.origin.y;
        xmlView.frame = CGRectMake(0, m==0?0:xmlContens.size.height+xmlContens.origin.y, LWidth, y+9);
        
        UIImageView* row = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
        row.frame = CGRectMake(0, xmlView.frame.size.height-1, LWidth, 1);
        row.alpha = 0.4;
        row.tag = m+100;
        [xmlView addSubview:row];
        [xmlView bringSubviewToFront:row];
        xmlContens = xmlView.frame;
    }
    
    if ([titleStr isEqualToString:@"查看"]) {
        UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
        back.backgroundColor = [UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1];
        back.frame = CGRectMake(20, xmlContens.size.height+xmlContens.origin.y+10, (LWidth-40), 30);
        [back setTitle:@"取消" forState:0];
        back.layer.cornerRadius = 3;
        back.layer.masksToBounds = YES;
        [back setTitleColor:[UIColor whiteColor] forState:0];
        [back addTarget:self action:@selector(go_back) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:back];
    }else{
        UIButton* updata = [UIButton buttonWithType:UIButtonTypeCustom];
        updata.backgroundColor = [UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1];
        updata.frame = CGRectMake(20, xmlContens.size.height+xmlContens.origin.y+10, (LWidth-60)/2, 30);
        [updata setTitle:@"保存" forState:0];
        updata.layer.cornerRadius = 3;
        updata.layer.masksToBounds = YES;
        [updata setTitleColor:[UIColor whiteColor] forState:0];
        [updata addTarget:self action:@selector(upDataRequest) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:updata];
        
        UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
        back.backgroundColor = [UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1];
        back.frame = CGRectMake(40+((LWidth-60)/2), xmlContens.size.height+xmlContens.origin.y+10, (LWidth-60)/2, 30);
        [back setTitle:@"取消" forState:0];
        back.layer.masksToBounds = YES;
        back.layer.cornerRadius = 3;
        [back setTitleColor:[UIColor whiteColor] forState:0];
        [back addTarget:self action:@selector(go_back) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:back];
    }
}
- (void)editDataClick:(UIButton *)sender
{
    if ([[typeArray[sender.tag-1000] objectForKey:@"APPDBFIELDCONTROL"] isEqualToString:@"4"]) {
        timeIndex = sender.tag;
        [self.view bringSubviewToFront:pView];
        [UIView animateWithDuration:0.25 animations:^{
            pView.frame = CGRectMake(0, LHeight-255, LWidth, 190);
        }];
    }else if ([[typeArray[sender.tag-1000] objectForKey:@"APPDBFIELDCONTROL"] isEqualToString:@"5"]) {
        dateTimeIndex = sender.tag;
        [self.view bringSubviewToFront:pDTView];
        [UIView animateWithDuration:0.25 animations:^{
            pDTView.frame = CGRectMake(0, LHeight-255, LWidth, 190);
        }];
    }else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"修改（%@）信息",[typeArray[sender.tag-1000] objectForKey:@"APPDBFIELDLABEL"]] message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* determine = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self refactoringView:sender.tag contens:alert.textFields[0].text];
        }];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            for (id view in [sender subviews]) {
                if ([view isKindOfClass:[UILabel class]]) {
                    UILabel* mobileLabel = (UILabel *)view;
                    if (mobileLabel.tag == sender.tag-899) {
                        textField.text = mobileLabel.text;
                    }
                }
            }
            textField.textColor = [UIColor blueColor];
            if ([[typeArray[sender.tag-1000] objectForKey:@"APPDBFIELDCONTROL"] isEqualToString:@"2"])textField.keyboardType = UIKeyboardTypeNumberPad;;
        }];
        [self presentViewController:alert animated:YES completion:nil];
        [alert addAction:determine];
        [alert addAction:cancel];
    }
}
- (CGSize)sizeWithStringTitle:(NSString *)string font:(UIFont *)font sizwLwidth:(float)width
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, LHeight)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  | NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    return rect.size;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)upDataRequest
{
    [SVProgressHUD showWithStatus:@"修改中..."];
    NSString* xmlB = @"";
    for (NSInteger index = 0; index < typeArray.count; index ++) {
        UILabel* lable = [contens viewWithTag:index+101];
        if (index==0) {
            xmlB = [NSString stringWithFormat:@"<%@ type='%@'>%@</%@>",[typeArray[index] objectForKey:@"APPDBFIELDNAME"],[typeArray[index] objectForKey:@"APPDBFIELDCONTROL"],[self uilabelTextStr],[typeArray[index] objectForKey:@"APPDBFIELDNAME"]];
        }else{
            xmlB = [NSString stringWithFormat:@"%@<%@ type='%@'>%@</%@>",xmlB,[typeArray[index] objectForKey:@"APPDBFIELDNAME"],[typeArray[index] objectForKey:@"APPDBFIELDCONTROL"],lable.text,[typeArray[index] objectForKey:@"APPDBFIELDNAME"]];
        }
    }
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@%@</Data>",xmlStr,xmlB],@"FormInfo",@"SAVEFORMOTHER",@"Action", nil];
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@</Data>",xmlStr,xmlB]);
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/%@",HTTPIP,SLRD,MOBILE_URL] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            NSNotification *notification =[NSNotification notificationWithName:@"change" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}
- (void)go_back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSString *)uilabelTextStr
{
    for (id view in [self.view subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* mobileView = (UIButton *)view;
            if (mobileView.tag==1000) {
                for (id aView in [mobileView subviews]) {
                    if ([aView isKindOfClass:[UILabel class]]) {
                        UILabel* mobileLabel = (UILabel *)aView;
                        if (mobileLabel.tag == 101) {
                            return mobileLabel.text;
                        }
                    }
                }
            }
        }
    }
    return nil;
}
- (void)refactoringView:(NSInteger)tag contens:(NSString *)str
{
    for (id view in [self.view subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* mobileView = (UIButton *)view;
            float y = 0.0;
            if (mobileView.tag==tag) {
                for (id aView in [mobileView subviews]) {
                    if ([aView isKindOfClass:[UILabel class]]) {
                        UILabel* mobileLabel = (UILabel *)aView;
                        if (mobileLabel.tag == tag-899) {
                            mobileLabel.text = str;
                            CGSize size = [self sizeWithStringTitle:str font:[UIFont systemFontOfSize:15] sizwLwidth:LWidth-15-mobileLabel.frame.origin.x];
                            y = size.height>mobileLabel.frame.size.height?mobileLabel.frame.origin.y+size.height+9:mobileView.frame.origin.y;
                            mobileLabel.frame = CGRectMake(mobileLabel.frame.origin.x, mobileLabel.frame.origin.y, size.width, size.height);
                            mobileView.frame = CGRectMake(mobileView.frame.origin.x, mobileView.frame.origin.y, LWidth, size.height+18);
                            xmlContens = mobileView.frame;
                        }
                    }
                }
                for (id aView in [mobileView subviews]) {
                    if ([aView isKindOfClass:[UIImageView class]]) {
                        UIImageView* mobileIV = (UIImageView *)aView;
                        if (mobileIV.tag == tag-899) {
                            mobileIV.frame = CGRectMake(0, xmlContens.size.height-1, LWidth, 1);
                        }
                    }
                }
            }
            if (mobileView.tag>tag) {
                mobileView.frame = CGRectMake(mobileView.frame.origin.x, xmlContens.origin.y+xmlContens.size.height, LWidth, mobileView.frame.size.height);
                xmlContens = mobileView.frame;
            }
        }
    }
}


/**************************************************************************************************/
//    日期
/**************************************************************************************************/
- (void)timeView
{
    pView = [[UIView alloc] initWithFrame:CGRectMake(0, LHeight, LWidth, 190)];
    pView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pView];
    
    //    取消按钮
    UIButton* returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(10, 0, 50, 30);
    returnBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [returnBtn setTitle:@"取消" forState:0];
    [returnBtn setTitleColor:[UIColor colorWithRed:0.000 green:0.800 blue:0.600 alpha:1] forState:0];
    [returnBtn addTarget:self action:@selector(returnBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [pView addSubview:returnBtn];
    
    //    确定按钮
    UIButton* endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    endBtn.frame = CGRectMake(LWidth-60, 0, 50, 30);
    endBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [endBtn setTitle:@"完成" forState:0];
    [endBtn setTitleColor:[UIColor colorWithRed:0.000 green:0.800 blue:0.600 alpha:1] forState:0];
    [endBtn addTarget:self action:@selector(endBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [pView addSubview:endBtn];
    
    //    横线
    UIImageView* bgimagViewA = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
    bgimagViewA.frame = CGRectMake(0, 0, LWidth, 2);
    [pView addSubview:bgimagViewA];
    UIImageView* bgimagViewB = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
    bgimagViewB.frame = CGRectMake(0, 28, LWidth, 2);
    [pView addSubview:bgimagViewB];
    
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, LWidth, 160)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    datePicker.minuteInterval = 5;
    datePicker.backgroundColor = [UIColor whiteColor];
    [pView addSubview:datePicker];
}
- (void)returnBtnClick
{
    [UIView animateWithDuration:0.25 animations:^{
        pView.frame = CGRectMake(0, LHeight, LWidth, 190);
    }];
}
- (void)endBtnClick
{
    [UIView animateWithDuration:0.25 animations:^{
        pView.frame = CGRectMake(0, LHeight, LWidth, 190);
    }];
    NSDate *select = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
    [self refactoringView:timeIndex contens:dateAndTime];
}

/**************************************************************************************************/
//    日期+时间
/**************************************************************************************************/
- (void)dateTimeView
{
    pDTView = [[UIView alloc] initWithFrame:CGRectMake(0, LHeight, LWidth, 190)];
    pDTView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pDTView];
    
    UILabel* labtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, LWidth, 20)];
    labtitle.text = @"选择日期";
    labtitle.textAlignment = NSTextAlignmentCenter;
    labtitle.textColor = [UIColor blackColor];
    labtitle.font = [UIFont systemFontOfSize:15];
    labtitle.backgroundColor = [UIColor clearColor];
    [pDTView addSubview:labtitle];
    //    取消按钮
    UIButton* returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(10, 0, 50, 30);
    returnBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [returnBtn setTitle:@"取消" forState:0];
    [returnBtn setTitleColor:[UIColor colorWithRed:0.000 green:0.800 blue:0.600 alpha:1] forState:0];
    [returnBtn addTarget:self action:@selector(returnDTBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [pDTView addSubview:returnBtn];
    
    //    确定按钮
    UIButton* endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    endBtn.frame = CGRectMake(LWidth-60, 0, 50, 30);
    endBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [endBtn setTitle:@"完成" forState:0];
    [endBtn setTitleColor:[UIColor colorWithRed:0.000 green:0.800 blue:0.600 alpha:1] forState:0];
    [endBtn addTarget:self action:@selector(endBtnDTClick) forControlEvents:UIControlEventTouchUpInside];
    [pDTView addSubview:endBtn];
    
    //    横线
    UIImageView* bgimagViewA = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
    bgimagViewA.frame = CGRectMake(0, 0, LWidth, 2);
    [pDTView addSubview:bgimagViewA];
    UIImageView* bgimagViewB = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
    bgimagViewB.frame = CGRectMake(0, 28, LWidth, 2);
    [pDTView addSubview:bgimagViewB];
    
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    dateTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, LWidth, 160)];
    dateTimePicker.datePickerMode = UIDatePickerModeDate;
    [dateTimePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    dateTimePicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    dateTimePicker.minuteInterval = 5;
    dateTimePicker.backgroundColor = [UIColor whiteColor];
    [pDTView addSubview:dateTimePicker];
}
- (void)dateView
{
    timeStr = nil;
    [pDView removeFromSuperview];
    pDView = [[UIView alloc] initWithFrame:CGRectMake(0, LHeight, LWidth, 190)];
    pDView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pDView];
    
    UILabel* labtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, LWidth, 20)];
    labtitle.text = @"选择时分";
    labtitle.textAlignment = NSTextAlignmentCenter;
    labtitle.textColor = [UIColor blackColor];
    labtitle.font = [UIFont systemFontOfSize:15];
    labtitle.backgroundColor = [UIColor clearColor];
    [pDView addSubview:labtitle];
    //    取消按钮
    UIButton* returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(10, 0, 50, 30);
    returnBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [returnBtn setTitle:@"取消" forState:0];
    [returnBtn setTitleColor:[UIColor colorWithRed:0.000 green:0.800 blue:0.600 alpha:1] forState:0];
    [returnBtn addTarget:self action:@selector(returnDBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [pDView addSubview:returnBtn];
    
    //    确定按钮
    UIButton* endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    endBtn.frame = CGRectMake(LWidth-60, 0, 50, 30);
    endBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [endBtn setTitle:@"完成" forState:0];
    [endBtn setTitleColor:[UIColor colorWithRed:0.000 green:0.800 blue:0.600 alpha:1] forState:0];
    [endBtn addTarget:self action:@selector(endBtnDClick) forControlEvents:UIControlEventTouchUpInside];
    [pDView addSubview:endBtn];
    
    //    横线
    UIImageView* bgimagViewA = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
    bgimagViewA.frame = CGRectMake(0, 0, LWidth, 2);
    [pDView addSubview:bgimagViewA];
    UIImageView* bgimagViewB = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
    bgimagViewB.frame = CGRectMake(0, 28, LWidth, 2);
    [pDView addSubview:bgimagViewB];
    
    
    pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, LWidth, 160)];
    pickView.backgroundColor = [UIColor whiteColor];
    pickView.delegate = self;
    pickView.dataSource = self;
    [pickView selectRow:0 inComponent:0 animated:YES];
    [pDView addSubview:pickView];
    
    [UIView animateWithDuration:0.25 animations:^{
        pDView.frame = CGRectMake(0, LHeight-255, LWidth, 190);
    }];
    [self.view bringSubviewToFront:pDView];
}
- (void)returnDTBtnClick
{
    [UIView animateWithDuration:0.25 animations:^{
        pDTView.frame = CGRectMake(0, LHeight, LWidth, 190);
    }];
}
- (void)endBtnDTClick
{
    [UIView animateWithDuration:0.25 animations:^{
        pDTView.frame = CGRectMake(0, LHeight, LWidth, 190);
    } completion:^(BOOL finished) {
        [self dateView];
    }];
}
- (void)returnDBtnClick
{
    [UIView animateWithDuration:0.25 animations:^{
        pDView.frame = CGRectMake(0, LHeight, LWidth, 190);
    }];
}
- (void)endBtnDClick
{
    [UIView animateWithDuration:0.25 animations:^{
        pDView.frame = CGRectMake(0, LHeight, LWidth, 190);
    }];
    NSDate *select = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
    
    if (timeStr==nil||[timeStr isEqualToString:@""]||[timeStr isEqual:[NSNull null]]) {
        timeStr = [NSString stringWithFormat:@"%@ 00:00:00",dateAndTime];
    }else{
        timeStr = [NSString stringWithFormat:@"%@ %@:00",dateAndTime,timeStr];
    }
    [self refactoringView:dateTimeIndex contens:timeStr];
}
#pragma mark ----------------------------- pickview
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 24;
    }else{
        return 60;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return whenArray[row];
    }else{
        return pointsArray[row];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString* timeh = @"";
    NSString* timem = @"";
    if (component == 0) {
        timeh = whenArray[row];
    }else{
        timem = pointsArray[row];
    }
    timeStr = [NSString stringWithFormat:@"%@:%@",timeh==nil||[timeh isEqualToString:@""]||[timeh isEqual:[NSNull null]]?whenArray[0]:timeh,timem==nil||[timem isEqualToString:@""]||[timem isEqual:[NSNull null]]?pointsArray[0]:timem];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
    }
    return YES;
}
@end
