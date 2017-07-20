//
//  AllQuery_news_ViewController.m
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/12/8.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "AllQuery_news_ViewController.h"
#import "TopView.h"
#import "AllTableViewCell.h"
#import "AllQueryTableView.h"
#import "NSViewController.h"

@interface AllQuery_news_ViewController () <TopViewDelegate,UIScrollViewDelegate>
{
    NSDictionary* showData;
    NSArray* titleArrayData;
    NSMutableArray* titleArrayName;
    NSArray* viceArray;
    UIScrollView* totalScrollView;
    UIScrollView* mainScroll;
    NSString* title_str;
    UILabel* contens;
    CGRect xmlContens;
    NSString *GUID;
}
@end

@implementation AllQuery_news_ViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[App ddMenu] setEnableGesture:NO];
}

- (id)initWithTableTitle:(NSArray *)array titleData:(NSDictionary *)dict viceTitle:(NSArray *)vice title:(NSString *)titleStr
{
    self = [super init];
    if (self) {
        titleArrayData = [NSArray arrayWithArray:array];
        
        NSLog(@"titlearray ====%@",titleArrayData);
        showData = [NSDictionary dictionaryWithDictionary:dict];
        NSLog(@"showData====%@",showData);
        viceArray = [NSArray arrayWithArray:vice];
        NSLog(@"vicArray===%@",viceArray);
        title_str = titleStr;
    }
    return self;
}
-(void)fileBtnClick{
    NSLog(@"附件");
    if ([[showData allKeys] containsObject:@"GUID"]) {
        //[[NSUserDefaults standardUserDefaults] setObject:@"y" forKey:showData[@"GUID"]];
        NSViewController* nsVC = [[NSViewController alloc] initWithUrl:showData[@"GUID"] WithTitleStr:@"查看附件"];
        [self.navigationController pushViewController:nsVC animated:YES];
    }else{
        
        UIAlertController *conttter =[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前单据没有附件！！！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action =[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [conttter addAction:action];
        [self presentViewController:conttter animated:YES completion:nil];
    
    
    }
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightBnt =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"附件"] style:UIBarButtonItemStylePlain target:self action:@selector(fileBtnClick)];
    
    self.navigationItem.rightBarButtonItem=rightBnt;
    self.title = [NSString stringWithFormat:@"%@明细",title_str];
    titleArrayName = [[NSMutableArray alloc] init];
    [titleArrayName addObject:@"基本信息"];
    
    TopView* vc = [[TopView alloc] initWithFrame:CGRectMake(0, 0, LWidth, 40)];
    vc.array = titleArrayName;
    vc.delegate = self;
    vc.backgroundColor = [UIColor blackColor];
    [self.view addSubview:vc];
    
    totalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, LWidth, LHeight-104)];//总scrollView
    totalScrollView.backgroundColor = [UIColor whiteColor];
    totalScrollView.pagingEnabled = YES;
    totalScrollView.delegate = self;
    [self.view addSubview:totalScrollView];
    
    for (NSInteger index = 0; index < viceArray.count; index ++) {
        [titleArrayName addObject:[viceArray[index] objectForKey:@"tableName"]];
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[viceArray[index] objectForKey:@"tableFrom"],@"APPDBCONN",@"GETQUERYSUBTABLE",@"Action",[viceArray[index] objectForKey:@"tableCode"],@"APPDBTABLE",[showData objectForKey:[viceArray[index] objectForKey:@"mainField"]],@"GUID",[viceArray[index] objectForKey:@"subField"],@"APPFLOWFIELD", nil];
        AllQueryTableView* view = [[AllQueryTableView alloc] initWithModel:dict title:[viceArray[index] objectForKey:@"showType"]];
        view.frame = CGRectMake(index * LWidth+LWidth, 0, LWidth, LHeight-104);
        view.backgroundColor = [UIColor whiteColor];
        [totalScrollView addSubview:view];
    }
    totalScrollView.contentSize = CGSizeMake(LWidth*titleArrayName.count, 40);
    
    mainScroll = [[UIScrollView alloc] init];
    mainScroll.frame = CGRectMake(0, 0, LWidth, LHeight-104);
    [totalScrollView addSubview:mainScroll];
    
    for (NSInteger m = 0; m < titleArrayData.count; m ++) {
        UIButton* xmlView = [UIButton buttonWithType:UIButtonTypeCustom];
        xmlView.tag = m+1000;
        [mainScroll addSubview:xmlView];
        
        UILabel* title = [[UILabel alloc] init];
        title.textAlignment = NSTextAlignmentRight;
        title.tag = 10000;
        title.numberOfLines = 0;
        title.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        title.text = [NSString stringWithFormat:@"%@:",[titleArrayData[m] objectForKey:@"fieldName"]==nil?@"":[titleArrayData[m] objectForKey:@"fieldName"]];
        title.font = [UIFont systemFontOfSize:14];
        CGSize titleSize = [self sizeWithStringTitle:title.text font:title.font sizwLwidth:90];
        title.frame = CGRectMake(5, 8, 90, titleSize.height);
        [xmlView addSubview:title];
        
        contens = [[UILabel alloc] init];
        contens.textAlignment = NSTextAlignmentLeft;
        contens.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
        contens.numberOfLines = 0;
        contens.font = [UIFont systemFontOfSize:14];
        contens.tag = m+100;
        contens.text = [showData objectForKey:[titleArrayData[m] objectForKey:@"fieldCode"]]==nil?@"":[[[showData objectForKey:[titleArrayData[m] objectForKey:@"fieldCode"]] stringByReplacingOccurrencesOfString:@"T" withString:@" "] stringByReplacingOccurrencesOfString:@"+08:00" withString:@""];
        
        CGSize btnSize = [self sizeWithStringTitle:contens.text font:title.font sizwLwidth:LWidth-15-(title.frame.size.width+title.frame.origin.x)];
        contens.frame = CGRectMake(title.frame.size.width+10, 8, btnSize.width, btnSize.height);
        
        [xmlView addSubview:contens];
        
        float y = title.frame.size.height>contens.frame.size.height?title.frame.size.height+title.frame.origin.y:contens.frame.size.height+contens.frame.origin.y;
        xmlView.frame = CGRectMake(0, m==0?0:xmlContens.origin.y+xmlContens.size.height, LWidth, y+9);
        
        UIImageView* row = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividing-line"]];
        row.frame = CGRectMake(0, xmlView.frame.size.height-1, LWidth, 1);
        row.alpha = 0.4;
        row.tag = m+100;
        [xmlView addSubview:row];
        [xmlView bringSubviewToFront:row];
        xmlContens = xmlView.frame;
    }
    mainScroll.contentSize = CGSizeMake(LWidth, xmlContens.size.height+xmlContens.origin.y+40);
    
    
}
- (CGSize)sizeWithStringTitle:(NSString *)string font:(UIFont *)font sizwLwidth:(float)width
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, LHeight)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  | NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    return rect.size;
}
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(LWidth-20, LHeight)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  | NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    return rect.size;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(unsigned long)(scrollView.contentOffset.x / scrollView.frame.size.width)],@"indexpage", nil];
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
- (void)pushNewsViewController:(NSInteger)page
{
    [totalScrollView setContentOffset:CGPointMake(LWidth*page, 0) animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
