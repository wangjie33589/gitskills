//
//  JPullDownMenu.m
//  JPullDownMenuDemo
//
//  Created by 开发者 on 16/5/19.
//  Copyright © 2016年 jinxiansen. All rights reserved.
//

#import "JPullDownMenu.h"
#import <objc/runtime.h>

#define Kscreen_width  [UIScreen mainScreen].bounds.size.width
#define Kscreen_height [UIScreen mainScreen].bounds.size.height
#define KTitleButtonHeight 40

// 格式 0xff3737
#define RGBHexAlpha(rgbValue,a) [UIColor colorWithRed:0.01 green:0.66 blue:1 alpha:1]

#define KDefaultColor RGBHexAlpha(0x189cfb, 1)

#define KmaskBackGroundViewColor  [UIColor colorWithRed:40/255 green:40/255 blue:40/255 alpha:.2]
#define kCellBgColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:.7]

#define KTableViewCellHeight 40

#define KDisplayMaxCellOfNumber  5

#define KTitleButtonTag 0


#define KOBJCSetObject(object,value)  objc_setAssociatedObject(object,@"title" , value, OBJC_ASSOCIATION_RETAIN_NONATOMIC)

#define KOBJCGetObject(object) objc_getAssociatedObject(object, @"title")

@interface JPullDownMenu () <UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *_deleteData;
   
}

@property (nonatomic) UIButton  *tempButton;

@property (nonatomic) NSArray *titleArray ;

@property (nonatomic)UITableView *tableView;
@property (nonatomic)NSMutableArray *tableDataArray;

@property (nonatomic) CGFloat selfOriginalHeight ;
@property (nonatomic) CGFloat tableViewMaxHeight ;

@property (nonatomic) NSMutableArray *buttonArray;

@property (nonatomic) UIView  *maskBackGroundView;

@end

@implementation JPullDownMenu


- (instancetype)initWithFrame:(CGRect)frame menuTitleArray:(NSArray *)titleArray
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.tableViewMaxHeight = KTableViewCellHeight * KDisplayMaxCellOfNumber;
        self.selfOriginalHeight =frame.size.height;
        self.titleArray =titleArray;
        self.showSelectTitleAtButton = YES;
        
        [self addSubview:self.maskBackGroundView];
        [self addSubview:self.tableView];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selecteduserid"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"beforDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"wo-------");
        [self initDataArray];//取用户列表请求
        [self configBaseInfo];
       
        
    }
    return self;
}

//取用户列表数组
-(void)initDataArray
{
       NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10201\",\"serverid\":\"%@\"}",SERVERID];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    NSLog(@"dict======%@",dict);
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if ([[dictt objectForKey:@"SS"] integerValue]==200) {
            NSLog(@"dict:==%@",dictt[@"DATA"]);
            _deleteData=dictt[@"DATA"];

            NSLog(@"这是数据---%@",dictt[@"DATA"]);
            
        }
    };
    
}




-(void)configBaseInfo
{
    
      self.backgroundColor=KmaskBackGroundViewColor;
    
    //用于遮盖self.backgroundColor 。
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Kscreen_width, KTitleButtonHeight)];
    view.backgroundColor=[UIColor whiteColor];
    [self addSubview:view];
    
    CGFloat width = Kscreen_width /self.titleArray.count;
    
    for (int index=0; index<self.titleArray.count; index++) {
        
        UIButton *titleButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
      titleButton.frame= CGRectMake((width+0.5) * index, 0, width-0.5, KTitleButtonHeight);
//        titleButton.frame = CGRectMake(0, 0, (Kscreen_width)/2, KTitleButtonHeight);
        titleButton.backgroundColor =KDefaultColor;
        [titleButton setTitle:self.titleArray[index] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        titleButton.tag =KTitleButtonTag + index ;
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [titleButton setTitleColor:[[UIColor whiteColor]colorWithAlphaComponent:0.3] forState:UIControlStateSelected];
        [titleButton setImage:[UIImage imageNamed:@"JPullDown.bundle/jiantou_up"] forState:UIControlStateNormal];
        [titleButton setAdjustsImageWhenHighlighted:NO];
        
        titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        
        [self addSubview:titleButton];
        [self.buttonArray addObject:titleButton];
        
    }
    
}




-(UITableView *)tableView
{
    if (_tableView) {
        return _tableView;
    }
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, Kscreen_width, 0)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
//    self.tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.tableView.rowHeight= KTableViewCellHeight;
    return self.tableView;
}


