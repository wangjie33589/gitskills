//
//  BTViewController.m
//  MYsearchdisplaycontroller
//
//  workTaskVC.m
//  ios版本科远APP
//
//  Created by sciyonSoft on 15/11/28.
//  Copyright © 2015年 sciyonSoft. All rights reserved.

#define REFRESH_HEADER_HEIGHT 52.0f
#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]

#pragma mark - 设备型号识别
#define is_IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#pragma mark - 硬件
#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]

#pragma mark - 设备型号识别
#define is_IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#pragma mark - 硬件
#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)



#import "BTViewController.h"
#import "BTTableViewCell.h"
#import "workTask.h"
#import "NetWorkTool.h"

#import "allocModel.h"
#import "DetilVC.h"
#import "workTaskVC.h"
#import "MJRefresh.h"



@interface BTViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UIScrollViewDelegate,UIScrollViewAccessibilityDelegate,UISearchControllerDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;//数据源
    NSMutableArray *_resultsData;//搜索结果数据
    UISearchBar *mySearchBar;
    UISearchDisplayController *mySearchDisplayController;
    
    NSMutableArray *_searchARRAY;

}
@end




@implementation BTViewController




-(id)initWithALLMODELARRAY:(NSMutableArray *)ARRATY DataSourse:(NSArray *)array{
    
    
    self =[super init];
    if (self) {
        
        self.DaTAarray=array;
        self.AllTaskArray=ARRATY;
        
        
       
    
       
    }

    return self;





}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self setupStrings];
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    //mySearchDisplayController.searchResultsTableView reloadData];
    
    [_tableView reloadData];
    
[self initTableView];
    [self initMysearchBarAndMysearchDisPlay];


}









- (void)viewDidLoad
{
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBarHidden = YES;
    
    _dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    _resultsData = [[NSMutableArray alloc]initWithCapacity:0];
    _searchARRAY =[[NSMutableArray alloc]initWithCapacity:0];
    //self.DaTAarray=[[NSMutableArray alloc]initWithCapacity:0];
    [self addPullToRefreshFooter];
    [self setupStrings];
    
    for (workTask *tasK in  self.AllTaskArray ) {
        
        NSString *str = tasK.title;
        [_dataArray addObject:str];
        
        
    }

    
    
    
}

-(void)configData{
  
    [NetWorkTool workTaskcompletionBlock:^(NSDictionary *dic) {
        NSArray *array =dic[@"data"];
     
        for (NSDictionary *taskDic in array ) {
            workTask *task =[[workTask alloc ]initWithDic:taskDic];
            [self.DaTAarray addObject:task];
            
        }
         [_tableView reloadData];
        [mySearchDisplayController.searchResultsTableView reloadData];

            }];
    
    
}


-(void)initDataSource
{
    for (int i = 0; i < 50; i ++) {
        [_dataArray addObject:[NSString stringWithFormat:@"Hello World %d",i]];
    }
}

-(void)initNav{
    //状态栏的背景颜色
    UILabel *twoL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH
                                                              , is_IOS_7?64:44)];
    twoL.backgroundColor = RGBACOLOR(249,249,249,1);
    [self.view addSubview:twoL];
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,is_IOS_7?20:0,SCREEN_WIDTH, 44)];
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.textColor = RGBACOLOR(11, 104, 210, 1);
    navLabel.text = @"搜索列表";
    navLabel.font = [UIFont systemFontOfSize:18];
    navLabel.textAlignment = NSTextAlignmentCenter;
    navLabel.userInteractionEnabled = YES;
    [self.view addSubview:navLabel];
}

- (void)initTableView
{
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableHeaderView = [[UIView alloc] init];
   // _tableView.tableFooterView = [[UIView alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    //[dataTableView addHeaderWithTarget:self action:@selector(upRefresh:)];
    [_tableView addFooterWithTarget:self action:@selector(downRefresh:)];

    [_tableView registerNib:[UINib nibWithNibName:@"BTTableViewCell" bundle:nil] forCellReuseIdentifier:@"BTCELL"];
   
    
       [self.view addSubview:_tableView];
    
    if (is_IOS_7)
        //分割线的位置不带偏移
        _tableView.separatorInset = UIEdgeInsetsZero;
}
//下拉加载
- (void)downRefresh:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //[self requestShowDataRefresh];
        [_tableView footerEndRefreshing];
    });
}


-(void)initMysearchBarAndMysearchDisPlay
{
    mySearchBar = [[UISearchBar alloc] init];
    mySearchBar.delegate = self;
//    //设置选项
//    [mySearchBar setScopeButtonTitles:[NSArray arrayWithObjects:@"First",@"Last",nil]];
    [mySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [mySearchBar sizeToFit];
    mySearchBar.backgroundColor = RGBACOLOR(249,249,249,1);
    mySearchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:mySearchBar.bounds.size];
    //加入列表的header里面
    _tableView.tableHeaderView = mySearchBar;
    
    mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:mySearchBar contentsController:self];
    mySearchDisplayController.delegate = self;
    mySearchDisplayController.searchResultsDataSource = self;
    mySearchDisplayController.searchResultsDelegate = self;
     [mySearchDisplayController.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UICELL"];
//    mySearchDisplayController.searchResultsTableView.dataSource=self;
//    mySearchDisplayController.searchResultsTableView.delegate=self;
}

