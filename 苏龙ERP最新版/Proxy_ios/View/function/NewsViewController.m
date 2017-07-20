//
//  NewsViewController.m
//  Proxy_ios
//
//  Created by E-Bans on 15/11/24.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()
{
    NSString* guid;
    NSDictionary* showDict;
}
@end

@implementation NewsViewController
- (id)initWithUrl:(NSString *)aUrl
{
    self = [super init];
    if (self) {
        guid = aUrl;
    }
    return self;
}
- (void)requestShowDataNews
{
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETNOTICEDATABYGUID",@"Action",guid,@"GUID", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/NM/ProxyMobile/NoticeProxy.ashx",HTTPIP,SLRD] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        showDict= [NSDictionary dictionaryWithDictionary:[[dictt objectForKey:@"Data"] objectForKey:@"R"]];
        [self initView];
        [SVProgressHUD dismiss];
    };
}
- (void)initView
{
    nsTitle.text = [showDict objectForKey:@"TITLE"];
    time.text = [NSString stringWithFormat:@"发布时间:%@",[[[showDict objectForKey:@"ADDTIME"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:16]];
    name.text = [NSString stringWithFormat:@"发布人:%@",[showDict objectForKey:@"ADDUSERNAME"]];
    contens.text = [[NSString stringWithFormat:@"%@",[showDict objectForKey:@"CONTENT"]] stringByReplacingOccurrencesOfString:@"<null>" withString:@"无详细内容"];
    UIFont* font = [UIFont systemFontOfSize:15];
    CGSize size = [self sizeWithString:[NSString stringWithFormat:@"%@",[showDict objectForKey:@"CONTENT"]] font:font];
    contens.frame = CGRectMake(8, name.frame.origin.y+30, LWidth-16, size.height+8);
    [self requestShowData];
}
- (void)requestShowData
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETMOBILEFILES",@"Action",guid,@"GUID",@"FILE",@"TYPE", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/ProxyMobile/MobileFrame.ashx",HTTPIP,SLRD] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
    };
}
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(LWidth-16, LHeight)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  | NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    
    return rect.size;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新闻详情";
    [self requestShowDataNews];
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