#pragma mark  --  <代理方法>
#pragma mark  --  <UITableViewDelegate,UITableViewDataSource>

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableDataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    downMenuCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell =[[downMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    #define TAG [[NSUserDefaults standardUserDefaults] objectForKey:@"tag"]
    
    if (![self.tableDataArray[indexPath.row] isKindOfClass:[NSNull class]]) {
        cell.textLabel.text = self.tableDataArray[indexPath.row];
    }
    
//    if ([TAG isEqualToString:@"0"]) {
//        cell.textLabel.text =_deleteData[indexPath.row][@"user"][@"id"];
//
//    }if ([TAG isEqualToString:@"1"]) {
//    cell.textLabel.text = self.tableDataArray[indexPath.row];
//    }
    
    
    NSString *objcTitle = KOBJCGetObject(self.tempButton);
    
    if ([cell.textLabel.text isEqualToString:objcTitle]) {
        cell.isSelected = YES;
    }
    else
    {
        cell.isSelected=NO;
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    downMenuCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.isSelected = YES;
    NSDate * mydate = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"---当前的时间的字符串 =%@",currentDateStr);
    
    if ([TAG isEqualToString:@"0"]) {
        NSLog(@"选择的ID为----%@",_deleteData[indexPath.row][@"user"][@"id"]);
        [[NSUserDefaults standardUserDefaults] setObject:_deleteData[indexPath.row][@"user"][@"id"] forKey:@"selecteduserid"];//选择用户deID
    }if ([TAG isEqualToString:@"1"]) {
        if (indexPath.row==0) {
            
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *comps = nil;
            comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
            NSDateComponents *adcomps = [[NSDateComponents alloc] init];
            [adcomps setYear:0];
            [adcomps setMonth:0];
            [adcomps setDay:-3];
            NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
            NSString *beforDate = [dateFormatter stringFromDate:newdate];
            NSLog(@"三天前 =%@",beforDate);
            [[NSUserDefaults standardUserDefaults] setObject:beforDate forKey:@"beforDate"];
        }else if (indexPath.row==1){
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *comps = nil;
            comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
            NSDateComponents *adcomps = [[NSDateComponents alloc] init];
            [adcomps setYear:0];
            [adcomps setMonth:0];
            [adcomps setDay:-5];
            NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
            NSString *beforDate = [dateFormatter stringFromDate:newdate];
            NSLog(@"5天前 =%@",beforDate);
            [[NSUserDefaults standardUserDefaults] setObject:beforDate forKey:@"beforDate"];
        }else if(indexPath.row ==2){
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *comps = nil;
            comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
            NSDateComponents *adcomps = [[NSDateComponents alloc] init];
            [adcomps setYear:0];
            [adcomps setMonth:0];
            [adcomps setDay:-10];
            NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
            NSString *beforDate = [dateFormatter stringFromDate:newdate];
            NSLog(@"10天前 =%@",beforDate);
            [[NSUserDefaults standardUserDefaults] setObject:beforDate forKey:@"beforDate"];
        }else if(indexPath.row==3){
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *comps = nil;
            comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
            NSDateComponents *adcomps = [[NSDateComponents alloc] init];
            [adcomps setYear:0];
            [adcomps setMonth:0];
            [adcomps setDay:-20];
            NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
            NSString *beforDate = [dateFormatter stringFromDate:newdate];
            NSLog(@"20天前 =%@",beforDate);
            [[NSUserDefaults standardUserDefaults] setObject:beforDate forKey:@"beforDate"];
           
        }else if(indexPath.row==4){
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *comps = nil;
            comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
            NSDateComponents *adcomps = [[NSDateComponents alloc] init];
            [adcomps setYear:0];
            [adcomps setMonth:-1];
            [adcomps setDay:0];
            NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
            NSString *beforDate = [dateFormatter stringFromDate:newdate];
            NSLog(@"一个月前 =%@",beforDate);
            [[NSUserDefaults standardUserDefaults] setObject:beforDate forKey:@"beforDate"];
        }
       
    }

    if (_showSelectTitleAtButton) {
        [self.tempButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
    }
    
    KOBJCSetObject(self.tempButton, cell.textLabel.text);
    
    if (self.handleSelectDataBlock) {
        self.handleSelectDataBlock(cell.textLabel.text,indexPath.row,self.tempButton.tag - KTitleButtonTag);
    }
    
    [self takeBackTableView];
   
    
}



-(void)setDefauldSelectedCell
{
    
    for (int index=0; index<self.buttonArray.count; index++) {
        
        self.tableDataArray =self.menuDataArray[index];
        
        UIButton *button =self.buttonArray[index];
        
        NSString *title = self.tableDataArray.firstObject;
        
        KOBJCSetObject(button, title);
        
        if (_showSelectTitleAtButton) {
             [button setTitle:title forState:UIControlStateNormal];
        }
        
    }
    
    [self takeBackTableView];
    
}


-(void)titleButtonClick:(UIButton *)titleButton
{
    NSUInteger index =  titleButton.tag - KTitleButtonTag;
     NSLog(@"--%d",titleButton.tag);
    NSString *str = [NSString stringWithFormat:@"%d",titleButton.tag];
     [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"tag"];
//    if (index ==0) {
//         NSLog(@"888--%d",titleButton.tag);
//    }
   
    for (UIButton *button in self.buttonArray) {
        if (button == titleButton) {
            button.selected=!button.selected;
            self.tempButton =button;
            [self changeButtonObject:button TransformAngle:M_PI];
        }else
        {
            button.selected=NO;
            [self changeButtonObject:button TransformAngle:0];
        }
    }
    
    
    if (titleButton.selected) {
        
       [self changeButtonObject:titleButton TransformAngle:M_PI];
        
        self.tableDataArray = self.menuDataArray[index];
        
        //设置默认选中第一项。
        if ([KOBJCGetObject(self.tempButton) length]<1) {
            
            NSString *title = self.tableDataArray.firstObject;
            KOBJCSetObject(self.tempButton, title);
            
        }
        
        [self.tableView reloadData];
        
        CGFloat tableViewHeight =  self.tableDataArray.count * KTableViewCellHeight < self.tableViewMaxHeight ?
        self.tableDataArray.count * KTableViewCellHeight : self.tableViewMaxHeight;
        [self expandWithTableViewHeight:tableViewHeight];
    }else
    {
        [self takeBackTableView];
    }
    
}



//展开。
-(void)expandWithTableViewHeight:(CGFloat )tableViewHeight
{
    
    self.maskBackGroundView.hidden=NO;
    
    CGRect rect = self.frame;
    rect.size.height = Kscreen_height - self.frame.origin.y;
    self.frame= rect;
    
    [self showSpringAnimationWithDuration:0.3 animations:^{
        
        self.tableView.frame = CGRectMake(0, self.selfOriginalHeight, Kscreen_width, tableViewHeight);
        
        self.maskBackGroundView.alpha =1;
        
    } completion:^{
        
    }];
}

//收起。
-(void)takeBackTableView
{
    for (UIButton *button in self.buttonArray) {
        button.selected=NO;
        [self changeButtonObject:button TransformAngle:0];
    }
    
    CGRect rect = self.frame;
    rect.size.height = self.selfOriginalHeight;
    self.frame = rect;
    
    [self showSpringAnimationWithDuration:.3 animations:^{
        
        self.tableView.frame = CGRectMake(0, self.selfOriginalHeight, Kscreen_width,0);
        self.maskBackGroundView.alpha =0;
        
    } completion:^{
        self.maskBackGroundView.hidden=YES;
    }];
    
}


-(void)changeButtonObject:(UIButton *)button TransformAngle:(CGFloat)angle
{
    [UIView animateWithDuration:0.5 animations:^{
        button.imageView.transform =CGAffineTransformMakeRotation(angle);
    } completion:^(BOOL finished) {
    }];

}

-(void)showSpringAnimationWithDuration:(CGFloat)duration
                            animations:(void (^)())animations
                            completion:(void (^)())completion
{
 
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:.8 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        if (animations) {
            animations();
        }
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}



-(void)maskBackGroundViewTapClick
{
    [self takeBackTableView];
}



-(NSMutableArray *)menuDataArray
{
    if (_menuDataArray) {
        return _menuDataArray;
    }
    self.menuDataArray =[[NSMutableArray alloc]init];
    
    return self.menuDataArray;
}


-(NSMutableArray *)tableDataArray
{
    if (_tableDataArray) {
        return _tableDataArray;
    }
    self.tableDataArray = [[NSMutableArray alloc]init];
    
    return self.tableDataArray;
}

-(NSMutableArray *)buttonArray
{
    if (_buttonArray) {
        return _buttonArray;
    }
    self.buttonArray =[[NSMutableArray alloc]init];
    
    return self.buttonArray;
}

-(UIView *)maskBackGroundView
{
    if (_maskBackGroundView) {
        return _maskBackGroundView;
    }
    self.maskBackGroundView=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width, Kscreen_height - self.frame.origin.y)];
    self.maskBackGroundView.backgroundColor=KmaskBackGroundViewColor;
    self.maskBackGroundView.hidden=YES;
    self.maskBackGroundView.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskBackGroundViewTapClick)];
    [self.maskBackGroundView addGestureRecognizer:tap];
    
    return self.maskBackGroundView;
}

@end




@implementation downMenuCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configCellView];
    }
    
    return self;
}


-(void)configCellView
{
    self.selectImageView.hidden=YES;
    self.textLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.selectImageView];
}


-(UIImageView *)selectImageView
{
    if (_selectImageView) {
        return _selectImageView;
    }
    
    UIImage *image = [UIImage imageNamed:@"JPullDown.bundle/ok"];
    self.selectImageView = [[UIImageView alloc]init];
    self.selectImageView.image=image;
    
    self.selectImageView.frame = CGRectMake(0,0,25,18);
    
    self.selectImageView.center = CGPointMake(Kscreen_width-40, self.frame.size.height/2);
    
    return self.selectImageView;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (isSelected) {
        self.textLabel.textColor = KDefaultColor;
        self.backgroundColor =kCellBgColor;
        self.selectImageView.hidden = NO;
    }else
    {
        self.textLabel.textColor = [UIColor lightGrayColor];
        self.selectImageView.hidden = YES;
        self.backgroundColor=[UIColor groupTableViewBackgroundColor];
    }
}

@end