#pragma mark UISearchBar and UISearchDisplayController Delegate Methods

//searchBar开始编辑时改变取消按钮的文字
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    switch (self.flag) {
        case 0:
        {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"post" object:nil];
            
            
        }
            break;
            
        default:{
             [[NSNotificationCenter defaultCenter]postNotificationName:@"post1" object:nil];
            
            
        }
            break;
    }

    
   ;
    mySearchBar.showsCancelButton = YES;

    
    NSArray *subViews;

    if (is_IOS_7) {
        subViews = [(mySearchBar.subviews[0]) subviews];
    }
    else {
        subViews = mySearchBar.subviews;
    }
    
    for (id view in subViews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* cancelbutton = (UIButton* )view;
            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
            break;
        }
    }
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
    
    //準備搜尋前，把上面調整的TableView調整回全屏幕的狀態
    [UIView animateWithDuration:1.0 animations:^{
    
        
        //self.view.frame=CGRectMake(0, -50, SCREEN_WIDTH, SCREEN_HEIGHT+50);
        
        //[self.view bringSubviewToFront:_tableView];
        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    switch (self.flag) {
        case 0:
        {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"otherpost" object:nil];

        
        }
            break;
            
        default:{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"otherpost1" object:nil];
            

        
        
        }
            break;
    }
    
   
    //搜尋結束後，恢復原狀
       [UIView animateWithDuration:1.0 animations:^{
        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    }];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller

shouldReloadTableForSearchString:(NSString *)searchString

{
    //一旦SearchBar輸入內容有變化，則執行這個方法，詢問要不要重裝searchResultTableView的數據
  
   
    [self filterContentForSearchText:searchString
                               scope:[mySearchBar scopeButtonTitles][mySearchBar.selectedScopeButtonIndex]];
    
  
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller

shouldReloadTableForSearchScope:(NSInteger)searchOption

{
    NSLog(@"111111");
    //如果设置了选项，当Scope Button选项有變化的时候，則執行這個方法，詢問要不要重裝searchResultTableView的數據
    
    // Return YES to cause the search result table view to be reloaded.
    
    [self filterContentForSearchText:mySearchBar.text
                               scope:mySearchBar.scopeButtonTitles[searchOption]];
    
    return YES;
}

//源字符串内容是否包含或等于要搜索的字符串内容
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope

{
  
    
    NSMutableArray *tempResults = [NSMutableArray array];
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    
    
    
    
    for (int i = 0; i < _dataArray.count; i++) {
            NSString *storeString = _dataArray[i];
            NSRange storeRange = NSMakeRange(0, storeString.length);
            NSRange foundRange = [storeString rangeOfString:searchText options:searchOptions range:storeRange];
            if (foundRange.length) {
                [tempResults addObject:storeString];
            }
        }

        
    
    
    [_resultsData removeAllObjects];
    [_resultsData addObjectsFromArray:tempResults];
    
    

}

#pragma mark - tableView代理


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //searchDisplayController自身有一个searchResultsTableView，所以在执行操作的时候首先要判断是否是搜索结果的tableView，如果是显示的就是搜索结果的数据，如果不是，则显示原始数据。
//    
    if(tableView == mySearchDisplayController.searchResultsTableView)
    {
        return _resultsData.count;
    }
    else
    {
        
        return self.DaTAarray.count;
            }
    
    
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == mySearchDisplayController.searchResultsTableView)
    {
               return 44;
    }
    else
    {
        
        return 100;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    

    
    switch (self.flag) {
        case 0:
        {
            
            
            if(tableView == mySearchDisplayController.searchResultsTableView)
            {
                UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"UICELL"];
                

                
                cell.textLabel.text = _resultsData[indexPath.row];
                
                return cell;
            }
            else{
                BTTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"BTCELL"];
                
                        workTask *task =self.DaTAarray[indexPath.row];
                cell.firstLab.text=task.title;
                NSLog(@"task=%@",task.title);
                cell.secondLab.text=[NSString stringWithFormat:@"分配人:%@    %@",task.mangerName,task.mangeTime];
                cell.ThirdLab.text=[NSString stringWithFormat:@"   状态：  %@",task.state];
                
                
                
                
                
                return cell;
                
                
                
            }

        
        }
            break;
            
        default:{
            
            
            if(tableView == mySearchDisplayController.searchResultsTableView)
            {
                UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"UICELL"];
                
                
                cell.textLabel.text = _resultsData[indexPath.row];
                
                return cell;
            }
            else{
                BTTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"BTCELL"];
                
                allocModel *model =[self.DaTAarray objectAtIndex:indexPath.row];
                cell.firstLab.text=model.title;
                cell.secondLab.text=[NSString stringWithFormat:@"处理人：%@",model.manger ];
                
                cell.ThirdLab.text=[NSString stringWithFormat:@"   状态：  %@",model.state];
                
                
                
                
                return cell;
                
                
                
            }

        
        
        }
            break;
    }//
    
        
    



}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    if(tableView == mySearchDisplayController.searchResultsTableView)
    {
         [NetWorkTool workTaskWithName:_resultsData[indexPath.row] completionBlock:^(NSDictionary *dic) {
             NSLog(@"BACKDATA+++++%@",dic);
             
            NSArray *ARRAY=dic[@"data"];
             
             
                workTask *task =[[workTask alloc ]initWithDic:ARRAY[0]];;
             

             
             DetilVC *detil =[[DetilVC alloc]init];
             detil.FGUID=task.FGUID;
             detil.modalPresentationStyle=UIModalPresentationCustom;
             detil.modalTransitionStyle=UIModalPresentationCustom;
             [self presentViewController:detil animated:YES completion:nil];
             
             
             
         }];
    
    
    }
    else
    {
        
        workTask *task =self.DaTAarray[indexPath.row];
        DetilVC *detil =[[DetilVC alloc]init];
        detil.FGUID=task.FGUID;
       
        [self.navigationController pushViewController:detil animated:YES];

    }

    
}

