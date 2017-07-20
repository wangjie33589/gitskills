//
//  BYMainController.m
//  BYDailyNews
//
//  Created by bassamyan on 15/1/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BYMainController.h"
#import "BYListBar.h"
#import "BYArrow.h"
#import "BYDetailsList.h"
#import "BYDeleteBar.h"
#import "BYScroller.h"
#import "ContensView.h"
#import "NewsViewController.h"

#define kListBarH 30
#define kArrowW 40
#define kAnimationTime 0.8

@interface BYMainController () <UIScrollViewDelegate,ContensViewDelegate>
{
    NSMutableArray* dataArray;
    NSMutableArray* titleArray;
}

@property (nonatomic,strong) BYListBar *listBar;

@property (nonatomic,strong) BYDeleteBar *deleteBar;
//
@property (nonatomic,strong) BYDetailsList *detailsList;

@property (nonatomic,strong) BYArrow *arrow;

@property (nonatomic,strong) UIScrollView *mainScroller;

@end

@implementation BYMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _title_Str;
    [self requestShowDataNews];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)requestShowDataNews
{
    [dataArray removeAllObjects];
    dataArray = [[NSMutableArray alloc] init];
    [titleArray removeAllObjects];
    titleArray = [[NSMutableArray alloc] init];
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETNOTICETYPEDATA",@"Action", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/NM/ProxyMobile/NoticeProxy.ashx",HTTPIP,SLRD] withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        if (dataArray>0&&titleArray>0) {
            NSLog(@"dattt==%@",dictt);
            NSObject *objDAta=[dictt objectForKey:@"Data"];
            
            if ((NSNull *)objDAta == [NSNull null]) {return;
                
                            
            }else{
                for (NSDictionary* modelDict in [[dictt objectForKey:@"Data"] objectForKey:@"R"]) {
                    [dataArray addObject:[NewsModel initWithAddData:modelDict]];
                    [titleArray addObject:[modelDict objectForKey:@"TYPENAME"]];
            
            
            }
           
            }
          
        }
               [self makeContent:titleArray];
    };
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[App ddMenu] setEnableGesture:NO];
}
-(void)makeContent:(NSMutableArray *)listTop
{
    __weak typeof(self) unself = self;
    
    if (!self.detailsList) {
        self.detailsList = [[BYDetailsList alloc] initWithFrame:CGRectMake(0, kListBarH-kScreenH, kScreenW, kScreenH-kListBarH)];
        self.detailsList.listAll = [NSMutableArray arrayWithObjects:listTop,nil, nil];
        self.detailsList.longPressedBlock = ^(){
            [unself.deleteBar sortBtnClick:unself.deleteBar.sortBtn];
        };
        self.detailsList.opertionFromItemBlock = ^(animateType type, NSString *itemName, int index){
            [unself.listBar operationFromBlock:type itemName:itemName index:index];
        };
        [self.view addSubview:self.detailsList];
    }
    
    if (!self.listBar) {
        self.listBar = [[BYListBar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kListBarH)];
        self.listBar.visibleItemList = listTop;
        self.listBar.arrowChange = ^(){
            if (unself.arrow.arrowBtnClick) {
                unself.arrow.arrowBtnClick();
            }
        };
        self.listBar.listBarItemClickBlock = ^(NSString *itemName , NSInteger itemIndex){
            [unself.detailsList itemRespondFromListBarClickWithItemName:itemName];
            //添加scrollview
            //移动到该位置
            unself.mainScroller.contentOffset =  CGPointMake(itemIndex * unself.mainScroller.frame.size.width, 0);
        };
        [self.view addSubview:self.listBar];
    }
    
    if (!self.deleteBar) {
        self.deleteBar = [[BYDeleteBar alloc] initWithFrame:self.listBar.frame];
        [self.view addSubview:self.deleteBar];
    }
    
    
    if (!self.arrow) {
        self.arrow = [[BYArrow alloc] initWithFrame:CGRectMake(kScreenW-kArrowW, 0, kArrowW, kListBarH)];
        self.arrow.arrowBtnClick = ^(){
            
            unself.deleteBar.hidden = !unself.deleteBar.hidden;
            [UIView animateWithDuration:kAnimationTime animations:^{
                CGAffineTransform rotation = unself.arrow.imageView.transform;
                unself.arrow.imageView.transform = CGAffineTransformRotate(rotation,M_PI);
                unself.detailsList.transform = (unself.detailsList.frame.origin.y<0)?CGAffineTransformMakeTranslation(0, kScreenH):CGAffineTransformMakeTranslation(0, -kScreenH);
            }];
        };
        [self.view addSubview:self.arrow];
    }
    if (!self.mainScroller) {
        self.mainScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kListBarH, kScreenW , kScreenH-kListBarH-64)];
        self.mainScroller.backgroundColor = [UIColor whiteColor];
        self.mainScroller.bounces = NO;
        self.mainScroller.pagingEnabled = YES;
        self.mainScroller.showsHorizontalScrollIndicator = NO;
        self.mainScroller.showsVerticalScrollIndicator = NO;
        self.mainScroller.delegate = self;
        self.mainScroller.contentSize = CGSizeMake(kScreenW*listTop.count,self.mainScroller.frame.size.height);
        [self.view insertSubview:self.mainScroller atIndex:0];
        
        for (NSInteger index = 0; index <listTop.count; index ++) {
            [self addScrollViewWithItemName:listTop[index] index:index];
        }
    }
}

-(void)addScrollViewWithItemName:(NSString *)itemName index:(NSInteger)index{
    ContensView* view = [[ContensView alloc] initWithModel:dataArray[index]];
    view.delegate = self;
    view.frame = CGRectMake(index * self.mainScroller.frame.size.width, 0, self.mainScroller.frame.size.width, self.mainScroller.frame.size.height);
    view.backgroundColor = [UIColor whiteColor];
    [self.mainScroller addSubview:view];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.listBar itemClickByScrollerWithIndex:scrollView.contentOffset.x / self.mainScroller.frame.size.width];
}
- (void)pushNewsViewController:(NSString *)aGuid
{
    NewsViewController* newsVC = [[NewsViewController alloc] initWithUrl:aGuid];
    [self.navigationController pushViewController:newsVC animated:YES];
}
@end