-(void)myAlertViewAccording:(NSString *)content
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"cell－content" message:content delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (void)setupStrings{
    textPull    = @"上拉刷新...";
    textRelease = @"释放开始刷新...";
    textLoading = @"正在加载...";
    _textNoMore  = @"没有更多内容了...";
    _hasMore = YES;
}

-(void)addPullToRefreshFooter{
    refreshFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.frame.size.height+20, SCREEN_WIDTH, REFRESH_HEADER_HEIGHT )];
    refreshFooterView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    
    
    

    
    
    
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),27, 44);
    
    
    
    
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    27, 44);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshFooterView addSubview:refreshLabel];
    [refreshFooterView addSubview:refreshArrow];
    [refreshFooterView addSubview:refreshSpinner];
    [_tableView addSubview:refreshFooterView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSLog(@"begin");
    if (isLoading && scrollView.contentOffset.y > 0) {
        // Update the content inset, good for section headers
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, REFRESH_HEADER_HEIGHT , 0);
    }else if(!_hasMore){
        refreshLabel.text = self.textNoMore;
        refreshArrow.hidden = YES;
    }else if (isDragging && scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom) <= 0 ) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        refreshArrow.hidden = NO;
        if (scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom) <= -REFRESH_HEADER_HEIGHT) {
            // User is scrolling above the header
            refreshLabel.text = self.textRelease;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            refreshLabel.text = self.textPull;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    //if (isLoading || !_hasMore) return;
   isDragging = NO;


    
   

    NSLog(@"end");
    if(scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom) <= -REFRESH_HEADER_HEIGHT && scrollView.contentOffset.y > 0){
        [self startLoading];
        
    }

    
}

- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    refreshLabel.text = self.textLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
    
    // Refresh action!
    [self refresh];
}
- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
   _tableView.contentInset = UIEdgeInsetsZero;
    UIEdgeInsets tableContentInset = _tableView.contentInset;
    tableContentInset.top = 0.0;
    _tableView.contentInset = tableContentInset;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}
- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    NSLog(@"%f",_tableView.contentSize.height);
    
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    
    [refreshFooterView setFrame:CGRectMake(0, _tableView.contentSize.height, 320, 0)];
    
    [refreshSpinner stopAnimating];
}
- (void)refresh {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(addItem) withObject:nil afterDelay:2.0];
    
}
- (void)addItem {
 
    
    static int i=1;
    i++;
    [NetWorkTool workTaskSearchPAGE:i completionBlock:^(NSDictionary *dic) {
        
        NSLog(@"PULLdic====%@",dic);
        NSArray *array =dic[@"data"];
        
        switch (self.flag) {
            case 0:
            {
                for (NSDictionary *taskDic in  array ) {
                    workTask *task =[[workTask alloc ]initWithDic:taskDic];;
                    [self.DaTAarray addObject:task];
            }
                

            
            }
                break;
                
            default:{
                
                for (NSDictionary *alloc in  array) {
                    allocModel *model =[[allocModel alloc]initWithDic:alloc];
                    [self.DaTAarray addObject:model];
                    
                }
                

            
            
            }
                break;
        }
        
               [_tableView reloadData];
        
        [self stopLoading];
        
        
        
    }];
    
    
    self.hasMore = NO;
    
    
    //没有更多内容了
    }



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

